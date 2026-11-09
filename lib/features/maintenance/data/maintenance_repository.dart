import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/enums/enums.dart';
import '../../../core/exceptions/user_facing_exception.dart';
import '../../../core/services/attachment_service.dart';
import '../../../core/services/expense_service.dart';
import '../../../core/utils/date_utils.dart';
import '../../motorcycle/domain/motorcycle.dart';
import '../../odometer/data/odometer_repository.dart';
import '../../parts/data/parts_repository.dart';
import '../../parts/domain/part_models.dart';
import '../domain/maintenance_models.dart';
import '../domain/maintenance_record_detail.dart';
import '../domain/maintenance_snapshot.dart';

/// Input for saving or editing a service record.
class NewMaintenanceRecord {
  const NewMaintenanceRecord({
    required this.motorcycleId,
    required this.itemId,
    required this.action,
    required this.date,
    required this.odometerKm,
    this.laborCostCentavos = 0,
    this.totalCostCentavos,
    this.serviceProvider,
    this.notes,
    this.parts = const [],
    this.photoPaths = const [],
    this.keepAttachmentIds = const [],
  });

  final int motorcycleId;
  final int itemId;
  final MaintenanceAction action;
  final DateTime date;
  final int odometerKm;
  final int laborCostCentavos;

  /// If null, computed from [laborCostCentavos] + [parts] line totals.
  final int? totalCostCentavos;
  final String? serviceProvider;
  final String? notes;
  final List<RecordPartInput> parts;

  /// Newly picked photo source paths to copy & attach.
  final List<String> photoPaths;

  /// When editing an existing record, existing attachment IDs to retain.
  final List<int> keepAttachmentIds;
}

class MaintenanceException implements UserFacingException {
  const MaintenanceException(this.message);
  @override
  final String message;
  @override
  String toString() => message;
}

/// Repository for schedule rules, service records and the calculation snapshot.
class MaintenanceRepository {
  MaintenanceRepository(
    this._db,
    this._odometer, {
    PartsRepository? parts,
    AttachmentService? attachments,
    ExpenseService expense = const ExpenseService(),
    DateTime Function()? clock,
  })  : _clock = clock ?? DateTime.now,
        _parts = parts ?? PartsRepository(_db, clock: clock),
        _attachments = attachments,
        _expense = expense;

  final AppDatabase _db;
  final OdometerRepository _odometer;
  final PartsRepository _parts;
  final AttachmentService? _attachments;
  final ExpenseService _expense;
  final DateTime Function() _clock;

