import 'package:drift/drift.dart';

import '../app_database.dart';
import 'honda_adv160_catalogue_data.dart';

/// Seeds verified official Honda OEM parts catalogue for the Honda ADV 160 (ADV160AP, 18K0WP01).
class HondaPartsSeed {
  HondaPartsSeed(this.db);
  final AppDatabase db;

  static const String sourceModel = 'Honda ADV 160';
  static const String sourceModelCode = 'ADV160AP';
  static const int modelYear = 2022;
  static const String regionalVariant = 'Philippines (2PH)';

  Future<void> ensureDiagramsSeeded() async {
    try {
      final tableCheck = await db
          .customSelect(
            "SELECT count(*) as c FROM sqlite_master WHERE type='table' AND name='parts_catalog_images';",
          )
          .getSingle();
      if ((tableCheck.data['c'] as int? ?? 0) == 0) {
        return; // Table does not exist yet (e.g. during schema migration tests)
      }

      for (final d in officialHondaDiagrams) {
        final existing = await (db.select(db.partsCatalogImages)
              ..where((t) => t.diagramCode.equals(d.diagramCode)))
            .getSingleOrNull();
        if (existing == null) {
          await db.into(db.partsCatalogImages).insert(
                PartsCatalogImagesCompanion.insert(
                  diagramCode: d.diagramCode,
                  title: d.title,
                  assemblyName: d.assemblyName,
                  description: Value(d.description),
                  imageAssetPath: Value(d.imageAssetPath),
                ),
              );
        } else if (existing.imageAssetPath != d.imageAssetPath ||
            existing.title != d.title) {
          await (db.update(db.partsCatalogImages)
                ..where((t) => t.id.equals(existing.id)))
              .write(
            PartsCatalogImagesCompanion(
              title: Value(d.title),
              assemblyName: Value(d.assemblyName),
              description: Value(d.description),
              imageAssetPath: Value(d.imageAssetPath),
            ),
          );
        }
      }
    } catch (_) {
      // Gracefully ignore if database is in an intermediate migration state
    }
  }

  Future<void> run() async {
    await db.transaction(() async {
      await ensureDiagramsSeeded();

      // 1. Fetch Maintenance Items map to link catalog parts directly
      final items = await (db.select(db.maintenanceItems)).get();
      final itemMap = {for (final item in items) item.name: item.id};

      final existingCount = await (db.select(db.partsCatalog)).get();
      if (existingCount.length >= 500) {
        return; // Already fully seeded with complete catalogue
      }

      final nowStr = DateTime.now().toIso8601String();

      for (final p in officialHondaParts) {
        final existing = await (db.select(db.partsCatalog)
              ..where((t) => t.partNumber.equals(p.partNumber)))
            .getSingleOrNull();

        final int catalogId;
        if (existing == null) {
          catalogId = await db.into(db.partsCatalog).insert(
                PartsCatalogCompanion.insert(
                  partNumber: p.partNumber,
                  officialName: p.officialName,
                  description: Value(
                      'Genuine Honda OEM part for ADV160AP. Diagram ${p.diagramNumber} Ref #${p.refNo}.'),
                  category: p.category,
                  assemblyName: p.assemblyName,
                  diagramNumber: Value(p.diagramNumber),
                  referenceNumber: Value(p.refNo),
                  standardQuantity: Value(p.standardQuantity),
                  remarks: Value(p.remarks),
                  maintenanceItemId: Value(
                    p.maintenanceItemName != null
                        ? itemMap[p.maintenanceItemName]
                        : null,
                  ),
                  createdAt: nowStr,
                ),
              );
        } else {
          catalogId = existing.id;
          // Update diagram/ref link if older seed was sparse
          if (existing.diagramNumber == null ||
              existing.diagramNumber != p.diagramNumber) {
            await (db.update(db.partsCatalog)
                  ..where((t) => t.id.equals(existing.id)))
                .write(
              PartsCatalogCompanion(
                diagramNumber: Value(p.diagramNumber),
                referenceNumber: Value(p.refNo),
                assemblyName: Value(p.assemblyName),
                category: Value(p.category),
                officialName: Value(p.officialName),
                maintenanceItemId: Value(
                  p.maintenanceItemName != null
                      ? itemMap[p.maintenanceItemName]
                      : existing.maintenanceItemId,
                ),
              ),
            );
          }
        }

        // Add compatibility record
        final existingCompat = await (db.select(db.partsCatalogCompatibility)
              ..where((t) =>
                  t.partsCatalogId.equals(catalogId) &
                  t.modelCode.equals(sourceModelCode)))
            .getSingleOrNull();

        if (existingCompat == null) {
          await db.into(db.partsCatalogCompatibility).insert(
                PartsCatalogCompatibilityCompanion.insert(
                  partsCatalogId: catalogId,
                  modelName: sourceModel,
                  modelCode: sourceModelCode,
                  startYear: 2022,
                  endYear: const Value(2023),
                  regionalVariant: regionalVariant,
                  notes: const Value(
                    'Official Honda Parts Catalogue 18K0WP01 (ADV160AP, PH)',
                  ),
                ),
              );
        }
      }
    });
  }
}
