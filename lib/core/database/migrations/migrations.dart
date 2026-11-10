import 'package:drift/drift.dart';

import '../app_database.dart';
import '../seed/honda_schedule_seed.dart';
import '../seed/initial_seed.dart';
import '../seed/honda_parts_seed.dart';

/// Runs schema upgrades one version at a time.
///
/// Migrations must never drop or rewrite maintenance history, custom rules,
/// odometer logs, or component measurements.
Future<void> runMigrations(
  AppDatabase db,
  Migrator m,
  int from,
  int to,
) async {
  if (from > to) {
    throw StateError('Database downgrade from v$from to v$to is not supported');
  }

  // v2: adds the Honda manual schedule configuration. Idempotent.
  if (from < 2 && to >= 2) {
    await HondaScheduleSeed(db).run();
  }

  // v3 (Phase 3): record versioning, measurement soft-delete, and optional
  // numeric value for condition-only observations. History is preserved.
  if (from < 3 && to >= 3) {
    final recCols = await _columnNames(db, 'maintenance_records');
    if (!recCols.contains('supersedes_record_id')) {
      await m.addColumn(
          db.maintenanceRecords, db.maintenanceRecords.supersedesRecordId);
    }
    final measCols = await _columnNames(db, 'component_measurements');
    await m.alterTable(TableMigration(
      db.componentMeasurements,
      newColumns: [
        if (!measCols.contains('voided_at')) db.componentMeasurements.voidedAt,
      ],
    ));
  }

  // v4: aligns category & item names in place (preserving primary keys and all
  // foreign-key references from maintenance_records, component_measurements,
  // parts, and custom rules) and seeds the full verified 2023 Honda ADV160
  // Owner's Manual (32K0WA100, pp. 87–89) inspection schedule.
  if (from < 4 && to >= 4) {
    const categoryRenames = {
      'CVT': 'CVT / Transmission',
      'Brakes': 'Braking System',
      'Electrical': 'Electrical / Battery',
      'Tires and Wheels': 'Tires / Wheels',
      'Final Drive': 'Chassis / Suspension',
    };
    for (final entry in categoryRenames.entries) {
      await db.customStatement(
        'UPDATE maintenance_categories SET name = ? '
        'WHERE name = ? AND NOT EXISTS '
        '(SELECT 1 FROM maintenance_categories WHERE name = ?)',
        [entry.value, entry.key, entry.value],
      );
    }

    const itemRenames = {
      'CVT Drive Belt': 'Drive Belt',
      'Brake Pads': 'Brake Pads Wear',
      'Tire': 'Wheels/Tyres',
      'Coolant': 'Radiator Coolant',
    };
    for (final entry in itemRenames.entries) {
      await db.customStatement(
        'UPDATE maintenance_items SET name = ? '
        'WHERE name = ? AND NOT EXISTS '
        '(SELECT 1 FROM maintenance_items WHERE name = ?)',
        [entry.value, entry.key, entry.value],
      );
    }

    await InitialSeed(db).run();
    await HondaScheduleSeed(db).run();
  }

  // v5: adds is_user_defined to maintenance_items, custom rule warning/baseline
  // columns (warning_km, warning_days, last_completed_km, last_completed_date)
  // to maintenance_rules, and the component_specs table for user-defined
  // component measurement limits. Preserves all existing records and rules.
  if (from < 5 && to >= 5) {
    final itemCols = await _columnNames(db, 'maintenance_items');
    if (!itemCols.contains('is_user_defined')) {
      await m.addColumn(db.maintenanceItems, db.maintenanceItems.isUserDefined);
    }
    await db.customStatement(
      "UPDATE maintenance_items SET is_user_defined = 1 WHERE name = 'Fuel Filter'",
    );

    final ruleCols = await _columnNames(db, 'maintenance_rules');
    if (!ruleCols.contains('warning_km')) {
      await m.addColumn(db.maintenanceRules, db.maintenanceRules.warningKm);
    }
    if (!ruleCols.contains('warning_days')) {
      await m.addColumn(db.maintenanceRules, db.maintenanceRules.warningDays);
    }
    if (!ruleCols.contains('last_completed_km')) {
      await m.addColumn(
          db.maintenanceRules, db.maintenanceRules.lastCompletedKm);
    }
    if (!ruleCols.contains('last_completed_date')) {
      await m.addColumn(
          db.maintenanceRules, db.maintenanceRules.lastCompletedDate);
    }

    final tables = await db
        .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='component_specs'")
        .get();
    if (tables.isEmpty) {
      await m.createTable(db.componentSpecs);
    }
  }

  // v6: adds trips and trip_waypoints tables for Ride History & Trip Logger
  if (from < 6 && to >= 6) {
    final tripTables = await db
        .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='trips'")
        .get();
    if (tripTables.isEmpty) {
      await m.createTable(db.trips);
    }

    final waypointTables = await db
        .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='trip_waypoints'")
        .get();
    if (waypointTables.isEmpty) {
      await m.createTable(db.tripWaypoints);
    }
  }

  // v7: adds cvt_configurations and cvt_performance_logs tables for CVT Manager
  if (from < 7 && to >= 7) {
    final cvtTables = await db
        .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='cvt_configurations'")
        .get();
    if (cvtTables.isEmpty) {
      await m.createTable(db.cvtConfigurations);
    }

    final perfTables = await db
        .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='cvt_performance_logs'")
        .get();
    if (perfTables.isEmpty) {
      await m.createTable(db.cvtPerformanceLogs);
    }
  }

  // v8: adds parts_catalog, parts_catalog_images, and parts_catalog_compatibility
  // tables for the Honda ADV 160 OEM Parts Catalogue.
  if (from < 8 && to >= 8) {
    final catTables = await db
        .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='parts_catalog'")
        .get();
    if (catTables.isEmpty) {
      await m.createTable(db.partsCatalog);
    }

    final imgTables = await db
        .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='parts_catalog_images'")
        .get();
    if (imgTables.isEmpty) {
      await m.createTable(db.partsCatalogImages);
    }

    final compatTables = await db
        .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='parts_catalog_compatibility'")
        .get();
    if (compatTables.isEmpty) {
      await m.createTable(db.partsCatalogCompatibility);
    }

    await HondaPartsSeed(db).run();
  }

  // v9: adds heading and accuracy_meters to trip_waypoints, and creates
  // saved_locations and saved_routes tables.
  if (from < 9 && to >= 9) {
    final wpTables = await db
        .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='trip_waypoints'")
        .get();
    if (wpTables.isNotEmpty) {
      final wpCols = await _columnNames(db, 'trip_waypoints');
      if (!wpCols.contains('heading')) {
        await m.addColumn(db.tripWaypoints, db.tripWaypoints.heading);
      }
      if (!wpCols.contains('accuracy_meters')) {
        await m.addColumn(db.tripWaypoints, db.tripWaypoints.accuracyMeters);
      }
    } else {
      await m.createTable(db.tripWaypoints);
    }

    final locTables = await db
        .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='saved_locations'")
        .get();
    if (locTables.isEmpty) {
      await m.createTable(db.savedLocations);
    }

    final routeTables = await db
        .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='saved_routes'")
        .get();
    if (routeTables.isEmpty) {
      await m.createTable(db.savedRoutes);
    }
  }
}

Future<Set<String>> _columnNames(AppDatabase db, String table) async {
  final rows = await db.customSelect('PRAGMA table_info($table)').get();
  return rows.map((r) => r.read<String>('name')).toSet();
}
