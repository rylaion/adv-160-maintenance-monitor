import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/date_utils.dart';
import '../domain/trip_models.dart';
import 'trips_view_model.dart';
import 'widgets/trip_route_map.dart';
import 'widgets/trip_speed_chart.dart';

class TripDetailScreen extends ConsumerStatefulWidget {
  const TripDetailScreen({super.key, required this.tripId});
  final int tripId;

  @override
  ConsumerState<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen> {
  TripDetail? _trip;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTrip();
  }

  Future<void> _loadTrip() async {
    final repo = ref.read(tripsRepositoryProvider);
    final t = await repo.getTripById(widget.tripId);
    if (mounted) {
      setState(() {
        _trip = t;
        _loading = false;
      });
    }
  }

  Future<void> _deleteTrip() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Trip?'),
        content: const Text(
          'Are you sure you want to delete this trip record? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final err = await ref
          .read(tripActionsProvider.notifier)
          .deleteTrip(widget.tripId);
      if (mounted) {
        if (err == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Trip deleted successfully.')),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $err')),
          );
        }
      }
    }
  }

  Future<void> _editTrip() async {
    if (_trip == null) return;
    final titleCtrl = TextEditingController(text: _trip!.title);
    final originCtrl = TextEditingController(text: _trip!.origin ?? '');
    final destCtrl = TextEditingController(text: _trip!.destination ?? '');
    final notesCtrl = TextEditingController(text: _trip!.notes ?? '');
    TripCategory category = _trip!.category;

    final updated = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Edit Trip Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Trip Title *'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<TripCategory>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: TripCategory.values
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c.label)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => category = val);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: originCtrl,
                  decoration: const InputDecoration(labelText: 'Origin'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: destCtrl,
                  decoration: const InputDecoration(labelText: 'Destination'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (updated == true && mounted) {
      final err = await ref.read(tripActionsProvider.notifier).updateTrip(
            tripId: _trip!.id,
            title: titleCtrl.text,
            category: category,
            origin: originCtrl.text,
            destination: destCtrl.text,
            notes: notesCtrl.text,
            photoPaths: _trip!.photoPaths,
          );

      if (mounted) {
        if (err == null) {
          _loadTrip();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Trip updated successfully.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $err')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trip Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final trip = _trip;
    if (trip == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trip Details')),
        body: const Center(child: Text('Trip record not found.')),
      );
    }

    final theme = Theme.of(context);
    final durationMins = (trip.durationSeconds / 60).round();

    return Scaffold(
      appBar: AppBar(
        title: Text(trip.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Trip',
            onPressed: _editTrip,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete Trip',
            onPressed: _deleteTrip,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (trip.isGpsTracked && trip.waypoints.isNotEmpty) ...[
            TripRouteMap(
              waypoints: trip.waypoints,
              origin: trip.origin,
              destination: trip.destination,
              height: 320,
              enableReplay: true,
            ),
            const SizedBox(height: 16),
            TripSpeedChart(
              waypoints: trip.waypoints,
              avgSpeedKmh: trip.avgSpeedKmh,
              maxSpeedKmh: trip.maxSpeedKmh,
            ),
            const SizedBox(height: 16),
          ],
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          trip.category.label,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (trip.isGpsTracked)
                        Row(
                          children: [
                            Icon(Icons.gps_fixed,
                                size: 16, color: theme.colorScheme.primary),
                            const SizedBox(width: 4),
                            Text('GPS Tracked',
                                style: theme.textTheme.bodySmall),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${trip.distanceKm.toStringAsFixed(1)} km',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (trip.origin != null || trip.destination != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.route, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${trip.origin ?? 'Start'} → ${trip.destination ?? 'End'}',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.calendar_today_outlined,
                          label: 'Start Date & Time',
                          value: AppDates.formatDateTime(trip.startTime),
                        ),
                      ),
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.timer_outlined,
                          label: 'Duration',
                          value: durationMins >= 60
                              ? '${durationMins ~/ 60}h ${durationMins % 60}m'
                              : '$durationMins min',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.speed,
                          label: 'Avg Speed',
                          value: trip.avgSpeedKmh != null
                              ? '${trip.avgSpeedKmh!.toStringAsFixed(1)} km/h'
                              : '—',
                        ),
                      ),
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.speed_outlined,
                          label: 'Max Speed',
                          value: trip.maxSpeedKmh != null
                              ? '${trip.maxSpeedKmh!.toStringAsFixed(1)} km/h'
                              : '—',
                        ),
                      ),
                    ],
                  ),
                  if (trip.startOdometerKm != null ||
                      trip.endOdometerKm != null) ...[
                    const Divider(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.pin_drop_outlined,
                            label: 'Start Odometer',
                            value: trip.startOdometerKm != null
                                ? '${trip.startOdometerKm} km'
                                : '—',
                          ),
                        ),
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.pin_drop,
                            label: 'End Odometer',
                            value: trip.endOdometerKm != null
                                ? '${trip.endOdometerKm} km'
                                : '—',
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (trip.notes != null && trip.notes!.isNotEmpty) ...[
                    const Divider(height: 24),
                    Text('Notes', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(trip.notes!, style: theme.textTheme.bodyMedium),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              Text(
                value,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
