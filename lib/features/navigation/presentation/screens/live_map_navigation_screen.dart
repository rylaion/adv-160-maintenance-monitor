import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:adv_mon/features/motorcycle/presentation/motorcycle_view_model.dart';
import 'package:adv_mon/features/trips/domain/trip_models.dart';
import 'package:adv_mon/features/trips/presentation/trips_view_model.dart';
import '../../domain/navigation_models.dart';
import '../map_view_model.dart';
import '../route_planning_view_model.dart';
import '../widgets/interactive_osm_map.dart';
import '../widgets/live_navigation_hud.dart';
import '../widgets/motorcycle_location_marker.dart';
import '../widgets/turn_by_turn_banner.dart';

/// Dedicated Live Map & Navigation screen featuring OpenStreetMap.
/// Displays live motorcycle position, directional heading, live speed HUD,
/// GPS accuracy indicator, and follow-me navigation tracking.
class LiveMapNavigationScreen extends ConsumerStatefulWidget {
  const LiveMapNavigationScreen({super.key});

  @override
  ConsumerState<LiveMapNavigationScreen> createState() =>
      _LiveMapNavigationScreenState();
}

class _LiveMapNavigationScreenState
    extends ConsumerState<LiveMapNavigationScreen> {
  final MapController _mapController = MapController();
  bool _isSavingTrip = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(liveLocationServiceProvider).startLocationUpdates();
    });
  }

  void _handleStartTrip() {
    ref.read(gpsTrackingServiceProvider).startTracking();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('GPS Trip recording started.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handlePauseTrip() {
    ref.read(gpsTrackingServiceProvider).pauseTracking();
  }

  void _handleResumeTrip() {
    ref.read(gpsTrackingServiceProvider).resumeTracking();
  }

  Future<void> _handleStopTrip() async {
    final gpsService = ref.read(gpsTrackingServiceProvider);
    final snapshot = gpsService.currentSnapshot;

    if (snapshot.waypoints.isEmpty && snapshot.distanceKm < 0.05) {
      gpsService.stopTracking();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip discarded (no distance recorded).')),
      );
      return;
    }

    final bike = await ref.read(primaryMotorcycleProvider.future);
    if (bike == null || !mounted) return;

    final titleCtrl = TextEditingController(
      text:
          'Ride on ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Save Recorded Trip'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Distance: ${snapshot.distanceKm.toStringAsFixed(2)} km'),
            Text('Duration: ${(snapshot.durationSeconds ~/ 60)} mins'),
            Text('Avg Speed: ${snapshot.avgSpeedKmh.toStringAsFixed(1)} km/h'),
            const SizedBox(height: 12),
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Trip Title',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Discard'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Save to History'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isSavingTrip = true);
      final input = NewTripInput(
        motorcycleId: bike.id,
        title: titleCtrl.text.trim().isEmpty ? 'Ride' : titleCtrl.text.trim(),
        category: TripCategory.leisure,
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
      gpsService.stopTracking();

      if (mounted) {
        setState(() => _isSavingTrip = false);
        if (err == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Trip saved to Ride History!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving trip: $err')),
          );
        }
      }
    } else {
      gpsService.stopTracking();
    }
  }

  @override
  Widget build(BuildContext context) {
    final guidanceService = ref.watch(navigationGuidanceServiceProvider);
    final guidanceSnapshot = ref.watch(activeGuidanceProvider).valueOrNull ??
        guidanceService.currentSnapshot;

    // Listen to live GPS telemetry stream
    ref.listen<AsyncValue<MotorcycleGpsPosition>>(
      liveMotorcyclePositionProvider,
      (prev, next) {
        final pos = next.valueOrNull;
        if (pos != null) {
          ref.read(mapViewModelProvider.notifier).onLocationUpdated(pos);
          final mapState = ref.read(mapViewModelProvider);
          if (mapState.isFollowLocationEnabled) {
            _mapController.move(pos.latLng, _mapController.camera.zoom);
          }
          if (mapState.isHeadingUpMode && pos.speedKmh > 1.5) {
            _mapController.rotate(pos.heading);
          }

          if (ref
              .read(navigationGuidanceServiceProvider)
              .currentSnapshot
              .isActive) {
            ref
                .read(navigationGuidanceServiceProvider)
                .updateRiderLocation(pos);
          }
        }
      },
    );

    final mapState = ref.watch(mapViewModelProvider);
    final theme = Theme.of(context);
    final isNightMode = mapState.activeConfig.isDarkThemed;
    final locService = ref.watch(liveLocationServiceProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen Interactive OSM Map with Motorcycle Marker & Route
          InteractiveOsmMap(
            mapController: _mapController,
            showControls: true,
            extraLayers: [
              if (guidanceSnapshot.isActive && guidanceSnapshot.route != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: guidanceSnapshot.route!.polyline,
                      strokeWidth: 5.5,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ...MotorcycleLocationMarker.buildLayers(
                context: context,
                position: mapState.currentPosition,
                showAccuracyCircle: true,
              ),
            ],
          ),

          // Top Cockpit Bar (Back, Active Style, Night Ride Toggle)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    // Back button
                    Material(
                      color: theme.colorScheme.surface.withAlpha(235),
                      shape: const CircleBorder(),
                      elevation: 3,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        tooltip: 'Back',
                        onPressed: () => context.pop(),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Active Provider Badge
                    Expanded(
                      child: Material(
                        color: theme.colorScheme.surface.withAlpha(235),
                        borderRadius: BorderRadius.circular(24),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          child: Row(
                            children: [
                              Icon(
                                isNightMode
                                    ? Icons.nightlight_round
                                    : Icons.map_outlined,
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  mapState.activeConfig.name,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'z${mapState.zoom.toStringAsFixed(1)}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Route Planning Launcher
                    Material(
                      color: theme.colorScheme.surface.withAlpha(235),
                      shape: const CircleBorder(),
                      elevation: 3,
                      child: IconButton(
                        icon: const Icon(Icons.alt_route,
                            color: Colors.blueAccent),
                        tooltip: 'Plan Motorcycle Route',
                        onPressed: () => context.push('/map/plan'),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Offline Maps Manager Launcher
                    Material(
                      color: theme.colorScheme.surface.withAlpha(235),
                      shape: const CircleBorder(),
                      elevation: 3,
                      child: IconButton(
                        icon: const Icon(Icons.download_for_offline,
                            color: Colors.amber),
                        tooltip: 'Offline Maps & Regions',
                        onPressed: () => context.push('/map/offline'),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Quick Night Ride Toggle
                    Material(
                      color: theme.colorScheme.surface.withAlpha(235),
                      shape: const CircleBorder(),
                      elevation: 3,
                      child: IconButton(
                        icon: Icon(
                          isNightMode ? Icons.wb_sunny : Icons.nightlight,
                          color: isNightMode ? Colors.amber : Colors.blueGrey,
                        ),
                        tooltip: isNightMode ? 'Day Mode' : 'Night Ride Mode',
                        onPressed: () {
                          ref
                              .read(mapViewModelProvider.notifier)
                              .toggleNightMode();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Battery Saver Mode Toggle
                    Material(
                      color: theme.colorScheme.surface.withAlpha(235),
                      shape: const CircleBorder(),
                      elevation: 3,
                      child: IconButton(
                        icon: Icon(
                          mapState.isBatterySaverMode
                              ? Icons.battery_saver
                              : Icons.battery_charging_full,
                          color: mapState.isBatterySaverMode
                              ? Colors.green
                              : Colors.blueGrey,
                        ),
                        tooltip: mapState.isBatterySaverMode
                            ? 'Battery Saver Active'
                            : 'Enable Battery Saver',
                        onPressed: () {
                          final next = !mapState.isBatterySaverMode;
                          ref
                              .read(mapViewModelProvider.notifier)
                              .toggleBatterySaverMode();
                          ref
                              .read(liveLocationServiceProvider)
                              .setBatterySaverMode(next);
                          ref
                              .read(gpsTrackingServiceProvider)
                              .setBatterySaver(next);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Location Error / Permission Banner (if applicable)
          if (locService.errorMessage != null)
            Positioned(
              top: 80,
              left: 16,
              right: 16,
              child: Material(
                color: Colors.amber.shade900.withAlpha(230),
                borderRadius: BorderRadius.circular(12),
                elevation: 4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          locService.errorMessage!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                      TextButton(
                        onPressed: () => locService.startLocationUpdates(),
                        child: const Text('RETRY',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Turn-by-Turn Instruction Banner
          if (guidanceSnapshot.isActive)
            Positioned(
              top: 72,
              left: 16,
              right: 16,
              child: TurnByTurnBanner(
                snapshot: guidanceSnapshot,
                voiceService: ref.watch(voiceGuidanceServiceProvider),
                onCancel: () => ref
                    .read(navigationGuidanceServiceProvider)
                    .cancelGuidance(),
              ),
            ),

          // Live Navigation Cockpit HUD (Speedometer, Compass, Accuracy & Trip Control)
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: LiveNavigationHud(
              onStartTrip: _handleStartTrip,
              onPauseTrip: _handlePauseTrip,
              onResumeTrip: _handleResumeTrip,
              onStopTrip: _handleStopTrip,
            ),
          ),

          if (_isSavingTrip)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
