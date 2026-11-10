import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/widgets/item_status_card.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../cvt/presentation/cvt_view_model.dart';
import '../../maintenance/domain/maintenance_overview.dart';
import '../../maintenance/presentation/maintenance_view_model.dart';
import '../../maintenance/presentation/status_text.dart';
import '../../reminders/presentation/reminders_view_model.dart';
import '../../trips/domain/trip_models.dart';
import '../../trips/presentation/trips_view_model.dart';

/// Redesigned ADV MON Dashboard with dark brown & soft pink visual identity.
///
/// Features:
/// - Compact App Bar with unread reminders and settings shortcut
/// - Hero Motorcycle Information Card with live status pill and odometer stats
/// - Real-time Motorcycle Statistics (Upcoming, Overdue, Total Rides, Monthly Km)
/// - Next Maintenance Checkpoint Card with calculated progress bar and schedule sheet
/// - Responsive 2-column Quick Actions grid replacing oversized buttons
/// - Inspection summary and clickable due/overdue item cards
/// - Integration cards for Trips, CVT configuration, and OEM Parts Catalog
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(maintenanceOverviewProvider);
    final remindersCount =
        ref.watch(activeRemindersProvider).valueOrNull?.length ?? 0;
    final tripStats = ref.watch(tripStatsProvider).valueOrNull ??
        const TripStats(
          totalDistanceKm: 0,
          totalTrips: 0,
          avgDistanceKm: 0,
          longestDistanceKm: 0,
          monthlyDistanceKm: 0,
        );
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.14),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.two_wheeler_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ADV-MON',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'HONDA ADV 160 COMPANION',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color:
                          theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                      fontSize: 9,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Reminders ($remindersCount)',
            icon: Badge(
              isLabelVisible: remindersCount > 0,
              label: Text('$remindersCount'),
              backgroundColor: theme.colorScheme.primary,
              textColor: theme.colorScheme.onPrimary,
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () => context.push('/reminders'),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load data: $e')),
        data: (o) => _DashboardBody(overview: o, tripStats: tripStats),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.overview, required this.tripStats});
  final MaintenanceOverview overview;
  final TripStats tripStats;

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // B. Hero Motorcycle Information Card
            _MotorcycleHeroCard(
              bikeName: bike?.displayName ?? 'Honda ADV 160',
              modelYear: bike?.modelYear ?? 2023,
              currentKm: o.currentKm,
              trackedKm: o.trackedKm,
              overdueCount: o.overdue.length,
              dueCount: o.due.length,
              upcomingCount: o.upcoming.length,
              onTap: bike == null ? null : () => context.push('/motorcycle'),
            ),

            if (o.currentKm == null)
              const _Hint(
                  'Enter your current odometer reading so mileage-based '
                  'maintenance can be calculated.'),
            if (o.needsBaseline)
              const _Hint('Set the purchase date in the motorcycle profile to '
                  'enable date-based schedules.'),

            const SizedBox(height: 14),

            // C. Motorcycle Statistics (2x2 Grid using real database figures)
            _DashboardStatisticsGrid(
              overview: o,
              tripStats: tripStats,
              isWide: isWide,
            ),

            const SizedBox(height: 14),

            // D. Next Maintenance Checkpoint Card with Progress Bar
            if (nextMajorKm != null)
              _NextMajorCheckpointCard(
                checkpointKm: nextMajorKm,
                currentKm: o.currentKm,
                tasks: nextMajorTasks,
                overview: o,
              ),

            const SizedBox(height: 16),

            // E. Quick Actions (Responsive 2-column grid replacing oversized pill buttons)
            Row(
              children: [
                Icon(
                  Icons.grid_view_rounded,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Quick Actions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _QuickActionsGrid(isWide: isWide),

            const SizedBox(height: 18),

            // F. Maintenance Inspection Summary & Due Lists
            Row(
              children: [
                Icon(
                  Icons.playlist_add_check_rounded,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Maintenance inspection summary',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _Summary(
              overview: o,
              counts: o.statusCounts,
              unscheduled: o.unscheduled.length,
            ),

            if (o.overdue.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Overdue maintenance (${o.overdue.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: StatusColors.overdue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              ...o.overdue.map((i) => _buildDashboardItemCard(context, o, i)),
            ],

            if (o.due.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Due maintenance (${o.due.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: StatusColors.due,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              ...o.due.map((i) => _buildDashboardItemCard(context, o, i)),
            ],

            if (o.upcoming.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Upcoming maintenance (${o.upcoming.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              ...o.upcoming.map((i) => _buildDashboardItemCard(context, o, i)),
            ],

            const SizedBox(height: 16),
            Text(
              'Recently completed maintenance',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            if (recentRecords.isEmpty)
              const Card(
                child: ListTile(
                  leading: Icon(Icons.task_alt_outlined),
                  title: Text('No completed maintenance recorded yet'),
                  subtitle: Text(
                    'Log a completed service to track completed checkpoints.',
                  ),
                ),
              )
            else
              Card(
                child: Column(
                  children: [
                    for (final r in recentRecords)
                      ListTile(
                        leading: const Icon(
                          Icons.task_alt,
                          color: StatusColors.good,
                        ),
                        title: Text(o.itemById(r.itemId)?.name ?? 'Item'),
                        subtitle: Text(
                          '${r.action.label} · ${AppDates.formatDate(r.date)} '
                          'at ${StatusText.km(r.odometerKm)}',
                        ),
                        trailing: const StatusChip(
                          status: MaintenanceStatus.completed,
                        ),
                        onTap: () =>
                            context.push('/maintenance/item/${r.itemId}'),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 14),

            // Service History and Expense Summary Card
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.history_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    title: const Text('Last maintenance'),
                    subtitle: Text(
                      last == null
                          ? 'No maintenance recorded'
                          : '${lastItem?.name ?? 'Item'} · ${AppDates.formatDate(last.date)} '
                              'at ${StatusText.km(last.odometerKm)}',
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: last == null
                        ? () => context.push('/maintenance/history')
                        : () =>
                            context.push('/maintenance/item/${last.itemId}'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.payments_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    title: const Text('Total maintenance expenses'),
                    subtitle: Text(StatusText.pesos(o.totalExpensesCentavos)),
                    trailing: TextButton(
                      onPressed: () => context.push('/maintenance/history'),
                      child: const Text('View History'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const _DashboardTripSummary(),
            const SizedBox(height: 14),
            _DashboardCvtSummary(currentKm: o.currentKm),
            const SizedBox(height: 14),
            const _DashboardPartsCatalogSummary(),
            const SizedBox(height: 24),
          ],
        );
      },
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

/// B. Hero Motorcycle Information Card
class _MotorcycleHeroCard extends StatelessWidget {
  const _MotorcycleHeroCard({
    required this.bikeName,
    required this.modelYear,
    required this.currentKm,
    required this.trackedKm,
    required this.overdueCount,
    required this.dueCount,
    required this.upcomingCount,
    required this.onTap,
  });

  final String bikeName;
  final int modelYear;
  final int? currentKm;
  final int? trackedKm;
  final int overdueCount;
  final int dueCount;
  final int upcomingCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Compute overall maintenance condition indicator
    final Color statusColor;
    final String statusLabel;
    final IconData statusIcon;

    if (overdueCount > 0) {
      statusColor = StatusColors.overdue;
      statusLabel = '$overdueCount Overdue';
      statusIcon = Icons.error_outline_rounded;
    } else if (dueCount > 0) {
      statusColor = StatusColors.due;
      statusLabel = '$dueCount Due Now';
      statusIcon = Icons.notifications_active_outlined;
    } else if (upcomingCount > 0) {
      statusColor = StatusColors.upcoming;
      statusLabel = '$upcomingCount Upcoming';
      statusIcon = Icons.schedule_rounded;
    } else {
      statusColor = StatusColors.good;
      statusLabel = 'All Systems Good';
      statusIcon = Icons.check_circle_outline_rounded;
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Profile Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Motorcycle Avatar / Hero Badge
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.35),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        'assets/icons/app_icon.png',
                        width: 68,
                        height: 68,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.two_wheeler_rounded,
                          size: 38,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Bike Details & Condition Pill
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: statusColor.withOpacity(0.4),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    statusIcon,
                                    size: 13,
                                    color: statusColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    statusLabel,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          bikeName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Model Year $modelYear · 160cc 4V eSP+',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Navigate Arrow
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color:
                          theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Odometer & Tracked Stats Row
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.speed_rounded,
                      label: 'Current Odometer',
                      value: currentKm == null
                          ? 'Not recorded'
                          : StatusText.km(currentKm!),
                      accentColor: theme.colorScheme.primary,
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 1,
                    color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                  ),
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.route_rounded,
                      label: 'Distance Tracked',
                      value:
                          trackedKm == null ? '—' : StatusText.km(trackedKm!),
                      accentColor: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper tile for metrics in the hero card
class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: accentColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// C. Compact Motorcycle Statistics Grid (2x2)
class _DashboardStatisticsGrid extends StatelessWidget {
  const _DashboardStatisticsGrid({
    required this.overview,
    required this.tripStats,
    required this.isWide,
  });

  final MaintenanceOverview overview;
  final TripStats tripStats;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overdueCount = overview.overdue.length;
    final upcomingCount = overview.upcoming.length;

    final cards = [
      _StatCard(
        title: '$upcomingCount',
        subtitle: 'Upcoming tasks',
        icon: Icons.schedule_rounded,
        iconColor: StatusColors.upcoming,
        onTap: () => _showStatusItemsSheet(
          context,
          overview,
          MaintenanceStatus.upcoming,
        ),
      ),
      _StatCard(
        title: '$overdueCount',
        subtitle: overdueCount == 0 ? 'Overdue: none' : 'Overdue items',
        icon: overdueCount > 0
            ? Icons.warning_amber_rounded
            : Icons.check_circle_outline_rounded,
        iconColor: overdueCount > 0 ? StatusColors.overdue : StatusColors.good,
        onTap: () => _showStatusItemsSheet(
          context,
          overview,
          MaintenanceStatus.overdue,
        ),
      ),
      _StatCard(
        title: '${tripStats.totalTrips}',
        subtitle: 'Recorded rides',
        icon: Icons.sports_motorsports_outlined,
        iconColor: theme.colorScheme.primary,
        onTap: () => context.push('/trips'),
      ),
      _StatCard(
        title: '${tripStats.monthlyDistanceKm.toStringAsFixed(1)} km',
        subtitle: 'Ridden this month',
        icon: Icons.calendar_month_outlined,
        iconColor: theme.colorScheme.secondary,
        onTap: () => context.push('/trips'),
      ),
    ];

    if (isWide) {
      return Row(
        children: cards
            .map((c) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: c,
                  ),
                ))
            .toList(),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 8),
            Expanded(child: cards[1]),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: cards[2]),
            const SizedBox(width: 8),
            Expanded(child: cards[3]),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant
                            .withOpacity(0.75),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// D. Improved Next Major Checkpoint Card with Progress Bar
class _NextMajorCheckpointCard extends StatelessWidget {
  const _NextMajorCheckpointCard({
    required this.checkpointKm,
    required this.currentKm,
    required this.tasks,
    required this.overview,
  });

  final int checkpointKm;
  final int? currentKm;
  final List<ScheduledTaskStatus> tasks;
  final MaintenanceOverview overview;

  void _showCheckpointSheet(BuildContext context) {
    if (tasks.isEmpty) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        maxChildSize: 0.90,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Icon(
                  Icons.flag_rounded,
                  color: Theme.of(ctx).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Checkpoint ${StatusText.km(checkpointKm)} Schedule (${tasks.length})',
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final t in tasks)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(ctx)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.4),
                    child: Icon(
                      t.actionCode == ActionCode.replace
                          ? Icons.build_circle_outlined
                          : Icons.search,
                      size: 20,
                      color: Theme.of(ctx).colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    '${t.item.name} · ${t.actionCode.label} (${t.actionCode.code})',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Category: ${t.category.name} · Scheduled at ${StatusText.km(checkpointKm)}',
                  ),
                  trailing: StatusChip(status: t.status),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/maintenance/item/${t.item.id}');
                  },
                ),
              ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: () {
                Navigator.pop(ctx);
                context.go('/maintenance');
              },
              icon: const Icon(Icons.calendar_month),
              label: const Text('Open Full Maintenance Schedule'),
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

    // Calculate progress between previous checkpoint and next checkpoint
    final prevCp = overview.availableCheckpointsKm
            .where((cp) => cp < checkpointKm)
            .lastOrNull ??
        0;
    final span = checkpointKm - prevCp;
    final double progress;
    if (currentKm == null || span <= 0) {
      progress = 0.0;
    } else if (currentKm! >= checkpointKm) {
      progress = 1.0;
    } else {
      progress = ((currentKm! - prevCp) / span).clamp(0.0, 1.0);
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showCheckpointSheet(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.flag_rounded,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Next major maintenance checkpoint',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Schedule',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Odometer Milestone Figures
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    StatusText.km(checkpointKm),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  if (rem != null)
                    Text(
                      '(${StatusText.remainingKm(rem)})',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: rem <= 0
                            ? StatusColors.overdue
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 7,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  color: rem != null && rem <= 0
                      ? StatusColors.overdue
                      : theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${(progress * 100).toInt()}% of checkpoint interval',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color:
                            theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Current: ${currentKm != null ? StatusText.km(currentKm!) : "—"}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),

              // Breakdown Chips
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _CheckpointTag(
                    icon: Icons.search_rounded,
                    label: '$inspectCount Inspect',
                    color: StatusColors.inspection,
                  ),
                  _CheckpointTag(
                    icon: Icons.build_circle_outlined,
                    label: '$replaceCount Replace',
                    color: StatusColors.replacement,
                  ),
                  _CheckpointTag(
                    icon: Icons.cleaning_services_outlined,
                    label: '$cleanCount Clean / Service',
                    color: StatusColors.good,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckpointTag extends StatelessWidget {
  const _CheckpointTag({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// E. Responsive Two-Column Grid of Quick Action Cards
class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({required this.isWide});
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: Icons.speed_rounded,
        title: 'Update Odometer',
        subtitle: 'Log current km',
        onTap: () => context.push('/odometer'),
      ),
      _ActionItem(
        icon: Icons.add_task_rounded,
        title: 'Add Maintenance',
        subtitle: 'Log service & parts',
        onTap: () => context.push('/maintenance/record'),
      ),
      _ActionItem(
        icon: Icons.fact_check_outlined,
        title: 'Inspection Guide',
        subtitle: 'Schedules & rules',
        onTap: () => context.go('/maintenance'),
      ),
      _ActionItem(
        icon: Icons.straighten_rounded,
        title: 'Record Measurement',
        subtitle: 'Tire & brake wear',
        onTap: () => context.go('/components'),
      ),
      _ActionItem(
        icon: Icons.map_outlined,
        title: 'Live Map & GPS',
        subtitle: 'Navigation & tracking',
        onTap: () => context.push('/map'),
      ),
      _ActionItem(
        icon: Icons.route_rounded,
        title: 'Ride History & Trips',
        subtitle: 'Trip logs & replay',
        onTap: () => context.push('/trips'),
      ),
      _ActionItem(
        icon: Icons.tune_rounded,
        title: 'CVT Configurations',
        subtitle: 'Rollers, belt & spring',
        onTap: () => context.push('/cvt'),
      ),
      _ActionItem(
        icon: Icons.auto_stories_outlined,
        title: 'OEM Parts Catalogue',
        subtitle: 'Schematics & numbers',
        onTap: () => context.push('/parts'),
      ),
    ];

    final int crossAxisCount = isWide ? 4 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 76,
      ),
      itemBuilder: (context, index) {
        final a = actions[index];
        return _ActionCardWidget(item: a);
      },
    );
  }
}

class _ActionItem {
  const _ActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}

class _ActionCardWidget extends StatelessWidget {
  const _ActionCardWidget({required this.item});
  final _ActionItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.icon,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color:
                            theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                        fontSize: 10.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showStatusItemsSheet(
  BuildContext context,
  MaintenanceOverview overview,
  MaintenanceStatus s,
) {
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
          'No ${s.label.toLowerCase()} maintenance items right now.',
        ),
      ),
    );
    return;
  }

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      maxChildSize: 0.90,
      builder: (_, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${s.label} Maintenance (${list.length})',
                style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
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
                final defaultAction = (item.evaluation.next?.next?.actionCode ??
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
                Icon(
                  Icons.route_rounded,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ride History & Trips',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/trips'),
                  child: const Text('View All'),
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
            const Divider(height: 20),
            recentAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (recent) {
                if (recent.isEmpty) {
                  return Text(
                    'No trips logged yet. Tap Live Map & GPS or Ride History to start tracking.',
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
                Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Active CVT Setup',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
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
                            horizontal: 8,
                            vertical: 2,
                          ),
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
                Icon(
                  Icons.auto_stories_rounded,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Honda ADV 160 OEM Parts Catalogue',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
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
              'Official Honda 18K0WP01 catalogue with exploded schematics, factory part numbers, and replacement integration.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.settings_input_component, size: 16),
                  label: const Text('Drive Belt 23100-K1Z-N21'),
                  onPressed: () => context.push('/parts'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.album_outlined, size: 16),
                  label: const Text('Front Brake Pad 06455-K84-902'),
                  onPressed: () => context.push('/parts'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.air, size: 16),
                  label: const Text('Air Cleaner 17220-K2S-N00'),
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
      const SizedBox(height: 2),
      Text(
        value,
        style: t.titleSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
    ]);
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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

  void _showUnscheduledSheet(BuildContext context) {
    final list = overview.unscheduled.toList();
    if (list.isEmpty) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        maxChildSize: 0.90,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Condition / Custom Items (${list.length})',
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
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
          onTap: () => _showStatusItemsSheet(context, overview, s),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surfaceContainer,
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withOpacity(0.3),
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
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.6),
                ),
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
