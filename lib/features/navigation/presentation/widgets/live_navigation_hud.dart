import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:adv_mon/features/trips/data/gps_tracking_service.dart';
import 'package:adv_mon/features/trips/presentation/trips_view_model.dart';
import '../../domain/navigation_models.dart';
import '../map_view_model.dart';

/// Live motorcycle navigation HUD overlay displaying:
/// - Real-time digital speedometer (km/h)
/// - Direction / bearing compass chip
/// - GPS accuracy & signal quality pill
/// - Follow-me & Heading-up camera toggles
/// - Seamless start/pause/resume trip recording controls
class LiveNavigationHud extends ConsumerWidget {
  const LiveNavigationHud({
    super.key,
    required this.onStartTrip,
    required this.onPauseTrip,
    required this.onResumeTrip,
    required this.onStopTrip,
  });

  final VoidCallback onStartTrip;
  final VoidCallback onPauseTrip;
  final VoidCallback onResumeTrip;
  final VoidCallback onStopTrip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapViewModelProvider);
    final gpsService = ref.watch(gpsTrackingServiceProvider);
    final gpsSnapshot = ref.watch(liveGpsTrackingProvider).valueOrNull ??
        gpsService.currentSnapshot;

    final pos = mapState.currentPosition;
    final theme = Theme.of(context);
    final isRecording = gpsSnapshot.state == TrackingState.recording;
    final isPaused = gpsSnapshot.state == TrackingState.paused;

    final speed = pos != null ? pos.speedKmh : 0.0;
    final speedText = speed.toStringAsFixed(0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top HUD: Speedometer, Bearing, and GPS Precision
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Digital Motorcycle Speedometer Card
            Material(
              color: Colors.black.withAlpha(210),
              borderRadius: BorderRadius.circular(16),
              elevation: 4,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      speedText,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KM/H',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          _getCompassDirection(pos?.heading ?? 0),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),

            // Right column: GPS Signal Pill & Camera Follow/Heading controls
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _GpsAccuracyBadge(position: pos),
                const SizedBox(height: 8),

                // Heading-Up vs North-Up Mode Toggle
                Material(
                  color: mapState.isHeadingUpMode
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surface.withAlpha(235),
                  shape: const CircleBorder(),
                  elevation: 3,
                  child: IconButton(
                    tooltip: mapState.isHeadingUpMode
                        ? 'Heading-Up (Tap for North-Up)'
                        : 'North-Up (Tap for Heading-Up)',
                    icon: Icon(
                      mapState.isHeadingUpMode
                          ? Icons.explore
                          : Icons.explore_off_outlined,
                      color: mapState.isHeadingUpMode
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                    ),
                    onPressed: () {
                      ref
                          .read(mapViewModelProvider.notifier)
                          .toggleHeadingUpMode();
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // Recenter / Follow-Me Button
                Material(
                  color: mapState.isFollowLocationEnabled
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface.withAlpha(235),
                  shape: const CircleBorder(),
                  elevation: 3,
                  child: IconButton(
                    tooltip: mapState.isFollowLocationEnabled
                        ? 'Following Motorcycle'
                        : 'Recenter on Motorcycle',
                    icon: Icon(
                      mapState.isFollowLocationEnabled
                          ? Icons.my_location
                          : Icons.location_searching,
                      color: mapState.isFollowLocationEnabled
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                    ),
                    onPressed: () {
                      ref
                          .read(mapViewModelProvider.notifier)
                          .recenterOnMotorcycle();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Bottom HUD: Trip Recording Telemetry & Action Controls
        if (isRecording || isPaused)
          Material(
            color: Colors.black.withAlpha(210),
            borderRadius: BorderRadius.circular(16),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Blinking / Red Recording Dot
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRecording ? Colors.redAccent : Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Distance traveled
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DISTANCE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                        ),
                      ),
                      Text(
                        '${gpsSnapshot.distanceKm.toStringAsFixed(2)} km',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 18),

                  // Duration
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TIME',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                        ),
                      ),
                      Text(
                        _formatDuration(gpsSnapshot.durationSeconds),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Pause / Resume
                  IconButton(
                    tooltip: isRecording ? 'Pause Trip' : 'Resume Trip',
                    icon: Icon(
                      isRecording ? Icons.pause_circle : Icons.play_circle,
                      color: isRecording ? Colors.amber : Colors.greenAccent,
                      size: 32,
                    ),
                    onPressed: isRecording ? onPauseTrip : onResumeTrip,
                  ),

                  // Stop & Save
                  IconButton(
                    tooltip: 'Finish & Save Trip',
                    icon: const Icon(
                      Icons.stop_circle,
                      color: Colors.redAccent,
                      size: 32,
                    ),
                    onPressed: onStopTrip,
                  ),
                ],
              ),
            ),
          )
        else
          // Not recording: Floating "Start Ride" Quick Pill
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(24),
              elevation: 4,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: onStartTrip,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.fiber_manual_record,
                          color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Start Recording Ride',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _getCompassDirection(double bearing) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW', 'N'];
    final normalized = (bearing % 360 + 360) % 360;
    final index = ((normalized + 22.5) ~/ 45) % 8;
    return '${directions[index]} ${normalized.toStringAsFixed(0)}°';
  }
}

class _GpsAccuracyBadge extends StatelessWidget {
  const _GpsAccuracyBadge({required this.position});
  final MotorcycleGpsPosition? position;

  @override
  Widget build(BuildContext context) {
    final quality = position?.signalQuality ?? GpsSignalQuality.searching;
    Color badgeColor = Colors.redAccent;
    String label = 'Searching GPS';

    switch (quality) {
      case GpsSignalQuality.good:
        badgeColor = Colors.greenAccent;
        label = 'GPS ±${position!.accuracyMeters.toStringAsFixed(0)}m';
        break;
      case GpsSignalQuality.fair:
        badgeColor = Colors.amberAccent;
        label = 'GPS ±${position!.accuracyMeters.toStringAsFixed(0)}m';
        break;
      case GpsSignalQuality.poor:
        badgeColor = Colors.orangeAccent;
        label = 'GPS Low';
        break;
      case GpsSignalQuality.searching:
        badgeColor = Colors.redAccent;
        label = 'Searching GPS';
        break;
    }

    return Material(
      color: Colors.black.withAlpha(200),
      borderRadius: BorderRadius.circular(20),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
