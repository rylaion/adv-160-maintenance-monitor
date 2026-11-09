import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/seed/honda_schedule_seed.dart';
import '../../../core/enums/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/widgets/item_status_card.dart';
import '../../../shared/widgets/status_chip.dart';
import '../domain/maintenance_overview.dart';
import 'maintenance_history_screen.dart';
import 'maintenance_view_model.dart';
import 'status_text.dart';

/// Maintenance Tracker & Odometer-Based Inspection Guide screen:
/// - **By Category tab:** Groups all maintenance items by the 8 categories
///   (Engine, Fuel System, CVT / Transmission, Braking System, Cooling System,
///   Electrical / Battery, Tires / Wheels, Chassis / Suspension). Clearly
///   labels `Fuel Filter` as a user-defined maintenance task.
/// - **Inspection Guide tab:** Displays the 2023 Honda ADV160 Philippines
///   Owner's Manual (`32K0WA100`, pages 87–89) odometer-based inspection
///   guide with Overdue, Due, Upcoming, and Completed tasks plus checkpoint
///   filtering (1k, 6k, 12k, 18k, 24k, 30k, 36k, ...).
class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(maintenanceOverviewProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Maintenance & Guide'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'By Category'),
              Tab(text: 'Inspection Guide'),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Parts management',
              icon: const Icon(Icons.inventory_2_outlined),
              onPressed: () => context.push('/parts'),
            ),
            IconButton(
              tooltip: 'Maintenance history',
              icon: const Icon(Icons.history),
              onPressed: () => context.push('/maintenance/history'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/maintenance/record'),
          icon: const Icon(Icons.add),
          label: const Text('Add Service'),
        ),
        body: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) =>
              Center(child: Text('Could not load maintenance: $e')),
          data: (o) => TabBarView(
            children: [
              _CategoriesTab(overview: o),
              _InspectionGuideTab(overview: o),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab({required this.overview});
  final MaintenanceOverview overview;

  @override
  Widget build(BuildContext context) {
    final o = overview;
    final children = <Widget>[];
    for (final cat in o.snapshot.categories) {
      final items = o.items.where((i) => i.category.id == cat.id).toList();
      if (items.isEmpty) continue;
      children.add(Padding(
        padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
        child: Text(cat.name, style: Theme.of(context).textTheme.titleSmall),
      ));
      children.addAll(items.map((i) => _TrackerItemCard(
            status: i,
            motorcycleId: o.snapshot.motorcycle?.id,
          )));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
      children: children,
    );
  }
}

class _InspectionGuideTab extends StatefulWidget {
  const _InspectionGuideTab({required this.overview});
  final MaintenanceOverview overview;

  @override
  State<_InspectionGuideTab> createState() => _InspectionGuideTabState();
}

class _InspectionGuideTabState extends State<_InspectionGuideTab> {
  int? _selectedCheckpointKm;

  @override
  Widget build(BuildContext context) {
    final o = widget.overview;
    final theme = Theme.of(context);
    final checkpoints = o.availableCheckpointsKm;
    final nextMajorKm = o.nextMajorCheckpointKm;

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Honda ADV160 Odometer Inspection Guide',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Reference: ${HondaScheduleSeed.sourceDocument}, pp. 87–89\n'
                  'Legend: I = Inspect · R = Replace · C = Clean',
                  style: theme.textTheme.bodySmall,
                ),
                const Divider(height: 16),
                Text(
                  'Current odometer: ${o.currentKm == null ? 'Not recorded' : StatusText.km(o.currentKm!)} · '
                  'Next applicable checkpoint: ${nextMajorKm == null ? '—' : StatusText.km(nextMajorKm)}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: const Text('Active Status Summary'),
                  selected: _selectedCheckpointKm == null,
                  onSelected: (_) =>
                      setState(() => _selectedCheckpointKm = null),
                ),
              ),
              for (final km in checkpoints)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(StatusText.km(km)),
                    selected: _selectedCheckpointKm == km,
                    onSelected: (_) =>
                        setState(() => _selectedCheckpointKm = km),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_selectedCheckpointKm != null) ...[
          Text(
            'Checkpoint ${StatusText.km(_selectedCheckpointKm!)} Schedule',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          for (final t in o.tasksAtCheckpoint(_selectedCheckpointKm!))
            _CheckpointTaskTile(task: t),
        ] else ...[
          if (o.overdueTasks.isNotEmpty) ...[
            Text(
              'Overdue Checkpoints (${o.overdueTasks.length})',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            for (final t in o.overdueTasks) _CheckpointTaskTile(task: t),
            const SizedBox(height: 12),
          ],
          if (o.dueTasks.isNotEmpty) ...[
            Text(
              'Due Checkpoints (${o.dueTasks.length})',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            for (final t in o.dueTasks) _CheckpointTaskTile(task: t),
            const SizedBox(height: 12),
          ],
          if (o.upcomingTasks.isNotEmpty) ...[
            Text(
              'Upcoming Checkpoints (${o.upcomingTasks.length})',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            for (final t in o.upcomingTasks) _CheckpointTaskTile(task: t),
            const SizedBox(height: 12),
          ],
          if (o.completedTasks.isNotEmpty) ...[
            Text(
              'Completed Checkpoints (${o.completedTasks.length})',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            for (final t in o.completedTasks.reversed)
              _CheckpointTaskTile(task: t),
          ],
          if (o.overdueTasks.isEmpty &&
              o.dueTasks.isEmpty &&
              o.upcomingTasks.isEmpty &&
              o.completedTasks.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No checkpoints are currently due, overdue, or within the '
                  'upcoming warning distance. Select a checkpoint chip above '
                  'to inspect any milestone from 1,000 km to 36,000+ km.',
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _CheckpointTaskTile extends StatelessWidget {
  const _CheckpointTaskTile({required this.task});
  final ScheduledTaskStatus task;

  @override
  Widget build(BuildContext context) {
    final dueKm = task.dueKm;
    final remKm = task.remainingKm;
    final completed = task.completedBy;
    final defaultAction = task.actionCode.defaultMaintenanceAction.code;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          '${task.item.name} · ${task.actionCode.label} (${task.actionCode.code})',
        ),
        subtitle: Text([
          'Category: ${task.category.name}',
          if (dueKm != null)
            'Scheduled at ${StatusText.km(dueKm)}'
                '${remKm != null && !task.isCompleted ? ' (${StatusText.remainingKm(remKm)})' : ''}',
          if (completed != null)
            'Completed: ${AppDates.formatDate(completed.date)} at ${StatusText.km(completed.odometerKm)}',
        ].join('\n')),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            StatusChip(status: task.status),
            if (!task.isCompleted)
              InkWell(
                onTap: () => context.push(
                  '/maintenance/record?itemId=${task.item.id}'
                  '&action=$defaultAction'
                  '${dueKm != null ? '&km=$dueKm' : ''}',
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Complete',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TrackerItemCard extends ConsumerWidget {
  const _TrackerItemCard({required this.status, this.motorcycleId});
  final ItemStatus status;
  final int? motorcycleId;

  Future<void> _showCustomRuleDialog(
      BuildContext context, WidgetRef ref) async {
    final bikeId = motorcycleId;
    if (bikeId == null) return;
    final kmCtl = TextEditingController();
    final monthsCtl = TextEditingController();
    final notesCtl = TextEditingController();
    var action = ActionCode.replace;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text('Custom interval · ${status.item.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<ActionCode>(
                value: action,
                decoration: const InputDecoration(labelText: 'Action'),
                items: [
                  for (final a in ActionCode.values)
                    DropdownMenuItem(value: a, child: Text(a.label)),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => action = v);
                },
              ),
              const SizedBox(height: 8),
              TextField(
                controller: kmCtl,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Interval (km, optional)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: monthsCtl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Interval (months, optional)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notesCtl,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Save Rule')),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    final err =
        await ref.read(maintenanceActionsProvider.notifier).addCustomRule(
              motorcycleId: bikeId,
              itemId: status.item.id,
              action: action,
              intervalKm: int.tryParse(kmCtl.text.trim()),
              intervalMonths: int.tryParse(monthsCtl.text.trim()),
              notes: notesCtl.text,
            );
    if (context.mounted && err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  void _showItemDetailsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        builder: (_, controller) => _ItemDetailSheet(
          status: status,
          scrollController: controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCustomOnlyItem = status.item.name == 'Fuel Filter';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showItemDetailsSheet(context),
          child: ItemStatusCard(status: status),
        ),
        if (isCustomOnlyItem)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'User-defined maintenance task (not a Honda-prescribed interval '
              'in Owner\'s Manual 32K0WA100)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _showCustomRuleDialog(context, ref),
                icon: const Icon(Icons.tune, size: 16),
                label: const Text('Custom Interval'),
              ),
              TextButton.icon(
                onPressed: () => context
                    .push('/maintenance/record?itemId=${status.item.id}'),
                icon: const Icon(Icons.add_task, size: 16),
                label: const Text('Log Service'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ItemDetailSheet extends ConsumerWidget {
  const _ItemDetailSheet({
    required this.status,
    required this.scrollController,
  });

  final ItemStatus status;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final eval = status.evaluation;
    final historyAsync = ref.watch(itemHistoryProvider(status.item.id));
    final last = eval.lastService;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(status.item.name, style: theme.textTheme.titleLarge),
            ),
            if (eval.hasSchedule) StatusChip(status: eval.status),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          status.item.instructions ??
              'Instructions: Refer to Honda ADV160 Owner\'s Manual (32K0WA100).',
          style: theme.textTheme.bodySmall,
        ),
        const Divider(height: 24),
        Text(
            'Last service date: ${last == null ? '—' : AppDates.formatDate(last.date)}'),
        Text(
            'Last service mileage: ${last == null ? '—' : StatusText.km(last.odometerKm)}'),
        if (eval.next != null) ...[
          for (final l in StatusText.nextLines(eval.next)) Text(l),
          if (eval.next!.remainingKm != null)
            Text('Remaining km: ${StatusText.km(eval.next!.remainingKm!)}'),
          if (eval.next!.remainingDays != null)
            Text('Remaining days: ${eval.next!.remainingDays}'),
        ],
        const SizedBox(height: 16),
        Text('Service history', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        historyAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
          data: (records) => records.isEmpty
              ? const Text('No records for this item yet.')
              : Column(
                  children: [
                    for (final r in records) MaintenanceRecordCard(record: r),
                  ],
                ),
        ),
      ],
    );
  }
}
