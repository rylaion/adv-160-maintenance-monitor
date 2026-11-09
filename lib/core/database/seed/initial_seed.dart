import 'package:drift/drift.dart';

import '../../constants/app_constants.dart';
import '../app_database.dart';

/// Seeds first-run data: the motorcycle, the 8 maintenance categories, and all
/// 26 maintenance items (25 official 2023 Honda ADV160 Owner's Manual items
/// plus the user-defined `Fuel Filter` item).
class InitialSeed {
  InitialSeed(this.db);
  final AppDatabase db;

  static const String fuelFilterCustomLabel =
      'User-defined maintenance task (not a Honda-prescribed interval in '
      '2023 Honda ADV160 Owner\'s Manual 32K0WA100; the official schedule '
      'lists Fuel Line inspection only).';

  static const String lightsHornPreRideLabel =
      'Pre-ride inspection item (2023 Honda ADV160 Owner\'s Manual 32K0WA100, '
      'pp. 89–90): check that lights, indicators, and horn function properly '
      'before each ride.';

  /// Category name -> item names (ordered per Section 6).
  static const Map<String, List<String>> categoryItems = {
    'Engine': [
      'Engine Oil',
      'Engine Oil Strainer Screen',
      'Spark Plug',
      'Valve Clearance',
      'Engine Idle Speed',
      'Crankcase Breather',
    ],
    'Fuel System': [
      'Fuel Line',
      'Air Cleaner',
      'Throttle Operation',
      'Fuel Filter',
    ],
    'CVT / Transmission': [
      'Drive Belt',
      'Clutch Shoes Wear',
      'Final Drive Oil',
    ],
    'Braking System': [
      'Brake Fluid',
      'Brake Pads Wear',
      'Brake System',
    ],
    'Cooling System': [
      'Radiator Coolant',
      'Cooling System',
    ],
    'Electrical / Battery': [
      'Battery',
      'Headlight Aim',
      'Lights/Horn',
    ],
    'Tires / Wheels': [
      'Wheels/Tyres',
    ],
    'Chassis / Suspension': [
      'Side Stand',
      'Suspension',
      'Nuts, Bolts, Fasteners',
      'Steering Head Bearings',
    ],
  };

  /// Idempotent: safe to call more than once. Preserves existing item IDs.
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
        await (db.update(db.maintenanceCategories)
              ..where((c) => c.id.equals(category.id)))
            .write(MaintenanceCategoriesCompanion(
                sortOrder: Value(categoryOrder)));

        for (final itemName in entry.value) {
          itemOrder++;
          final defaultInstructions = switch (itemName) {
            'Fuel Filter' => fuelFilterCustomLabel,
            'Lights/Horn' => lightsHornPreRideLabel,
            _ => null,
          };
          await db.into(db.maintenanceItems).insert(
                MaintenanceItemsCompanion.insert(
                  categoryId: category.id,
                  name: itemName,
                  instructions: Value(defaultInstructions),
                  sortOrder: Value(itemOrder),
                ),
                mode: InsertMode.insertOrIgnore,
              );
          final existingItem = await (db.select(db.maintenanceItems)
                ..where((i) => i.name.equals(itemName)))
              .getSingle();
          await (db.update(db.maintenanceItems)
                ..where((i) => i.id.equals(existingItem.id)))
              .write(MaintenanceItemsCompanion(
            categoryId: Value(category.id),
            sortOrder: Value(itemOrder),
            instructions:
                existingItem.instructions == null && defaultInstructions != null
                    ? Value(defaultInstructions)
                    : const Value.absent(),
          ));
        }
      }
    });
  }
}
