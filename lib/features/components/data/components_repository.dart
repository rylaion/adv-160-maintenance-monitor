import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/services/attachment_service.dart';
import '../../../core/utils/date_utils.dart';
import '../../maintenance/domain/maintenance_record_detail.dart';
import '../../odometer/data/odometer_repository.dart';
import '../domain/component_models.dart';

/// Repository for component measurements and condition monitoring.
///
/// Historical measurements are never overwritten or hard-deleted (soft delete
/// via `voided_at`). No component wear or safety threshold is invented here.
class ComponentsRepository {
  ComponentsRepository(
    this._db,
    this._odometer, {
    AttachmentService? attachments,
    DateTime Function()? clock,
  })  : _attachments = attachments,
        _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final OdometerRepository _odometer;
  final AttachmentService? _attachments;
  final DateTime Function() _clock;

  static String? _clean(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  /// Watches measurements for [itemId] (or all items if null), newest first.
  Stream<List<ComponentMeasurement>> watchMeasurements({int? itemId}) async* {
    yield await loadMeasurements(itemId: itemId);
    final updates = _db.tableUpdates(TableUpdateQuery.onAllTables([
      _db.componentMeasurements,
      _db.attachments,
    ]));
    await for (final _ in updates) {
      yield await loadMeasurements(itemId: itemId);
    }
  }

  Future<List<ComponentMeasurement>> loadMeasurements({int? itemId}) async {
    final q = _db.select(_db.componentMeasurements)
      ..where((t) => t.voidedAt.isNull());
    if (itemId != null) {
      q.where((t) => t.itemId.equals(itemId));
    }
    q.orderBy([
      (t) => OrderingTerm.desc(t.measuredDate),
      (t) => OrderingTerm.desc(t.id),
    ]);
    final rows = await q.get();
    final attRows = await (_db.select(_db.attachments)
          ..where((t) => t.measurementId.isNotNull()))
        .get();
    return [
      for (final r in rows)
        if (AppDates.parseDateOnly(r.measuredDate) != null)
          ComponentMeasurement(
            id: r.id,
            motorcycleId: r.motorcycleId,
            itemId: r.itemId,
            recordId: r.recordId,
            measuredDate: AppDates.parseDateOnly(r.measuredDate)!,
            odometerKm: r.odometerKm,
            measurementType: MeasurementType.fromCode(r.measurementType),
            value: r.value,
            unit: r.unit,
            position: r.position,
            measurementContext: r.measurementContext,
            brand: r.brand,
            partNumber: r.partNumber,
            visualCondition: r.visualCondition,
            hasDamage: r.hasDamage,
            notes: r.notes,
            attachments: [
              for (final a in attRows.where((x) => x.measurementId == r.id))
                AttachmentInfo(
                  id: a.id,
                  filePath: a.filePath,
                  mimeType: a.mimeType,
                  caption: a.caption,
                ),
            ],
          ),
    ];
  }

  /// Records a single measurement or condition observation.
  Future<int> addMeasurement(NewComponentMeasurement m) async {
    final ids = await addMeasurements([m]);
    return ids.single;
  }

  /// Records one or more measurements (e.g. tire pressure + tread depth
  /// together) in a single transaction, copying photos once.
  Future<List<int>> addMeasurements(List<NewComponentMeasurement> list) async {
    if (list.isEmpty) {
      throw const ComponentException('At least one measurement is required.');
    }
    final today = AppDates.todayManila(_clock());
    for (final m in list) {
      final day = AppDates.dateOnly(m.measuredDate);
      if (day.isAfter(today)) {
        throw const ComponentException('Date cannot be in the future.');
      }
      if (m.odometerKm != null && m.odometerKm! < 0) {
        throw const ComponentException('Odometer cannot be negative.');
      }
      if (m.measurementType != MeasurementType.conditionObservation) {
        if (m.value == null) {
          throw ComponentException('${m.measurementType.label} is required.');
        }
        if (m.value!.isNaN || m.value!.isInfinite || m.value! <= 0) {
          throw ComponentException(
              '${m.measurementType.label} must be greater than zero.');
        }
      } else {
        if (m.value != null &&
            (m.value!.isNaN || m.value!.isInfinite || m.value! < 0)) {
          throw const ComponentException('Value cannot be negative.');
        }
        final hasObs = _clean(m.visualCondition) != null ||
            _clean(m.notes) != null ||
            _clean(m.brand) != null ||
            m.hasDamage;
        if (!hasObs && m.value == null) {
          throw const ComponentException(
              'Enter a condition, brand, or inspection notes.');
        }
      }
    }

    final firstPhotos = list.first.photoPaths;
    final storedPhotos = firstPhotos.isEmpty
        ? const <StoredPhoto>[]
        : await (_attachments != null
            ? _attachments.store(firstPhotos)
            : Future.value([
                for (final path in firstPhotos) StoredPhoto(path: path),
              ]));

    try {
      return await _db.transaction(() async {
        final out = <int>[];
        final nowIso = _clock().toIso8601String();
        for (var i = 0; i < list.length; i++) {
          final m = list[i];
          final day = AppDates.dateOnly(m.measuredDate);
          final item = await (_db.select(_db.maintenanceItems)
                ..where((t) => t.id.equals(m.itemId)))
              .getSingleOrNull();
          if (item == null) {
            throw const ComponentException('Maintenance item not found.');
          }
          if (m.odometerKm != null) {
            await _odometer.logIfHigher(
              motorcycleId: m.motorcycleId,
              readingKm: m.odometerKm!,
              date: day,
              note: 'Logged from component inspection (${item.name})',
              createdAt: _clock(),
            );
          }
          final id = await _db.into(_db.componentMeasurements).insert(
                ComponentMeasurementsCompanion.insert(
                  motorcycleId: m.motorcycleId,
                  itemId: m.itemId,
                  recordId: Value(m.recordId),
                  measuredDate: AppDates.toIsoDate(day),
                  odometerKm: Value(m.odometerKm),
                  measurementType: m.measurementType.code,
                  value: Value(m.value),
                  unit: m.measurementType.unit,
                  position: Value(_clean(m.position)),
                  measurementContext: Value(_clean(m.measurementContext)),
                  brand: Value(_clean(m.brand)),
                  partNumber: Value(_clean(m.partNumber)),
                  visualCondition: Value(_clean(m.visualCondition)),
                  hasDamage: Value(m.hasDamage),
                  notes: Value(_clean(m.notes)),
                  createdAt: nowIso,
                ),
              );
          if (i == 0) {
            for (final ph in storedPhotos) {
              await _db.into(_db.attachments).insert(
                    AttachmentsCompanion.insert(
                      measurementId: Value(id),
                      motorcycleId: Value(m.motorcycleId),
                      filePath: ph.path,
                      mimeType: Value(ph.mimeType),
                      createdAt: nowIso,
                    ),
                  );
            }
          }
          out.add(id);
        }
        return out;
      });
    } catch (_) {
      if (_attachments != null && storedPhotos.isNotEmpty) {
        await _attachments.discard(storedPhotos);
      }
      rethrow;
    }
  }

  /// Soft-deletes a measurement (`voided_at` set). Never removes rows.
  Future<void> voidMeasurement(int id) async {
    final row = await (_db.select(_db.componentMeasurements)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null || row.voidedAt != null) {
      throw const ComponentException('Measurement not found.');
    }
    await (_db.update(_db.componentMeasurements)..where((t) => t.id.equals(id)))
        .write(ComponentMeasurementsCompanion(
            voidedAt: Value(_clock().toIso8601String())));
  }
}
