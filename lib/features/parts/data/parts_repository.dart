import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/date_utils.dart';
import '../domain/part_models.dart';

/// Repository for parts and their installation lifecycle.
///
/// Lifecycle rule: installing a part never edits earlier rows other than
/// stamping `removed_*` on the part it replaces, so every installed component
/// remains in history.
class PartsRepository {
  PartsRepository(this._db, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  DateTime get _today => AppDates.todayManila(_clock());

  static PartInfo _part(PartRow r) => PartInfo(
        id: r.id,
        itemId: r.itemId,
        name: r.name,
        brand: r.brand,
        partNumber: r.partNumber,
        specification: r.specification,
        purchasePriceCentavos: r.purchasePriceCentavos,
        purchaseDate: AppDates.parseDateOnly(r.purchaseDate),
        supplier: r.supplier,
        quantity: r.quantity,
      );

  static String? _clean(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  Stream<List<PartInfo>> watchParts() {
    final q = _db.select(_db.parts)
      ..orderBy([(t) => OrderingTerm.desc(t.id)]);
    return q.watch().map((rows) => rows.map(_part).toList());
  }

  Future<PartInfo?> findPart(int id) async {
    final row = await (_db.select(_db.parts)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _part(row);
  }

  /// Validates and inserts a part. Must be callable inside a transaction.
  Future<int> addPart(NewPart p) async {
    final name = p.name.trim();
    if (name.isEmpty) throw const PartsException('Part name is required.');
    if (name.length > 120) {
      throw const PartsException('Part name is too long (max 120).');
    }
    if (p.quantity < 1) {
      throw const PartsException('Quantity must be at least 1.');
    }
    if (p.purchasePriceCentavos < 0) {
      throw const PartsException('Price cannot be negative.');
    }
    final pd = p.purchaseDate == null ? null : AppDates.dateOnly(p.purchaseDate!);
    if (pd != null && pd.isAfter(_today)) {
      throw const PartsException('Purchase date cannot be in the future.');
    }
    if (p.itemId != null) {
      final item = await (_db.select(_db.maintenanceItems)
            ..where((t) => t.id.equals(p.itemId!)))
          .getSingleOrNull();
      if (item == null) throw const PartsException('Maintenance item not found.');
    }
    return _db.into(_db.parts).insert(PartsCompanion.insert(
          itemId: Value(p.itemId),
          name: name,
          brand: Value(_clean(p.brand)),
          partNumber: Value(_clean(p.partNumber)),
          specification: Value(_clean(p.specification)),
          purchasePriceCentavos: Value(p.purchasePriceCentavos),
          purchaseDate: Value(pd == null ? null : AppDates.toIsoDate(pd)),
          supplier: Value(_clean(p.supplier)),
          quantity: Value(p.quantity),
          createdAt: _clock().toIso8601String(),
        ));
  }

  /// Installations (newest first), optionally for one maintenance item.
  Stream<List<InstallationInfo>> watchInstallations({int? itemId}) async* {
    yield await loadInstallations(itemId: itemId);
    final updates = _db.tableUpdates(TableUpdateQuery.onAllTables(
        [_db.partInstallations, _db.parts, _db.maintenanceItems]));
    await for (final _ in updates) {
      yield await loadInstallations(itemId: itemId);
    }
  }

  Future<List<InstallationInfo>> loadInstallations({int? itemId}) async {
    final q = _db.select(_db.partInstallations).join([
      innerJoin(_db.parts, _db.parts.id.equalsExp(_db.partInstallations.partId)),
      leftOuterJoin(_db.maintenanceItems,
          _db.maintenanceItems.id.equalsExp(_db.parts.itemId)),
    ]);
    if (itemId != null) q.where(_db.parts.itemId.equals(itemId));
    q.orderBy([
      OrderingTerm.desc(_db.partInstallations.installedDate),
      OrderingTerm.desc(_db.partInstallations.id),
    ]);
    final rows = await q.get();
    return rows.map((r) {
      final i = r.readTable(_db.partInstallations);
      return InstallationInfo(
        id: i.id,
        part: _part(r.readTable(_db.parts)),
        itemName: r.readTableOrNull(_db.maintenanceItems)?.name,
        position: i.position,
        installedDate:
            AppDates.parseDateOnly(i.installedDate) ?? DateTime.utc(1970),
        installedKm: i.installedOdometerKm,
        removedDate: AppDates.parseDateOnly(i.removedDate),
        removedKm: i.removedOdometerKm,
        notes: i.notes,
      );
    }).toList();
  }

  /// Installs [partId]. If another part of the same item (and position) is
  /// currently installed, it is closed at the same date/odometer.
  Future<int> install({
    required int partId,
    required int motorcycleId,
    required DateTime date,
    required int odometerKm,
    String? position,
    int? recordId,
    String? notes,
  }) {
    return _db.transaction(() async {
      final day = AppDates.dateOnly(date);
      if (odometerKm < 0) {
        throw const PartsException('Odometer cannot be negative.');
      }
      if (day.isAfter(_today)) {
        throw const PartsException('Installation date cannot be in the future.');
      }
      final part = await findPart(partId);
      if (part == null) throw const PartsException('Part not found.');
      final pos = _clean(position);

      final alreadyOpen = await (_db.select(_db.partInstallations)
            ..where((t) => t.partId.equals(partId) & t.removedDate.isNull()))
          .get();
      if (alreadyOpen.isNotEmpty) {
        throw const PartsException('This part is already installed.');
      }

      if (part.itemId != null) {
        final open = await loadInstallations(itemId: part.itemId);
        for (final o in open.where((o) => o.isInstalled && o.position == pos)) {
          await _close(o, day, odometerKm);
        }
      }

      return _db.into(_db.partInstallations).insert(
            PartInstallationsCompanion.insert(
              partId: partId,
              motorcycleId: motorcycleId,
              recordId: Value(recordId),
              position: Value(pos),
              installedDate: AppDates.toIsoDate(day),
              installedOdometerKm: odometerKm,
              notes: Value(_clean(notes)),
            ),
          );
    });
  }

  /// Marks an installed part as removed without a replacement.
  Future<void> remove({
    required int installationId,
    required DateTime date,
    required int odometerKm,
  }) async {
    await _db.transaction(() async {
      final all = await loadInstallations();
      final target = all.where((i) => i.id == installationId).firstOrNull;
      if (target == null) throw const PartsException('Installation not found.');
      if (!target.isInstalled) {
        throw const PartsException('This part has already been removed.');
      }
      final day = AppDates.dateOnly(date);
      if (day.isAfter(_today)) {
        throw const PartsException('Removal date cannot be in the future.');
      }
      await _close(target, day, odometerKm);
    });
  }

  Future<void> _close(InstallationInfo i, DateTime day, int km) async {
    if (day.isBefore(i.installedDate)) {
      throw const PartsException(
          'Removal date is earlier than the installation date.');
    }
    if (km < i.installedKm) {
      throw PartsException(
          'Odometer is lower than when the part was installed (${i.installedKm} km).');
    }
    await (_db.update(_db.partInstallations)..where((t) => t.id.equals(i.id)))
        .write(PartInstallationsCompanion(
      removedDate: Value(AppDates.toIsoDate(day)),
      removedOdometerKm: Value(km),
    ));
  }

  /// Re-points installations from a replaced (edited) record to its new version.
  Future<void> moveInstallationsToRecord(int fromRecordId, int toRecordId) =>
      (_db.update(_db.partInstallations)
            ..where((t) => t.recordId.equals(fromRecordId)))
          .write(PartInstallationsCompanion(recordId: Value(toRecordId)));
}

