import 'package:flutter_test/flutter_test.dart';

import 'package:adv_mon/core/enums/enums.dart';
import 'package:adv_mon/core/services/maintenance_calculator.dart';
import 'package:adv_mon/core/utils/date_utils.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_models.dart';

DateTime d(int y, int m, int day) => DateTime.utc(y, m, day);

ServiceEvent ev(MaintenanceAction a, int km, [DateTime? date]) =>
    ServiceEvent(date: date ?? d(2026, 1, 1), odometerKm: km, action: a);

const calc = MaintenanceCalculator();
final today = d(2026, 11, 9);

/// Honda-style engine oil candidate: R at 1,000 then every 6,000 from 6,000.
const oil = RuleDef(
  id: 1,
  itemId: 1,
  ruleType: RuleType.mileage,
  actionCode: ActionCode.replace,
  source: MaintenanceSource.hondaManual,
  steps: [
    RuleStepDef(actionCode: ActionCode.replace, atKm: 1000),
    RuleStepDef(
        actionCode: ActionCode.replace, atKm: 6000, repeatEveryKm: 6000),
  ],
);

const beltInspect = RuleDef(
  id: 2,
  itemId: 2,
  ruleType: RuleType.mileage,
  actionCode: ActionCode.inspect,
  source: MaintenanceSource.hondaManual,
  steps: [
    RuleStepDef(actionCode: ActionCode.inspect, atKm: 18000),
    RuleStepDef(actionCode: ActionCode.inspect, atKm: 36000),
  ],
);

const beltReplace = RuleDef(
  id: 3,
  itemId: 2,
  ruleType: RuleType.mileage,
  actionCode: ActionCode.replace,
  source: MaintenanceSource.hondaManual,
  steps: [RuleStepDef(actionCode: ActionCode.replace, atKm: 30000)],
);

const brakeFluid = RuleDef(
  id: 4,
  itemId: 3,
  ruleType: RuleType.date,
  actionCode: ActionCode.replace,
  source: MaintenanceSource.hondaManual,
  intervalMonths: 24,
);

RuleEvaluation evalRule(
  RuleDef rule, {
  List<ServiceEvent> events = const [],
  int km = 0,
  DateTime? now,
  int? baselineKm = 0,
  DateTime? baselineDate,
  MaintenanceCalculator c = calc,
}) =>
    c.evaluateRule(
      rule: rule,
      events: events,
      currentKm: km,
      today: now ?? today,
      baselineKm: baselineKm,
      baselineDate: baselineDate,
    )!;

