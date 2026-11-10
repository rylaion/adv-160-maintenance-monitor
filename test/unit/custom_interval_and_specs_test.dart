import 'package:adv_mon/core/enums/enums.dart';
import 'package:adv_mon/core/services/maintenance_calculator.dart';
import 'package:adv_mon/features/components/domain/component_models.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_models.dart';
import 'package:adv_mon/features/maintenance/presentation/status_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Custom Maintenance Interval Calculation Engine', () {
    const calculator = MaintenanceCalculator();
    final today = DateTime.utc(2026, 11, 9);

    test(
        'CVT Cleaning custom interval (6,000 km, last completed 12,000 km) '
        'calculates Next Due 18,000 km and Upcoming at 16,500 km', () {
      const rule = RuleDef(
        id: 101,
        itemId: 50,
        ruleType: RuleType.mileage,
        actionCode: ActionCode.clean,
        source: MaintenanceSource.custom,
        intervalKm: 6000,
        lastCompletedKm: 12000,
      );

      final evalAt16500 = calculator.evaluateItem(
        itemId: 50,
        rules: const [rule],
        events: const [],
        currentKm: 16500,
        today: today,
        baselineKm: 16500,
      );

      expect(evalAt16500.hasSchedule, isTrue);
      expect(evalAt16500.next?.next?.dueKm, 18000);
      expect(evalAt16500.next?.remainingKm, 1500);
      expect(evalAt16500.status, MaintenanceStatus.upcoming);

      // Updating current odometer recalculates status without shifting Next Due
      final evalAt14000 = calculator.evaluateItem(
        itemId: 50,
        rules: const [rule],
        events: const [],
        currentKm: 14000,
        today: today,
        baselineKm: 14000,
      );
      expect(evalAt14000.next?.next?.dueKm, 18000);
      expect(evalAt14000.status, MaintenanceStatus.good);

      final evalAt18000 = calculator.evaluateItem(
        itemId: 50,
        rules: const [rule],
        events: const [],
        currentKm: 18000,
        today: today,
        baselineKm: 18000,
      );
      expect(evalAt18000.next?.next?.dueKm, 18000);
      expect(evalAt18000.status, MaintenanceStatus.due);

      final evalAt18500 = calculator.evaluateItem(
        itemId: 50,
        rules: const [rule],
        events: const [],
        currentKm: 18500,
        today: today,
        baselineKm: 18500,
      );
      expect(evalAt18500.next?.next?.dueKm, 18000);
      expect(evalAt18500.status, MaintenanceStatus.overdue);
    });

    test(
        'Next due is anchored to last completed service (or 0 if never serviced), '
        'never to current odometer baselineKm', () {
      const rule = RuleDef(
        id: 102,
        itemId: 51,
        ruleType: RuleType.mileage,
        actionCode: ActionCode.inspect,
        source: MaintenanceSource.custom,
        intervalKm: 3000,
      );

      // No service records, user's first odometer log is 10,000 km:
      // Next due must be 0 + 3,000 = 3,000 km (Overdue), NOT 10,000 + 3,000 = 13,000 km.
      final evalNoService = calculator.evaluateItem(
        itemId: 51,
        rules: const [rule],
        events: const [],
        currentKm: 10000,
        today: today,
        baselineKm: 10000,
      );
      expect(evalNoService.next?.next?.dueKm, 3000);
      expect(evalNoService.status, MaintenanceStatus.overdue);

      // After logging a service at 10,000 km, next due becomes 13,000 km.
      final evalAfterService = calculator.evaluateItem(
        itemId: 51,
        rules: const [rule],
        events: [
          ServiceEvent(
            date: today,
            odometerKm: 10000,
            action: MaintenanceAction.cleaning,
          ),
        ],
        currentKm: 10000,
        today: today,
        baselineKm: 10000,
      );
      expect(evalAfterService.next?.next?.dueKm, 13000);
      expect(evalAfterService.status, MaintenanceStatus.good);
    });

    test('Custom warning threshold overrides default upcoming threshold', () {
      const rule = RuleDef(
        id: 103,
        itemId: 52,
        ruleType: RuleType.mileage,
        actionCode: ActionCode.replace,
        source: MaintenanceSource.custom,
        intervalKm: 5000,
        warningKm: 800,
        lastCompletedKm: 10000,
      );

      final at14100 = calculator.evaluateItem(
        itemId: 52,
        rules: const [rule],
        events: const [],
        currentKm: 14100,
        today: today,
      );
      expect(at14100.status, MaintenanceStatus.good);

      final at14200 = calculator.evaluateItem(
        itemId: 52,
        rules: const [rule],
        events: const [],
        currentKm: 14200,
        today: today,
      );
      expect(at14200.status, MaintenanceStatus.upcoming);
    });

    test(
        'Custom rule on a Honda item drives item status while retaining Honda rule in ruleEvaluations',
        () {
      const hondaRule = RuleDef(
        id: 1,
        itemId: 10,
        ruleType: RuleType.mileage,
        actionCode: ActionCode.inspect,
        source: MaintenanceSource.hondaManual,
        sourceDocument: 'Honda ADV160 2023 Owner\'s Manual (32K0WA100)',
        sourcePage: 88,
        isVerified: true,
        steps: [
          RuleStepDef(
            actionCode: ActionCode.inspect,
            atKm: 6000,
            repeatEveryKm: 6000,
          ),
        ],
      );
      const customRule = RuleDef(
        id: 2,
        itemId: 10,
        ruleType: RuleType.mileage,
        actionCode: ActionCode.inspect,
        source: MaintenanceSource.custom,
        intervalKm: 3000,
        lastCompletedKm: 12000,
      );

      final eval = calculator.evaluateItem(
        itemId: 10,
        rules: const [hondaRule, customRule],
        events: const [],
        currentKm: 14800,
        today: today,
      );

      expect(eval.ruleEvaluations.length, 2);
      expect(eval.next?.rule.source, MaintenanceSource.custom);
      expect(eval.next?.next?.dueKm, 15000);
      expect(eval.status, MaintenanceStatus.upcoming);
    });
  });

  group('Honda Manual Recommendation Formatting', () {
    test('Formats official Honda manual interval with action code and source',
        () {
      const hondaRule = RuleDef(
        id: 1,
        itemId: 1,
        ruleType: RuleType.mileage,
        actionCode: ActionCode.inspect,
        source: MaintenanceSource.hondaManual,
        isVerified: true,
        steps: [
          RuleStepDef(
            actionCode: ActionCode.inspect,
            atKm: 6000,
            repeatEveryKm: 6000,
          ),
        ],
      );

      final rec = StatusText.hondaRecommendationForRules(const [hondaRule]);
      expect(rec, contains('Inspect (I) every 6,000 km'));
      expect(rec, contains('Honda ADV160 Owner\'s Manual 32K0WA100'));
    });

    test('Displays no-fixed-interval note when no Honda rule exists', () {
      const customRule = RuleDef(
        id: 2,
        itemId: 99,
        ruleType: RuleType.mileage,
        actionCode: ActionCode.clean,
        source: MaintenanceSource.custom,
        intervalKm: 6000,
      );

      final rec = StatusText.hondaRecommendationForRules(const [customRule]);
      expect(rec, StatusText.noHondaIntervalNote);
    });
  });

  group('Component Measurement & Wear Specifications', () {
    final inspectionDate = DateTime.utc(2026, 11, 9);

    test(
        'Verified Honda specifications (Tire tread depth & Throttle freeplay) '
        'evaluate Good, Monitor, Replace, and Not recorded accurately', () {
      final frontTireDef = ComponentSpecDefinition.catalog
          .firstWhere((c) => c.specKey == 'front_tire_tread');
      final rearTireDef = ComponentSpecDefinition.catalog
          .firstWhere((c) => c.specKey == 'rear_tire_tread');

      expect(frontTireDef.isHondaVerified, isTrue);
      expect(frontTireDef.hondaServiceLimit, 1.5);
      expect(rearTireDef.isHondaVerified, isTrue);
      expect(rearTireDef.hondaServiceLimit, 2.0);

      // Not recorded
      final notRecorded = EvaluatedComponentSpec.evaluate(
        definition: frontTireDef,
        itemMeasurements: const [],
      );
      expect(notRecorded.status, ComponentSpecStatus.notRecorded);
      expect(notRecorded.isHondaLimit, isTrue);
      expect(notRecorded.isUserDefinedLimit, isFalse);

      // Good (3.5 mm > 1.5 + 0.5)
      final goodEval = EvaluatedComponentSpec.evaluate(
        definition: frontTireDef,
        itemMeasurements: [
          ComponentMeasurement(
            id: 1,
            motorcycleId: 1,
            itemId: 24,
            measuredDate: inspectionDate,
            odometerKm: 6000,
            measurementType: MeasurementType.treadDepthMm,
            value: 3.5,
            unit: 'mm',
            position: 'FRONT',
          ),
        ],
      );
      expect(goodEval.status, ComponentSpecStatus.good);

      // Monitor (1.8 mm is within 0.5 mm of 1.5 mm limit)
      final monitorEval = EvaluatedComponentSpec.evaluate(
        definition: frontTireDef,
        itemMeasurements: [
          ComponentMeasurement(
            id: 2,
            motorcycleId: 1,
            itemId: 24,
            measuredDate: inspectionDate,
            odometerKm: 12000,
            measurementType: MeasurementType.treadDepthMm,
            value: 1.8,
            unit: 'mm',
            position: 'FRONT',
          ),
        ],
      );
      expect(monitorEval.status, ComponentSpecStatus.monitor);

      // Replace (1.5 mm reached service limit)
      final replaceEval = EvaluatedComponentSpec.evaluate(
        definition: frontTireDef,
        itemMeasurements: [
          ComponentMeasurement(
            id: 3,
            motorcycleId: 1,
            itemId: 24,
            measuredDate: inspectionDate,
            odometerKm: 18000,
            measurementType: MeasurementType.treadDepthMm,
            value: 1.5,
            unit: 'mm',
            position: 'FRONT',
          ),
        ],
      );
      expect(replaceEval.status, ComponentSpecStatus.replace);
    });

    test(
        'Missing specifications (Drive belt, Brake pads, Brake discs) are '
        'marked "Not available in verified manual" and NEVER treated as zero',
        () {
      for (final key in [
        'drive_belt_width',
        'front_brake_pad',
        'rear_brake_pad',
        'front_brake_disc',
        'rear_brake_disc',
      ]) {
        final def =
            ComponentSpecDefinition.catalog.firstWhere((c) => c.specKey == key);
        expect(def.isHondaVerified, isFalse);
        expect(def.hondaServiceLimit, isNull);

        final evaluated = EvaluatedComponentSpec.evaluate(
          definition: def,
          itemMeasurements: [
            ComponentMeasurement(
              id: 10,
              motorcycleId: 1,
              itemId: 12,
              measuredDate: inspectionDate,
              odometerKm: 12000,
              measurementType: def.measurementType,
              value: 4.0,
              unit: 'mm',
              position: def.position,
            ),
          ],
        );

        expect(
          evaluated.standardDisplay,
          ComponentSpecDefinition.notAvailableText,
        );
        expect(
          evaluated.serviceLimitDisplay,
          ComponentSpecDefinition.notAvailableText,
        );
        expect(evaluated.effectiveServiceLimit, isNull);
        // Without a verified or user-defined limit, status is Monitor (never compared to 0)
        expect(evaluated.status, ComponentSpecStatus.monitor);
      }
    });

    test('User-defined limits are distinguished from Honda specifications', () {
      final beltDef = ComponentSpecDefinition.catalog
          .firstWhere((c) => c.specKey == 'drive_belt_width');
      const userSpec = UserComponentSpec(
        specKey: 'drive_belt_width',
        itemId: 12,
        customStandardValue: 22.0,
        customServiceLimit: 21.0,
        unit: 'mm',
      );

      final evalGood = EvaluatedComponentSpec.evaluate(
        definition: beltDef,
        userSpec: userSpec,
        itemMeasurements: [
          ComponentMeasurement(
            id: 1,
            motorcycleId: 1,
            itemId: 12,
            measuredDate: inspectionDate,
            odometerKm: 12000,
            measurementType: MeasurementType.thicknessMm,
            value: 21.8,
            unit: 'mm',
          ),
        ],
      );

      expect(evalGood.isUserDefinedLimit, isTrue);
      expect(evalGood.isHondaLimit, isFalse);
      expect(evalGood.standardDisplay, contains('User-defined'));
      expect(evalGood.serviceLimitDisplay, contains('User-defined'));
      expect(evalGood.status, ComponentSpecStatus.good);

      final evalReplace = EvaluatedComponentSpec.evaluate(
        definition: beltDef,
        userSpec: userSpec,
        itemMeasurements: [
          ComponentMeasurement(
            id: 2,
            motorcycleId: 1,
            itemId: 12,
            measuredDate: inspectionDate,
            odometerKm: 24000,
            measurementType: MeasurementType.thicknessMm,
            value: 20.9,
            unit: 'mm',
          ),
        ],
      );
      expect(evalReplace.status, ComponentSpecStatus.replace);
    });
  });
}
