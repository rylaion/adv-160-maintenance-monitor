import 'package:drift/drift.dart';

import 'motorcycle_tables.dart';

/// A service performed. Records are never overwritten; mistakes are voided
/// (soft delete via [voidedAt]) so history is preserved.
@DataClassName('MaintenanceRecordRow')
@TableIndex(name: 'idx_records_item_date', columns: {#itemId, #performedDate})
@TableIndex(name: 'idx_records_motorcycle', columns: {#motorcycleId})
class MaintenanceRecords extends Table {
  @override
  String get tableName => 'maintenance_records';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get motorcycleId => integer().references(Motorcycles, #id)();
  IntColumn get itemId => integer().references(MaintenanceItems, #id)();

  /// INSPECTION | CLEANING | ADJUSTMENT | REPLACEMENT | LUBRICATION
  TextColumn get action => text()();
  TextColumn get performedDate => text()();
  IntColumn get odometerKm => integer()();
  IntColumn get laborCostCentavos => integer().withDefault(const Constant(0))();
  IntColumn get totalCostCentavos => integer().withDefault(const Constant(0))();
  TextColumn get serviceProvider => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get voidedAt => text().nullable()();

  /// When this record is an edited version, the record it replaces. The old
  /// record is kept (voided) so history is never overwritten.
  IntColumn get supersedesRecordId =>
      integer().nullable().references(MaintenanceRecords, #id)();
  TextColumn get createdAt => text()();
}

/// Odometer audit trail. Corrections create a new row that supersedes the
/// erroneous one; the original is kept with status CORRECTED/VOIDED.
@DataClassName('OdometerLogRow')
@TableIndex(
    name: 'idx_odometer_motorcycle_date',
    columns: {#motorcycleId, #recordedDate})
class OdometerLogs extends Table {
  @override
  String get tableName => 'odometer_logs';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get motorcycleId => integer().references(Motorcycles, #id)();
  IntColumn get readingKm =>
      integer().customConstraint('NOT NULL CHECK (reading_km >= 0)')();
  TextColumn get recordedDate => text()();
  TextColumn get notes => text().nullable()();

  /// CONFIRMED | CORRECTED | VOIDED
  TextColumn get status => text().withDefault(const Constant('CONFIRMED'))();
  IntColumn get supersedesLogId =>
      integer().nullable().references(OdometerLogs, #id)();
  TextColumn get correctionReason => text().nullable()();
  TextColumn get createdAt => text()();
}

@DataClassName('ComponentMeasurementRow')
@TableIndex(
    name: 'idx_measurements_item_date', columns: {#itemId, #measuredDate})
class ComponentMeasurements extends Table {
  @override
  String get tableName => 'component_measurements';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get motorcycleId => integer().references(Motorcycles, #id)();
  IntColumn get itemId => integer().references(MaintenanceItems, #id)();
  IntColumn get recordId =>
      integer().nullable().references(MaintenanceRecords, #id)();
  TextColumn get measuredDate => text()();
  IntColumn get odometerKm => integer().nullable()();

  /// e.g. THICKNESS_MM, VOLTAGE_V, PRESSURE_KPA, TREAD_DEPTH_MM
  TextColumn get measurementType => text()();
  /// Null for condition-only observations (no numeric reading).
  RealColumn get value => real().nullable()();
  TextColumn get unit => text()();

  /// FRONT | REAR (nullable when not applicable)
  TextColumn get position => text().nullable()();

  /// e.g. ENGINE_OFF | ENGINE_RUNNING | CHARGING for battery readings
  TextColumn get measurementContext => text().nullable()();
  TextColumn get brand => text().nullable()();
  TextColumn get partNumber => text().nullable()();
  TextColumn get visualCondition => text().nullable()();
  BoolColumn get hasDamage => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();

  /// Soft delete: measurements are never physically removed.
  TextColumn get voidedAt => text().nullable()();
  TextColumn get createdAt => text()();
}

