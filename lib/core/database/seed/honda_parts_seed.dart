import 'dart:developer' as developer;
import 'package:drift/drift.dart';

import '../app_database.dart';
import 'honda_adv160_catalogue_data.dart';

/// Seeds and synchronizes verified official Honda OEM parts catalogue for
/// the Honda ADV 160 (ADV160AP, 18K0WP01).
class HondaPartsSeed {
  HondaPartsSeed(this.db);
  final AppDatabase db;

  static const String sourceModel = 'Honda ADV 160';
  static const String sourceModelCode = 'ADV160AP';
  static const int modelYear = 2022;
  static const String regionalVariant = 'Philippines (2PH)';

  /// Synchronizes diagrams and catalogue parts in place.
  /// If [force] is true, checks and updates all 696 OEM parts and 54 diagrams
  /// to ensure diagrams, image asset paths, and reference numbers match the
  /// official Honda 18K0WP01 catalogue without altering user history or custom records.
  Future<void> syncCatalogue({bool force = false}) async {
    try {
      final tableCheck = await db
          .customSelect(
            "SELECT count(*) as c FROM sqlite_master WHERE type='table' AND name='parts_catalog_images';",
          )
          .getSingle();
      if ((tableCheck.data['c'] as int? ?? 0) == 0) {
        return; // Tables do not exist yet
      }

      await db.transaction(() async {
        // 1. Synchronize Diagrams in parts_catalog_images
        int diagramsUpdated = 0;
        int diagramsInserted = 0;

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
            diagramsInserted++;
          } else if (force ||
              existing.imageAssetPath != d.imageAssetPath ||
              existing.title != d.title ||
              existing.description != d.description ||
              existing.assemblyName != d.assemblyName) {
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
            diagramsUpdated++;
          }
        }

        // 2. Fetch Maintenance Items map to link catalog parts directly
        final items = await (db.select(db.maintenanceItems)).get();
        final itemMap = {for (final item in items) item.name: item.id};

        final existingPartsCount = await (db.select(db.partsCatalog)).get();
        final needsFullPartSync = force || existingPartsCount.length < 500;

        // If not force and already has >= 500 parts, do a fast check on sample parts
        bool shouldSyncParts = needsFullPartSync;
        if (!shouldSyncParts) {
          // Verify a sample part (e.g. Rear Brake Cylinder) to see if diagramNumber is valid
          final sample = await (db.select(db.partsCatalog)
                ..where((t) => t.partNumber.equals('43510-K1Z-J11')))
              .getSingleOrNull();
          if (sample == null || sample.diagramNumber != 'F-6') {
            shouldSyncParts = true;
          }
        }

        if (shouldSyncParts) {
          final nowStr = DateTime.now().toIso8601String();
          int partsInserted = 0;
          int partsUpdated = 0;

          for (final p in officialHondaParts) {
            final existing = await (db.select(db.partsCatalog)
                  ..where((t) => t.partNumber.equals(p.partNumber)))
                .getSingleOrNull();

            final int catalogId;
            final desc =
                'Genuine Honda OEM part for ADV160AP. Diagram ${p.diagramNumber} Ref #${p.refNo}.';

            if (existing == null) {
              catalogId = await db.into(db.partsCatalog).insert(
                    PartsCatalogCompanion.insert(
                      partNumber: p.partNumber,
                      officialName: p.officialName,
                      description: Value(desc),
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
              partsInserted++;
            } else {
              catalogId = existing.id;
              // Synchronize diagram reference, official name, and assembly in place
              if (existing.diagramNumber != p.diagramNumber ||
                  existing.referenceNumber != p.refNo ||
                  existing.assemblyName != p.assemblyName ||
                  existing.category != p.category ||
                  existing.officialName != p.officialName) {
                await (db.update(db.partsCatalog)
                      ..where((t) => t.id.equals(existing.id)))
                    .write(
                  PartsCatalogCompanion(
                    diagramNumber: Value(p.diagramNumber),
                    referenceNumber: Value(p.refNo),
                    assemblyName: Value(p.assemblyName),
                    category: Value(p.category),
                    officialName: Value(p.officialName),
                    description: Value(desc),
                    standardQuantity: Value(p.standardQuantity),
                    remarks: Value(p.remarks),
                    maintenanceItemId: Value(
                      p.maintenanceItemName != null
                          ? itemMap[p.maintenanceItemName]
                          : existing.maintenanceItemId,
                    ),
                  ),
                );
                partsUpdated++;
              }
            }

            // Ensure compatibility entry exists
            final existingCompat =
                await (db.select(db.partsCatalogCompatibility)
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

          developer.log(
            'HondaPartsSeed: synced diagrams ($diagramsInserted inserted, $diagramsUpdated updated), '
            'parts ($partsInserted inserted, $partsUpdated updated).',
            name: 'adv_mon.seed',
          );
        }
      });
    } catch (e, stack) {
      developer.log(
        'HondaPartsSeed sync failed: $e',
        error: e,
        stackTrace: stack,
        name: 'adv_mon.seed',
      );
    }
  }

  /// Explicit entry point for database migration v10.
  Future<void> forceSyncCatalogue() async {
    await syncCatalogue(force: true);
  }

  Future<void> ensureDiagramsSeeded() async {
    await syncCatalogue(force: false);
  }

  Future<void> run() async {
    await syncCatalogue(force: false);
  }
}
