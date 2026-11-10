import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../motorcycle/presentation/motorcycle_view_model.dart';
import '../data/gps_tracking_service.dart';
import '../domain/trip_models.dart';
import 'trips_view_model.dart';
import 'widgets/trip_route_map.dart';

class ActiveGpsTrackingScreen extends ConsumerStatefulWidget {
  const ActiveGpsTrackingScreen({super.key});

  @override
  ConsumerState<ActiveGpsTrackingScreen> createState() =>
      _ActiveGpsTrackingScreenState();
}

class _ActiveGpsTrackingScreenState
    extends ConsumerState<ActiveGpsTrackingScreen> {
  final _titleCtrl = TextEditingController(text: 'Live Ride');
  TripCategory _category = TripCategory.leisure;
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _endAndSaveTrip(GpsTrackingSnapshot snapshot) async {
    final bike = await ref.read(primaryMotorcycleProvider.future);
    if (bike == null) return;

    final title =
        _titleCtrl.text.trim().isEmpty ? 'Ride' : _titleCtrl.text.trim();

    setState(() => _saving = true);

    final input = NewTripInput(
      motorcycleId: bike.id,
      title: title,
      category: _category,
      distanceKm: snapshot.distanceKm,
      startTime: snapshot.startTime ?? DateTime.now(),
      endTime: DateTime.now(),
      durationSeconds: snapshot.durationSeconds,
      avgSpeedKmh: snapshot.avgSpeedKmh,
      maxSpeedKmh: snapshot.maxSpeedKmh,
      isGpsTracked: true,
      waypoints: snapshot.waypoints,
    );

    final err = await ref.read(tripActionsProvider.notifier).saveTrip(input);
    ref.read(gpsTrackingServiceProvider).stopTracking();

    if (mounted) {
      setState(() => _saving = false);
      if (err == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('GPS Trip saved successfully!')),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving trip: $err')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gpsService = ref.watch(gpsTrackingServiceProvider);
    final gpsAsync = ref.watch(liveGpsTrackingProvider);
    final snapshot = gpsAsync.valueOrNull ?? gpsService.currentSnapshot;
    final theme = Theme.of(context);

    final durationSecs = snapshot.durationSeconds;
    final hours = durationSecs ~/ 3600;
    final minutes = (durationSecs % 3600) ~/ 60;
    final seconds = durationSecs % 60;
    final timeStr = hours > 0
        ? '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
        : '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live GPS Trip'),
        actions: [
          if (snapshot.state != TrackingState.stopped)
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Discard',
              onPressed: () {
                gpsService.stopTracking();
                context.pop();
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TripRouteMap(waypoints: snapshot.waypoints, height: 260),
          const SizedBox(height: 16),
          if (snapshot.errorMessage != null)
            Card(
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: theme.colorScheme.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        snapshot.errorMessage!,
                        style: TextStyle(
                            color: theme.colorScheme.onErrorContainer),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatCol(
                        label: 'DISTANCE',
                        value: '${snapshot.distanceKm.toStringAsFixed(2)} km',
                      ),
                      _StatCol(
                        label: 'TIME',
                        value: timeStr,
                      ),
                      _StatCol(
                        label: 'SPEED',
                        value:
                            '${snapshot.currentSpeedKmh.toStringAsFixed(1)} km/h',
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatCol(
                        label: 'AVG SPEED',
                        value:
                            '${snapshot.avgSpeedKmh.toStringAsFixed(1)} km/h',
                      ),
                      _StatCol(
                        label: 'MAX SPEED',
                        value:
                            '${snapshot.maxSpeedKmh.toStringAsFixed(1)} km/h',
                      ),
                      _StatCol(
                        label: 'GPS POINTS',
                        value: '${snapshot.waypoints.length}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (snapshot.state == TrackingState.stopped) ...[
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Trip Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<TripCategory>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: TripCategory.values
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _category = v);
              },
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => gpsService.startTracking(),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Recording Ride'),
            ),
          ] else ...[
            Row(
              children: [
                if (snapshot.state == TrackingState.recording)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => gpsService.pauseTracking(),
                      icon: const Icon(Icons.pause),
                      label: const Text('Pause'),
                    ),
                  )
                else
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => gpsService.resumeTracking(),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Resume'),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _saving ? null : () => _endAndSaveTrip(snapshot),
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.stop),
                    label: const Text('Finish & Save'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCol extends StatelessWidget {
  const _StatCol({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(letterSpacing: 1.1),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
