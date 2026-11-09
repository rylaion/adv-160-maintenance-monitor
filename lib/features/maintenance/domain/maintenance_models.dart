import '../../../core/enums/enums.dart';

/// One explicit checkpoint definition of a rule (maps to maintenance_rule_steps).
///
/// A step produces a first checkpoint at [atKm] / [atMonths]; if a repeat is
/// given it produces further checkpoints every [repeatEveryKm] /
/// [repeatEveryMonths]. Months are counted from the baseline date.
class RuleStepDef {
  const RuleStepDef({
    required this.actionCode,
    this.atKm,
    this.atMonths,
    this.repeatEveryKm,
    this.repeatEveryMonths,
  });

  final ActionCode actionCode;
  final int? atKm;
  final int? atMonths;
  final int? repeatEveryKm;
  final int? repeatEveryMonths;
}

/// A maintenance rule (maintenance_rules + its steps).
class RuleDef {
  const RuleDef({
    required this.id,
    required this.itemId,
    required this.ruleType,
    required this.actionCode,
    required this.source,
    this.sourceDocument,
    this.sourcePage,
    this.intervalKm,
    this.intervalMonths,
    this.isVerified = false,
    this.isActive = true,
    this.notes,
    this.steps = const [],
  });

  final int id;
  final int itemId;
  final RuleType ruleType;
  final ActionCode actionCode;
  final MaintenanceSource source;
  final String? sourceDocument;
  final int? sourcePage;

  /// Simple recurring interval, measured from the last matching service.
  /// Ignored when [steps] is non-empty.
  final int? intervalKm;
  final int? intervalMonths;
  final bool isVerified;
  final bool isActive;
  final String? notes;
  final List<RuleStepDef> steps;

  bool get isManufacturer => source != MaintenanceSource.custom;
}

/// A completed, non-voided service used as calculation input.
class ServiceEvent {
  const ServiceEvent({
    required this.date,
    required this.odometerKm,
    required this.action,
  });

  /// Date-only (UTC midnight).
  final DateTime date;
  final int odometerKm;
  final MaintenanceAction action;
}

/// Thresholds that turn "remaining" into a status. These are app notification
/// policy (configurable in Settings), NOT Honda specifications.
///
/// Default warning distance is 500 km (`upcomingKm = 500`) and exact checkpoint
/// reached is `dueKm = 0`.
class MaintenanceThresholds {
  const MaintenanceThresholds({
    this.dueKm = 0,
    this.dueDays = 7,
    this.upcomingKm = 500,
    this.upcomingDays = 30,
  });

  /// Remaining at or below this (but not past due) => DUE.
  final int dueKm;
  final int dueDays;

  /// Remaining at or below this => UPCOMING.
  final int upcomingKm;
  final int upcomingDays;
}

/// Externally supplied condition result for condition-based rules. The
/// calculator never derives wear limits itself; callers pass a flag only when a
/// verified threshold has been breached.
enum ConditionFlag { none, inspectionRequired, replacementRequired }

/// A single scheduled occurrence of an action.
class Checkpoint {
  const Checkpoint({
    required this.actionCode,
    this.dueKm,
    this.dueDate,
    required this.sequence,
  });

  final ActionCode actionCode;
  final int? dueKm;
  final DateTime? dueDate;

  /// Position within the rule's generated series.
  final int sequence;
}

/// Computed evaluation of a single scheduled checkpoint (e.g. Fuel Line Inspect
/// at 12,000 km).
class CheckpointEvaluation {
  const CheckpointEvaluation({
    required this.rule,
    required this.checkpoint,
    required this.status,
    this.remainingKm,
    this.remainingDays,
    this.completedBy,
  });

  final RuleDef rule;
  final Checkpoint checkpoint;
  final MaintenanceStatus status;
  final int? remainingKm;
  final int? remainingDays;
  final ServiceEvent? completedBy;

  bool get isCompleted => status == MaintenanceStatus.completed;
}

/// Result of evaluating one rule.
class RuleEvaluation {
  const RuleEvaluation({
    required this.rule,
    required this.status,
    this.next,
    this.remainingKm,
    this.remainingDays,
    this.missedCount = 0,
    this.lastService,
    this.skippedBeforeTracking = 0,
    this.missingBaseline = false,
    this.checkpoints = const [],
  });

  final RuleDef rule;
  final MaintenanceStatus status;

  /// Most urgent unsatisfied checkpoint; null when the schedule is complete.
  final Checkpoint? next;
  final int? remainingKm;
  final int? remainingDays;

  /// Unsatisfied checkpoints that are already past due.
  final int missedCount;

  /// Latest service that satisfies this rule's action.
  final ServiceEvent? lastService;

  /// Checkpoints before the first tracked odometer reading that were ignored.
  final int skippedBeforeTracking;

  /// A date limit could not be computed because no baseline date exists.
  final bool missingBaseline;

  /// Individual checkpoint evaluations for the Odometer-Based Inspection Guide.
  final List<CheckpointEvaluation> checkpoints;

  /// Any checkpoint at or above the current odometer that is UPCOMING, even if
  /// an earlier checkpoint was skipped and remains OVERDUE.
  CheckpointEvaluation? get upcomingCheckpoint => checkpoints
      .where((c) => c.status == MaintenanceStatus.upcoming)
      .firstOrNull;

  /// Most recently completed checkpoint for this rule.
  CheckpointEvaluation? get lastCompletedCheckpoint => checkpoints
      .where((c) => c.status == MaintenanceStatus.completed)
      .lastOrNull;
}

/// Combined result for one maintenance item.
class ItemEvaluation {
  const ItemEvaluation({
    required this.itemId,
    required this.hasSchedule,
    required this.status,
    this.next,
    this.ruleEvaluations = const [],
    this.lastService,
    this.needsBaseline = false,
    this.skippedBeforeTracking = 0,
  });

  final int itemId;

  /// False when no rule could be evaluated (no rules, or baseline missing).
  final bool hasSchedule;
  final MaintenanceStatus status;

  /// The most urgent rule evaluation (drives "next scheduled maintenance").
  final RuleEvaluation? next;
  final List<RuleEvaluation> ruleEvaluations;

  /// Latest service of any action.
  final ServiceEvent? lastService;
  final bool needsBaseline;
  final int skippedBeforeTracking;

  /// All scheduled checkpoints across all active rules of this item, ordered by
  /// mileage / date.
  List<CheckpointEvaluation> get checkpoints {
    final list = [
      for (final r in ruleEvaluations) ...r.checkpoints,
    ];
    list.sort((a, b) {
      final k = (a.checkpoint.dueKm ?? 1 << 30)
          .compareTo(b.checkpoint.dueKm ?? 1 << 30);
      if (k != 0) return k;
      return a.checkpoint.sequence.compareTo(b.checkpoint.sequence);
    });
    return list;
  }

  /// True when a maintenance record confirms that a scheduled task for this
  /// item was completed.
  bool get hasCompletedRecord => lastService != null;
}
