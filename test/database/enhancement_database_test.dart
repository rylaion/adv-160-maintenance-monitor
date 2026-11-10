import 'dart:io';

import 'package:adv_mon/core/database/app_database.dart';
import 'package:adv_mon/core/enums/enums.dart';
import 'package:adv_mon/features/components/data/components_repository.dart';
import 'package:adv_mon/features/components/domain/component_models.dart';
import 'package:adv_mon/features/cvt/data/cvt_repository.dart';
import 'package:adv_mon/features/maintenance/data/maintenance_repository.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_overview.dart';
import 'package:adv_mon/features/odometer/data/odometer_repository.dart';
import 'package:adv_mon/features/parts_catalog/data/parts_catalog_repository.dart';
import 'package:adv_mon/features/trips/data/trips_repository.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions, Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as raw_sqlite;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  group('Custom Intervals, Component Measurements & Database Migrations', () {
    late AppDatabase db;
    late OdometerRepository odoRepo;
    late MaintenanceRepository maintRepo;
    late ComponentsRepository compRepo;
    final fixedNow = DateTime.utc(2026, 11, 9, 10, 0);

    setUp(() {
      db = AppDatabase.inMemory();
      odoRepo = OdometerRepository(db);
      maintRepo = MaintenanceRepository(db, odoRepo, clock: () => fixedNow);
      compRepo = ComponentsRepository(db, odoRepo, clock: () => fixedNow);
    });

    tearDown(() async {
      await db.close();
    });

    test(
        'Custom interval full lifecycle: create, calculate, edit, delete, '
        'and reject invalid values', () async {
      final snap0 = await maintRepo.loadSnapshot();
      final bikeId = snap0.motorcycle!.id;

      await odoRepo.insert(
        motorcycleId: bikeId,
        readingKm: 16500,
        date: DateTime.utc(2026, 11, 9),
        createdAt: fixedNow,
      );

      // Reject invalid values (0, negative, missing intervals, invalid warningKm)
      expect(
        () => maintRepo.createCustomItemAndRule(
          motorcycleId: bikeId,
          itemName: 'Invalid Zero',
          action: ActionCode.clean,
          intervalKm: 0,
        ),
        throwsA(isA<MaintenanceException>()),
      );
      expect(
        () => maintRepo.createCustomItemAndRule(
          motorcycleId: bikeId,
          itemName: 'Invalid Negative',
          action: ActionCode.clean,
          intervalKm: -3000,
        ),
        throwsA(isA<MaintenanceException>()),
      );
      expect(
        () => maintRepo.createCustomItemAndRule(
          motorcycleId: bikeId,
          itemName: 'Invalid Empty',
          action: ActionCode.clean,
        ),
        throwsA(isA<MaintenanceException>()),
      );
      expect(
        () => maintRepo.createCustomItemAndRule(
          motorcycleId: bikeId,
          itemName: 'Invalid Warning',
          action: ActionCode.clean,
          intervalKm: 3000,
          warningKm: 3500,
        ),
        throwsA(isA<MaintenanceException>()),
      );

      // Create custom item: CVT Cleaning, Interval 6,000 km, Last Completed 12,000 km
      final itemId = await maintRepo.createCustomItemAndRule(
        motorcycleId: bikeId,
        itemName: 'CVT Cleaning',
        action: ActionCode.clean,
        intervalKm: 6000,
        lastCompletedKm: 12000,
        notes: 'Clean CVT pulley and housing',
      );

      var overview = MaintenanceOverview.build(
        snapshot: await maintRepo.loadSnapshot(),
        today: DateTime.utc(2026, 11, 9),
      );
      var cvtStatus = overview.items.firstWhere((i) => i.item.id == itemId);

      expect(cvtStatus.item.name, 'CVT Cleaning');
      expect(cvtStatus.item.isUserDefined, isTrue);
      expect(cvtStatus.evaluation.next?.next?.dueKm, 18000);
      expect(cvtStatus.evaluation.status, MaintenanceStatus.upcoming);
      expect(overview.upcoming.any((i) => i.item.id == itemId), isTrue);

      // Edit custom interval to 3,000 km (Next Due becomes 12,000 + 3,000 = 15,000 km -> Overdue at 16,500 km)
      final customRuleId = cvtStatus.evaluation.ruleEvaluations
          .firstWhere((r) => !r.rule.isManufacturer)
          .rule
          .id;

      await maintRepo.saveCustomRule(
        ruleId: customRuleId,
        motorcycleId: bikeId,
        itemId: itemId,
        action: ActionCode.clean,
        intervalKm: 3000,
        lastCompletedKm: 12000,
      );

      overview = MaintenanceOverview.build(
        snapshot: await maintRepo.loadSnapshot(),
        today: DateTime.utc(2026, 11, 9),
      );
      cvtStatus = overview.items.firstWhere((i) => i.item.id == itemId);
      expect(
        cvtStatus.evaluation.ruleEvaluations
            .where((r) => !r.rule.isManufacturer)
            .length,
        1,
      );
      expect(cvtStatus.evaluation.next?.next?.dueKm, 15000);
      expect(cvtStatus.evaluation.status, MaintenanceStatus.overdue);
      expect(overview.overdue.any((i) => i.item.id == itemId), isTrue);

      // Delete custom interval
      await maintRepo.deleteCustomRule(customRuleId);
      overview = MaintenanceOverview.build(
        snapshot: await maintRepo.loadSnapshot(),
        today: DateTime.utc(2026, 11, 9),
      );
      cvtStatus = overview.items.firstWhere((i) => i.item.id == itemId);
      expect(cvtStatus.evaluation.hasSchedule, isFalse);
    });

    test('Custom interval and item persist after closing and reopening DB file',
        () async {
      final tempDir = await Directory.systemTemp.createTemp('adv_mon_persist_');
      final dbFile = File(p.join(tempDir.path, 'persist_test.sqlite'));

      try {
        // Session 1: open DB, create custom item & interval, close DB
        final db1 = AppDatabase(NativeDatabase(dbFile));
        final odo1 = OdometerRepository(db1);
        final maint1 = MaintenanceRepository(db1, odo1, clock: () => fixedNow);

        final snap1 = await maint1.loadSnapshot();
        final bikeId = snap1.motorcycle!.id;
        await odo1.insert(
          motorcycleId: bikeId,
          readingKm: 16500,
          date: DateTime.utc(2026, 11, 9),
          createdAt: fixedNow,
        );
        final customItemId = await maint1.createCustomItemAndRule(
          motorcycleId: bikeId,
          itemName: 'CVT Cleaning',
          action: ActionCode.clean,
          intervalKm: 6000,
          lastCompletedKm: 12000,
        );
        await db1.close();

        // Session 2: reopen DB file and verify custom item and next due (18,000 km) persist
        final db2 = AppDatabase(NativeDatabase(dbFile));
        final odo2 = OdometerRepository(db2);
        final maint2 = MaintenanceRepository(db2, odo2, clock: () => fixedNow);

        final overview2 = MaintenanceOverview.build(
          snapshot: await maint2.loadSnapshot(),
          today: DateTime.utc(2026, 11, 9),
        );
        final restored =
            overview2.items.firstWhere((i) => i.item.id == customItemId);
        expect(restored.item.name, 'CVT Cleaning');
        expect(restored.evaluation.next?.next?.dueKm, 18000);
        expect(restored.evaluation.status, MaintenanceStatus.upcoming);

        await db2.close();
      } finally {
        try {
          if (await tempDir.exists()) {
            await tempDir.delete(recursive: true);
          }
        } catch (_) {}
      }
    });

    test(
        'Component measurements & user-defined limits persist and retain history',
        () async {
      final snap = await maintRepo.loadSnapshot();
      final bikeId = snap.motorcycle!.id;
      final beltItem = snap.items.firstWhere((i) => i.name == 'Drive Belt');

      // Record measurement at 12,000 km on 2026-11-09
      await compRepo.addMeasurement(
        NewComponentMeasurement(
          motorcycleId: bikeId,
          itemId: beltItem.id,
          measuredDate: DateTime.utc(2026, 11, 9),
          odometerKm: 12000,
          measurementType: MeasurementType.thicknessMm,
          value: 21.8,
        ),
      );

      // Advance clock and record measurement at 18,000 km on 2027-02-09
      final laterRepo = ComponentsRepository(
        db,
        odoRepo,
        clock: () => DateTime.utc(2027, 2, 10),
      );
      await laterRepo.addMeasurement(
        NewComponentMeasurement(
          motorcycleId: bikeId,
          itemId: beltItem.id,
          measuredDate: DateTime.utc(2027, 2, 9),
          odometerKm: 18000,
          measurementType: MeasurementType.thicknessMm,
          value: 21.2,
        ),
      );

      final history = await compRepo.loadMeasurements(itemId: beltItem.id);
      expect(history.length, 2);
      expect(history.first.odometerKm, 18000);
      expect(history.first.value, 21.2);
      expect(history.last.odometerKm, 12000);
      expect(history.last.value, 21.8);

      // Save user-defined limit for drive_belt_width
      await compRepo.saveUserSpec(
        specKey: 'drive_belt_width',
        itemId: beltItem.id,
        customStandardValue: 22.0,
        customServiceLimit: 21.0,
        unit: 'mm',
      );
      final specs = await compRepo.loadUserSpecs();
      expect(specs['drive_belt_width']?.customStandardValue, 22.0);
      expect(specs['drive_belt_width']?.customServiceLimit, 21.0);
    });

    test(
        'Adding maintenance record with inline measurement saves both and '
        'prevents duplicate maintenance records', () async {
      final snap = await maintRepo.loadSnapshot();
      final bikeId = snap.motorcycle!.id;
      final padsItem =
          snap.items.firstWhere((i) => i.name == 'Brake Pads Wear');

      await maintRepo.addRecord(
        NewMaintenanceRecord(
          motorcycleId: bikeId,
          itemId: padsItem.id,
          action: MaintenanceAction.inspection,
          date: DateTime.utc(2026, 11, 9),
          odometerKm: 6000,
          notes: 'Inspected front brake pads',
          measurementValue: 4.5,
          measurementUnit: 'mm',
          measurementType: MeasurementType.thicknessMm,
          measurementPosition: 'FRONT',
        ),
      );

      // Verify measurement was linked and saved
      final measurements = await compRepo.loadMeasurements(itemId: padsItem.id);
      expect(measurements.length, 1);
      expect(measurements.single.value, 4.5);
      expect(measurements.single.unit, 'mm');
      expect(measurements.single.position, 'FRONT');

      // Duplicate submission with same item, action, date, and odometer is rejected
      expect(
        () => maintRepo.addRecord(
          NewMaintenanceRecord(
            motorcycleId: bikeId,
            itemId: padsItem.id,
            action: MaintenanceAction.inspection,
            date: DateTime.utc(2026, 11, 9),
            odometerKm: 6000,
          ),
        ),
        throwsA(isA<MaintenanceException>()),
      );
    });

    test(
        'Database migration v4 -> v5 upgrades existing installation without '
        'losing maintenance records or custom rules', () async {
      final tempDir = await Directory.systemTemp.createTemp('adv_mon_mig_v5_');
      final dbFile = File(p.join(tempDir.path, 'v4_upgrade.sqlite'));

      try {
        // Create a v4 schema SQLite database using raw sqlite3
        final raw = raw_sqlite.sqlite3.open(dbFile.path);
        raw.execute('PRAGMA user_version = 4;');
        raw.execute('''
          CREATE TABLE motorcycles (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            brand TEXT NOT NULL,
            model TEXT NOT NULL,
            model_year INTEGER NOT NULL,
            plate_number TEXT NULL,
            chassis_number TEXT NULL,
            engine_number TEXT NULL,
            purchase_date TEXT NULL,
            photo_path TEXT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          );
          CREATE TABLE maintenance_categories (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            sort_order INTEGER NOT NULL DEFAULT 0
          );
          CREATE TABLE maintenance_items (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            category_id INTEGER NOT NULL REFERENCES maintenance_categories (id),
            name TEXT NOT NULL UNIQUE,
            instructions TEXT NULL,
            sort_order INTEGER NOT NULL DEFAULT 0,
            is_active INTEGER NOT NULL DEFAULT 1
          );
          CREATE TABLE maintenance_rules (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            motorcycle_id INTEGER NOT NULL REFERENCES motorcycles (id),
            item_id INTEGER NOT NULL REFERENCES maintenance_items (id),
            rule_type TEXT NOT NULL,
            action_code TEXT NOT NULL,
            source TEXT NOT NULL,
            source_document TEXT NULL,
            source_page INTEGER NULL,
            interval_km INTEGER NULL,
            interval_months INTEGER NULL,
            is_verified INTEGER NOT NULL DEFAULT 0,
            is_active INTEGER NOT NULL DEFAULT 1,
            notes TEXT NULL
          );
          CREATE TABLE maintenance_rule_steps (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            rule_id INTEGER NOT NULL REFERENCES maintenance_rules (id),
            step_order INTEGER NOT NULL,
            action_code TEXT NOT NULL,
            at_km INTEGER NULL,
            at_months INTEGER NULL,
            repeat_every_km INTEGER NULL,
            repeat_every_months INTEGER NULL,
            notes TEXT NULL
          );
          CREATE TABLE maintenance_records (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            motorcycle_id INTEGER NOT NULL REFERENCES motorcycles (id),
            item_id INTEGER NOT NULL REFERENCES maintenance_items (id),
            action TEXT NOT NULL,
            performed_date TEXT NOT NULL,
            odometer_km INTEGER NOT NULL,
            labor_cost_centavos INTEGER NOT NULL DEFAULT 0,
            total_cost_centavos INTEGER NOT NULL DEFAULT 0,
            service_provider TEXT NULL,
            notes TEXT NULL,
            voided_at TEXT NULL,
            supersedes_record_id INTEGER NULL REFERENCES maintenance_records (id),
            created_at TEXT NOT NULL
          );
          CREATE TABLE odometer_logs (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            motorcycle_id INTEGER NOT NULL REFERENCES motorcycles (id),
            reading_km INTEGER NOT NULL CHECK (reading_km >= 0),
            recorded_date TEXT NOT NULL,
            notes TEXT NULL,
            status TEXT NOT NULL DEFAULT 'CONFIRMED',
            supersedes_log_id INTEGER NULL REFERENCES odometer_logs (id),
            correction_reason TEXT NULL,
            created_at TEXT NOT NULL
          );
          CREATE TABLE component_measurements (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            motorcycle_id INTEGER NOT NULL REFERENCES motorcycles (id),
            item_id INTEGER NOT NULL REFERENCES maintenance_items (id),
            record_id INTEGER NULL REFERENCES maintenance_records (id),
            measured_date TEXT NOT NULL,
            odometer_km INTEGER NULL,
            measurement_type TEXT NOT NULL,
            value REAL NULL,
            unit TEXT NOT NULL,
            position TEXT NULL,
            measurement_context TEXT NULL,
            brand TEXT NULL,
            part_number TEXT NULL,
            visual_condition TEXT NULL,
            has_damage INTEGER NOT NULL DEFAULT 0,
            notes TEXT NULL,
            voided_at TEXT NULL,
            created_at TEXT NOT NULL
          );
          CREATE TABLE parts (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            item_id INTEGER NULL REFERENCES maintenance_items (id),
            name TEXT NOT NULL,
            brand TEXT NULL,
            part_number TEXT NULL,
            specification TEXT NULL,
            purchase_price_centavos INTEGER NOT NULL DEFAULT 0,
            purchase_date TEXT NULL,
            supplier TEXT NULL,
            quantity INTEGER NOT NULL DEFAULT 1,
            notes TEXT NULL,
            created_at TEXT NOT NULL
          );
          CREATE TABLE maintenance_record_parts (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            record_id INTEGER NOT NULL REFERENCES maintenance_records (id),
            part_id INTEGER NOT NULL REFERENCES parts (id),
            quantity INTEGER NOT NULL DEFAULT 1,
            unit_cost_centavos INTEGER NOT NULL DEFAULT 0
          );
          CREATE TABLE part_installations (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            part_id INTEGER NOT NULL REFERENCES parts (id),
            motorcycle_id INTEGER NOT NULL REFERENCES motorcycles (id),
            record_id INTEGER NULL REFERENCES maintenance_records (id),
            position TEXT NULL,
            installed_date TEXT NOT NULL,
            installed_km INTEGER NOT NULL,
            removed_date TEXT NULL,
            removed_km INTEGER NULL,
            notes TEXT NULL
          );
          CREATE TABLE maintenance_reminders (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            motorcycle_id INTEGER NOT NULL REFERENCES motorcycles (id),
            item_id INTEGER NULL REFERENCES maintenance_items (id),
            rule_id INTEGER NULL REFERENCES maintenance_rules (id),
            reminder_type TEXT NOT NULL,
            title TEXT NOT NULL,
            body TEXT NULL,
            due_date TEXT NULL,
            due_odometer_km INTEGER NULL,
            dedupe_key TEXT NOT NULL UNIQUE,
            status TEXT NOT NULL DEFAULT 'PENDING',
            notified_at TEXT NULL,
            created_at TEXT NOT NULL
          );
          CREATE TABLE attachments (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            record_id INTEGER NULL REFERENCES maintenance_records (id),
            measurement_id INTEGER NULL REFERENCES component_measurements (id),
            motorcycle_id INTEGER NULL REFERENCES motorcycles (id),
            file_path TEXT NOT NULL,
            mime_type TEXT NULL,
            caption TEXT NULL,
            created_at TEXT NOT NULL
          );
        ''');

        raw.execute('''
          INSERT INTO motorcycles (id, brand, model, model_year, created_at, updated_at)
          VALUES (1, 'Honda', 'ADV 160', 2023, '2026-01-01', '2026-01-01');
          INSERT INTO maintenance_categories (id, name, sort_order)
          VALUES (1, 'Engine', 1), (2, 'Fuel System', 2);
          INSERT INTO maintenance_items (id, category_id, name, sort_order, is_active)
          VALUES (1, 1, 'Engine Oil', 1, 1), (2, 2, 'Fuel Filter', 2, 1);
          INSERT INTO maintenance_records (id, motorcycle_id, item_id, action, performed_date, odometer_km, created_at)
          VALUES (1, 1, 1, 'REPLACEMENT', '2026-05-01', 1000, '2026-05-01T00:00:00Z');
        ''');
        raw.dispose();

        // Now open with AppDatabase (v5) and verify migration succeeds
        final upgradedDb = AppDatabase(NativeDatabase(dbFile));
        final upgradedOdo = OdometerRepository(upgradedDb);
        final upgradedMaint = MaintenanceRepository(upgradedDb, upgradedOdo,
            clock: () => fixedNow);
        final upgradedComp = ComponentsRepository(upgradedDb, upgradedOdo,
            clock: () => fixedNow);

        final snap = await upgradedMaint.loadSnapshot();
        expect(snap.records.length, 1);
        expect(snap.records.single.odometerKm, 1000);

        final fuelFilter =
            snap.items.firstWhere((i) => i.name == 'Fuel Filter');
        expect(fuelFilter.isUserDefined, isTrue);

        // Verify new v5 features (warningKm, lastCompletedKm, component_specs) work on upgraded DB
        await upgradedMaint.saveCustomRule(
          motorcycleId: 1,
          itemId: fuelFilter.id,
          action: ActionCode.replace,
          intervalKm: 10000,
          warningKm: 1000,
          lastCompletedKm: 5000,
        );
        await upgradedComp.saveUserSpec(
          specKey: 'drive_belt_width',
          itemId: 1,
          customServiceLimit: 21.0,
        );

        final specs = await upgradedComp.loadUserSpecs();
        expect(specs['drive_belt_width']?.customServiceLimit, 21.0);

        await upgradedDb.close();
      } finally {
        try {
          if (await tempDir.exists()) {
            await tempDir.delete(recursive: true);
          }
        } catch (_) {}
      }
    });

    test(
        'Database migration v7 -> v8 creates parts catalog tables and seeds OEM parts',
        () async {
      final tempDir =
          await Directory.systemTemp.createTemp('adv_mon_v7_v8_test_');
      final dbFile = File(p.join(tempDir.path, 'v7_upgrade.sqlite'));

      try {
        final raw = raw_sqlite.sqlite3.open(dbFile.path);
        raw.execute('PRAGMA user_version = 7');
        raw.execute('''
          CREATE TABLE motorcycles (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            brand TEXT NOT NULL,
            model TEXT NOT NULL,
            model_year INTEGER NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          );
          CREATE TABLE maintenance_categories (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            sort_order INTEGER NOT NULL
          );
          CREATE TABLE maintenance_items (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            category_id INTEGER NOT NULL,
            name TEXT NOT NULL UNIQUE,
            sort_order INTEGER NOT NULL,
            is_active INTEGER NOT NULL DEFAULT 1,
            instructions TEXT NULL,
            is_user_defined INTEGER NOT NULL DEFAULT 0
          );
          CREATE TABLE maintenance_rules (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            motorcycle_id INTEGER NOT NULL,
            item_id INTEGER NOT NULL,
            source TEXT NOT NULL,
            action TEXT NOT NULL,
            interval_km INTEGER NULL,
            interval_months INTEGER NULL,
            warning_km INTEGER NULL,
            warning_days INTEGER NULL,
            last_completed_km INTEGER NULL,
            last_completed_date TEXT NULL,
            is_initial INTEGER NOT NULL DEFAULT 0,
            is_recurring INTEGER NOT NULL DEFAULT 1,
            is_verified INTEGER NOT NULL DEFAULT 1,
            priority INTEGER NOT NULL DEFAULT 0,
            notes TEXT NULL,
            created_at TEXT NOT NULL
          );
          CREATE TABLE maintenance_records (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            motorcycle_id INTEGER NOT NULL,
            item_id INTEGER NOT NULL,
            action TEXT NOT NULL,
            performed_date TEXT NOT NULL,
            odometer_km INTEGER NOT NULL,
            labor_cost_centavos INTEGER NOT NULL DEFAULT 0,
            total_cost_centavos INTEGER NOT NULL DEFAULT 0,
            service_provider TEXT NULL,
            notes TEXT NULL,
            voided_at TEXT NULL,
            supersedes_record_id INTEGER NULL,
            created_at TEXT NOT NULL
          );
          CREATE TABLE cvt_configurations (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            motorcycle_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            pulley_brand_model TEXT NULL,
            flyball_weight_grams REAL NULL,
            flyball_arrangement TEXT NULL,
            center_spring_rpm INTEGER NULL,
            clutch_spring_rpm INTEGER NULL,
            belt_brand_part_number TEXT NULL,
            pulley_washer_thickness_mm REAL NULL,
            clutch_bell_spec TEXT NULL,
            exhaust_spec TEXT NULL,
            other_mods TEXT NULL,
            installed_date INTEGER NOT NULL,
            installed_odometer_km INTEGER NULL,
            is_active INTEGER NOT NULL DEFAULT 0,
            is_archived INTEGER NOT NULL DEFAULT 0,
            notes TEXT NULL,
            photo_paths TEXT NULL,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NOT NULL
          );
          CREATE TABLE cvt_performance_logs (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            configuration_id INTEGER NOT NULL,
            log_date INTEGER NOT NULL,
            acceleration_rating INTEGER NULL,
            top_speed_kmh REAL NULL,
            rpm_observed INTEGER NULL,
            fuel_consumption_kpl REAL NULL,
            vibration_rating INTEGER NULL,
            comfort_rating INTEGER NULL,
            overall_assessment TEXT NULL,
            notes TEXT NULL,
            is_measured INTEGER NOT NULL DEFAULT 0,
            created_at INTEGER NOT NULL
          );
        ''');
        raw.execute('''
          INSERT INTO motorcycles (id, brand, model, model_year, created_at, updated_at)
          VALUES (1, 'Honda', 'ADV 160', 2023, '2026-01-01', '2026-01-01');
          INSERT INTO maintenance_categories (id, name, sort_order)
          VALUES (1, 'Engine', 1), (3, 'CVT / Transmission', 3);
          INSERT INTO maintenance_items (id, category_id, name, sort_order, is_active)
          VALUES (1, 1, 'Engine Oil', 1, 1), (4, 3, 'Drive Belt', 4, 1);
          INSERT INTO cvt_configurations (id, motorcycle_id, name, flyball_weight_grams, installed_date, is_active, created_at, updated_at)
          VALUES (1, 1, 'Existing Setup', 19.0, 1761955200, 1, 1761955200, 1761955200);
        ''');
        raw.dispose();

        final upgradedDb = AppDatabase(NativeDatabase(dbFile));
        final catalogRepo = PartsCatalogRepository(upgradedDb);
        final cvtRepo = CvtRepository(upgradedDb);

        final activeCvt = await cvtRepo.getActiveConfiguration(1);
        expect(activeCvt?.name, 'Existing Setup');
        expect(activeCvt?.flyballWeightGrams, 19.0);

        final parts = await catalogRepo.watchParts().first;
        expect(parts.length, greaterThanOrEqualTo(20));

        final belt = parts.firstWhere((p) => p.partNumber == '23100-K0W-N01');
        expect(belt.officialName, 'Drive V-Belt');

        await upgradedDb.close();
      } finally {
        try {
          if (await tempDir.exists()) {
            await tempDir.delete(recursive: true);
          }
        } catch (_) {}
      }
    });

    test(
        'Database migration v8 -> v9 adds heading and accuracy to trip_waypoints and creates saved_locations / saved_routes',
        () async {
      final tempDir =
          await Directory.systemTemp.createTemp('adv_mon_v8_v9_test_');
      final dbFile = File(p.join(tempDir.path, 'adv_mon_v8.sqlite'));

      try {
        final raw = raw_sqlite.sqlite3.open(dbFile.path);
        raw.execute('PRAGMA user_version = 8;');
        raw.execute('''
          CREATE TABLE motorcycles (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            brand TEXT NOT NULL,
            model TEXT NOT NULL,
            model_year INTEGER NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          );
          CREATE TABLE trips (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            motorcycle_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            category TEXT NOT NULL,
            origin TEXT NULL,
            destination TEXT NULL,
            start_odometer_km INTEGER NULL,
            end_odometer_km INTEGER NULL,
            distance_km REAL NOT NULL,
            start_time INTEGER NOT NULL,
            end_time INTEGER NULL,
            duration_seconds INTEGER NOT NULL DEFAULT 0,
            avg_speed_kmh REAL NULL,
            max_speed_kmh REAL NULL,
            is_gps_tracked INTEGER NOT NULL DEFAULT 0,
            notes TEXT NULL,
            photo_paths TEXT NULL,
            created_at INTEGER NOT NULL
          );
          CREATE TABLE trip_waypoints (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            trip_id INTEGER NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            altitude REAL NULL,
            speed_kmh REAL NULL,
            recorded_at INTEGER NOT NULL,
            sequence INTEGER NOT NULL
          );
          INSERT INTO motorcycles (id, brand, model, model_year, created_at, updated_at)
          VALUES (1, 'Honda', 'ADV 160', 2023, '2026-01-01', '2026-01-01');
          INSERT INTO trips (id, motorcycle_id, title, category, distance_km, start_time, created_at)
          VALUES (1, 1, 'Pre-migration Ride', 'LEISURE', 15.5, 1761955200, 1761955200);
          INSERT INTO trip_waypoints (id, trip_id, latitude, longitude, speed_kmh, recorded_at, sequence)
          VALUES (1, 1, 14.5800, 121.0500, 42.0, 1761955200, 0);
        ''');
        raw.dispose();

        final upgradedDb = AppDatabase(NativeDatabase(dbFile));
        final tripsRepo =
            TripsRepository(upgradedDb, OdometerRepository(upgradedDb));

        final trip = await tripsRepo.getTripById(1);
        expect(trip, isNotNull);
        expect(trip!.title, 'Pre-migration Ride');
        expect(trip.waypoints.length, 1);
        expect(trip.waypoints.first.latitude, 14.5800);
        expect(trip.waypoints.first.heading, isNull);

        // Verify newly created columns accept heading and accuracy
        await upgradedDb.into(upgradedDb.tripWaypoints).insert(
              TripWaypointsCompanion.insert(
                tripId: 1,
                latitude: 14.5810,
                longitude: 121.0510,
                heading: const Value(90.0),
                accuracyMeters: const Value(4.5),
                recordedAt: DateTime.now(),
                sequence: 1,
              ),
            );

        final updatedTrip = await tripsRepo.getTripById(1);
        expect(updatedTrip!.waypoints.length, 2);
        expect(updatedTrip.waypoints[1].heading, 90.0);
        expect(updatedTrip.waypoints[1].accuracyMeters, 4.5);

        // Verify saved_locations and saved_routes tables exist
        final locCount = await upgradedDb
            .customSelect('SELECT COUNT(*) as c FROM saved_locations')
            .getSingle();
        expect(locCount.read<int>('c'), 0);

        final routeCount = await upgradedDb
            .customSelect('SELECT COUNT(*) as c FROM saved_routes')
            .getSingle();
        expect(routeCount.read<int>('c'), 0);

        await upgradedDb.close();
      } finally {
        try {
          if (await tempDir.exists()) {
            await tempDir.delete(recursive: true);
          }
        } catch (_) {}
      }
    });

    test(
        'Database migration v8 -> v9 adds heading and accuracy to trip_waypoints and creates saved_locations / saved_routes',
        () async {
      final tempDir =
          await Directory.systemTemp.createTemp('adv_mon_v8_v9_test_');
      final dbFile = File(p.join(tempDir.path, 'adv_mon_v8.sqlite'));

      try {
        final raw = raw_sqlite.sqlite3.open(dbFile.path);
        raw.execute('PRAGMA user_version = 8;');
        raw.execute('''
          CREATE TABLE motorcycles (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            brand TEXT NOT NULL,
            model TEXT NOT NULL,
            model_year INTEGER NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          );
          CREATE TABLE trips (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            motorcycle_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            category TEXT NOT NULL,
            origin TEXT NULL,
            destination TEXT NULL,
            start_odometer_km INTEGER NULL,
            end_odometer_km INTEGER NULL,
            distance_km REAL NOT NULL,
            start_time INTEGER NOT NULL,
            end_time INTEGER NULL,
            duration_seconds INTEGER NOT NULL DEFAULT 0,
            avg_speed_kmh REAL NULL,
            max_speed_kmh REAL NULL,
            is_gps_tracked INTEGER NOT NULL DEFAULT 0,
            notes TEXT NULL,
            photo_paths TEXT NULL,
            created_at INTEGER NOT NULL
          );
          CREATE TABLE trip_waypoints (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            trip_id INTEGER NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            altitude REAL NULL,
            speed_kmh REAL NULL,
            recorded_at INTEGER NOT NULL,
            sequence INTEGER NOT NULL
          );
          INSERT INTO motorcycles (id, brand, model, model_year, created_at, updated_at)
          VALUES (1, 'Honda', 'ADV 160', 2023, '2026-01-01', '2026-01-01');
          INSERT INTO trips (id, motorcycle_id, title, category, distance_km, start_time, created_at)
          VALUES (1, 1, 'Pre-migration Ride', 'LEISURE', 15.5, 1761955200, 1761955200);
          INSERT INTO trip_waypoints (id, trip_id, latitude, longitude, speed_kmh, recorded_at, sequence)
          VALUES (1, 1, 14.5800, 121.0500, 42.0, 1761955200, 0);
        ''');
        raw.dispose();

        final upgradedDb = AppDatabase(NativeDatabase(dbFile));
        final tripsRepo =
            TripsRepository(upgradedDb, OdometerRepository(upgradedDb));

        final trip = await tripsRepo.getTripById(1);
        expect(trip, isNotNull);
        expect(trip!.title, 'Pre-migration Ride');
        expect(trip.waypoints.length, 1);
        expect(trip.waypoints.first.latitude, 14.5800);
        expect(trip.waypoints.first.heading, isNull);

        // Verify newly created columns accept heading and accuracy
        await upgradedDb.into(upgradedDb.tripWaypoints).insert(
              TripWaypointsCompanion.insert(
                tripId: 1,
                latitude: 14.5810,
                longitude: 121.0510,
                heading: const Value(90.0),
                accuracyMeters: const Value(4.5),
                recordedAt: DateTime.now(),
                sequence: 1,
              ),
            );

        final updatedTrip = await tripsRepo.getTripById(1);
        expect(updatedTrip!.waypoints.length, 2);
        expect(updatedTrip.waypoints[1].heading, 90.0);
        expect(updatedTrip.waypoints[1].accuracyMeters, 4.5);

        // Verify saved_locations and saved_routes tables exist
        final locCount = await upgradedDb
            .customSelect('SELECT COUNT(*) as c FROM saved_locations')
            .getSingle();
        expect(locCount.read<int>('c'), 0);

        final routeCount = await upgradedDb
            .customSelect('SELECT COUNT(*) as c FROM saved_routes')
            .getSingle();
        expect(routeCount.read<int>('c'), 0);

        await upgradedDb.close();
      } finally {
        try {
          if (await tempDir.exists()) {
            await tempDir.delete(recursive: true);
          }
        } catch (_) {}
      }
    });
  });
}
