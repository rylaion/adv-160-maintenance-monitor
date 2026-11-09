import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adv_mon/core/constants/app_constants.dart';
import 'package:adv_mon/core/database/app_database.dart';
import 'package:adv_mon/core/database/seed/initial_seed.dart';
import 'package:adv_mon/features/motorcycle/data/motorcycle_repository.dart';
import 'package:adv_mon/features/motorcycle/domain/motorcycle.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('creates all 13 tables', () async {
    final rows = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type='table' "
            "AND name NOT LIKE 'sqlite_%'")
        .get();
    final names = rows.map((r) => r.read<String>('name')).toSet();
    expect(
        names,
        containsAll(<String>{
          'motorcycles',
          'maintenance_categories',
          'maintenance_items',
          'maintenance_rules',
          'maintenance_rule_steps',
          'maintenance_records',
          'odometer_logs',
          'component_measurements',
          'parts',
          'maintenance_record_parts',
          'part_installations',
          'maintenance_reminders',
          'attachments',
        }));
  });

  test('schema version and foreign keys', () async {
    final v = await db.customSelect('PRAGMA user_version').getSingle();
    expect(v.read<int>('user_version'), kDatabaseSchemaVersion);
    final fk = await db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(fk.read<int>('foreign_keys'), 1);
  });

  test('indexes exist', () async {
    final rows = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type='index' "
            "AND name LIKE 'idx_%'")
        .get();
    expect(rows.length, greaterThanOrEqualTo(15));
  });

  test('seeds ADV 160 motorcycle', () async {
    final bikes = await db.select(db.motorcycles).get();
    expect(bikes, hasLength(1));
    expect(bikes.single.brand, 'Honda');
    expect(bikes.single.model, 'ADV 160');
    expect(bikes.single.modelYear, 2023);
  });

  test('seeds categories and items with correct mapping', () async {
    final cats = await db.select(db.maintenanceCategories).get();
    expect(cats.map((c) => c.name), [
      'Engine',
      'CVT',
      'Fuel System',
      'Brakes',
      'Electrical',
      'Tires and Wheels',
      'Cooling System',
      'Final Drive',
    ]);
    final items = await db.select(db.maintenanceItems).get();
    expect(items.map((i) => i.name).toSet(), {
      'Engine Oil',
      'CVT Drive Belt',
      'Fuel Filter',
      'Fuel Line',
      'Brake Pads',
      'Brake Fluid',
      'Battery',
      'Tire',
      'Coolant',
      'Final Drive Oil',
    });
    final oil = items.firstWhere((i) => i.name == 'Engine Oil');
    final engine = cats.firstWhere((c) => c.name == 'Engine');
    expect(oil.categoryId, engine.id);
    // No invented specs.
    expect(items.every((i) => i.instructions == null), isTrue);
    expect(await db.select(db.maintenanceRules).get(), hasLength(6));
  });

  test('seed is idempotent', () async {
    await InitialSeed(db).run();
    expect(await db.select(db.motorcycles).get(), hasLength(1));
    expect(await db.select(db.maintenanceCategories).get(), hasLength(8));
    expect(await db.select(db.maintenanceItems).get(), hasLength(10));
  });

  test('foreign keys block deleting categories that have items', () async {
    expect(
      () => db.delete(db.maintenanceCategories).go(),
      throwsA(isA<Exception>()),
    );
  });

  test('foreign keys block deleting items with maintenance history', () async {
    final bike = (await db.select(db.motorcycles).get()).single;
    final item = (await db.select(db.maintenanceItems).get()).first;
    await db
        .into(db.maintenanceRecords)
        .insert(MaintenanceRecordsCompanion.insert(
          motorcycleId: bike.id,
          itemId: item.id,
          action: 'REPLACEMENT',
          performedDate: '2026-01-01',
          odometerKm: 1000,
          createdAt: '2026-01-01T00:00:00',
        ));
    expect(
      () => (db.delete(db.maintenanceItems)..where((t) => t.id.equals(item.id)))
          .go(),
      throwsA(isA<Exception>()),
    );
  });

  test('odometer rejects negative readings', () async {
    final bike = (await db.select(db.motorcycles).get()).single;
    expect(
      () => db.into(db.odometerLogs).insert(OdometerLogsCompanion.insert(
            motorcycleId: bike.id,
            readingKm: -1,
            recordedDate: '2026-01-01',
            createdAt: '2026-01-01T00:00:00',
          )),
      throwsA(isA<Exception>()),
    );
  });

  test('transaction rolls back on failure', () async {
    try {
      await db.transaction(() async {
        await db.into(db.parts).insert(PartsCompanion.insert(
            name: 'Oil filter', createdAt: '2026-01-01T00:00:00'));
        throw StateError('boom');
      });
    } catch (_) {}
    expect(await db.select(db.parts).get(), isEmpty);
  });

  test('duplicate reminder dedupe_key is rejected', () async {
    final bike = (await db.select(db.motorcycles).get()).single;
    MaintenanceRemindersCompanion r() => MaintenanceRemindersCompanion.insert(
          motorcycleId: bike.id,
          reminderType: 'DUE',
          title: 'Oil',
          dedupeKey: 'oil-6000-DUE',
          createdAt: '2026-01-01T00:00:00',
        );
    await db.into(db.maintenanceReminders).insert(r());
    expect(() => db.into(db.maintenanceReminders).insert(r()),
        throwsA(isA<Exception>()));
  });

  test('component measurements store decimals', () async {
    final bike = (await db.select(db.motorcycles).get()).single;
    final item = (await db.select(db.maintenanceItems).get())
        .firstWhere((i) => i.name == 'CVT Drive Belt');
    await db.into(db.componentMeasurements).insert(
          ComponentMeasurementsCompanion.insert(
            motorcycleId: bike.id,
            itemId: item.id,
            measuredDate: '2026-01-01',
            measurementType: 'THICKNESS_MM',
            value: 21.35,
            unit: 'mm',
            createdAt: '2026-01-01T00:00:00',
          ),
        );
    final row = (await db.select(db.componentMeasurements).get()).single;
    expect(row.value, 21.35);
  });

  test('motorcycle repository updates profile', () async {
    final repo = MotorcycleRepository(db);
    final m = (await repo.watchPrimary().first)!;
    await repo.update(Motorcycle(
      id: m.id,
      brand: m.brand,
      model: m.model,
      modelYear: m.modelYear,
      plateNumber: ' ABC 123 ',
    ));
    final updated = (await repo.watchPrimary().first)!;
    expect(updated.plateNumber, 'ABC 123');
    expect(updated.displayName, 'Honda ADV 160');
  });
}
