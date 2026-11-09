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

/// Dashboard driven entirely by stored data and the calculation engine.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(maintenanceOverviewProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('ADV-MON')),
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
        FilledButton.icon(
          onPressed: () => context.push('/odometer'),
          icon: const Icon(Icons.speed),
          label: const Text('Update Odometer'),
        ),
        if (o.currentKm == null)
          const _Hint('Enter your current odometer reading so mileage-based '
              'maintenance can be calculated.'),
        if (o.needsBaseline)
          const _Hint('Set the purchase date in the motorcycle profile to '
              'enable date-based schedules.'),
        if (o.skippedBeforeTracking > 0)
          _Hint('${o.skippedBeforeTracking} manufacturer checkpoint(s) before '
              'your first odometer entry are not counted as missed. Record past '
              'services to confirm them.'),
        const SizedBox(height: 16),
        Text('Status summary', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        _Summary(counts: o.statusCounts, unscheduled: o.unscheduled.length),
        if (o.overdue.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Overdue', style: theme.textTheme.titleMedium),
          ...o.overdue
              .map((i) => ItemStatusCard(status: i, showCategory: true)),
        ],
        if (o.dueSoon.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Upcoming', style: theme.textTheme.titleMedium),
          ...o.dueSoon
              .map((i) => ItemStatusCard(status: i, showCategory: true)),
        ],
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
  const _Summary({required this.counts, required this.unscheduled});
  final Map<String, int> counts;
  final int unscheduled;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    for (final s in MaintenanceStatus.values) {
      final n = counts[s.code];
      if (n == null) continue;
      chips.add(Row(mainAxisSize: MainAxisSize.min, children: [
        StatusChip(status: s),
        const SizedBox(width: 4),
        Text('$n'),
      ]));
    }
    if (chips.isEmpty) chips.add(const Text('No scheduled items'));
    return Wrap(spacing: 12, runSpacing: 4, children: [
      ...chips,
      if (unscheduled > 0) Text('$unscheduled without schedule'),
    ]);
  }
}
