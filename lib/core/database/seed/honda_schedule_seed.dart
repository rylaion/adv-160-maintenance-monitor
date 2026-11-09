import 'package:drift/drift.dart';

import '../../enums/enums.dart';
import '../app_database.dart';

/// Honda manual schedule configuration CANDIDATES for the ADV160.
///
/// Source: Honda ADV160 2023 Owner's Manual, document 32K0WA100.
///
/// IMPORTANT: every rule below is seeded with `is_verified = false` and no page
/// number. The entries come from the project specification's "configuration
/// candidates"; they have NOT been checked against the official manual. Page
/// numbers must be filled in and `is_verified` set to true after verification.
///
/// Not seeded (no interval was supplied or verified, so none is invented):
/// fuel line, brake pads, battery and tire inspections, brake fluid and
/// coolant inspections, and any fuel filter interval (custom rules only).
class HondaScheduleSeed {
  HondaScheduleSeed(this.db);
  final AppDatabase db;

  static const String sourceDocument =
      'Honda ADV160 2023 Owner\'s Manual (32K0WA100)';

  static const String _unverifiedNote =
      'UNVERIFIED candidate from project specification; confirm against the '
      'official manual and record the page number.';

  /// Idempotent: does nothing if Honda manual rules already exist.
  Future<void> run() async {
    await db.transaction(() async {
      final existing = await (db.select(db.maintenanceRules)
            ..where((r) => r.source.equals(MaintenanceSource.hondaManual.code))
            ..limit(1))
          .get();
      if (existing.isNotEmpty) return;

      final bike = await (db.select(db.motorcycles)
            ..orderBy([(t) => OrderingTerm.asc(t.id)])
            ..limit(1))
          .getSingleOrNull();
      if (bike == null) return;

      final items = {
        for (final i in await db.select(db.maintenanceItems).get())
          i.name: i.id,
      };

      Future<void> add(
        String item,
        RuleType type,
        ActionCode action, {
        int? intervalMonths,
        List<MaintenanceRuleStepsCompanion Function(int ruleId, int order)>
            steps = const [],
        String? extraNote,
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
              intervalMonths: Value(intervalMonths),
              isVerified: const Value(false),
              notes: Value(extraNote == null
                  ? _unverifiedNote
                  : '$_unverifiedNote $extraNote'),
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

      // Engine oil: initial 1,000 km, then 6,000 km checkpoints (6,000, 12,000, ...).
      await add(
        'Engine Oil',
        RuleType.mileage,
        ActionCode.replace,
        steps: [
          step(ActionCode.replace, atKm: 1000),
          step(ActionCode.replace, atKm: 6000, repeatEveryKm: 6000),
        ],
        extraNote: 'Checkpoint pattern 1,000 then every 6,000 km is assumed '
            'to be absolute odometer values.',
      );

      // CVT drive belt: inspect 18,000 and 36,000; replace 30,000.
      await add(
        'CVT Drive Belt',
        RuleType.mileage,
        ActionCode.inspect,
        steps: [
          step(ActionCode.inspect, atKm: 18000),
          step(ActionCode.inspect, atKm: 36000),
        ],
      );
      await add(
        'CVT Drive Belt',
        RuleType.mileage,
        ActionCode.replace,
        steps: [step(ActionCode.replace, atKm: 30000)],
      );

      // Date-based replacements.
      await add('Brake Fluid', RuleType.date, ActionCode.replace,
          intervalMonths: 24);
      await add('Coolant', RuleType.date, ActionCode.replace,
          intervalMonths: 36);
      await add('Final Drive Oil', RuleType.date, ActionCode.replace,
          intervalMonths: 24);
    });
  }
}
