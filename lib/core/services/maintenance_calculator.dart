import '../enums/enums.dart';
import '../../features/maintenance/domain/maintenance_models.dart';
import '../utils/date_utils.dart';

/// Pure maintenance rule engine (no Flutter, no database).
///
/// Supports mileage, date, combined (either limit triggers), condition (via
/// an externally supplied [ConditionFlag]) and custom interval rules.
///
/// Key behaviours:
/// * Manufacturer checkpoints are generated from the rule and are never
///   modified by what the user does. Overdue work leaves the schedule intact;
///   it is simply reported as overdue until a satisfying service is recorded.
/// * A service satisfies a checkpoint when its action is compatible with the
///   checkpoint's action code and it was done at or after
///   `dueKm - earlyToleranceKm` (or `dueDate - earlyToleranceDays`), which
///   supports completing maintenance earlier than scheduled. Services done
///   after a checkpoint also satisfy every earlier checkpoint.
/// * Simple interval rules (custom/date) count from the last matching service,
///   or from the baseline if none exists.
/// * Checkpoints below the first tracked odometer reading ([baselineKm]) are
///   not counted as missed; they are reported as `skippedBeforeTracking`.
///
/// Thresholds and tolerances are app policy, not Honda specifications.
class MaintenanceCalculator {
  const MaintenanceCalculator({
    this.thresholds = const MaintenanceThresholds(),
    this.earlyToleranceKm = 1000,
    this.earlyToleranceDays = 30,
  });

  final MaintenanceThresholds thresholds;
  final int earlyToleranceKm;
  final int earlyToleranceDays;

  /// Evaluates every active rule of one item and combines the results.
  ItemEvaluation evaluateItem({
    required int itemId,
    required List<RuleDef> rules,
    required List<ServiceEvent> events,
    required int currentKm,
    required DateTime today,
    int? baselineKm,
    DateTime? baselineDate,
    ConditionFlag condition = ConditionFlag.none,
  }) {
    final results = <RuleEvaluation>[];
    for (final rule in rules) {
      final r = evaluateRule(
        rule: rule,
        events: events,
        currentKm: currentKm,
        today: today,
        baselineKm: baselineKm,
        baselineDate: baselineDate,
      );
      if (r != null) results.add(r);
    }

    final last = _latest(events);
    final computable =
        results.where((r) => !(r.next == null && r.missingBaseline)).toList();
    final needsBaseline = results.any((r) => r.missingBaseline);
    final skipped = results.fold<int>(0, (a, r) => a + r.skippedBeforeTracking);

    var status = MaintenanceStatus.good;
    RuleEvaluation? next;
    for (final r in computable) {
      if (next == null || _isMoreUrgent(r, next)) next = r;
      if (r.status.severity > status.severity) status = r.status;
    }

    var hasSchedule = computable.isNotEmpty;
    final flagged = switch (condition) {
      ConditionFlag.none => null,
      ConditionFlag.inspectionRequired => MaintenanceStatus.inspectionRequired,
      ConditionFlag.replacementRequired =>
        MaintenanceStatus.replacementRequired,
    };
    if (flagged != null) {
      hasSchedule = true;
      if (flagged.severity > status.severity) status = flagged;
    }

    return ItemEvaluation(
      itemId: itemId,
      hasSchedule: hasSchedule,
      status: status,
      next: next,
      ruleEvaluations: results,
      lastService: last,
      needsBaseline: needsBaseline,
      skippedBeforeTracking: skipped,
    );
  }

  /// Evaluates one rule. Returns null for inactive or condition-based rules
  /// (condition rules are driven by [ConditionFlag], never by invented limits)
  /// and for rules with no usable interval.
  RuleEvaluation? evaluateRule({
    required RuleDef rule,
    required List<ServiceEvent> events,
    required int currentKm,
    required DateTime today,
    int? baselineKm,
    DateTime? baselineDate,
  }) {
    if (!rule.isActive || rule.ruleType == RuleType.condition) return null;
    final day = AppDates.dateOnly(today);
    final base = baselineDate == null ? null : AppDates.dateOnly(baselineDate);

    if (rule.steps.isNotEmpty) {
      return _evaluateSteps(rule, events, currentKm, day, baselineKm, base);
    }
    if (rule.intervalKm == null && rule.intervalMonths == null) return null;
    return _evaluateInterval(rule, events, currentKm, day, baselineKm, base);
  }

  // ---------------------------------------------------------------- steps