void main() {
  group('mileage-based: next due, remaining, status', () {
    test('first checkpoint at 1,000 km', () {
      final e = evalRule(oil, km: 0);
      expect(e.next!.dueKm, 1000);
      expect(e.next!.actionCode, ActionCode.replace);
      expect(e.remainingKm, 1000);
      expect(e.remainingDays, isNull);
      expect(e.status, MaintenanceStatus.upcoming);
    });

    test('remaining kilometers shrink as odometer rises', () {
      expect(evalRule(oil, km: 200).remainingKm, 800);
      expect(evalRule(oil, km: 950).remainingKm, 50);
    });

    test('status thresholds: upcoming, due, overdue', () {
      expect(evalRule(oil, km: 0).status, MaintenanceStatus.upcoming); // 1000
      expect(evalRule(oil, km: 899).status, MaintenanceStatus.upcoming); // 101
      expect(evalRule(oil, km: 900).status, MaintenanceStatus.due); // 100
      expect(evalRule(oil, km: 1000).status, MaintenanceStatus.due); // 0
      expect(evalRule(oil, km: 1001).status, MaintenanceStatus.overdue); // -1
    });

    test('good when the next checkpoint is far away', () {
      final e = evalRule(oil,
          km: 2000, events: [ev(MaintenanceAction.replacement, 1000)]);
      expect(e.next!.dueKm, 6000);
      expect(e.remainingKm, 4000);
      expect(e.status, MaintenanceStatus.good);
    });

    test('custom thresholds are honoured', () {
      const strict = MaintenanceCalculator(
          thresholds: MaintenanceThresholds(
              dueKm: 0, dueDays: 0, upcomingKm: 100, upcomingDays: 1));
      expect(evalRule(oil, km: 0, c: strict).status, MaintenanceStatus.good);
      expect(
          evalRule(oil, km: 900, c: strict).status, MaintenanceStatus.upcoming);
    });
  });

  group('recurring manufacturer checkpoints', () {
    test('advances to the next 6,000 km checkpoint after service', () {
      final e = evalRule(oil, km: 7000, events: [
        ev(MaintenanceAction.replacement, 1000),
        ev(MaintenanceAction.replacement, 6200),
      ]);
      expect(e.next!.dueKm, 12000);
      expect(e.remainingKm, 5000);
      expect(e.status, MaintenanceStatus.good);
      expect(e.lastService!.odometerKm, 6200);
    });

    test('generates checkpoints far into the future', () {
      final events = [
        for (var k = 1000; k <= 61000; k += 6000)
          ev(MaintenanceAction.replacement, k)
      ];
      final e = evalRule(oil, km: 61000, events: events);
      expect(e.next!.dueKm, 66000);
      expect(e.missedCount, 0);
    });

    test('counts every missed checkpoint and reports the earliest', () {
      final e = evalRule(oil,
          km: 30500, events: [ev(MaintenanceAction.replacement, 1000)]);
      expect(e.status, MaintenanceStatus.overdue);
      expect(e.next!.dueKm, 6000);
      expect(e.remainingKm, 6000 - 30500);
      expect(e.missedCount, 5); // 6k, 12k, 18k, 24k, 30k
    });
  });

  group('overdue and early completion', () {
    test('overdue does not shift the manufacturer schedule', () {
      final overdue = evalRule(oil, km: 7000);
      expect(overdue.next!.dueKm, 1000);
      expect(overdue.missedCount, 2); // 1,000 and 6,000

      final after = evalRule(oil,
          km: 7000, events: [ev(MaintenanceAction.replacement, 7000)]);
      // Next checkpoint is still 12,000, not 7,000 + 6,000.
      expect(after.next!.dueKm, 12000);
      expect(after.missedCount, 0);
    });

    test('service within early tolerance satisfies the checkpoint', () {
      final early = evalRule(oil, km: 5100, events: [
        ev(MaintenanceAction.replacement, 1000),
        ev(MaintenanceAction.replacement, 5000),
      ]);
      expect(early.next!.dueKm, 12000);
      expect(early.remainingKm, 6900);
    });

    test('service earlier than the tolerance does not satisfy it', () {
      final tooEarly = evalRule(oil, km: 5000, events: [
        ev(MaintenanceAction.replacement, 1000),
        ev(MaintenanceAction.replacement, 4999),
      ]);
      expect(tooEarly.next!.dueKm, 6000);
      expect(tooEarly.remainingKm, 1000);
      expect(tooEarly.status, MaintenanceStatus.upcoming);
    });

    test('only compatible actions satisfy a replacement checkpoint', () {
      final e = evalRule(oil, km: 500, events: [
        ev(MaintenanceAction.inspection, 900),
        ev(MaintenanceAction.lubrication, 900),
      ]);
      expect(e.next!.dueKm, 1000);
    });

    test('a later service satisfies all earlier missed checkpoints', () {
      final e = evalRule(oil,
          km: 13000, events: [ev(MaintenanceAction.replacement, 13000)]);
      expect(e.next!.dueKm, 18000);
      expect(e.missedCount, 0);
    });

    test('custom early tolerance', () {
      const tight = MaintenanceCalculator(earlyToleranceKm: 0);
      final e = evalRule(oil, km: 5500, c: tight, events: [
        ev(MaintenanceAction.replacement, 1000),
        ev(MaintenanceAction.replacement, 5500),
      ]);
      expect(e.next!.dueKm, 6000);
    });
  });

  group('separate inspection and replacement actions (CVT belt)', () {
    List<RuleDef> rules = [beltInspect, beltReplace];

    ItemEvaluation item(int km, List<ServiceEvent> events) => calc.evaluateItem(
          itemId: 2,
          rules: rules,
          events: events,
          currentKm: km,
          today: today,
          baselineKm: 0,
        );

    test('nearest action drives the item', () {
      final e = item(17500, []);
      expect(e.status, MaintenanceStatus.upcoming);
      expect(e.next!.rule.id, beltInspect.id);
      expect(e.next!.next!.dueKm, 18000);
      expect(e.next!.next!.actionCode, ActionCode.inspect);
      final replace =
          e.ruleEvaluations.firstWhere((r) => r.rule.id == beltReplace.id);
      expect(replace.next!.dueKm, 30000);
      expect(replace.remainingKm, 12500);
      expect(replace.status, MaintenanceStatus.good);
    });

    test('inspection moves only the inspection schedule', () {
      final e = item(18100, [ev(MaintenanceAction.inspection, 18000)]);
      final insp =
          e.ruleEvaluations.firstWhere((r) => r.rule.id == beltInspect.id);
      final repl =
          e.ruleEvaluations.firstWhere((r) => r.rule.id == beltReplace.id);
      expect(insp.next!.dueKm, 36000);
      expect(repl.next!.dueKm, 30000);
      expect(e.status, MaintenanceStatus.good);
    });

    test('an inspection does not satisfy the replacement', () {
      final e = item(30500, [ev(MaintenanceAction.inspection, 30000)]);
      final repl =
          e.ruleEvaluations.firstWhere((r) => r.rule.id == beltReplace.id);
      expect(repl.status, MaintenanceStatus.overdue);
      expect(e.status, MaintenanceStatus.overdue);
    });

    test('replacement completes the replace schedule', () {
      final e = item(31000, [ev(MaintenanceAction.replacement, 30000)]);
      final repl =
          e.ruleEvaluations.firstWhere((r) => r.rule.id == beltReplace.id);
      expect(repl.next, isNull);
      expect(repl.status, MaintenanceStatus.good);
      expect(e.hasSchedule, isTrue);
      final insp =
          e.ruleEvaluations.firstWhere((r) => r.rule.id == beltInspect.id);
      expect(insp.next!.dueKm, 36000); // replacement also covers I@18,000
    });

    test('replacement made early satisfies the replace checkpoint', () {
      final e = item(29600, [ev(MaintenanceAction.replacement, 29500)]);
      final repl =
          e.ruleEvaluations.firstWhere((r) => r.rule.id == beltReplace.id);
      expect(repl.next, isNull);
    });
  });

  group('date-based maintenance', () {
    final replaced = [ev(MaintenanceAction.replacement, 100, d(2024, 2, 29))];

    RuleEvaluation at(DateTime now) =>
        evalRule(brakeFluid, events: replaced, now: now);

    test('24 months from a leap day lands on 28 Feb', () {
      final e = at(d(2026, 1, 1));
      expect(e.next!.dueDate, d(2026, 2, 28));
      expect(e.remainingDays, 58);
      expect(e.remainingKm, isNull);
      expect(e.status, MaintenanceStatus.good);
    });

    test('status by remaining days', () {
      expect(at(d(2026, 1, 29)).status, MaintenanceStatus.upcoming); // 30
      expect(at(d(2026, 2, 21)).status, MaintenanceStatus.due); // 7
      expect(at(d(2026, 2, 28)).status, MaintenanceStatus.due); // 0
      expect(at(d(2026, 2, 28)).remainingDays, 0);
      final overdue = at(d(2026, 3, 1));
      expect(overdue.status, MaintenanceStatus.overdue);
      expect(overdue.remainingDays, -1);
      expect(overdue.missedCount, 1);
    });

    test('counts from baseline date when never serviced', () {
      final e = evalRule(brakeFluid, baselineDate: d(2023, 6, 15));
      expect(e.next!.dueDate, d(2025, 6, 15));
      expect(e.remainingDays, AppDates.daysBetween(today, d(2025, 6, 15)));
      expect(e.status, MaintenanceStatus.overdue);
    });

    test('most recent matching service resets the interval', () {
      final e = evalRule(brakeFluid, now: d(2026, 11, 9), events: [
        ev(MaintenanceAction.replacement, 100, d(2023, 1, 1)),
        ev(MaintenanceAction.replacement, 9000, d(2026, 10, 1)),
      ]);
      expect(e.next!.dueDate, d(2028, 10, 1));
      expect(e.status, MaintenanceStatus.good);
    });

    test('36 month coolant interval', () {
      const coolant = RuleDef(
        id: 5,
        itemId: 4,
        ruleType: RuleType.date,
        actionCode: ActionCode.replace,
        source: MaintenanceSource.hondaManual,
        intervalMonths: 36,
      );
      final e = evalRule(coolant, baselineDate: d(2023, 6, 15));
      expect(e.next!.dueDate, d(2026, 6, 15));
    });

    test('missing baseline yields no schedule', () {
      final e = evalRule(brakeFluid, baselineDate: null);
      expect(e.next, isNull);
      expect(e.missingBaseline, isTrue);

      final item = calc.evaluateItem(
        itemId: 3,
        rules: [brakeFluid],
        events: const [],
        currentKm: 0,
        today: today,
      );
      expect(item.hasSchedule, isFalse);
      expect(item.needsBaseline, isTrue);
    });
  });

  group('combined mileage and date (either limit triggers)', () {
    const custom = RuleDef(
      id: 6,
      itemId: 5,
      ruleType: RuleType.combined,
      actionCode: ActionCode.replace,
      source: MaintenanceSource.custom,
      intervalKm: 5000,
      intervalMonths: 6,
    );
    final serviced = [
      ev(MaintenanceAction.replacement, 10000, d(2026, 6, 1)),
    ];

    test('both limits are calculated', () {
      final e = evalRule(custom, events: serviced, km: 10500);
      expect(e.next!.dueKm, 15000);
      expect(e.next!.dueDate, d(2026, 12, 1));
      expect(e.remainingKm, 4500);
      expect(e.remainingDays, 22);
    });

    test('date limit nearer than km limit drives status', () {
      final e = evalRule(custom, events: serviced, km: 10500);
      expect(e.status, MaintenanceStatus.upcoming); // 22 days, 4500 km
    });

    test('km limit reached first', () {
      final e =
          evalRule(custom, events: serviced, km: 15200, now: d(2026, 6, 20));
      expect(e.status, MaintenanceStatus.overdue);
      expect(e.remainingKm, -200);
      expect(e.remainingDays, greaterThan(0));
    });

    test('date limit reached first', () {
      final e =
          evalRule(custom, events: serviced, km: 10500, now: d(2026, 12, 2));
      expect(e.status, MaintenanceStatus.overdue);
      expect(e.remainingDays, -1);
      expect(e.remainingKm, 4500);
    });

    test('neither limit reached', () {
      final e =
          evalRule(custom, events: serviced, km: 10100, now: d(2026, 6, 10));
      expect(e.status, MaintenanceStatus.good);
    });

    test('mileage-only custom interval counts from last service', () {
      const everyThree = RuleDef(
        id: 7,
        itemId: 1,
        ruleType: RuleType.mileage,
        actionCode: ActionCode.replace,
        source: MaintenanceSource.custom,
        intervalKm: 3000,
      );
      final e = evalRule(everyThree,
          km: 3900, events: [ev(MaintenanceAction.replacement, 1000)]);
      expect(e.next!.dueKm, 4000);
      expect(e.remainingKm, 100);
      expect(e.status, MaintenanceStatus.due);
    });

    test('step with both km and months, from baseline date', () {
      const both = RuleDef(
        id: 8,
        itemId: 1,
        ruleType: RuleType.combined,
        actionCode: ActionCode.replace,
        source: MaintenanceSource.serviceManual,
        steps: [
          RuleStepDef(
            actionCode: ActionCode.replace,
            atKm: 6000,
            atMonths: 12,
            repeatEveryKm: 6000,
            repeatEveryMonths: 12,
          ),
        ],
      );
      final e = evalRule(both, km: 3000, baselineDate: d(2025, 11, 30));
      expect(e.next!.dueKm, 6000);
      expect(e.next!.dueDate, d(2026, 11, 30));
      expect(e.remainingKm, 3000);
      expect(e.remainingDays, 21);
      expect(e.status, MaintenanceStatus.upcoming);

      // A service on the date side satisfies the checkpoint.
      final done = evalRule(both,
          km: 3000,
          baselineDate: d(2025, 11, 30),
          events: [ev(MaintenanceAction.replacement, 3000, d(2026, 11, 5))]);
      expect(done.next!.dueKm, 12000);
      expect(done.next!.dueDate, d(2027, 11, 30));
    });

    test('leap day in a step date', () {
      const yearly = RuleDef(
        id: 9,
        itemId: 1,
        ruleType: RuleType.date,
        actionCode: ActionCode.inspect,
        source: MaintenanceSource.serviceManual,
        steps: [
          RuleStepDef(
              actionCode: ActionCode.inspect,
              atMonths: 12,
              repeatEveryMonths: 12),
        ],
      );
      final e =
          evalRule(yearly, baselineDate: d(2024, 2, 29), now: d(2025, 1, 1));
      expect(e.next!.dueDate, d(2025, 2, 28));
    });
  });

  group('first tracked reading', () {
    test('checkpoints before it are skipped, not missed', () {
      final e = evalRule(oil, km: 8000, baselineKm: 8000);
      expect(e.skippedBeforeTracking, 2);
      expect(e.next!.dueKm, 12000);
      expect(e.remainingKm, 4000);
      expect(e.status, MaintenanceStatus.good);
      expect(e.missedCount, 0);
    });

    test('simple interval counts from the first reading when never serviced',
        () {
      const everyThree = RuleDef(
        id: 7,
        itemId: 1,
        ruleType: RuleType.mileage,
        actionCode: ActionCode.replace,
        source: MaintenanceSource.custom,
        intervalKm: 3000,
      );
      final e = evalRule(everyThree, km: 8000, baselineKm: 8000);
      expect(e.next!.dueKm, 11000);
    });
  });

  group('custom rules alongside manufacturer rules', () {
    const customOil = RuleDef(
      id: 20,
      itemId: 1,
      ruleType: RuleType.mileage,
      actionCode: ActionCode.replace,
      source: MaintenanceSource.custom,
      intervalKm: 3000,
    );

    test('are evaluated separately and the manual rule is unchanged', () {
      final events = [ev(MaintenanceAction.replacement, 1000)];
      final item = calc.evaluateItem(
        itemId: 1,
        rules: [oil, customOil],
        events: events,
        currentKm: 3900,
        today: today,
        baselineKm: 0,
      );
      final manual =
          item.ruleEvaluations.firstWhere((r) => r.rule.id == oil.id);
      final custom =
          item.ruleEvaluations.firstWhere((r) => r.rule.id == customOil.id);
      expect(manual.rule.source, MaintenanceSource.hondaManual);
      expect(manual.next!.dueKm, 6000);
      expect(manual.status, MaintenanceStatus.good);
      expect(custom.rule.source, MaintenanceSource.custom);
      expect(custom.next!.dueKm, 4000);
      expect(item.status, MaintenanceStatus.due);
      expect(item.next!.rule.id, customOil.id);

      // The manual rule evaluates identically without the custom rule.
      final only = calc.evaluateItem(
        itemId: 1,
        rules: [oil],
        events: events,
        currentKm: 3900,
        today: today,
        baselineKm: 0,
      );
      expect(only.ruleEvaluations.single.next!.dueKm, 6000);
    });

    test('inactive rules are ignored', () {
      const off = RuleDef(
        id: 21,
        itemId: 1,
        ruleType: RuleType.mileage,
        actionCode: ActionCode.replace,
        source: MaintenanceSource.custom,
        intervalKm: 1000,
        isActive: false,
      );
      expect(
          calc.evaluateRule(
              rule: off, events: const [], currentKm: 0, today: today),
          isNull);
    });

    test('rule without any interval is ignored', () {
      const none = RuleDef(
        id: 22,
        itemId: 1,
        ruleType: RuleType.custom,
        actionCode: ActionCode.replace,
        source: MaintenanceSource.custom,
      );
      expect(
          calc.evaluateRule(
              rule: none, events: const [], currentKm: 0, today: today),
          isNull);
    });
  });

  group('condition-based rules', () {
    const condition = RuleDef(
      id: 30,
      itemId: 2,
      ruleType: RuleType.condition,
      actionCode: ActionCode.inspect,
      source: MaintenanceSource.hondaManual,
    );

    ItemEvaluation item(ConditionFlag flag, [List<RuleDef> extra = const []]) =>
        calc.evaluateItem(
          itemId: 2,
          rules: [condition, ...extra],
          events: const [],
          currentKm: 100,
          today: today,
          baselineKm: 0,
          condition: flag,
        );

    test('never derive wear limits on their own', () {
      expect(
          calc.evaluateRule(
              rule: condition,
              events: const [],
              currentKm: 99999,
              today: today),
          isNull);
      final e = item(ConditionFlag.none);
      expect(e.hasSchedule, isFalse);
    });

    test('verified-threshold flags map to statuses', () {
      expect(item(ConditionFlag.inspectionRequired).status,
          MaintenanceStatus.inspectionRequired);
      expect(item(ConditionFlag.replacementRequired).status,
          MaintenanceStatus.replacementRequired);
      expect(item(ConditionFlag.replacementRequired).hasSchedule, isTrue);
    });

    test('condition flag outranks schedule status', () {
      final e = item(ConditionFlag.replacementRequired, [beltInspect]);
      expect(e.status, MaintenanceStatus.replacementRequired);
      final e2 = item(ConditionFlag.inspectionRequired, [beltInspect]);
      expect(
          e2.status,
          MaintenanceStatus.upcoming.severity >
                  MaintenanceStatus.inspectionRequired.severity
              ? MaintenanceStatus.upcoming
              : MaintenanceStatus.inspectionRequired);
    });
  });

  group('item evaluation', () {
    test('last service is the latest of any action', () {
      final e = calc.evaluateItem(
        itemId: 1,
        rules: [oil],
        events: [
          ev(MaintenanceAction.replacement, 1000, d(2026, 2, 1)),
          ev(MaintenanceAction.inspection, 1500, d(2026, 5, 1)),
        ],
        currentKm: 1600,
        today: today,
        baselineKm: 0,
      );
      expect(e.lastService!.action, MaintenanceAction.inspection);
      expect(e.lastService!.odometerKm, 1500);
    });

    test('no rules means no schedule and no invented status', () {
      final e = calc.evaluateItem(
        itemId: 9,
        rules: const [],
        events: const [],
        currentKm: 0,
        today: today,
      );
      expect(e.hasSchedule, isFalse);
      expect(e.next, isNull);
    });
  });

  group('action code compatibility', () {
    test('replacement covers inspect and clean; others only themselves', () {
      expect(ActionCode.inspect.isSatisfiedBy(MaintenanceAction.replacement),
          isTrue);
      expect(ActionCode.clean.isSatisfiedBy(MaintenanceAction.replacement),
          isTrue);
      expect(ActionCode.replace.isSatisfiedBy(MaintenanceAction.inspection),
          isFalse);
      expect(
          ActionCode.clean.isSatisfiedBy(MaintenanceAction.cleaning), isTrue);
      expect(ActionCode.inspect.isSatisfiedBy(MaintenanceAction.cleaning),
          isFalse);
    });
  });
}
