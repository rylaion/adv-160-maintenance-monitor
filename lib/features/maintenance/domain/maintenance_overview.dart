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

/// Everything the dashboard and maintenance tab display, derived purely from
/// stored data (no hardcoded values).
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

  List<ItemStatus> get overdue => _sorted(scheduled.where((i) =>
      i.evaluation.status == MaintenanceStatus.overdue ||
      i.evaluation.status == MaintenanceStatus.replacementRequired));

  List<ItemStatus> get dueSoon => _sorted(scheduled.where((i) =>
      i.evaluation.status == MaintenanceStatus.due ||
      i.evaluation.status == MaintenanceStatus.upcoming ||
      i.evaluation.status == MaintenanceStatus.inspectionRequired));

  /// Count of scheduled items per status code.
  Map<String, int> get statusCounts {
    final m = <String, int>{};
    for (final i in scheduled) {
      m.update(i.evaluation.status.code, (v) => v + 1, ifAbsent: () => 1);
    }
    return m;
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
