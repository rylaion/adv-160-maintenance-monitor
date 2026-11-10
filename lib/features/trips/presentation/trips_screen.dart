import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/date_utils.dart';
import 'trips_view_model.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripsListProvider);
    final statsAsync = ref.watch(tripStatsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride History & Trips'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            tooltip: 'Live Map',
            onPressed: () => context.push('/map'),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Manual Trip Entry',
            onPressed: () => context.push('/trips/add'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/trips/track'),
        icon: const Icon(Icons.gps_fixed),
        label: const Text('Record Ride (GPS)'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        children: [
          statsAsync.when(
            loading: () => const Center(child: LinearProgressIndicator()),
            error: (e, _) => const SizedBox.shrink(),
            data: (stats) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Riding Statistics',
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryStat(
                            label: 'Total Distance',
                            value:
                                '${stats.totalDistanceKm.toStringAsFixed(1)} km',
                          ),
                        ),
                        Expanded(
                          child: _SummaryStat(
                            label: 'Total Trips',
                            value: '${stats.totalTrips}',
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryStat(
                            label: 'Average Trip',
                            value:
                                '${stats.avgDistanceKm.toStringAsFixed(1)} km',
                          ),
                        ),
                        Expanded(
                          child: _SummaryStat(
                            label: 'This Month',
                            value:
                                '${stats.monthlyDistanceKm.toStringAsFixed(1)} km',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('All Recorded Trips', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          tripsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error loading trips: $e')),
            data: (trips) {
              if (trips.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Icon(Icons.two_wheeler,
                            size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        const Text(
                          'No trips recorded yet.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Start live GPS tracking or log a trip manually.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => context.push('/trips/add'),
                              icon: const Icon(Icons.edit_calendar),
                              label: const Text('Manual Entry'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: () => context.push('/trips/track'),
                              icon: const Icon(Icons.gps_fixed),
                              label: const Text('Live GPS'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: trips.length,
                itemBuilder: (ctx, idx) {
                  final t = trips[idx];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Icon(
                        t.isGpsTracked ? Icons.route : Icons.motorcycle,
                        color: theme.colorScheme.primary,
                        size: 32,
                      ),
                      title: Text(t.title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text([
                        '${t.category.label} · ${t.distanceKm.toStringAsFixed(1)} km',
                        if (t.origin != null && t.destination != null)
                          '${t.origin} → ${t.destination}',
                        AppDates.formatDate(t.startTime),
                      ].join('\n')),
                      isThreeLine: true,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/trips/${t.id}'),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
