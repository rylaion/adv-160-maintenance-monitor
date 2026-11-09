import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';
import 'migrations/migrations.dart';
import 'seed/honda_schedule_seed.dart';
import 'seed/initial_seed.dart';
import 'tables/history_tables.dart';
import 'tables/motorcycle_tables.dart';
import 'tables/parts_tables.dart';
import 'tables/reminder_tables.dart';
import 'tables/rule_tables.dart';

part 'app_database.g.dart';

/// Single SQLite database for the whole app (offline, on-device only).
@DriftDatabase(tables: [
  Motorcycles,
  MaintenanceCategories,
  MaintenanceItems,
  MaintenanceRules,
  MaintenanceRuleSteps,
  MaintenanceRecords,
  OdometerLogs,
  ComponentMeasurements,
  Parts,
  MaintenanceRecordParts,
  PartInstallations,
  MaintenanceReminders,
  Attachments,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Opens the on-device database file.
  factory AppDatabase.open() => AppDatabase(_openConnection());

  /// In-memory database for tests.
  factory AppDatabase.inMemory() => AppDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => kDatabaseSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await InitialSeed(this).run();
          await HondaScheduleSeed(this).run();
        },
        onUpgrade: (m, from, to) => runMigrations(this, m, from, to),
        beforeOpen: (details) async {
          // Enforce referential integrity; protects history from accidental
          // deletion of rows that have dependents.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, kDatabaseFileName));
    return NativeDatabase.createInBackground(file);
  });
}
