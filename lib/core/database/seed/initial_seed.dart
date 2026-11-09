import 'package:drift/drift.dart';

import '../../constants/app_constants.dart';
import '../app_database.dart';

/// Seeds first-run data only: the motorcycle, categories and items.
///
/// Maintenance rules (manual schedule) are intentionally NOT seeded here;
/// they require verification against Honda document 32K0WA100 (Phase 2).
/// Item instructions are left empty so no specification is invented.
class InitialSeed {
  InitialSeed(this.db);
  final AppDatabase db;

  /// Category name -> item names (ordered).
  static const Map<String, List<String>> categoryItems = {
    'Engine': ['Engine Oil'],
    'CVT': ['CVT Drive Belt'],
    'Fuel System': ['Fuel Filter', 'Fuel Line'],
    'Brakes': ['Brake Pads', 'Brake Fluid'],
    'Electrical': ['Battery'],
    'Tires and Wheels': ['Tire'],
    'Cooling System': ['Coolant'],
    'Final Drive': ['Final Drive Oil'],
  };

  /// Idempotent: safe to call more than once.
  Future<void> run() async {
    await db.transaction(() async {
      final now = DateTime.now().toIso8601String();

      final existing = await db.select(db.motorcycles).get();
      if (existing.isEmpty) {
        await db.into(db.motorcycles).insert(MotorcyclesCompanion.insert(
              brand: kSeedBrand,
              model: kSeedModel,
              modelYear: kSeedModelYear,
              createdAt: now,
              updatedAt: now,
            ));
      }

      var categoryOrder = 0;
      var itemOrder = 0;
      for (final entry in categoryItems.entries) {
        categoryOrder++;
        await db.into(db.maintenanceCategories).insert(
              MaintenanceCategoriesCompanion.insert(
                name: entry.key,
                sortOrder: Value(categoryOrder),
              ),
              mode: InsertMode.insertOrIgnore,
            );
        final category = await (db.select(db.maintenanceCategories)
              ..where((c) => c.name.equals(entry.key)))
            .getSingle();
        for (final itemName in entry.value) {
          itemOrder++;
          await db.into(db.maintenanceItems).insert(
                MaintenanceItemsCompanion.insert(
                  categoryId: category.id,
                  name: itemName,
                  sortOrder: Value(itemOrder),
                ),
                mode: InsertMode.insertOrIgnore,
              );
        }
      }
    });
  }
}
