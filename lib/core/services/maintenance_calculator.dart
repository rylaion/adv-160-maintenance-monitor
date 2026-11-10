import '../../features/maintenance/domain/maintenance_models.dart';
import '../enums/enums.dart';
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
///   supports completing maintenance earlier than scheduled.
/// * Simple interval rules (custom/date) count from the last matching service,
///   or from the baseline if none exists.
/// * Manufacturer checkpoints are never marked completed or skipped merely
///   because the odometer was updated; if a checkpoint was skipped, it remains
///   OVERDUE until the user records completion (unless [skipBeforeBaseline] is
///   explicitly enabled by a caller).
///
/// Thresholds and tolerances are app policy, not Honda specifications.
class MaintenanceCalculator {
  const MaintenanceCalculator({
    this.thresholds = const MaintenanceThresholds(),
    this.earlyToleranceKm = 1000,
    this.earlyToleranceDays = 30,
    this.skipBeforeBaseline = false,
  });

  final MaintenanceThresholds thresholds;
  final int earlyToleranceKm;
  final int earlyToleranceDays;
  final bool skipBeforeBaseline;

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

    // If the user has configured active custom interval rule(s) on this item,
    // use those custom rules to drive the item's primary next due checkpoint
    // and status while keeping all rules (Honda + Custom) in ruleEvaluations.
    final customComputable =
        computable.where((r) => !r.rule.isManufacturer).toList();
    final effectiveComputable =
        customComputable.isNotEmpty ? customComputable : computable;

