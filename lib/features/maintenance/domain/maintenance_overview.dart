import '../../../core/enums/enums.dart';
import '../../../core/services/maintenance_calculator.dart';
import 'maintenance_models.dart';
import 'maintenance_snapshot.dart';

/// An item together with its category and computed evaluation.
class ItemStatus {
  const ItemStatus({
    required this.item,
    required this.category,
    required this.evaluation,
  });
  final ItemInfo item;
  final CategoryInfo category;
  final ItemEvaluation evaluation;
}

/// One scheduled maintenance checkpoint task in the Odometer-Based Maintenance
/// Inspection Guide (e.g. Fuel Line Inspect at 12,000 km).
class ScheduledTaskStatus {
  const ScheduledTaskStatus({
    required this.item,
    required this.category,
    required this.evaluation,
  });

  final ItemInfo item;
  final CategoryInfo category;
  final CheckpointEvaluation evaluation;

  int? get dueKm => evaluation.checkpoint.dueKm;
  DateTime? get dueDate => evaluation.checkpoint.dueDate;
  ActionCode get actionCode => evaluation.checkpoint.actionCode;
  MaintenanceStatus get status => evaluation.status;
  int? get remainingKm => evaluation.remainingKm;
  int? get remainingDays => evaluation.remainingDays;
  ServiceEvent? get completedBy => evaluation.completedBy;
  bool get isCompleted => evaluation.isCompleted;
}

/// Everything the dashboard, inspection guide, and maintenance tab display,
/// derived purely from stored data and the calculation engine (no hardcoded
/// values).
class MaintenanceOverview {
  const MaintenanceOverview({
    required this.snapshot,
    required this.today,
    required this.items,
  });

  final MaintenanceSnapshot snapshot;
  final DateTime today;
  final List<ItemStatus> items;

  int? get currentKm => snapshot.currentKm;

  /// Distance since the first tracked odometer reading.
  int? get trackedKm =>
      (snapshot.currentKm == null || snapshot.baselineKm == null)
          ? null
          : snapshot.currentKm! - snapshot.baselineKm!;

  Iterable<ItemStatus> get scheduled =>
      items.where((i) => i.evaluation.hasSchedule);
  Iterable<ItemStatus> get unscheduled =>
      items.where((i) => !i.evaluation.hasSchedule);

  /// Scheduled items currently OVERDUE (or flagged REPLACEMENT_REQUIRED).
  List<ItemStatus> get overdue => _sorted(scheduled.where((i) =>
      i.evaluation.status == MaintenanceStatus.overdue ||
      i.evaluation.status == MaintenanceStatus.replacementRequired ||
      i.evaluation.checkpoints
          .any((c) => c.status == MaintenanceStatus.overdue)));

  /// Scheduled items currently DUE (or flagged INSPECTION_REQUIRED).
  List<ItemStatus> get due => _sorted(scheduled.where((i) =>
      i.evaluation.status == MaintenanceStatus.due ||
      i.evaluation.status == MaintenanceStatus.inspectionRequired ||
      i.evaluation.checkpoints.any((c) => c.status == MaintenanceStatus.due)));

  /// Scheduled items approaching a checkpoint within the warning distance.
  /// Includes items whose next checkpoint is UPCOMING as well as items that
  /// have an UPCOMING checkpoint at the next milestone even if an earlier
  /// checkpoint was skipped.
  List<ItemStatus> get upcoming => _sorted(scheduled.where((i) =>
      i.evaluation.status == MaintenanceStatus.upcoming ||
      i.evaluation.checkpoints
          .any((c) => c.status == MaintenanceStatus.upcoming)));

  /// Combined Due + Upcoming list for compatibility.
  List<ItemStatus> get dueSoon => _sorted(scheduled.where((i) =>
      i.evaluation.status == MaintenanceStatus.due ||
      i.evaluation.status == MaintenanceStatus.upcoming ||
      i.evaluation.status == MaintenanceStatus.inspectionRequired));

  /// Items that have at least one completed maintenance record.
  List<ItemStatus> get completedItems =>
      items.where((i) => i.evaluation.lastService != null).toList();

  /// All checkpoint-level tasks across all scheduled items.
  List<ScheduledTaskStatus> get allCheckpointTasks {
    final out = <ScheduledTaskStatus>[];
    for (final itemStatus in items) {
      for (final cpEval in itemStatus.evaluation.checkpoints) {
        out.add(ScheduledTaskStatus(
          item: itemStatus.item,
          category: itemStatus.category,
          evaluation: cpEval,
        ));
      }
    }
    out.sort((a, b) {
      final k = (a.dueKm ?? 1 << 30).compareTo(b.dueKm ?? 1 << 30);
      if (k != 0) return k;
      return a.item.id.compareTo(b.item.id);
    });
    return out;
  }

  /// Overdue checkpoint tasks in the Odometer-Based Inspection Guide.
  List<ScheduledTaskStatus> get overdueTasks => allCheckpointTasks
      .where((t) => t.status == MaintenanceStatus.overdue)
      .toList();

  /// Due checkpoint tasks in the Odometer-Based Inspection Guide.
  List<ScheduledTaskStatus> get dueTasks => allCheckpointTasks
      .where((t) => t.status == MaintenanceStatus.due)
      .toList();