  RuleEvaluation _evaluateSteps(
    RuleDef rule,
    List<ServiceEvent> events,
    int currentKm,
    DateTime today,
    int? baselineKm,
    DateTime? baselineDate,
  ) {
    var limKm = currentKm;
    var limDate = today;
    for (final e in events) {
      if (e.odometerKm > limKm) limKm = e.odometerKm;
      if (e.date.isAfter(limDate)) limDate = e.date;
    }

    var missingBaseline = false;
    var skipped = 0;
    final open = <_Open>[];
    var anyCheckpoint = false;

    for (final cp in _generate(rule, limKm, limDate, baselineDate, () {
      missingBaseline = true;
    }, (c) => _isSatisfied(c, events))) {
      anyCheckpoint = true;
      if (_isSatisfied(cp, events)) continue;
      if (_predatesTracking(cp, baselineKm, baselineDate)) {
        skipped++;
        continue;
      }
      open.add(_Open(cp, _remainingKm(cp.dueKm, currentKm),
          _remainingDays(cp.dueDate, today)));
    }

    final lastService = _latest(
        events.where((e) => rule.actionCode.isSatisfiedBy(e.action)).toList());

    if (open.isEmpty) {
      return RuleEvaluation(
        rule: rule,
        status: MaintenanceStatus.good,
        lastService: lastService,
        skippedBeforeTracking: skipped,
        missingBaseline: missingBaseline && !anyCheckpoint,
      );
    }

    _Open? best;
    var missed = 0;
    for (final o in open) {
      final s = _statusFor(o.remKm, o.remDays);
      if (s == MaintenanceStatus.overdue) missed++;
      if (best == null || _openMoreUrgent(o, s, best)) {
        best = o;
        best.status = s;
      } else {
        o.status = s;
      }
    }
    return RuleEvaluation(
      rule: rule,
      status: best!.status ?? _statusFor(best.remKm, best.remDays),
      next: best.checkpoint,
      remainingKm: best.remKm,
      remainingDays: best.remDays,
      missedCount: missed,
      lastService: lastService,
      skippedBeforeTracking: skipped,
      missingBaseline: missingBaseline,
    );
  }

  Iterable<Checkpoint> _generate(
    RuleDef rule,
    int limKm,
    DateTime limDate,
    DateTime? baselineDate,
    void Function() onMissingBaseline,
    bool Function(Checkpoint) isSatisfied,
  ) sync* {
    var seq = 0;
    for (final step in rule.steps) {
      for (var n = 0; n < 1000; n++) {
        final repeats =
            step.repeatEveryKm != null || step.repeatEveryMonths != null;

        int? km;
        if (step.atKm != null) {
          if (n == 0) {
            km = step.atKm;
          } else if (step.repeatEveryKm != null) {
            km = step.atKm! + n * step.repeatEveryKm!;
          }
        }

        DateTime? date;
        if (step.atMonths != null) {
          if (baselineDate == null) {
            if (n == 0) onMissingBaseline();
          } else if (n == 0) {
            date = AppDates.addMonths(baselineDate, step.atMonths!);
          } else if (step.repeatEveryMonths != null) {
            date = AppDates.addMonths(
                baselineDate, step.atMonths! + n * step.repeatEveryMonths!);
          }
        }

        if (km == null && date == null) break;
        final cp = Checkpoint(
            actionCode: step.actionCode,
            dueKm: km,
            dueDate: date,
            sequence: seq++);
        yield cp;

        if (!repeats) break;
        final kmDone = km == null || km > limKm;
        final dateDone = date == null || date.isAfter(limDate);
        // Keep going past the horizon while checkpoints are already satisfied
        // (e.g. by an early service), so the next open one is always found.
        if (kmDone && dateDone && !isSatisfied(cp)) break;
      }
    }
  }

  bool _isSatisfied(Checkpoint cp, List<ServiceEvent> events) {
    for (final e in events) {
      if (!cp.actionCode.isSatisfiedBy(e.action)) continue;
      if (cp.dueKm != null && e.odometerKm >= cp.dueKm! - earlyToleranceKm) {
        return true;
      }
      if (cp.dueDate != null &&
          !e.date.isBefore(
              cp.dueDate!.subtract(Duration(days: earlyToleranceDays)))) {
        return true;
      }
    }
    return false;
  }

  bool _predatesTracking(
      Checkpoint cp, int? baselineKm, DateTime? baselineDate) {
    final kmBefore =
        cp.dueKm != null && baselineKm != null && cp.dueKm! < baselineKm;
    if (cp.dueDate == null) return kmBefore;
    final dateBefore =
        baselineDate != null && cp.dueDate!.isBefore(baselineDate);
    if (cp.dueKm == null) return dateBefore;
    return kmBefore && dateBefore;
  }

