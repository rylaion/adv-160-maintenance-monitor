import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/parts_catalog_models.dart';

/// Official sequential order of diagrams in Honda ADV160 Parts Catalogue 18K0WP01.
const List<String> kOfficialDiagramOrder = [
  'E-2',
  'E-3',
  'E-4',
  'E-5',
  'E-6',
  'E-9',
  'E-10',
  'E-11',
  'E-13',
  'E-14',
  'E-16',
  'E-17',
  'E-17-10',
  'E-19-10',
  'E-19-20',
  'E-20',
  'E-22',
  'F-1',
  'F-2',
  'F-3',
  'F-4',
  'F-5-20',
  'F-6',
  'F-7-10',
  'F-9',
  'F-10',
  'F-11',
  'F-12',
  'F-13',
  'F-14',
  'F-14-10',
  'F-15',
  'F-16',
  'F-17',
  'F-18',
  'F-20-40',
  'F-21',
  'F-22-40',
  'F-24',
  'F-26',
  'F-28',
  'F-30',
  'F-35',
  'F-36',
  'F-37',
  'F-38',
  'F-39',
  'F-40',
  'F-41',
  'F-42',
  'F-43',
  'F-46',
  'F-47',
  'F-48',
];

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

  /// Watch all available exploded diagrams strictly in official Honda catalogue order.
  Stream<List<PartsCatalogDiagramInfo>> watchDiagrams() {
    final orderMap = {
      for (int i = 0; i < kOfficialDiagramOrder.length; i++)
        kOfficialDiagramOrder[i]: i,
    };

    return _db.select(_db.partsCatalogImages).watch().map((rows) {
      final list = rows.map(PartsCatalogDiagramInfo.fromRow).toList();
      list.sort((a, b) {
        final orderA = orderMap[a.diagramCode] ?? 999;
        final orderB = orderMap[b.diagramCode] ?? 999;
        if (orderA != orderB) return orderA.compareTo(orderB);
        return (a.printedPageNumber ?? 0).compareTo(b.printedPageNumber ?? 0);
      });
      return list;
    });
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