    var status = MaintenanceStatus.good;
    RuleEvaluation? next;
    for (final r in effectiveComputable) {
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
    final horizonKm = limKm + thresholds.upcomingKm > 36000
        ? limKm + thresholds.upcomingKm
        : 36000;

    var missingBaseline = false;
    var skipped = 0;
    final open = <_Open>[];
    final generated = <Checkpoint>[];

    for (final cp
        in _generate(rule, limKm, horizonKm, limDate, baselineDate, () {
      missingBaseline = true;
    }, (c) => _isSatisfied(c, events))) {
      generated.add(cp);
    }

    generated.sort((a, b) {
      final k = (a.dueKm ?? 1 << 30).compareTo(b.dueKm ?? 1 << 30);
      if (k != 0) return k;
      return a.sequence.compareTo(b.sequence);
    });

    final checkpointEvals = <CheckpointEvaluation>[];
    for (var i = 0; i < generated.length; i++) {
      final cp = generated[i];
      final nextCpKm =
          (i + 1 < generated.length) ? generated[i + 1].dueKm : null;
      final remKm = _remainingKm(cp.dueKm, currentKm);
      final remDays = _remainingDays(cp.dueDate, today);
      final completedBy = _satisfyingEventForWindow(cp, nextCpKm, events);

      if (completedBy != null) {
        checkpointEvals.add(CheckpointEvaluation(
          rule: rule,
          checkpoint: cp,
          status: MaintenanceStatus.completed,
          remainingKm: remKm,
          remainingDays: remDays,
          completedBy: completedBy,
        ));
      } else {
        checkpointEvals.add(CheckpointEvaluation(
          rule: rule,
          checkpoint: cp,
          status: _statusFor(remKm, remDays),
          remainingKm: remKm,
          remainingDays: remDays,
        ));
      }

      if (_isSatisfied(cp, events)) continue;
      if (skipBeforeBaseline &&
          _predatesTracking(cp, baselineKm, baselineDate)) {
        skipped++;
        continue;
      }
      open.add(_Open(cp, remKm, remDays));
    }

    final lastService = _latest(
        events.where((e) => rule.actionCode.isSatisfiedBy(e.action)).toList());

    if (open.isEmpty) {
      return RuleEvaluation(
        rule: rule,
        status: MaintenanceStatus.good,
        lastService: lastService,
        skippedBeforeTracking: skipped,
        missingBaseline: missingBaseline && generated.isEmpty,
        checkpoints: checkpointEvals,
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
      checkpoints: checkpointEvals,
    );
  }

  Iterable<Checkpoint> _generate(
    RuleDef rule,
    int limKm,
    int horizonKm,
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
        final kmDone = km == null || (km > limKm && km >= horizonKm);
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

  /// Finds the specific service event that completed [cp] within its checkpoint
  /// window (before the next checkpoint's window).
  ServiceEvent? _satisfyingEventForWindow(
    Checkpoint cp,
    int? nextDueKm,
    List<ServiceEvent> events,
  ) {
    ServiceEvent? match;
    for (final e in events) {
      if (!cp.actionCode.isSatisfiedBy(e.action)) continue;
      if (cp.dueKm != null) {
        final minKm = cp.dueKm! - earlyToleranceKm;
        final maxKm = nextDueKm == null ? null : nextDueKm - earlyToleranceKm;
        if (e.odometerKm >= minKm && (maxKm == null || e.odometerKm < maxKm)) {
          if (match == null || e.odometerKm >= match.odometerKm) {
            match = e;
          }
        }
      } else if (cp.dueDate != null) {
        if (!e.date.isBefore(
            cp.dueDate!.subtract(Duration(days: earlyToleranceDays)))) {
          match = e;
        }
      }
    }
    return match;
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
    final matchingEvents = events
        .where((e) =>
            rule.actionCode.isSatisfiedBy(e.action) || !rule.isManufacturer)
        .toList();
    final latestEvent = _latest(matchingEvents);

    // If the rule has an explicit lastCompletedKm baseline (for custom rules)
    // and either no service event exists or the baseline is newer, use it so
    // the next due calculation is always anchored to the last completed service
    // and never to the current odometer reading.
    ServiceEvent? last = latestEvent;
    if (rule.lastCompletedKm != null &&
        (last == null || rule.lastCompletedKm! > last.odometerKm)) {
      last = ServiceEvent(
        date: rule.lastCompletedDate ?? today,
        odometerKm: rule.lastCompletedKm!,
        action: rule.actionCode.defaultMaintenanceAction,
      );
    }

    final fromKm = last?.odometerKm ?? rule.lastCompletedKm ?? 0;
    final fromDate = last?.date ?? rule.lastCompletedDate ?? baselineDate;

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
    final nextCp = Checkpoint(
        actionCode: rule.actionCode,
        dueKm: dueKm,
        dueDate: dueDate,
        sequence: 0);

    final effectiveUpcomingKm = rule.warningKm ??
        (!rule.isManufacturer && rule.intervalKm != null
            ? (rule.intervalKm! * 0.25)
                .round()
                .clamp(thresholds.upcomingKm, 5000)
            : thresholds.upcomingKm);
    final effectiveUpcomingDays = rule.warningDays ?? thresholds.upcomingDays;

    final status = _statusFor(
      remKm,
      remDays,
      upcomingKm: effectiveUpcomingKm,
      upcomingDays: effectiveUpcomingDays,
    );
    return RuleEvaluation(
      rule: rule,
      status: status,
      next: nextCp,
      remainingKm: remKm,
      remainingDays: remDays,
      missedCount: status == MaintenanceStatus.overdue ? 1 : 0,
      lastService: last,
      missingBaseline: missingBaseline,
      checkpoints: [
        if (last != null)
          CheckpointEvaluation(
            rule: rule,
            checkpoint: Checkpoint(
              actionCode: rule.actionCode,
              dueKm: last.odometerKm,
              dueDate: last.date,
              sequence: 0,
            ),
            status: MaintenanceStatus.completed,
            completedBy: last,
          ),
        CheckpointEvaluation(
          rule: rule,
          checkpoint: nextCp,
          status: status,
          remainingKm: remKm,
          remainingDays: remDays,
        ),
      ],
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
  MaintenanceStatus _statusFor(
    int? remKm,
    int? remDays, {
    int? upcomingKm,
    int? upcomingDays,
  }) {
    final upKm = upcomingKm ?? thresholds.upcomingKm;
    final upDays = upcomingDays ?? thresholds.upcomingDays;
    if ((remKm != null && remKm < 0) || (remDays != null && remDays < 0)) {
      return MaintenanceStatus.overdue;
    }
    if ((remKm != null && remKm <= thresholds.dueKm) ||
        (remDays != null && remDays <= thresholds.dueDays)) {
      return MaintenanceStatus.due;
    }
    if ((remKm != null && remKm <= upKm) ||
        (remDays != null && remDays <= upDays)) {
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
