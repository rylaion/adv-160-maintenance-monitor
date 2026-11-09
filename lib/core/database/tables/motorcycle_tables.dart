import 'package:drift/drift.dart';

/// Conventions for every table:
/// * Dates/timestamps are stored as ISO 8601 text.
/// * Odometer values are integer kilometers.
/// * Money is stored as integer centavos.
/// * Component measurements are decimal (REAL).

@DataClassName('MotorcycleRow')
class Motorcycles extends Table {
  @override
  String get tableName => 'motorcycles';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get brand => text().withLength(min: 1, max: 80)();
  TextColumn get model => text().withLength(min: 1, max: 80)();
  IntColumn get modelYear => integer()();
  TextColumn get plateNumber => text().nullable()();
  TextColumn get chassisNumber => text().nullable()();
  TextColumn get engineNumber => text().nullable()();
  TextColumn get purchaseDate => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
}

@DataClassName('MaintenanceCategoryRow')
class MaintenanceCategories extends Table {
  @override
  String get tableName => 'maintenance_categories';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80).unique()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

@DataClassName('MaintenanceItemRow')
@TableIndex(name: 'idx_maintenance_items_category', columns: {#categoryId})
class MaintenanceItems extends Table {
  @override
  String get tableName => 'maintenance_items';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId =>
      integer().references(MaintenanceCategories, #id)();
  TextColumn get name => text().withLength(min: 1, max: 80).unique()();
  TextColumn get instructions => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