  /// Upcoming checkpoint tasks in the Odometer-Based Inspection Guide.
  List<ScheduledTaskStatus> get upcomingTasks => allCheckpointTasks
      .where((t) => t.status == MaintenanceStatus.upcoming)
      .toList();

  /// Completed checkpoint tasks in the Odometer-Based Inspection Guide.
  List<ScheduledTaskStatus> get completedTasks => allCheckpointTasks
      .where((t) => t.status == MaintenanceStatus.completed)
      .toList();

  /// All distinct mileage checkpoints (e.g. 1000, 6000, 12000, 18000, 24000,
  /// 30000, 36000, and higher recurring checkpoints).
  List<int> get availableCheckpointsKm {
    final set = <int>{};
    for (final t in allCheckpointTasks) {
      if (t.dueKm != null && t.evaluation.rule.isManufacturer) {
        set.add(t.dueKm!);
      }
    }
    final list = set.toList()..sort();
    return list;
  }

  /// Returns all scheduled tasks at [checkpointKm].
  List<ScheduledTaskStatus> tasksAtCheckpoint(int checkpointKm) =>
      allCheckpointTasks.where((t) => t.dueKm == checkpointKm).toList();

  /// Next applicable maintenance checkpoint mileage at or above [currentKm]
  /// that still has uncompleted tasks.
  int? get nextMajorCheckpointKm {
    final km = currentKm ?? 0;
    for (final cpKm in availableCheckpointsKm) {
      if (cpKm < km) continue;
      final tasks = tasksAtCheckpoint(cpKm);
      if (tasks.any((t) => !t.isCompleted)) return cpKm;
    }
    return availableCheckpointsKm.lastOrNull;
  }

  /// Scheduled tasks at [nextMajorCheckpointKm].
  List<ScheduledTaskStatus> get nextMajorCheckpointTasks =>
      nextMajorCheckpointKm == null
          ? const []
          : tasksAtCheckpoint(nextMajorCheckpointKm!);

  /// Count of scheduled items per status code.
  Map<String, int> get statusCounts {
    return {
      MaintenanceStatus.overdue.code: overdue.length,
      MaintenanceStatus.due.code: due.length,
      MaintenanceStatus.upcoming.code: upcoming.length,
      MaintenanceStatus.completed.code: completedItems.isNotEmpty
          ? completedItems.length
          : completedTasks.length,
      MaintenanceStatus.good.code: scheduled
          .where((i) => i.evaluation.status == MaintenanceStatus.good)
          .length,
    };
  }

  bool get needsBaseline => items.any((i) => i.evaluation.needsBaseline);

  int get skippedBeforeTracking =>
      items.fold(0, (a, i) => a + i.evaluation.skippedBeforeTracking);

  RecordInfo? get lastRecord {
    RecordInfo? best;
    for (final r in snapshot.records) {
      if (best == null ||
          r.date.isAfter(best.date) ||
          (r.date == best.date && r.id > best.id)) {
        best = r;
      }
    }
    return best;
  }

  /// Most recent maintenance records (newest first).
  List<RecordInfo> get recentRecords {
    final list = List<RecordInfo>.of(snapshot.records);
    list.sort((a, b) {
      final d = b.date.compareTo(a.date);
      if (d != 0) return d;
      final k = b.odometerKm.compareTo(a.odometerKm);
      if (k != 0) return k;
      return b.id.compareTo(a.id);
    });
    return list;
  }

  int get totalExpensesCentavos =>
      snapshot.records.fold(0, (a, r) => a + r.totalCostCentavos);

  ItemInfo? itemById(int id) {
    for (final i in snapshot.items) {
      if (i.id == id) return i;
    }
    return null;
  }

  static List<ItemStatus> _sorted(Iterable<ItemStatus> list) {
    final l = list.toList();
    l.sort((a, b) {
      final s =
          b.evaluation.status.severity.compareTo(a.evaluation.status.severity);
      if (s != 0) return s;
      return (a.evaluation.next?.remainingKm ?? 1 << 30)
          .compareTo(b.evaluation.next?.remainingKm ?? 1 << 30);
    });
    return l;
  }

  /// Recalculates every item. Called whenever the snapshot changes, which
  /// covers odometer updates and new service records.
  static MaintenanceOverview build({
    required MaintenanceSnapshot snapshot,
    required DateTime today,
    MaintenanceCalculator calculator = const MaintenanceCalculator(),
  }) {
    final categories = {for (final c in snapshot.categories) c.id: c};
    final currentKm = snapshot.currentKm ?? 0;
    final baselineDate =
        snapshot.motorcycle?.purchaseDate ?? snapshot.firstLogDate;

    final items = <ItemStatus>[];
    for (final item in snapshot.items) {
      final category = categories[item.categoryId];
      if (category == null) continue;
      final events = snapshot.records
          .where((r) => r.itemId == item.id)
          .map((r) => r.toEvent())
          .toList();
      final rules = snapshot.rules.where((r) => r.itemId == item.id).toList();
      items.add(ItemStatus(
        item: item,
        category: category,
        evaluation: calculator.evaluateItem(
          itemId: item.id,
          rules: rules,
          events: events,
          currentKm: currentKm,
          today: today,
          baselineKm: snapshot.baselineKm,
          baselineDate: baselineDate,
        ),
      ));
    }
    return MaintenanceOverview(snapshot: snapshot, today: today, items: items);
  }
}
