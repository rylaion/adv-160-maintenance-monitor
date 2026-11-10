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
import '../../trips/presentation/trips_view_model.dart';
import '../../cvt/presentation/cvt_view_model.dart';

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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/icons/app_icon.png',
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.two_wheeler, size: 36),
                      ),
                    ),
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
              onPressed: () => context.push('/map'),
              icon: const Icon(Icons.map_outlined),
              label: const Text('Live Map & GPS'),
            ),
            OutlinedButton.icon(
              onPressed: () => context.push('/trips'),
              icon: const Icon(Icons.route),
              label: const Text('Ride History & Trips'),
            ),
            OutlinedButton.icon(
              onPressed: () => context.push('/cvt'),
              icon: const Icon(Icons.tune),
              label: const Text('CVT Configurations'),
            ),
            OutlinedButton.icon(
              onPressed: () => context.push('/parts'),
              icon: const Icon(Icons.auto_stories_outlined),
              label: const Text('OEM Parts Catalogue'),
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
        const SizedBox(height: 16),
        const _DashboardTripSummary(),
        const SizedBox(height: 16),
        _DashboardCvtSummary(currentKm: o.currentKm),
        const SizedBox(height: 16),
        const _DashboardPartsCatalogSummary(),
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

  void _showCheckpointSheet(BuildContext context) {
    if (tasks.isEmpty) return;
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
              'Checkpoint ${StatusText.km(checkpointKm)} Schedule (${tasks.length})',
              style: Theme.of(ctx).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            for (final t in tasks)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    '${t.item.name} · ${t.actionCode.label} (${t.actionCode.code})',
                  ),
                  subtitle: Text(
                    'Category: ${t.category.name} · '
                    'Scheduled at ${StatusText.km(checkpointKm)}',
                  ),
                  trailing: StatusChip(status: t.status),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/maintenance/item/${t.item.id}');
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

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
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showCheckpointSheet(context),
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
                  const Icon(Icons.chevron_right),
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
                '$cleanCount Clean (C) · Tap to view items',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardTripSummary extends ConsumerWidget {
  const _DashboardTripSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(tripStatsProvider);
    final recentAsync = ref.watch(recentTripsProvider);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.route, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ride History & Trips',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.push('/map'),
                  icon: const Icon(Icons.map_outlined, size: 16),
                  label: const Text('Live Map'),
                ),
                TextButton(
                  onPressed: () => context.push('/trips'),
                  child: const Text('Trips'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            statsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (stats) => Row(
                children: [
                  Expanded(
                    child: _Metric(
                      label: 'Total distance',
                      value: '${stats.totalDistanceKm.toStringAsFixed(1)} km',
                    ),
                  ),
                  Expanded(
                    child: _Metric(
                      label: 'Trips logged',
                      value: '${stats.totalTrips}',
                    ),
                  ),
                  Expanded(
                    child: _Metric(
                      label: 'This month',
                      value: '${stats.monthlyDistanceKm.toStringAsFixed(1)} km',
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            recentAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (recent) {
                if (recent.isEmpty) {
                  return Text(
                    'No trips logged yet. Tap Record Ride or Add Trip to start tracking.',
                    style: theme.textTheme.bodySmall,
                  );
                }
                final latest = recent.first;
                return Row(
                  children: [
                    Icon(
                      latest.isGpsTracked ? Icons.gps_fixed : Icons.edit_note,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Latest: ${latest.title} (${latest.distanceKm.toStringAsFixed(1)} km) on ${AppDates.formatDate(latest.startTime)}',
                        style: theme.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCvtSummary extends ConsumerWidget {
  const _DashboardCvtSummary({this.currentKm});
  final int? currentKm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeConfigAsync = ref.watch(activeCvtConfigurationProvider);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tune, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Active CVT Setup',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/cvt'),
                  child: const Text('Manage'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            activeConfigAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (config) {
                if (config == null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No active CVT configuration set. Track your rollers, pulley, belt, and springs for optimal tuning.',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () => context.push('/cvt/add'),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Create CVT Setup'),
                      ),
                    ],
                  );
                }

                final installedOdo = config.installedOdometerKm;
                final kmSince = (installedOdo != null &&
                        currentKm != null &&
                        currentKm! >= installedOdo)
                    ? currentKm! - installedOdo
                    : null;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            config.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Active',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _Metric(
                            label: 'Flyballs / Rollers',
                            value: config.flyballWeightGrams != null
                                ? '${config.flyballWeightGrams}g'
                                : 'Stock',
                          ),
                        ),
                        Expanded(
                          child: _Metric(
                            label: 'Center Spring',
                            value: config.centerSpringRpm != null
                                ? '${config.centerSpringRpm} RPM'
                                : 'Stock',
                          ),
                        ),
                        Expanded(
                          child: _Metric(
                            label: 'Distance on Setup',
                            value:
                                kmSince != null ? StatusText.km(kmSince) : '—',
                          ),
                        ),
                      ],
                    ),
                    if (config.pulleyBrandModel != null ||
                        config.beltBrandPartNumber != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        [
                          if (config.pulleyBrandModel != null)
                            'Pulley: ${config.pulleyBrandModel}',
                          if (config.beltBrandPartNumber != null)
                            'Belt: ${config.beltBrandPartNumber}',
                        ].join(' · '),
                        style: theme.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardPartsCatalogSummary extends StatelessWidget {
  const _DashboardPartsCatalogSummary();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_stories, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Honda ADV 160 OEM Parts Catalogue',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/parts'),
                  child: const Text('Browse All'),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Verified genuine Honda part numbers, service limits, and exploded schematics.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.settings_input_component, size: 16),
                  label: const Text('CVT Belt 23100-K0W-N01'),
                  onPressed: () => context.push('/parts'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.album_outlined, size: 16),
                  label: const Text('Brake Pads 06455-KRE-G01'),
                  onPressed: () => context.push('/parts'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.air, size: 16),
                  label: const Text('Air Filter 17210-K0W-N00'),
                  onPressed: () => context.push('/parts'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.schema_outlined, size: 16),
                  label: const Text('Exploded Diagrams'),
                  onPressed: () => context.push('/parts/diagrams'),
                ),
              ],
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
    if (list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'No ${s.label.toLowerCase()} maintenance items right now.')),
      );
      return;
    }

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

  void _showUnscheduledSheet(BuildContext context) {
    final list = overview.unscheduled.toList();
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
              'Condition / Unscheduled Items (${list.length})',
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
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const summaryOrder = [
      MaintenanceStatus.overdue,
      MaintenanceStatus.due,
      MaintenanceStatus.upcoming,
      MaintenanceStatus.completed,
      MaintenanceStatus.good,
    ];
    final chips = <Widget>[];
    for (final s in summaryOrder) {
      final n = counts[s.code] ?? 0;
      chips.add(
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showStatusItemsSheet(context, s),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatusChip(status: s),
                const SizedBox(width: 6),
                Text(
                  '$n',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.chevron_right, size: 16),
              ],
            ),
          ),
        ),
      );
    }
    return Wrap(spacing: 8, runSpacing: 8, children: [
      ...chips,
      if (unscheduled > 0)
        ActionChip(
          label: Text('$unscheduled condition / custom'),
          onPressed: () => _showUnscheduledSheet(context),
        ),
    ]);
  }
}
