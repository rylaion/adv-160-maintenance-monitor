import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/parts_catalog_models.dart';

class PartsCatalogRepository {
  PartsCatalogRepository(this._db);

  final AppDatabase _db;

  /// Watch parts catalog with optional category and search query filters.
  Stream<List<PartsCatalogItem>> watchParts({
    String? query,
    String? category,
  }) {
    final q = _db.select(_db.partsCatalog);

    if (category != null && category.isNotEmpty && category != 'All') {
      q.where((t) => t.category.equals(category));
    }

    if (query != null && query.trim().isNotEmpty) {
      final clean = query.trim().toLowerCase();
      // Match with or without dashes
      final noDash = clean.replaceAll('-', '');
      const unhyphenatedPartNo =
          CustomExpression<String>("REPLACE(LOWER(part_number), '-', '')");
      q.where((t) {
        return t.officialName.lower().like('%$clean%') |
            t.partNumber.lower().like('%$clean%') |
            unhyphenatedPartNo.like('%$noDash%') |
            t.assemblyName.lower().like('%$clean%') |
            t.description.lower().like('%$clean%') |
            t.diagramNumber.lower().like('%$clean%');
      });
    }

    q.orderBy([
      (t) => OrderingTerm.asc(t.category),
      (t) => OrderingTerm.asc(t.officialName)
    ]);

    return q.watch().map((rows) => rows.map(PartsCatalogItem.fromRow).toList());
  }

  /// Get detailed part information including verified model compatibilities.
  Future<PartsCatalogItem?> getPartById(int id) async {
    final row = await (_db.select(_db.partsCatalog)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;

    final compRows = await (_db.select(_db.partsCatalogCompatibility)
          ..where((t) => t.partsCatalogId.equals(id)))
        .get();

    return PartsCatalogItem.fromRow(row, compRows);
  }

  /// Search part by exact or partial OEM part number.
  Future<PartsCatalogItem?> getPartByPartNumber(String partNumber) async {
    final clean = partNumber.trim();
    final row = await (_db.select(_db.partsCatalog)
          ..where((t) => t.partNumber.equals(clean))
          ..limit(1))
        .getSingleOrNull();

    if (row == null) return null;
    return getPartById(row.id);
  }

  /// Get distinct component categories present in the catalogue.
  Future<List<String>> getCategories() async {
    final q = _db.selectOnly(_db.partsCatalog, distinct: true)
      ..addColumns([_db.partsCatalog.category])
      ..orderBy([OrderingTerm.asc(_db.partsCatalog.category)]);

    final rows = await q.get();
    return rows.map((r) => r.read(_db.partsCatalog.category)!).toList();
  }

  /// Watch all available exploded diagrams.
  Stream<List<PartsCatalogDiagramInfo>> watchDiagrams() {
    return (_db.select(_db.partsCatalogImages)
          ..orderBy([(t) => OrderingTerm.asc(t.diagramCode)]))
        .watch()
        .map((rows) => rows.map(PartsCatalogDiagramInfo.fromRow).toList());
  }

  /// Get all catalogue parts assigned to a specific diagram code (e.g. "E-17").
  Future<List<PartsCatalogItem>> getPartsForDiagram(String diagramCode) async {
    final rows = await (_db.select(_db.partsCatalog)
          ..where((t) => t.diagramNumber.equals(diagramCode))
          ..orderBy([(t) => OrderingTerm.asc(t.referenceNumber)]))
        .get();

    return rows.map(PartsCatalogItem.fromRow).toList();
  }
}
