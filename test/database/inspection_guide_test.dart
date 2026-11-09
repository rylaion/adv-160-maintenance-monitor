import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adv_mon/core/database/app_database.dart';
import 'package:adv_mon/core/database/migrations/migrations.dart';
import 'package:adv_mon/core/enums/enums.dart';
import 'package:adv_mon/core/services/odometer_service.dart';
import 'package:adv_mon/core/utils/date_utils.dart';
import 'package:adv_mon/features/maintenance/data/maintenance_repository.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_overview.dart';
import 'package:adv_mon/features/odometer/data/odometer_repository.dart';

void main() {
  late AppDatabase db;
  late OdometerRepository odoRepo;
  late OdometerService odo;
  late MaintenanceRepository repo;
  late int bikeId;
  late Map<String, int> itemIds;

  final fixedNow = DateTime.utc(2026, 11, 9, 2, 0);
  DateTime clock() => fixedNow;
  final day = DateTime.utc(2026, 11, 9);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    odoRepo = OdometerRepository(db);
    odo = OdometerService(odoRepo, clock: clock);
    repo = MaintenanceRepository(db, odoRepo, clock: clock);
    bikeId = (await db.select(db.motorcycles).getSingle()).id;
    itemIds = {
      for (final i in await db.select(db.maintenanceItems).get()) i.name: i.id
    };
  });

  tearDown(() => db.close());

  Future<MaintenanceOverview> overview() async => MaintenanceOverview.build(
        snapshot: await repo.loadSnapshot(),
        today: AppDates.todayManila(clock()),
      );

  ItemStatus item(MaintenanceOverview o, String name) =>
      o.items.firstWhere((i) => i.item.name == name);

  group('Odometer-Based Maintenance Inspection Guide (10 Required Scenarios)',
      () {
    test('1. Odometer at 11,500 km: 12,000 km fuel line inspection is UPCOMING',
        () async {
      await odo.record(motorcycleId: bikeId, readingKm: 11500, date: day);
      final o = await overview();
      final fuelLine = item(o, 'Fuel Line').evaluation;

      expect(fuelLine.status, MaintenanceStatus.upcoming);
      expect(fuelLine.next!.next!.dueKm, 12000);
      expect(fuelLine.next!.next!.actionCode, ActionCode.inspect);
      expect(fuelLine.next!.remainingKm, 500);

      final cp12k =
          fuelLine.checkpoints.firstWhere((cp) => cp.checkpoint.dueKm == 12000);
      expect(cp12k.status, MaintenanceStatus.upcoming);
      expect(
        o.upcomingTasks
            .any((t) => t.item.name == 'Fuel Line' && t.dueKm == 12000),
        isTrue,
      );
      expect(o.nextMajorCheckpointKm, 12000);
    });

    test('2. Odometer at 12,000 km: fuel line inspection is DUE', () async {
      await odo.record(motorcycleId: bikeId, readingKm: 12000, date: day);
      final o = await overview();
      final fuelLine = item(o, 'Fuel Line').evaluation;

      expect(fuelLine.status, MaintenanceStatus.due);
      expect(fuelLine.next!.next!.dueKm, 12000);
      expect(fuelLine.next!.remainingKm, 0);

      final cp12k =
          fuelLine.checkpoints.firstWhere((cp) => cp.checkpoint.dueKm == 12000);
      expect(cp12k.status, MaintenanceStatus.due);
      expect(
        o.dueTasks.any((t) => t.item.name == 'Fuel Line' && t.dueKm == 12000),
        isTrue,
      );
    });

    test(
        '3. Odometer at 12,500 km: fuel line inspection is OVERDUE if not completed',
        () async {
      await odo.record(motorcycleId: bikeId, readingKm: 12500, date: day);
      final o = await overview();
      final fuelLine = item(o, 'Fuel Line').evaluation;

      expect(fuelLine.status, MaintenanceStatus.overdue);
      expect(fuelLine.next!.next!.dueKm, 12000);
      expect(fuelLine.next!.remainingKm, -500);

      final cp12k =
          fuelLine.checkpoints.firstWhere((cp) => cp.checkpoint.dueKm == 12000);
      expect(cp12k.status, MaintenanceStatus.overdue);
      expect(
        o.overdueTasks
            .any((t) => t.item.name == 'Fuel Line' && t.dueKm == 12000),
        isTrue,
      );
    });

    test('4. Odometer at 18,000 km: air cleaner replacement is DUE', () async {
      await odo.record(motorcycleId: bikeId, readingKm: 18000, date: day);
      final o = await overview();
      final airCleaner = item(o, 'Air Cleaner').evaluation;

      expect(airCleaner.status, MaintenanceStatus.due);
      expect(airCleaner.next!.next!.dueKm, 18000);
      expect(airCleaner.next!.next!.actionCode, ActionCode.replace);
      expect(airCleaner.next!.remainingKm, 0);

      final cp18k = airCleaner.checkpoints
          .firstWhere((cp) => cp.checkpoint.dueKm == 18000);
      expect(cp18k.status, MaintenanceStatus.due);
      expect(
        o.dueTasks.any((t) => t.item.name == 'Air Cleaner' && t.dueKm == 18000),
        isTrue,
      );
    });

    test(
        '5. Odometer at 20,000 km: 18,000 km tasks remain OVERDUE if not completed',
        () async {
      await odo.record(motorcycleId: bikeId, readingKm: 20000, date: day);
      final o = await overview();

      // Air Cleaner (first checkpoint at 18,000 km) must remain OVERDUE at 20,000 km.
      final airCleaner = item(o, 'Air Cleaner').evaluation;
      expect(airCleaner.status, MaintenanceStatus.overdue);
      expect(airCleaner.next!.next!.dueKm, 18000);
      expect(airCleaner.next!.remainingKm, -2000);

      // 18,000 km checkpoints on other items also remain OVERDUE in checkpoints list.
      for (final name in [
        'Air Cleaner',
        'Fuel Line',
        'Spark Plug',
        'Valve Clearance',
        'Engine Oil',
        'Engine Oil Strainer Screen',
        'Radiator Coolant',
        'Cooling System',
      ]) {
        final cp18k = item(o, name)
            .evaluation
            .checkpoints
            .firstWhere((cp) => cp.checkpoint.dueKm == 18000);
        expect(cp18k.status, MaintenanceStatus.overdue, reason: name);
      }

      // Updating the odometer again without recording service must never mark tasks completed.
      await odo.record(motorcycleId: bikeId, readingKm: 21000, date: day);
      final o2 = await overview();
      expect(
          item(o2, 'Air Cleaner').evaluation.status, MaintenanceStatus.overdue);
      expect(o2.completedTasks, isEmpty);
    });

    test('6. Odometer at 23,500 km: 24,000 km maintenance tasks are UPCOMING',
        () async {
      await odo.record(motorcycleId: bikeId, readingKm: 23500, date: day);
      final o = await overview();

      expect(o.nextMajorCheckpointKm, 24000);

      final upcomingAt24k = o.upcomingTasks
          .where((t) => t.dueKm == 24000)
          .map((t) => '${t.item.name}:${t.actionCode.code}')
          .toSet();

      expect(
        upcomingAt24k,
        containsAll([
          'Fuel Line:I',
          'Crankcase Breather:C',
          'Spark Plug:R',
          'Valve Clearance:I',
          'Engine Oil:R',
          'Engine Idle Speed:I',
          'Throttle Operation:I',
          'Drive Belt:R',
          'Battery:I',
          'Brake Fluid:I',
          'Brake Pads Wear:I',
          'Brake System:I',
          'Headlight Aim:I',
          'Clutch Shoes Wear:I',
          'Side Stand:I',
          'Suspension:I',
          'Nuts, Bolts, Fasteners:I',
          'Wheels/Tyres:I',
          'Steering Head Bearings:I',
        ]),
      );
    });

    test(
        '7. Completing an 18,000 km maintenance task does not mark unrelated tasks as completed',
        () async {
      await odo.record(motorcycleId: bikeId, readingKm: 18000, date: day);
      await repo.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Air Cleaner']!,
        action: MaintenanceAction.replacement,
        date: day,
        odometerKm: 18000,
        notes: 'Replaced air cleaner element at 18,000 km',
      ));

      final o = await overview();
      final airCleaner = item(o, 'Air Cleaner').evaluation;
      expect(airCleaner.status, MaintenanceStatus.good);
      expect(airCleaner.next!.next!.dueKm, 36000);
      final ac18k = airCleaner.checkpoints
          .firstWhere((cp) => cp.checkpoint.dueKm == 18000);
      expect(ac18k.status, MaintenanceStatus.completed);
      expect(ac18k.completedBy?.odometerKm, 18000);

      // Unrelated items at 18,000 km must still be uncompleted (DUE or OVERDUE).
      for (final unrelated in [
        'Fuel Line',
        'Spark Plug',
        'Engine Oil',
        'Engine Oil Strainer Screen',
        'Valve Clearance',
        'Radiator Coolant',
      ]) {
        final cp18k = item(o, unrelated)
            .evaluation
            .checkpoints
            .firstWhere((cp) => cp.checkpoint.dueKm == 18000);
        expect(cp18k.isCompleted, isFalse, reason: unrelated);
      }
      expect(
        o.completedTasks.map((t) => t.item.name).toSet(),
        {'Air Cleaner'},
      );
    });

    test('8. Updating the odometer does not erase maintenance history',
        () async {
      await odo.record(motorcycleId: bikeId, readingKm: 1000, date: day);
      await repo.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Engine Oil']!,
        action: MaintenanceAction.replacement,
        date: day,
        odometerKm: 1000,
        notes: '1,000 km break-in oil change',
      ));
      await repo.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Engine Idle Speed']!,
        action: MaintenanceAction.inspection,
        date: day,
        odometerKm: 1000,
      ));

      for (final nextKm in [3000, 6000, 12000, 18500]) {
        await odo.record(motorcycleId: bikeId, readingKm: nextKm, date: day);
      }

      final records = await db.select(db.maintenanceRecords).get();
      expect(records, hasLength(2));
      expect(records.map((r) => r.odometerKm), [1000, 1000]);

      final o = await overview();
      expect(o.currentKm, 18500);
      expect(o.recentRecords, hasLength(2));

      final oil1k = item(o, 'Engine Oil')
          .evaluation
          .checkpoints
          .firstWhere((cp) => cp.checkpoint.dueKm == 1000);
      expect(oil1k.status, MaintenanceStatus.completed);
    });

    test('9. Verify recurring schedule calculations beyond 36,000 km',
        () async {
      // Complete Air Cleaner at 18,000 km and 36,000 km -> next due is 54,000 km.
      for (final km in [18000, 36000]) {
        await repo.addRecord(NewMaintenanceRecord(
          motorcycleId: bikeId,
          itemId: itemIds['Air Cleaner']!,
          action: MaintenanceAction.replacement,
          date: day,
          odometerKm: km,
        ));
      }
      // Complete Drive Belt replacement at 24,000 km -> next replacement is 48,000 km.
      await repo.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Drive Belt']!,
        action: MaintenanceAction.replacement,
        date: day,
        odometerKm: 24000,
      ));
      // Complete Drive Belt inspection at 12,000 km and 36,000 km -> next inspection is 60,000 km.
      for (final km in [12000, 36000]) {
        await repo.addRecord(NewMaintenanceRecord(
          motorcycleId: bikeId,
          itemId: itemIds['Drive Belt']!,
          action: MaintenanceAction.inspection,
          date: day,
          odometerKm: km,
        ));
      }
      // Complete Engine Oil at 1k, 6k, 12k, 18k, 24k, 30k, 36k -> next is 42,000 km.
      for (final km in [1000, 6000, 12000, 18000, 24000, 30000, 36000]) {
        await repo.addRecord(NewMaintenanceRecord(
          motorcycleId: bikeId,
          itemId: itemIds['Engine Oil']!,
          action: MaintenanceAction.replacement,
          date: day,
          odometerKm: km,
        ));
      }

      await odo.record(motorcycleId: bikeId, readingKm: 41600, date: day);
      final o = await overview();

      final oil = item(o, 'Engine Oil').evaluation;
      expect(oil.status, MaintenanceStatus.upcoming);
      expect(oil.next!.next!.dueKm, 42000);

      final airCleaner = item(o, 'Air Cleaner').evaluation;
      expect(airCleaner.status, MaintenanceStatus.good);
      expect(airCleaner.next!.next!.dueKm, 54000);

      final driveBelt = item(o, 'Drive Belt').evaluation;
      expect(driveBelt.next!.next!.dueKm, 48000);
      expect(driveBelt.next!.next!.actionCode, ActionCode.replace);
      final beltInspectRule = driveBelt.ruleEvaluations
          .firstWhere((r) => r.rule.actionCode == ActionCode.inspect);
      expect(beltInspectRule.next!.dueKm, 60000);
    });

    test('10. Verify that date-based maintenance rules still work', () async {
      await db
          .update(db.motorcycles)
          .write(const MotorcyclesCompanion(purchaseDate: Value('2024-11-01')));
      await odo.record(motorcycleId: bikeId, readingKm: 3000, date: day);

      final o = await overview();
      // Today is 2026-11-09, more than 24 months after 2024-11-01.
      final fdo = item(o, 'Final Drive Oil').evaluation;
      expect(fdo.status, MaintenanceStatus.overdue);
      expect(fdo.next!.next!.dueDate, DateTime.utc(2026, 11, 1));

      final bf = item(o, 'Brake Fluid').evaluation;
      final bfDateRule = bf.ruleEvaluations
          .firstWhere((r) => r.rule.ruleType == RuleType.date);
      expect(bfDateRule.status, MaintenanceStatus.overdue);
      expect(bfDateRule.next!.dueDate, DateTime.utc(2026, 11, 1));

      // Radiator Coolant replacement is 36 months (due 2027-11-01 -> GOOD).
      final coolant = item(o, 'Radiator Coolant').evaluation;
      final coolantDateRule = coolant.ruleEvaluations
          .firstWhere((r) => r.rule.ruleType == RuleType.date);
      expect(coolantDateRule.status, MaintenanceStatus.good);
      expect(coolantDateRule.next!.dueDate, DateTime.utc(2027, 11, 1));

      // Recording Final Drive Oil replacement today clears overdue status and schedules +24 months.
      await repo.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Final Drive Oil']!,
        action: MaintenanceAction.replacement,
        date: day,
        odometerKm: 3000,
      ));
      final oAfter = await overview();
      final fdoAfter = item(oAfter, 'Final Drive Oil').evaluation;
      expect(fdoAfter.status, MaintenanceStatus.good);
      expect(fdoAfter.next!.next!.dueDate, DateTime.utc(2028, 11, 9));
    });
  });

  group('Categories, Fuel Filter rule, and v3 -> v4 migration', () {
    test('seeds all 8 required categories and labels Fuel Filter clearly',
        () async {
      final categories = await db.select(db.maintenanceCategories).get();
      expect(
        categories.map((c) => c.name).toList(),
        [
          'Engine',
          'Fuel System',
          'CVT / Transmission',
          'Braking System',
          'Cooling System',
          'Electrical / Battery',
          'Tires / Wheels',
          'Chassis / Suspension',
        ],
      );

      final fuelFilter = (await db.select(db.maintenanceItems).get())
          .firstWhere((i) => i.name == 'Fuel Filter');
      expect(
        fuelFilter.instructions!.toLowerCase(),
        contains('user-defined maintenance task'),
      );
      expect(
        fuelFilter.instructions!.toLowerCase(),
        contains('not a honda-prescribed interval'),
      );

      final fuelFilterRules = await (db.select(db.maintenanceRules)
            ..where((r) => r.itemId.equals(fuelFilter.id)))
          .get();
      expect(fuelFilterRules, isEmpty);
    });

    test('v3 -> v4 migration renames legacy categories/items and keeps history',
        () async {
      // Simulate legacy v3 names in place.
      await (db.update(db.maintenanceCategories)
            ..where((c) => c.name.equals('Braking System')))
          .write(const MaintenanceCategoriesCompanion(name: Value('Brakes')));
      await (db.update(db.maintenanceItems)
            ..where((i) => i.name.equals('Drive Belt')))
          .write(
              const MaintenanceItemsCompanion(name: Value('CVT Drive Belt')));

      final beltId = (await (db.select(db.maintenanceItems)
                ..where((i) => i.name.equals('CVT Drive Belt')))
              .getSingle())
          .id;
      await repo.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: beltId,
        action: MaintenanceAction.inspection,
        date: day,
        odometerKm: 12000,
      ));

      await runMigrations(db, db.createMigrator(), 3, 4);

      final renamedBelt = await (db.select(db.maintenanceItems)
            ..where((i) => i.id.equals(beltId)))
          .getSingle();
      expect(renamedBelt.name, 'Drive Belt');
      final records = await db.select(db.maintenanceRecords).get();
      expect(records.single.itemId, beltId);
    });
  });
}
