import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adv_mon/core/database/app_database.dart';
import 'package:adv_mon/core/database/migrations/migrations.dart';
import 'package:adv_mon/core/database/seed/honda_schedule_seed.dart';
import 'package:adv_mon/core/enums/enums.dart';
import 'package:adv_mon/core/services/odometer_service.dart';
import 'package:adv_mon/core/utils/date_utils.dart';
import 'package:adv_mon/features/maintenance/data/maintenance_repository.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_overview.dart';
import 'package:adv_mon/features/odometer/data/odometer_repository.dart';
import 'package:adv_mon/features/odometer/domain/odometer_log.dart';

void main() {
  late AppDatabase db;
  late OdometerRepository odoRepo;
  late OdometerService odo;
  late MaintenanceRepository repo;
  late int bikeId;
  late Map<String, int> itemIds;

  // 2026-11-09 10:00 in Manila.
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

  group('Honda schedule seed', () {
    test('seeds manufacturer rules as verified from 32K0WA100 pp. 88-89',
        () async {
      final rules = await db.select(db.maintenanceRules).get();
      expect(rules, hasLength(28));
      for (final r in rules) {
        expect(r.source, MaintenanceSource.hondaManual.code);
        expect(r.sourceDocument, contains('32K0WA100'));
        expect(r.isVerified, isTrue);
        expect(r.sourcePage, isIn([88, 89]));
        expect(r.motorcycleId, bikeId);
      }
    });

    test('engine oil: 1,000 km then every 6,000 km', () async {
      final rule = (await db.select(db.maintenanceRules).get())
          .firstWhere((r) => r.itemId == itemIds['Engine Oil']);
      expect(rule.ruleType, 'MILEAGE');
      expect(rule.actionCode, 'R');
      final steps = await (db.select(db.maintenanceRuleSteps)
            ..where((s) => s.ruleId.equals(rule.id)))
          .get();
      expect(steps.map((s) => [s.atKm, s.repeatEveryKm]), [
        [1000, null],
        [6000, 6000]
      ]);
    });

    test('Drive Belt: separate inspect and replace rules', () async {
      final rules = (await db.select(db.maintenanceRules).get())
          .where((r) => r.itemId == itemIds['Drive Belt'])
          .toList();
      expect(rules, hasLength(2));
      final inspect = rules.firstWhere((r) => r.actionCode == 'I');
      final replace = rules.firstWhere((r) => r.actionCode == 'R');
      Future<List<int?>> kms(int id) async =>
          (await (db.select(db.maintenanceRuleSteps)
                    ..where((s) => s.ruleId.equals(id)))
                  .get())
              .map((s) => s.atKm)
              .toList();
      expect(await kms(inspect.id), [12000, 36000]);
      expect(await kms(replace.id), [24000]);
    });

    test('date-based replacements', () async {
      final rules = await db.select(db.maintenanceRules).get();
      int? months(String item) => rules
          .firstWhere((r) => r.itemId == itemIds[item] && r.ruleType == 'DATE')
          .intervalMonths;
      expect(months('Brake Fluid'), 24);
      expect(months('Radiator Coolant'), 36);
      expect(months('Final Drive Oil'), 24);
    });

    test(
        'no invented intervals: fuel filter and pre-ride lights/horn have no rule',
        () async {
      final ruled = (await db.select(db.maintenanceRules).get())
          .map((r) => r.itemId)
          .toSet();
      for (final name in ['Fuel Filter', 'Lights/Horn']) {
        expect(ruled, isNot(contains(itemIds[name])), reason: name);
      }
    });

    test('seed is idempotent', () async {
      await HondaScheduleSeed(db).run();
      expect(await db.select(db.maintenanceRules).get(), hasLength(28));
    });
  });

  group('migration v1 -> v2 and v3 -> v4', () {
    test('adds the schedule to a v1 database and is repeatable', () async {
      await db.delete(db.maintenanceRuleSteps).go();
      await db.delete(db.maintenanceRules).go();
      expect(await db.select(db.maintenanceRules).get(), isEmpty);

      await runMigrations(db, db.createMigrator(), 1, 2);
      expect(await db.select(db.maintenanceRules).get(), hasLength(28));
      expect(await db.select(db.maintenanceRuleSteps).get(), hasLength(36));

      await runMigrations(db, db.createMigrator(), 1, 2);
      expect(await db.select(db.maintenanceRules).get(), hasLength(28));
    });

    test('no-op when already current; downgrade is rejected', () async {
      await runMigrations(db, db.createMigrator(), 4, 4);
      expect(await db.select(db.maintenanceRules).get(), hasLength(28));
      expect(
          () => runMigrations(db, db.createMigrator(), 4, 3), throwsStateError);
    });

    test('preserves existing history', () async {
      await repo.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Engine Oil']!,
        action: MaintenanceAction.replacement,
        date: day,
        odometerKm: 1000,
      ));
      await runMigrations(db, db.createMigrator(), 1, 4);
      expect(await db.select(db.maintenanceRecords).get(), hasLength(1));
      expect(await db.select(db.odometerLogs).get(), hasLength(1));
    });
  });

  group('odometer service', () {
    Future<int> rec(int km, {DateTime? date, String? notes}) => odo.record(
        motorcycleId: bikeId, readingKm: km, date: date ?? day, notes: notes);

    test('rejects negative readings', () {
      expect(() => rec(-1), throwsA(isA<OdometerException>()));
    });

    test('accepts zero and first reading', () async {
      expect(await odo.currentKm(bikeId), isNull);
      await rec(0);
      expect(await odo.currentKm(bikeId), 0);
    });

    test('rejects readings lower than latest confirmed, accepts equal',
        () async {
      await rec(1000);
      expect(() => rec(999), throwsA(isA<OdometerException>()));
      await rec(1000);
      await rec(1200);
      expect(await odo.currentKm(bikeId), 1200);
      expect(await db.select(db.odometerLogs).get(), hasLength(3));
    });

    test('rejects future dates (Manila date)', () async {
      expect(() => rec(100, date: DateTime.utc(2026, 11, 10)),
          throwsA(isA<OdometerException>()));
      await rec(100, date: DateTime.utc(2026, 11, 9));
    });

    test('trims notes and stores ISO date', () async {
      await rec(500, notes: '  after trip  ');
      final row = await db.select(db.odometerLogs).getSingle();
      expect(row.notes, 'after trip');
      expect(row.recordedDate, '2026-11-09');
      expect(row.status, 'CONFIRMED');
    });

    test('correction keeps an audit trail', () async {
      await rec(1000, date: DateTime.utc(2026, 11, 1));
      final typo = await rec(10000, date: DateTime.utc(2026, 11, 5));
      expect(await odo.currentKm(bikeId), 10000);

      final newId = await odo.correct(
          logId: typo, newReadingKm: 1500, reason: 'Typed an extra zero');

      expect(await odo.currentKm(bikeId), 1500);
      final rows = await db.select(db.odometerLogs).get();
      expect(rows, hasLength(3)); // nothing deleted
      final old = rows.firstWhere((r) => r.id == typo);
      final fixed = rows.firstWhere((r) => r.id == newId);
      expect(old.status, 'CORRECTED');
      expect(old.readingKm, 10000);
      expect(fixed.status, 'CONFIRMED');
      expect(fixed.supersedesLogId, typo);
      expect(fixed.correctionReason, 'Typed an extra zero');
      expect(fixed.recordedDate, '2026-11-05');
    });

    test('correction validation', () async {
      final a = await rec(1000, date: DateTime.utc(2026, 11, 1));
      final b = await rec(2000, date: DateTime.utc(2026, 11, 2));
      await rec(3000, date: DateTime.utc(2026, 11, 3));

      expect(() => odo.correct(logId: b, newReadingKm: 2500, reason: ' '),
          throwsA(isA<OdometerException>()));
      expect(() => odo.correct(logId: b, newReadingKm: -5, reason: 'x'),
          throwsA(isA<OdometerException>()));
      expect(() => odo.correct(logId: b, newReadingKm: 900, reason: 'x'),
          throwsA(isA<OdometerException>()));
      expect(() => odo.correct(logId: b, newReadingKm: 3500, reason: 'x'),
          throwsA(isA<OdometerException>()));
      expect(() => odo.correct(logId: 9999, newReadingKm: 10, reason: 'x'),
          throwsA(isA<OdometerException>()));

      await odo.correct(logId: b, newReadingKm: 2500, reason: 'misread');
      // Superseded entries cannot be corrected again.
      expect(() => odo.correct(logId: b, newReadingKm: 2400, reason: 'x'),
          throwsA(isA<OdometerException>()));
      expect(a, isNonZero);
    });

    test('correcting a typo recalculates maintenance status', () async {
      await rec(500, date: DateTime.utc(2026, 11, 1));
      final typo = await rec(15000, date: DateTime.utc(2026, 11, 5));
      var o = await overview();
      expect(
          item(o, 'Engine Oil').evaluation.status, MaintenanceStatus.overdue);

      await odo.correct(logId: typo, newReadingKm: 1500, reason: 'typo');
      o = await overview();
      expect(o.currentKm, 1500);
      // 1,500 km: 1,000 km checkpoint is missed, 6,000 km is 4,500 away.
      expect(item(o, 'Engine Oil').evaluation.next!.next!.dueKm, 1000);

      await odo.correct(
          logId: (await db.select(db.odometerLogs).get())
              .firstWhere((l) => l.status == 'CONFIRMED' && l.readingKm == 1500)
              .id,
          newReadingKm: 700,
          reason: 'second look');
      o = await overview();
      expect(
          item(o, 'Engine Oil').evaluation.status, MaintenanceStatus.upcoming);
    });
  });

  group('maintenance records', () {
    NewMaintenanceRecord oilChange(int km,
            {DateTime? date, int total = 0, int labor = 0}) =>
        NewMaintenanceRecord(
          motorcycleId: bikeId,
          itemId: itemIds['Engine Oil']!,
          action: MaintenanceAction.replacement,
          date: date ?? day,
          odometerKm: km,
          totalCostCentavos: total,
          laborCostCentavos: labor,
        );

    test('validation', () {
      expect(() => repo.addRecord(oilChange(-1)),
          throwsA(isA<MaintenanceException>()));
      expect(() => repo.addRecord(oilChange(100, total: -1)),
          throwsA(isA<MaintenanceException>()));
      expect(() => repo.addRecord(oilChange(100, total: 100, labor: 200)),
          throwsA(isA<MaintenanceException>()));
      expect(
          () =>
              repo.addRecord(oilChange(100, date: DateTime.utc(2026, 11, 10))),
          throwsA(isA<MaintenanceException>()));
      expect(
          () => repo.addRecord(NewMaintenanceRecord(
                motorcycleId: bikeId,
                itemId: 9999,
                action: MaintenanceAction.inspection,
                date: day,
                odometerKm: 1,
              )),
          throwsA(isA<MaintenanceException>()));
    });

    test('is persisted and logs a higher odometer in the same transaction',
        () async {
      await odo.record(motorcycleId: bikeId, readingKm: 900, date: day);
      await repo.addRecord(oilChange(1000, total: 85000, labor: 15000));

      final records = await db.select(db.maintenanceRecords).get();
      expect(records, hasLength(1));
      expect(records.single.performedDate, '2026-11-09');
      expect(records.single.totalCostCentavos, 85000);
      expect(await odo.currentKm(bikeId), 1000);
    });

    test('backdated record does not lower the odometer', () async {
      await odo.record(motorcycleId: bikeId, readingKm: 5000, date: day);
      await repo.addRecord(
          oilChange(1000, date: DateTime.utc(2026, 3, 1), total: 50000));
      expect(await odo.currentKm(bikeId), 5000);
      expect(await db.select(db.odometerLogs).get(), hasLength(1));
    });

    test('recalculates status and preserves history', () async {
      await odo.record(motorcycleId: bikeId, readingKm: 500, date: day);
      await odo.record(motorcycleId: bikeId, readingKm: 1100, date: day);
      var o = await overview();
      expect(
          item(o, 'Engine Oil').evaluation.status, MaintenanceStatus.overdue);
      expect(o.lastRecord, isNull);
      expect(o.totalExpensesCentavos, 0);

      await repo.addRecord(oilChange(1100, total: 85000));
      o = await overview();
      final oil = item(o, 'Engine Oil').evaluation;
      expect(oil.status, MaintenanceStatus.good);
      expect(oil.next!.next!.dueKm, 6000);
      expect(oil.lastService!.odometerKm, 1100);
      expect(o.totalExpensesCentavos, 85000);
      expect(o.lastRecord!.odometerKm, 1100);

      // A second service never overwrites the first.
      await repo.addRecord(oilChange(6100, total: 90000));
      expect(await db.select(db.maintenanceRecords).get(), hasLength(2));
      o = await overview();
      expect(o.totalExpensesCentavos, 175000);
    });

    test('voided records are ignored by calculations', () async {
      final id = await repo.addRecord(oilChange(1000, total: 10000));
      await (db.update(db.maintenanceRecords)..where((t) => t.id.equals(id)))
          .write(
              const MaintenanceRecordsCompanion(voidedAt: Value('2026-11-09')));
      final o = await overview();
      expect(o.snapshot.records, isEmpty);
      expect(o.totalExpensesCentavos, 0);
    });

    test('cannot delete an item that has history', () async {
      await repo.addRecord(oilChange(1000));
      expect(
          () => (db.delete(db.maintenanceItems)
                ..where((t) => t.id.equals(itemIds['Engine Oil']!)))
              .go(),
          throwsA(isA<Exception>()));
    });
  });

  group('custom rules', () {
    test('fuel filter custom interval works and is separate from Honda rules',
        () async {
      expect(
          () => repo.addCustomRule(
              motorcycleId: bikeId,
              itemId: itemIds['Fuel Filter']!,
              action: ActionCode.replace),
          throwsA(isA<MaintenanceException>()));
      expect(
          () => repo.addCustomRule(
              motorcycleId: bikeId,
              itemId: itemIds['Fuel Filter']!,
              action: ActionCode.replace,
              intervalKm: 0),
          throwsA(isA<MaintenanceException>()));

      await odo.record(motorcycleId: bikeId, readingKm: 2000, date: day);
      await repo.addCustomRule(
        motorcycleId: bikeId,
        itemId: itemIds['Fuel Filter']!,
        action: ActionCode.replace,
        intervalKm: 12000,
      );

      final rows = await db.select(db.maintenanceRules).get();
      expect(rows.where((r) => r.source == 'HONDA_MANUAL'), hasLength(28));
      expect(rows.where((r) => r.source == 'CUSTOM'), hasLength(1));

      final o = await overview();
      final ff = item(o, 'Fuel Filter').evaluation;
      expect(ff.hasSchedule, isTrue);
      expect(ff.next!.next!.dueKm, 14000); // from first tracked reading
      expect(ff.next!.rule.source, MaintenanceSource.custom);
    });
  });

  group('overview from seeded configuration', () {
    test('uses real rules and data, no hardcoded values', () async {
      var o = await overview();
      expect(o.currentKm, isNull);
      expect(o.snapshot.motorcycle!.displayName, 'Honda ADV 160');

      await odo.record(motorcycleId: bikeId, readingKm: 500, date: day);
      o = await overview();
      expect(o.currentKm, 500);
      expect(o.trackedKm, 0);
      expect(o.scheduled.length, 24);
      expect(o.unscheduled.map((i) => i.item.name).toSet(),
          {'Fuel Filter', 'Lights/Horn'});

      final oil = item(o, 'Engine Oil').evaluation;
      expect(oil.status, MaintenanceStatus.upcoming);
      expect(oil.next!.remainingKm, 500);
      expect(item(o, 'Drive Belt').evaluation.next!.next!.dueKm, 12000);

      // Date-based rules count from the first odometer date (no purchase date).
      final bf = item(o, 'Brake Fluid').evaluation;
      final bfDateRule = bf.ruleEvaluations
          .firstWhere((r) => r.rule.ruleType == RuleType.date);
      expect(bfDateRule.next!.dueDate, DateTime.utc(2028, 11, 9));
      expect(bf.status, MaintenanceStatus.good);

      expect(o.statusCounts[MaintenanceStatus.upcoming.code], 4);
      expect(o.statusCounts[MaintenanceStatus.good.code], 20);
      expect(o.overdue, isEmpty);
      expect(o.dueSoon.map((i) => i.item.name).toSet(), {
        'Engine Oil',
        'Engine Idle Speed',
        'Brake System',
        'Nuts, Bolts, Fasteners',
      });
    });

    test('purchase date drives date-based rules', () async {
      await db
          .update(db.motorcycles)
          .write(const MotorcyclesCompanion(purchaseDate: Value('2023-06-15')));
      await odo.record(motorcycleId: bikeId, readingKm: 20000, date: day);
      final o = await overview();
      final bf = item(o, 'Brake Fluid').evaluation;
      final bfDateRule = bf.ruleEvaluations
          .firstWhere((r) => r.rule.ruleType == RuleType.date);
      expect(bfDateRule.next!.dueDate, DateTime.utc(2025, 6, 15));
      expect(bf.status, MaintenanceStatus.overdue);
      final coolant = item(o, 'Radiator Coolant').evaluation;
      final coolantDateRule = coolant.ruleEvaluations
          .firstWhere((r) => r.rule.ruleType == RuleType.date);
      expect(coolantDateRule.next!.dueDate, DateTime.utc(2026, 6, 15));
      expect(o.overdue.map((i) => i.item.name),
          containsAll(['Brake Fluid', 'Radiator Coolant', 'Final Drive Oil']));
    });

    test('checkpoints before the first reading remain overdue until completed',
        () async {
      await odo.record(motorcycleId: bikeId, readingKm: 8000, date: day);
      final o = await overview();
      final oil = item(o, 'Engine Oil').evaluation;
      expect(oil.status, MaintenanceStatus.overdue);
      expect(oil.next!.next!.dueKm, 1000);
    });

    test('watchSnapshot re-emits after an odometer update', () async {
      final stream = repo.watchSnapshot();
      final future = stream
          .firstWhere((s) => s.currentKm == 2500)
          .timeout(const Duration(seconds: 5));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await odo.record(motorcycleId: bikeId, readingKm: 2500, date: day);
      expect((await future).currentKm, 2500);
    });

    test('watchSnapshot re-emits after a service record', () async {
      final future = repo
          .watchSnapshot()
          .firstWhere((s) => s.records.isNotEmpty)
          .timeout(const Duration(seconds: 5));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await repo.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Engine Oil']!,
        action: MaintenanceAction.replacement,
        date: day,
        odometerKm: 1000,
      ));
      expect((await future).records.single.odometerKm, 1000);
    });
  });
}