  static String? _clean(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  /// Emits a fresh snapshot now and after any relevant table changes, so every
  /// status is recalculated after an odometer update or service record.
  Stream<MaintenanceSnapshot> watchSnapshot() async* {
    yield await loadSnapshot();
    final updates = _db.tableUpdates(TableUpdateQuery.onAllTables([
      _db.motorcycles,
      _db.maintenanceItems,
      _db.maintenanceCategories,
      _db.maintenanceRules,
      _db.maintenanceRuleSteps,
      _db.maintenanceRecords,
      _db.odometerLogs,
    ]));
    await for (final _ in updates) {
      yield await loadSnapshot();
    }
  }

  Future<MaintenanceSnapshot> loadSnapshot() async {
    final bikeRow = await (_db.select(_db.motorcycles)
          ..orderBy([(t) => OrderingTerm.asc(t.id)])
          ..limit(1))
        .getSingleOrNull();
    final bike = bikeRow == null ? null : Motorcycle.fromRow(bikeRow);

    final categories = (await (_db.select(_db.maintenanceCategories)
              ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
            .get())
        .map((c) => CategoryInfo(id: c.id, name: c.name))
        .toList();

    final items = (await (_db.select(_db.maintenanceItems)
              ..where((t) => t.isActive.equals(true))
              ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
            .get())
        .map((i) => ItemInfo(
            id: i.id,
            name: i.name,
            categoryId: i.categoryId,
            instructions: i.instructions))
        .toList();

    final ruleRows = await _db.select(_db.maintenanceRules).get();
    final stepRows = await (_db.select(_db.maintenanceRuleSteps)
          ..orderBy([(t) => OrderingTerm.asc(t.stepOrder)]))
        .get();
    final rules = ruleRows.map((r) {
      final steps = stepRows
          .where((s) => s.ruleId == r.id)
          .map((s) => RuleStepDef(
                actionCode: ActionCode.fromCode(s.actionCode),
                atKm: s.atKm,
                atMonths: s.atMonths,
                repeatEveryKm: s.repeatEveryKm,
                repeatEveryMonths: s.repeatEveryMonths,
              ))
          .toList();
      return RuleDef(
        id: r.id,
        itemId: r.itemId,
        ruleType: RuleType.fromCode(r.ruleType),
        actionCode: ActionCode.fromCode(r.actionCode),
        source: MaintenanceSource.fromCode(r.source),
        sourceDocument: r.sourceDocument,
        sourcePage: r.sourcePage,
        intervalKm: r.intervalKm,
        intervalMonths: r.intervalMonths,
        isVerified: r.isVerified,
        isActive: r.isActive,
        notes: r.notes,
        steps: steps,
      );
    }).toList();

    final recordRows = await (_db.select(_db.maintenanceRecords)
          ..where((t) => t.voidedAt.isNull()))
        .get();
    final records = [
      for (final r in recordRows)
        if (AppDates.parseDateOnly(r.performedDate) != null)
          RecordInfo(
            id: r.id,
            itemId: r.itemId,
            action: MaintenanceAction.fromCode(r.action),
            date: AppDates.parseDateOnly(r.performedDate)!,
            odometerKm: r.odometerKm,
            totalCostCentavos: r.totalCostCentavos,
          ),
    ];

    int? currentKm;
    int? baselineKm;
    DateTime? firstDate;
    if (bike != null) {
      final confirmed = await _odometer.confirmedChronological(bike.id);
      if (confirmed.isNotEmpty) {
        currentKm =
            confirmed.map((l) => l.readingKm).reduce((a, b) => a > b ? a : b);
        baselineKm =
            confirmed.map((l) => l.readingKm).reduce((a, b) => a < b ? a : b);
        firstDate = confirmed.first.recordedDate;
      }
    }

    return MaintenanceSnapshot(
      motorcycle: bike,
      categories: categories,
      items: items,
      rules: rules,
      records: records,
      currentKm: currentKm,
      baselineKm: baselineKm,
      firstLogDate: firstDate,
    );
  }

  /// Streams full non-voided maintenance records in chronological order
  /// (newest first), optionally filtered.
  Stream<List<MaintenanceRecordDetail>> watchHistory({
    MaintenanceHistoryFilter filter = const MaintenanceHistoryFilter(),
  }) async* {
    yield (await loadHistory()).where(filter.matches).toList();
    final updates = _db.tableUpdates(TableUpdateQuery.onAllTables([
      _db.maintenanceRecords,
      _db.maintenanceRecordParts,
      _db.parts,
      _db.attachments,
      _db.maintenanceItems,
      _db.maintenanceCategories,
    ]));
    await for (final _ in updates) {
      yield (await loadHistory()).where(filter.matches).toList();
    }
  }

  Future<MaintenanceRecordDetail?> findRecord(int id) async {
    final all = await loadHistory();
    return all.where((r) => r.id == id).firstOrNull;
  }

  Future<List<MaintenanceRecordDetail>> loadHistory() async {
    final cats = {
      for (final c in await _db.select(_db.maintenanceCategories).get())
        c.id: c.name
    };
    final items = {
      for (final i in await _db.select(_db.maintenanceItems).get()) i.id: i
    };
    final partsMap = {
      for (final p in await _db.select(_db.parts).get())
        p.id: PartInfo(
          id: p.id,
          itemId: p.itemId,
          name: p.name,
          brand: p.brand,
          partNumber: p.partNumber,
          specification: p.specification,
          purchasePriceCentavos: p.purchasePriceCentavos,
          purchaseDate: AppDates.parseDateOnly(p.purchaseDate),
          supplier: p.supplier,
          quantity: p.quantity,
        )
    };
    final recParts = await _db.select(_db.maintenanceRecordParts).get();
    final attRows = await (_db.select(_db.attachments)
          ..where((t) => t.recordId.isNotNull()))
        .get();

    final rows = await (_db.select(_db.maintenanceRecords)
          ..where((t) => t.voidedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.performedDate),
            (t) => OrderingTerm.desc(t.odometerKm),
            (t) => OrderingTerm.desc(t.id),
          ]))
        .get();

    final out = <MaintenanceRecordDetail>[];
    for (final r in rows) {
      final item = items[r.itemId];
      final date = AppDates.parseDateOnly(r.performedDate);
      if (item == null || date == null) continue;
      final rpList = <RecordPartDetail>[];
      for (final rp in recParts.where((x) => x.recordId == r.id)) {
        final p = partsMap[rp.partId];
        if (p != null) {
          rpList.add(RecordPartDetail(
            id: rp.id,
            part: p,
            quantity: rp.quantity,
            unitCostCentavos: rp.unitCostCentavos,
          ));
        }
      }
      final atts = [
        for (final a in attRows.where((x) => x.recordId == r.id))
          AttachmentInfo(
            id: a.id,
            filePath: a.filePath,
            mimeType: a.mimeType,
            caption: a.caption,
          ),
      ];
      out.add(MaintenanceRecordDetail(
        id: r.id,
        motorcycleId: r.motorcycleId,
        itemId: r.itemId,
        itemName: item.name,
        categoryId: item.categoryId,
        categoryName: cats[item.categoryId] ?? '',
        action: MaintenanceAction.fromCode(r.action),
        performedDate: date,
        odometerKm: r.odometerKm,
        laborCostCentavos: r.laborCostCentavos,
        totalCostCentavos: r.totalCostCentavos,
        serviceProvider: r.serviceProvider,
        notes: r.notes,
        supersedesRecordId: r.supersedesRecordId,
        parts: rpList,
        attachments: atts,
      ));
    }
    return out;
  }

  /// Saves a service record in one transaction. If the record's odometer is
  /// higher than the latest confirmed reading, that reading is logged too, so
  /// mileage-based statuses stay consistent. Records are never overwritten.
  Future<int> addRecord(NewMaintenanceRecord r) =>
      _saveRecord(r, supersedesId: null);

  /// Edits a service record by voiding the original (`voidedAt` set) and
  /// creating a new record pointing to it via `supersedesRecordId`, so history
  /// is never overwritten in place.
  Future<int> editRecord(int recordId, NewMaintenanceRecord updated) =>
      _saveRecord(updated, supersedesId: recordId);

  /// Soft-deletes a record (`voidedAt` set). Never removes rows from SQLite.
  Future<void> voidRecord(int recordId) async {
    final row = await (_db.select(_db.maintenanceRecords)
          ..where((t) => t.id.equals(recordId)))
        .getSingleOrNull();
    if (row == null) throw const MaintenanceException('Record not found.');
    if (row.voidedAt != null) {
      throw const MaintenanceException('Record is already voided.');
    }
    await (_db.update(_db.maintenanceRecords)
          ..where((t) => t.id.equals(recordId)))
        .write(MaintenanceRecordsCompanion(
            voidedAt: Value(_clock().toIso8601String())));
  }

  Future<int> _saveRecord(NewMaintenanceRecord r,
      {required int? supersedesId}) async {
    if (r.odometerKm < 0) {
      throw const MaintenanceException('Odometer cannot be negative.');
    }
    if (r.laborCostCentavos < 0) {
      throw const MaintenanceException('Costs cannot be negative.');
    }
    for (final p in r.parts) {
      if (p.quantity < 1) {
        throw const MaintenanceException('Part quantity must be at least 1.');
      }
      if (p.unitCostCentavos < 0) {
        throw const MaintenanceException('Part unit cost cannot be negative.');
      }
      if (p.existingPartId == null && p.name.trim().isEmpty) {
        throw const MaintenanceException('Part name is required.');
      }
    }
    final computedTotal = _expense.totalCentavos(
      laborCentavos: r.laborCostCentavos,
      parts: r.parts.map(
          (p) => (quantity: p.quantity, unitCostCentavos: p.unitCostCentavos)),
    );
    final total = r.totalCostCentavos ?? computedTotal;
    if (total < 0) {
      throw const MaintenanceException('Costs cannot be negative.');
    }
    if (r.laborCostCentavos > total) {
      throw const MaintenanceException('Labor cost cannot exceed total cost.');
    }
    if (r.parts.isNotEmpty && total < computedTotal) {
      throw const MaintenanceException(
          'Total cost cannot be less than labor plus parts.');
    }
    final day = AppDates.dateOnly(r.date);
    if (day.isAfter(AppDates.todayManila(_clock()))) {
      throw const MaintenanceException('Date cannot be in the future.');
    }

    final storedPhotos = r.photoPaths.isEmpty
        ? const <StoredPhoto>[]
        : await (_attachments != null
            ? _attachments.store(r.photoPaths)
            : Future.value([
                for (final path in r.photoPaths) StoredPhoto(path: path),
              ]));

    try {
      return await _db.transaction(() async {
        final item = await (_db.select(_db.maintenanceItems)
              ..where((t) => t.id.equals(r.itemId)))
            .getSingleOrNull();
        if (item == null) {
          throw const MaintenanceException('Maintenance item not found.');
        }

        List<AttachmentRow> keptAttachments = const [];
        if (supersedesId != null) {
          final old = await (_db.select(_db.maintenanceRecords)
                ..where((t) => t.id.equals(supersedesId)))
              .getSingleOrNull();
          if (old == null || old.voidedAt != null) {
            throw const MaintenanceException('Original record not found.');
          }
          await (_db.update(_db.maintenanceRecords)
                ..where((t) => t.id.equals(supersedesId)))
              .write(MaintenanceRecordsCompanion(
                  voidedAt: Value(_clock().toIso8601String())));
          if (r.keepAttachmentIds.isNotEmpty) {
            keptAttachments = await (_db.select(_db.attachments)
                  ..where((t) =>
                      t.recordId.equals(supersedesId) &
                      t.id.isIn(r.keepAttachmentIds)))
                .get();
          }
        }

        await _odometer.logIfHigher(
          motorcycleId: r.motorcycleId,
          readingKm: r.odometerKm,
          date: day,
          note: 'Logged from maintenance record',
          createdAt: _clock(),
        );

        final recordId = await _db.into(_db.maintenanceRecords).insert(
              MaintenanceRecordsCompanion.insert(
                motorcycleId: r.motorcycleId,
                itemId: r.itemId,
                action: r.action.code,
                performedDate: AppDates.toIsoDate(day),
                odometerKm: r.odometerKm,
                laborCostCentavos: Value(r.laborCostCentavos),
                totalCostCentavos: Value(total),
                serviceProvider: Value(_clean(r.serviceProvider)),
                notes: Value(_clean(r.notes)),
                supersedesRecordId: Value(supersedesId),
                createdAt: _clock().toIso8601String(),
              ),
            );

        if (supersedesId != null && r.parts.isEmpty) {
          await _parts.moveInstallationsToRecord(supersedesId, recordId);
        }

        for (final p in r.parts) {
          final int partId;
          if (p.existingPartId != null) {
            final existing = await _parts.findPart(p.existingPartId!);
            if (existing == null) {
              throw const MaintenanceException('Selected part not found.');
            }
            partId = existing.id;
          } else {
            partId = await _parts.addPart(NewPart(
              itemId: r.itemId,
              name: p.name,
              brand: p.brand,
              partNumber: p.partNumber,
              specification: p.specification,
              purchasePriceCentavos: p.unitCostCentavos,
              purchaseDate: day,
              quantity: p.quantity,
            ));
          }
          await _db.into(_db.maintenanceRecordParts).insert(
                MaintenanceRecordPartsCompanion.insert(
                  recordId: recordId,
                  partId: partId,
                  quantity: Value(p.quantity),
                  unitCostCentavos: Value(p.unitCostCentavos),
                ),
              );
          if (r.action == MaintenanceAction.replacement &&
              p.trackInstallation) {
            await _parts.install(
              partId: partId,
              motorcycleId: r.motorcycleId,
              date: day,
              odometerKm: r.odometerKm,
              position: p.position,
              recordId: recordId,
              notes: r.notes,
            );
          }
        }

        final nowIso = _clock().toIso8601String();
        for (final a in keptAttachments) {
          await _db.into(_db.attachments).insert(AttachmentsCompanion.insert(
                recordId: Value(recordId),
                motorcycleId: Value(r.motorcycleId),
                filePath: a.filePath,
                mimeType: Value(a.mimeType),
                caption: Value(a.caption),
                createdAt: nowIso,
              ));
        }
        for (final ph in storedPhotos) {
          await _db.into(_db.attachments).insert(AttachmentsCompanion.insert(
                recordId: Value(recordId),
                motorcycleId: Value(r.motorcycleId),
                filePath: ph.path,
                mimeType: Value(ph.mimeType),
                createdAt: nowIso,
              ));
        }

        return recordId;
      });
    } catch (_) {
      if (_attachments != null && storedPhotos.isNotEmpty) {
        await _attachments.discard(storedPhotos);
      }
      rethrow;
    }
  }

  /// Adds a CUSTOM rule (e.g. a fuel filter replacement interval). Never
  /// modifies Honda manual rules; both are evaluated side by side.
  Future<int> addCustomRule({
    required int motorcycleId,
    required int itemId,
    required ActionCode action,
    int? intervalKm,
    int? intervalMonths,
    String? notes,
  }) async {
    if (intervalKm == null && intervalMonths == null) {
      throw const MaintenanceException(
          'Enter a distance and/or time interval.');
    }
    if ((intervalKm != null && intervalKm <= 0) ||
        (intervalMonths != null && intervalMonths <= 0)) {
      throw const MaintenanceException('Intervals must be greater than zero.');
    }
    final type = (intervalKm != null && intervalMonths != null)
        ? RuleType.combined
        : intervalKm != null
            ? RuleType.mileage
            : RuleType.date;
    return _db
        .into(_db.maintenanceRules)
        .insert(MaintenanceRulesCompanion.insert(
          motorcycleId: motorcycleId,
          itemId: itemId,
          ruleType: type.code,
          actionCode: action.code,
          source: MaintenanceSource.custom.code,
          intervalKm: Value(intervalKm),
          intervalMonths: Value(intervalMonths),
          isVerified: const Value(false),
          notes: Value(notes),
        ));
  }
}
