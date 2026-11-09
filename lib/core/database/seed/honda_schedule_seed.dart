import 'package:drift/drift.dart';

import '../../enums/enums.dart';
import '../app_database.dart';

/// Official 2023 Honda ADV160 Philippines Owner's Manual maintenance schedule
/// configuration.
///
/// Reference:
/// * Model: Honda ADV160, 2023
/// * Manual document number: 32K0WA100
/// * Maintenance Schedule: Owner's Manual pages 87–89
///
/// IMPORTANT:
/// * Note *1 (p. 89): "At higher odometer reading, repeat at the frequency
///   interval established here."
/// * Fuel Filter is NOT seeded here because the 2023 Honda ADV160 Owner's
///   Manual schedule lists Fuel Line inspection and does not prescribe a
///   scheduled fuel filter replacement interval.
class HondaScheduleSeed {
  HondaScheduleSeed(this.db);
  final AppDatabase db;

  static const String sourceDocument =
      'Honda ADV160 2023 Owner\'s Manual (32K0WA100)';

  /// Idempotent: seeds or upgrades the Honda manual rules without modifying
  /// custom rules or historical maintenance records.
  Future<void> run() async {
    await db.transaction(() async {
      final bike = await (db.select(db.motorcycles)
            ..orderBy([(t) => OrderingTerm.asc(t.id)])
            ..limit(1))
          .getSingleOrNull();
      if (bike == null) return;

      final existingManual = await (db.select(db.maintenanceRules)
            ..where((r) => r.source.equals(MaintenanceSource.hondaManual.code)))
          .get();

      // If all verified manual rules are already seeded (>= 24 rules), no-op.
      if (existingManual.length >= 24 &&
          existingManual.every((r) => r.isVerified)) {
        return;
      }

      // Clear any earlier unverified candidate manual rules before seeding the
      // complete verified 32K0WA100 schedule. Custom rules are untouched.
      if (existingManual.isNotEmpty) {
        final manualIds = existingManual.map((r) => r.id).toList();
        await (db.delete(db.maintenanceRuleSteps)
              ..where((s) => s.ruleId.isIn(manualIds)))
            .go();
        await (db.delete(db.maintenanceRules)
              ..where((r) => r.id.isIn(manualIds)))
            .go();
      }

      final items = {
        for (final i in await db.select(db.maintenanceItems).get())
          i.name: i.id,
      };

      Future<void> add(
        String item,
        RuleType type,
        ActionCode action, {
        required int page,
        int? intervalMonths,
        List<MaintenanceRuleStepsCompanion Function(int ruleId, int order)>
            steps = const [],
        String? notes,
      }) async {
        final itemId = items[item];
        if (itemId == null) return;
        final ruleId = await db
            .into(db.maintenanceRules)
            .insert(MaintenanceRulesCompanion.insert(
              motorcycleId: bike.id,
              itemId: itemId,
              ruleType: type.code,
              actionCode: action.code,
              source: MaintenanceSource.hondaManual.code,
              sourceDocument: const Value(sourceDocument),
              sourcePage: Value(page),
              intervalMonths: Value(intervalMonths),
              isVerified: const Value(true),
              notes: Value(notes),
            ));
        var order = 0;
        for (final s in steps) {
          await db.into(db.maintenanceRuleSteps).insert(s(ruleId, order++));
        }
      }

      MaintenanceRuleStepsCompanion Function(int, int) step(
        ActionCode a, {
        int? atKm,
        int? repeatEveryKm,
      }) =>
          (ruleId, order) => MaintenanceRuleStepsCompanion.insert(
                ruleId: ruleId,
                stepOrder: order,
                actionCode: a.code,
                atKm: Value(atKm),
                repeatEveryKm: Value(repeatEveryKm),
              );

      // =======================================================================
      // Owner's Manual Page 88
      // =======================================================================

      // 1. Fuel Line: I at 12k, 18k, 24k, 30k, 36k (repeat every 6,000 km).
      await add(
        'Fuel Line',
        RuleType.mileage,
        ActionCode.inspect,
        page: 88,
        steps: [
          step(ActionCode.inspect, atKm: 12000, repeatEveryKm: 6000),
        ],
        notes: 'Inspect fuel line at 12,000 km and every 6,000 km thereafter.',
      );

      // 2. Throttle Operation: I at 6k, 12k, 18k, 24k, 30k, 36k (every 6,000 km).
      await add(
        'Throttle Operation',
        RuleType.mileage,
        ActionCode.inspect,
        page: 88,
        steps: [
          step(ActionCode.inspect, atKm: 6000, repeatEveryKm: 6000),
        ],
        notes: 'Refer to page 110. Also part of pre-ride check.',
      );

      // 3. Air Cleaner *2: R at 18k, 36k (repeat every 18,000 km).
      await add(
        'Air Cleaner',
        RuleType.mileage,
        ActionCode.replace,
        page: 88,
        steps: [
          step(ActionCode.replace, atKm: 18000, repeatEveryKm: 18000),
        ],
        notes: 'Note *2: Service more frequently when riding in unusually wet '
            'or dusty areas.',
      );

      // 4. Crankcase Breather *3: C at 6k, 12k, 18k, 24k, 30k (every 6,000 km).
      await add(
        'Crankcase Breather',
        RuleType.mileage,
        ActionCode.clean,
        page: 88,
        steps: [
          step(ActionCode.clean, atKm: 6000, repeatEveryKm: 6000),
        ],
        notes: 'Note *3: Service more frequently when riding in rain or at '
            'full throttle.',
      );

      // 5. Spark Plug: I at 6k, 18k, 30k; R at 12k, 24k, 36k.
      await add(
        'Spark Plug',
        RuleType.mileage,
        ActionCode.inspect,
        page: 88,
        steps: [
          step(ActionCode.inspect, atKm: 6000, repeatEveryKm: 12000),
        ],
        notes: 'Inspect every 12,000 km starting at 6,000 km (6k, 18k, 30k).',
      );
      await add(
        'Spark Plug',
        RuleType.mileage,
        ActionCode.replace,
        page: 88,
        steps: [
          step(ActionCode.replace, atKm: 12000, repeatEveryKm: 12000),
        ],
        notes: 'Replace every 12,000 km (12k, 24k, 36k).',
      );

      // 6. Valve Clearance: I at 6k, 12k, 18k, 24k, 30k (every 6,000 km).
      await add(
        'Valve Clearance',
        RuleType.mileage,
        ActionCode.inspect,
        page: 88,
        steps: [
          step(ActionCode.inspect, atKm: 6000, repeatEveryKm: 6000),
        ],
      );

      // 7. Engine Oil: R at 1k, then 6k, 12k, 18k, 24k, 30k, 36k (every 6,000 km).
      await add(
        'Engine Oil',
        RuleType.mileage,
        ActionCode.replace,
        page: 88,
        steps: [
          step(ActionCode.replace, atKm: 1000),
          step(ActionCode.replace, atKm: 6000, repeatEveryKm: 6000),
        ],
        notes: 'Refer to page 103. Initial replacement at 1,000 km, then every '
            '6,000 km (or annual check).',
      );

      // 8. Engine Oil Strainer Screen: C at 6k, 18k, 30k (every 12,000 km).
      await add(
        'Engine Oil Strainer Screen',
        RuleType.mileage,
        ActionCode.clean,
        page: 88,
        steps: [
          step(ActionCode.clean, atKm: 6000, repeatEveryKm: 12000),
        ],
      );

      // 9. Engine Idle Speed: I at 1k, 6k, 12k, 18k, 24k, 30k, 36k.
      await add(
        'Engine Idle Speed',
        RuleType.mileage,
        ActionCode.inspect,
        page: 88,
        steps: [
          step(ActionCode.inspect, atKm: 1000),
          step(ActionCode.inspect, atKm: 6000, repeatEveryKm: 6000),
        ],
      );

      // 10. Radiator Coolant *4: I at 6k, 18k, 30k, 36k; Regular Replace 3 Years.
      await add(
        'Radiator Coolant',
        RuleType.mileage,
        ActionCode.inspect,
        page: 88,
        steps: [
          step(ActionCode.inspect, atKm: 6000),
          step(ActionCode.inspect, atKm: 18000),
          step(ActionCode.inspect, atKm: 30000),
          step(ActionCode.inspect, atKm: 36000, repeatEveryKm: 12000),
        ],
        notes: 'Refer to page 105.',
      );
      await add(
        'Radiator Coolant',
        RuleType.date,
        ActionCode.replace,
        page: 88,
        intervalMonths: 36,
        notes: 'Regular Replace every 3 Years (36 months). Note *4: '
            'Replacement requires mechanical skill.',
      );

      // 11. Cooling System: I at 6k, 18k, 30k, 36k.
      await add(
        'Cooling System',
        RuleType.mileage,
        ActionCode.inspect,
        page: 88,
        steps: [
          step(ActionCode.inspect, atKm: 6000),
          step(ActionCode.inspect, atKm: 18000),
          step(ActionCode.inspect, atKm: 30000),
          step(ActionCode.inspect, atKm: 36000, repeatEveryKm: 12000),
        ],
      );

      // =======================================================================
      // Owner's Manual Page 89
      // =======================================================================

      // 12. Drive Belt: I at 12k, 36k (every 24,000 km); R at 24k (every 24,000 km).
      await add(
        'Drive Belt',
        RuleType.mileage,
        ActionCode.inspect,
        page: 89,
        steps: [
          step(ActionCode.inspect, atKm: 12000),
          step(ActionCode.inspect, atKm: 36000, repeatEveryKm: 24000),
        ],
        notes: 'Inspect at 12,000 km and 36,000 km (every 24,000 km).',
      );
      await add(
        'Drive Belt',
        RuleType.mileage,
        ActionCode.replace,
        page: 89,
        steps: [
          step(ActionCode.replace, atKm: 24000, repeatEveryKm: 24000),
        ],
        notes: 'Replace every 24,000 km (24k, 48k, ...).',
      );

      // 13. Final Drive Oil *4: Regular Replace every 2 Years (24 months).
      await add(
        'Final Drive Oil',
        RuleType.date,
        ActionCode.replace,
        page: 89,
        intervalMonths: 24,
        notes: 'Regular Replace every 2 Years (24 months). Note *4: '
            'Replacement requires mechanical skill.',
      );

      // 14. Battery: I at 6k, 12k, 18k, 24k, 30k, 36k (every 6,000 km).
      await add(
        'Battery',
        RuleType.mileage,
        ActionCode.inspect,
        page: 89,
        steps: [
          step(ActionCode.inspect, atKm: 6000, repeatEveryKm: 6000),
        ],
        notes: 'Refer to page 100.',
      );

      // 15. Brake Fluid *4: I every 6,000 km; Regular Replace every 2 Years.
      await add(
        'Brake Fluid',
        RuleType.mileage,
        ActionCode.inspect,
        page: 89,
        steps: [
          step(ActionCode.inspect, atKm: 6000, repeatEveryKm: 6000),
        ],
        notes: 'Refer to page 107.',
      );
      await add(
        'Brake Fluid',
        RuleType.date,
        ActionCode.replace,
        page: 89,
        intervalMonths: 24,
        notes: 'Regular Replace every 2 Years (24 months). Note *4: '
            'Replacement requires mechanical skill.',
      );

      // 16. Brake Pads Wear: I at 6k, 12k, 18k, 24k, 30k, 36k (every 6,000 km).
      await add(
        'Brake Pads Wear',
        RuleType.mileage,
        ActionCode.inspect,
        page: 89,
        steps: [
          step(ActionCode.inspect, atKm: 6000, repeatEveryKm: 6000),
        ],
        notes: 'Refer to page 108.',
      );

      // 17. Brake System: I at 1k, 6k, 12k, 18k, 24k, 30k, 36k.
      await add(
        'Brake System',
        RuleType.mileage,
        ActionCode.inspect,
        page: 89,
        steps: [
          step(ActionCode.inspect, atKm: 1000),
          step(ActionCode.inspect, atKm: 6000, repeatEveryKm: 6000),
        ],
        notes: 'Refer to page 107.',
      );

      // 18. Headlight Aim: I at 6k, 12k, 18k, 24k, 30k, 36k (every 6,000 km).
      await add(
        'Headlight Aim',
        RuleType.mileage,
        ActionCode.inspect,
        page: 89,
        steps: [
          step(ActionCode.inspect, atKm: 6000, repeatEveryKm: 6000),
        ],
      );

      // Note: 19. Lights/Horn (page 89) has no odometer/date checkpoints in the
      // maintenance schedule columns; it is a pre-ride inspection item (page 90)
      // and is seeded with pre-ride instructions in InitialSeed.

      // 20. Clutch Shoes Wear: I at 12k, 24k, 36k (every 12,000 km).
      await add(
        'Clutch Shoes Wear',
        RuleType.mileage,
        ActionCode.inspect,
        page: 89,
        steps: [
          step(ActionCode.inspect, atKm: 12000, repeatEveryKm: 12000),
        ],
      );

      // 21. Side Stand: I at 6k, 12k, 18k, 24k, 30k, 36k (every 6,000 km).
      await add(
        'Side Stand',
        RuleType.mileage,
        ActionCode.inspect,
        page: 89,
        steps: [
          step(ActionCode.inspect, atKm: 6000, repeatEveryKm: 6000),
        ],
        notes: 'Refer to page 109.',
      );

      // 22. Suspension: I at 6k, 12k, 18k, 24k, 30k, 36k (every 6,000 km).
      await add(
        'Suspension',
        RuleType.mileage,
        ActionCode.inspect,
        page: 89,
        steps: [
          step(ActionCode.inspect, atKm: 6000, repeatEveryKm: 6000),
        ],
      );

      // 23. Nuts, Bolts, Fasteners: I at 1k, 12k, 24k, 36k.
      await add(
        'Nuts, Bolts, Fasteners',
        RuleType.mileage,
        ActionCode.inspect,
        page: 89,
        steps: [
          step(ActionCode.inspect, atKm: 1000),
          step(ActionCode.inspect, atKm: 12000, repeatEveryKm: 12000),
        ],
      );

      // 24. Wheels/Tyres: I at 6k, 12k, 18k, 24k, 30k, 36k (every 6,000 km).
      await add(
        'Wheels/Tyres',
        RuleType.mileage,
        ActionCode.inspect,
        page: 89,
        steps: [
          step(ActionCode.inspect, atKm: 6000, repeatEveryKm: 6000),
        ],
        notes: 'Refer to page 96.',
      );

      // 25. Steering Head Bearings: I at 12k, 24k, 36k (every 12,000 km).
      await add(
        'Steering Head Bearings',
        RuleType.mileage,
        ActionCode.inspect,
        page: 89,
        steps: [
          step(ActionCode.inspect, atKm: 12000, repeatEveryKm: 12000),
        ],
      );
    });
  }
}
