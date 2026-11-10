import 'package:drift/drift.dart';

import 'motorcycle_tables.dart';

@DataClassName('PartsCatalogRow')
@TableIndex(name: 'idx_parts_cat_part_no', columns: {#partNumber})
@TableIndex(name: 'idx_parts_cat_category', columns: {#category})
@TableIndex(name: 'idx_parts_cat_assembly', columns: {#assemblyName})
class PartsCatalog extends Table {
  @override
  String get tableName => 'parts_catalog';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get partNumber => text().withLength(min: 3, max: 50)();
  TextColumn get officialName => text().withLength(min: 1, max: 150)();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().withLength(min: 1, max: 80)();
  TextColumn get assemblyName => text().withLength(min: 1, max: 100)();
  TextColumn get diagramNumber => text().nullable()();
  IntColumn get referenceNumber => integer().nullable()();
  IntColumn get standardQuantity => integer().withDefault(const Constant(1))();
  TextColumn get supersededPartNumber => text().nullable()();
  TextColumn get remarks => text().nullable()();
  IntColumn get maintenanceItemId =>
      integer().nullable().references(MaintenanceItems, #id)();
  TextColumn get imageAssetPath => text().nullable()();
  TextColumn get createdAt => text()();
}

@DataClassName('PartsCatalogImageRow')
@TableIndex(name: 'idx_parts_cat_diagram', columns: {#diagramCode})
class PartsCatalogImages extends Table {
  @override
  String get tableName => 'parts_catalog_images';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get diagramCode => text().withLength(min: 1, max: 50)();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  TextColumn get description => text().nullable()();
  TextColumn get imageAssetPath => text().nullable()();
  TextColumn get assemblyName => text().withLength(min: 1, max: 100)();
}

@DataClassName('PartsCatalogCompatibilityRow')
@TableIndex(name: 'idx_parts_cat_compat_part', columns: {#partsCatalogId})
class PartsCatalogCompatibility extends Table {
  @override
  String get tableName => 'parts_catalog_compatibility';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get partsCatalogId => integer().references(PartsCatalog, #id)();
  TextColumn get modelName => text().withLength(min: 1, max: 100)();
  TextColumn get modelCode => text().withLength(min: 1, max: 30)();
  IntColumn get startYear => integer()();
  IntColumn get endYear => integer().nullable()();
  TextColumn get regionalVariant => text().withLength(min: 1, max: 50)();
  TextColumn get notes => text().nullable()();
}