  // ------------------------------------------------------------- interval

  RuleEvaluation _evaluateInterval(
    RuleDef rule,
    List<ServiceEvent> events,
    int currentKm,
    DateTime today,
    int? baselineKm,
    DateTime? baselineDate,
  ) {
    final last = _latest(
        events.where((e) => rule.actionCode.isSatisfiedBy(e.action)).toList());
    final fromKm = last?.odometerKm ?? baselineKm ?? 0;
    final fromDate = last?.date ?? baselineDate;

    final dueKm = rule.intervalKm == null ? null : fromKm + rule.intervalKm!;
    DateTime? dueDate;
    var missingBaseline = false;
    if (rule.intervalMonths != null) {
      if (fromDate == null) {
        missingBaseline = true;
      } else {
        dueDate = AppDates.addMonths(fromDate, rule.intervalMonths!);
      }
    }

    if (dueKm == null && dueDate == null) {
      return RuleEvaluation(
        rule: rule,
        status: MaintenanceStatus.good,
        lastService: last,
        missingBaseline: true,
      );
    }

    final remKm = _remainingKm(dueKm, currentKm);
    final remDays = _remainingDays(dueDate, today);
    return RuleEvaluation(
      rule: rule,
      status: _statusFor(remKm, remDays),
      next: Checkpoint(
          actionCode: rule.actionCode,
          dueKm: dueKm,
          dueDate: dueDate,
          sequence: 0),
      remainingKm: remKm,
      remainingDays: remDays,
      missedCount:
          _statusFor(remKm, remDays) == MaintenanceStatus.overdue ? 1 : 0,
      lastService: last,
      missingBaseline: missingBaseline,
    );
  }

  // --------------------------------------------------------------- shared

  /// Next due mileage minus the current odometer (negative = past due).
  static int? _remainingKm(int? dueKm, int currentKm) =>
      dueKm == null ? null : dueKm - currentKm;

  /// Days from [today] to the due date (negative = past due).
  static int? _remainingDays(DateTime? due, DateTime today) =>
      due == null ? null : AppDates.daysBetween(today, due);

  /// Either limit triggers: the worst of the km and day states wins.
  MaintenanceStatus _statusFor(int? remKm, int? remDays) {
    if ((remKm != null && remKm < 0) || (remDays != null && remDays < 0)) {
      return MaintenanceStatus.overdue;
    }
    if ((remKm != null && remKm <= thresholds.dueKm) ||
        (remDays != null && remDays <= thresholds.dueDays)) {
      return MaintenanceStatus.due;
    }
    if ((remKm != null && remKm <= thresholds.upcomingKm) ||
        (remDays != null && remDays <= thresholds.upcomingDays)) {
      return MaintenanceStatus.upcoming;
    }
    return MaintenanceStatus.good;
  }

  bool _openMoreUrgent(_Open o, MaintenanceStatus s, _Open best) {
    final bs = best.status ?? _statusFor(best.remKm, best.remDays);
    if (s.severity != bs.severity) return s.severity > bs.severity;
    return _compareRemaining(o.remKm, o.remDays, best.remKm, best.remDays) < 0;
  }

  bool _isMoreUrgent(RuleEvaluation a, RuleEvaluation b) {
    if (a.status.severity != b.status.severity) {
      return a.status.severity > b.status.severity;
    }
    return _compareRemaining(
            a.remainingKm, a.remainingDays, b.remainingKm, b.remainingDays) <
        0;
  }

  static int _compareRemaining(int? aKm, int? aDays, int? bKm, int? bDays) {
    const big = 1 << 30;
    final km = (aKm ?? big).compareTo(bKm ?? big);
    if (km != 0) return km;
    return (aDays ?? big).compareTo(bDays ?? big);
  }

  static ServiceEvent? _latest(List<ServiceEvent> events) {
    ServiceEvent? best;
    for (final e in events) {
      if (best == null ||
          e.date.isAfter(best.date) ||
          (e.date == best.date && e.odometerKm > best.odometerKm)) {
        best = e;
      }
    }
    return best;
  }
}

class _Open {
  _Open(this.checkpoint, this.remKm, this.remDays);
  final Checkpoint checkpoint;
  final int? remKm;
  final int? remDays;
  MaintenanceStatus? status;
}
