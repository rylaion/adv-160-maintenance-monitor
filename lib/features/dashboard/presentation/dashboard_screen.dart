import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/widgets/item_status_card.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../maintenance/domain/maintenance_overview.dart';
import '../../maintenance/presentation/maintenance_view_model.dart';
import '../../maintenance/presentation/status_text.dart';
import '../../reminders/presentation/reminders_view_model.dart';

/// Dashboard driven entirely by stored data and the calculation engine.
///
/// Displays:
/// - Motorcycle & odometer summary
/// - Next major maintenance checkpoint
/// - Maintenance inspection summary (Overdue, Due, Upcoming, Recently completed)
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(maintenanceOverviewProvider);
    final remindersCount =
        ref.watch(activeRemindersProvider).valueOrNull?.length ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADV-MON'),
        actions: [
          IconButton(
            tooltip: 'Reminders ($remindersCount)',
            icon: Badge(
              isLabelVisible: remindersCount > 0,
              label: Text('$remindersCount'),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () => context.push('/reminders'),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load data: $e')),
        data: (o) => _Body(overview: o),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.overview});
  final MaintenanceOverview overview;

  @override
  Widget build(BuildContext context) {
    final o = overview;
    final theme = Theme.of(context);
    final bike = o.snapshot.motorcycle;
    final last = o.lastRecord;
    final lastItem = last == null ? null : o.itemById(last.itemId);
    final nextMajorKm = o.nextMajorCheckpointKm;
    final nextMajorTasks = o.nextMajorCheckpointTasks;
    final recentRecords = o.recentRecords.take(5).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: bike == null ? null : () => context.push('/motorcycle'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.two_wheeler, size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bike?.displayName ?? 'No motorcycle',
                              style: theme.textTheme.titleLarge),
                          if (bike != null)
                            Text('Model year ${bike.modelYear}'),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ]),
                  const Divider(height: 24),
                  Row(children: [
                    Expanded(
                      child: _Metric(
                        label: 'Current odometer',
                        value: o.currentKm == null
                            ? 'Not recorded'
                            : StatusText.km(o.currentKm!),
                      ),
                    ),
                    Expanded(
                      child: _Metric(
                        label: 'Distance tracked',
                        value: o.trackedKm == null
                            ? '—'
                            : StatusText.km(o.trackedKm!),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: () => context.push('/odometer'),
              icon: const Icon(Icons.speed),
              label: const Text('Update Odometer'),
            ),
            FilledButton.tonalIcon(
              onPressed: () => context.push('/maintenance/record'),
              icon: const Icon(Icons.add_task),
              label: const Text('Add Maintenance'),
            ),
            OutlinedButton.icon(
              onPressed: () => context.go('/maintenance'),
              icon: const Icon(Icons.fact_check_outlined),
              label: const Text('Inspection Guide'),
            ),
            OutlinedButton.icon(
              onPressed: () => context.go('/components'),
              icon: const Icon(Icons.straighten),
              label: const Text('Record Measurement'),
            ),
            OutlinedButton.icon(
              onPressed: () => context.push('/maintenance/history'),
              icon: const Icon(Icons.history),
              label: const Text('View Maintenance History'),
            ),
          ],
        ),
        if (o.currentKm == null)
          const _Hint('Enter your current odometer reading so mileage-based '
              'maintenance can be calculated.'),
        if (o.needsBaseline)
          const _Hint('Set the purchase date in the motorcycle profile to '
              'enable date-based schedules.'),
        const SizedBox(height: 16),
        if (nextMajorKm != null)
          _NextMajorCheckpointCard(
            checkpointKm: nextMajorKm,
            currentKm: o.currentKm,
            tasks: nextMajorTasks,
          ),
        const SizedBox(height: 16),
        Text('Maintenance inspection summary',
            style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        _Summary(
          overview: o,
          counts: o.statusCounts,
          unscheduled: o.unscheduled.length,
        ),
        if (o.overdue.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Overdue maintenance (${o.overdue.length})',
              style: theme.textTheme.titleMedium),
          ...o.overdue.map((i) => _buildDashboardItemCard(context, o, i)),
        ],
        if (o.due.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Due maintenance (${o.due.length})',
              style: theme.textTheme.titleMedium),
          ...o.due.map((i) => _buildDashboardItemCard(context, o, i)),
        ],
        if (o.upcoming.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Upcoming maintenance (${o.upcoming.length})',
              style: theme.textTheme.titleMedium),
          ...o.upcoming.map((i) => _buildDashboardItemCard(context, o, i)),
        ],
        const SizedBox(height: 16),
        Text('Recently completed maintenance',
            style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (recentRecords.isEmpty)
          const Card(
            child: ListTile(
              leading: Icon(Icons.task_alt_outlined),
              title: Text('No completed maintenance recorded yet'),
              subtitle: Text(
                  'Log a completed service to track completed checkpoints.'),
            ),
          )
        else
          Card(
            child: Column(
              children: [
                for (final r in recentRecords)
                  ListTile(
                    leading: const Icon(Icons.task_alt),
                    title: Text(o.itemById(r.itemId)?.name ?? 'Item'),
                    subtitle: Text(
                      '${r.action.label} · ${AppDates.formatDate(r.date)} '
                      'at ${StatusText.km(r.odometerKm)}',
                    ),
                    trailing:
                        const StatusChip(status: MaintenanceStatus.completed),
                    onTap: () => context.push('/maintenance/item/${r.itemId}'),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Card(
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Last maintenance'),
              subtitle: Text(last == null
                  ? 'No maintenance recorded'
                  : '${lastItem?.name ?? 'Item'} · ${AppDates.formatDate(last.date)} '
                      'at ${StatusText.km(last.odometerKm)}'),
              onTap: last == null
                  ? null
                  : () => context.push('/maintenance/item/${last.itemId}'),
            ),
            ListTile(
              leading: const Icon(Icons.payments_outlined),
              title: const Text('Total maintenance expenses'),
              subtitle: Text(StatusText.pesos(o.totalExpensesCentavos)),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _buildDashboardItemCard(
    BuildContext context,
    MaintenanceOverview o,
    ItemStatus i,
  ) {
    final defaultAction =
        (i.evaluation.next?.next?.actionCode ?? ActionCode.inspect)
            .defaultMaintenanceAction
            .code;
    final currentKm = o.currentKm;
    return ItemStatusCard(
      status: i,
      showCategory: true,
      onTap: () => context.push('/maintenance/item/${i.item.id}'),
      onQuickLog: () => context.push(
        '/maintenance/record?itemId=${i.item.id}'
        '&action=$defaultAction'
        '${currentKm != null ? '&km=$currentKm' : ''}',
      ),
    );
  }
}

class _NextMajorCheckpointCard extends StatelessWidget {
  const _NextMajorCheckpointCard({
    required this.checkpointKm,
    required this.currentKm,
    required this.tasks,
  });

  final int checkpointKm;
  final int? currentKm;
  final List<ScheduledTaskStatus> tasks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rem = currentKm == null ? null : checkpointKm - currentKm!;
    final inspectCount =
        tasks.where((t) => t.actionCode == ActionCode.inspect).length;
    final replaceCount =
        tasks.where((t) => t.actionCode == ActionCode.replace).length;
    final cleanCount =
        tasks.where((t) => t.actionCode == ActionCode.clean).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flag_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Next major maintenance checkpoint',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              rem == null
                  ? StatusText.km(checkpointKm)
                  : '${StatusText.km(checkpointKm)} (${StatusText.remainingKm(rem)})',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              '${tasks.length} scheduled item(s): '
              '$inspectCount Inspect (I) · $replaceCount Replace (R) · '
              '$cleanCount Clean (C)',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: t.bodySmall),
      Text(value, style: t.titleMedium),
    ]);
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.info_outline, size: 18),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
        ]),
      );
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.overview,
    required this.counts,
    required this.unscheduled,
  });

  final MaintenanceOverview overview;
  final Map<String, int> counts;
  final int unscheduled;

  void _showStatusItemsSheet(BuildContext context, MaintenanceStatus s) {
    final List<ItemStatus> list = switch (s) {
      MaintenanceStatus.overdue ||
      MaintenanceStatus.replacementRequired =>
        overview.overdue,
      MaintenanceStatus.due ||
      MaintenanceStatus.inspectionRequired =>
        overview.due,
      MaintenanceStatus.upcoming => overview.upcoming,
      MaintenanceStatus.completed => overview.completedItems,
      MaintenanceStatus.good => overview.scheduled
          .where((i) => i.evaluation.status == MaintenanceStatus.good)
          .toList(),
    };
    if (list.isEmpty) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              '${s.label} Maintenance (${list.length})',
              style: Theme.of(ctx).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            for (final item in list)
              ItemStatusCard(
                status: item,
                showCategory: true,
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/maintenance/item/${item.item.id}');
                },
                onQuickLog: () {
                  Navigator.pop(ctx);
                  final defaultAction =
                      (item.evaluation.next?.next?.actionCode ??
                              ActionCode.inspect)
                          .defaultMaintenanceAction
                          .code;
                  final km = overview.currentKm;
                  context.push(
                    '/maintenance/record?itemId=${item.item.id}'
                    '&action=$defaultAction'
                    '${km != null ? '&km=$km' : ''}',
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    for (final s in MaintenanceStatus.values) {
      final n = counts[s.code];
      if (n == null) continue;
      chips.add(InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showStatusItemsSheet(context, s),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            StatusChip(status: s),
            const SizedBox(width: 4),
            Text('$n'),
          ]),
        ),
      ));
    }
    if (chips.isEmpty) chips.add(const Text('No scheduled items'));
    return Wrap(spacing: 12, runSpacing: 4, children: [
      ...chips,
      if (unscheduled > 0) Text('$unscheduled without schedule'),
    ]);
  }
}
