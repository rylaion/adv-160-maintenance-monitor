import 'package:drift/drift.dart';

import '../app_database.dart';
import '../seed/honda_schedule_seed.dart';
import '../seed/initial_seed.dart';

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
}

Future<Set<String>> _columnNames(AppDatabase db, String table) async {
  final rows = await db.customSelect('PRAGMA table_info($table)').get();
  return rows.map((r) => r.read<String>('name')).toSet();
}
