import 'package:drift/drift.dart';

import 'history_tables.dart';
import 'motorcycle_tables.dart';

@DataClassName('PartRow')
@TableIndex(name: 'idx_parts_item', columns: {#itemId})
class Parts extends Table {
  @override
  String get tableName => 'parts';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId =>
      integer().nullable().references(MaintenanceItems, #id)();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get brand => text().nullable()();
  TextColumn get partNumber => text().nullable()();
  TextColumn get specification => text().nullable()();
  IntColumn get purchasePriceCentavos =>
      integer().withDefault(const Constant(0))();
  TextColumn get purchaseDate => text().nullable()();
  TextColumn get supplier => text().nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get createdAt => text()();
}

@DataClassName('MaintenanceRecordPartRow')
@TableIndex(name: 'idx_record_parts_record', columns: {#recordId})
@TableIndex(name: 'idx_record_parts_part', columns: {#partId})
class MaintenanceRecordParts extends Table {
  @override
  String get tableName => 'maintenance_record_parts';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get recordId => integer().references(MaintenanceRecords, #id)();
  IntColumn get partId => integer().references(Parts, #id)();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  IntColumn get unitCostCentavos => integer().withDefault(const Constant(0))();
}

/// Lifecycle of an installed part. Replacing a part closes the old row
/// (removed_*) and opens a new one; nothing is overwritten.
@DataClassName('PartInstallationRow')
@TableIndex(name: 'idx_installations_part', columns: {#partId})
@TableIndex(name: 'idx_installations_motorcycle', columns: {#motorcycleId})
class PartInstallations extends Table {
  @override
  String get tableName => 'part_installations';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get partId => integer().references(Parts, #id)();
  IntColumn get motorcycleId => integer().references(Motorcycles, #id)();
  IntColumn get recordId =>
      integer().nullable().references(MaintenanceRecords, #id)();

  /// FRONT | REAR (nullable when not applicable)
  TextColumn get position => text().nullable()();
  TextColumn get installedDate => text()();
  IntColumn get installedOdometerKm => integer()();
  TextColumn get removedDate => text().nullable()();
  IntColumn get removedOdometerKm => integer().nullable()();
  TextColumn get notes => text().nullable()();
}
