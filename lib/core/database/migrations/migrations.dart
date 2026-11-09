import 'package:drift/drift.dart';

import '../app_database.dart';
import '../seed/honda_schedule_seed.dart';

/// Runs schema upgrades one version at a time.
///
/// Add a new `if (from < N)` block for every schema bump, e.g.
/// ```dart
/// if (from < 2) { await m.addColumn(db.parts, db.parts.someColumn); }
/// ```
/// Migrations must never drop or rewrite maintenance history.
Future<void> runMigrations(
  AppDatabase db,
  Migrator m,
  int from,
  int to,
) async {
  if (from > to) {
    throw StateError('Database downgrade from v$from to v$to is not supported');
  }

  // v2: no table changes; adds the Honda manual schedule configuration
  // (unverified candidates, see HondaScheduleSeed). Idempotent.
  if (from < 2) {
    await HondaScheduleSeed(db).run();
  }

  // v3 (Phase 3): record versioning, measurement soft-delete, and optional
  // numeric value for condition-only observations. History is preserved.
  if (from < 3) {
    await m.addColumn(
        db.maintenanceRecords, db.maintenanceRecords.supersedesRecordId);
    // Rebuilds the table so alue becomes nullable and adds oided_at.
    await m.alterTable(TableMigration(
      db.componentMeasurements,
      newColumns: [db.componentMeasurements.voidedAt],
    ));
  }
}
