import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/trip_models.dart';
import '../controllers/trip_replay_controller.dart';

/// Interactive OpenStreetMap widget that displays recorded trip routes with:
/// - Origin & Destination markers with custom location cards
/// - Traveled polyline track
/// - Interactive Route Replay (Play/Pause, scrub slider, 1x/2x/5x/10x speed)
/// - Directional Honda ADV motorcycle marker rotating along recorded heading
/// - Live telemetry HUD (replayed speed, heading, altitude, timestamp)
/// - Fullscreen modal view mode
class TripRouteMap extends StatefulWidget {
  const TripRouteMap({
    super.key,
    required this.waypoints,
    this.origin,
    this.destination,
    this.height = 320,
    this.enableReplay = true,
  });

  final List<TripWaypointItem> waypoints;
  final String? origin;
  final String? destination;
  final double height;
  final bool enableReplay;

  @override
  State<TripRouteMap> createState() => _TripRouteMapState();
}

class _TripRouteMapState extends State<TripRouteMap> {
  late final MapController _mapController;
  late final TripReplayController _replayController;
  bool _followReplay = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _replayController = TripReplayController(waypoints: widget.waypoints);
    _replayController.addListener(_onReplayUpdate);
  }

  @override
  void didUpdateWidget(TripRouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.waypoints != widget.waypoints) {
      _replayController.removeListener(_onReplayUpdate);
      _replayController.dispose();
      _replayController = TripReplayController(waypoints: widget.waypoints);
      _replayController.addListener(_onReplayUpdate);
    }
  }

  @override
  void dispose() {
    _replayController.removeListener(_onReplayUpdate);
    _replayController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _onReplayUpdate() {
    if (mounted) {
      setState(() {});
      if (_followReplay && _replayController.currentWaypoint != null) {
        final wp = _replayController.currentWaypoint!;
        _mapController.move(
          LatLng(wp.latitude, wp.longitude),
          _mapController.camera.zoom,
        );
      }
    }
  }

  void _fitBounds(List<LatLng> points) {
    if (points.isEmpty) return;
    if (points.length == 1) {
      _mapController.move(points.first, 15.0);
      return;
    }

    final bounds = LatLngBounds.fromPoints(points);
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(40),
      ),
    );
  }

  void _openFullscreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(
            title: Text(
              widget.origin != null && widget.destination != null
                  ? '${widget.origin} → ${widget.destination}'
                  : 'Trip Route Replay',
            ),
          ),
          body: TripRouteMap(
            waypoints: widget.waypoints,
            origin: widget.origin,
            destination: widget.destination,
            height: double.infinity,
            enableReplay: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.waypoints.isEmpty) {
      return Container(
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('No GPS route coordinates recorded for this trip.'),
      );
    }

    final theme = Theme.of(context);
    final points = _replayController.fullPolyline;
    final traveledPoints = _replayController.traveledPolyline;
    final currentWp = _replayController.currentWaypoint;

    // Calculate initial map center from bounds
    final bounds = LatLngBounds.fromPoints(points);
    final center = bounds.center;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: 14.0,
                initialCameraFit: CameraFit.bounds(
                  bounds: bounds,
                  padding: const EdgeInsets.all(36),
                ),
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
                onPositionChanged: (cam, hasGesture) {
                  if (hasGesture && _followReplay) {
                    setState(() => _followReplay = false);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'com.advmon.adv_mon (ADV-MON Motorcycle Assistant)',
                ),
                // Base recorded polyline (muted)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: points,
                      strokeWidth: 4.5,
                      color: theme.colorScheme.primary.withOpacity(0.4),
                    ),
                    // Traveled polyline during replay (bright active color)
                    if (traveledPoints.length > 1)
                      Polyline(
                        points: traveledPoints,
                        strokeWidth: 5.5,
                        color: Colors.amber.shade700,
                      ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    // Start Origin Marker
                    Marker(
                      point: points.first,
                      width: 40,
                      height: 40,
                      child: Tooltip(
                        message: 'Start: ${widget.origin ?? 'Origin'}',
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    // End Destination Marker
                    if (points.length > 1)
                      Marker(
                        point: points.last,
                        width: 40,
                        height: 40,
                        child: Tooltip(
                          message:
                              'Finish: ${widget.destination ?? 'Destination'}',
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.flag,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    // Replay Motorcycle Moving Marker
                    if (currentWp != null)
                      Marker(
                        point: LatLng(currentWp.latitude, currentWp.longitude),
                        width: 44,
                        height: 44,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer pulse halo
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber.withOpacity(0.25),
                              ),
                            ),
                            // Directional icon rotating to waypoint heading
                            Transform.rotate(
                              angle: (currentWp.heading ?? 0.0) *
                                  (3.141592653589793 / 180),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.amber.shade700,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.navigation,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      '© OpenStreetMap contributors',
                      prependCopyright: false,
                    ),
                  ],
                ),
              ],
            ),

            // Top Quick Map Actions (Recenter, Fullscreen)
            Positioned(
              top: 10,
              right: 10,
              child: Column(
                children: [
                  _MapActionButton(
                    icon: Icons.fullscreen,
                    tooltip: 'Full Screen',
                    onPressed: () => _openFullscreen(context),
                  ),
                  const SizedBox(height: 6),
                  _MapActionButton(
                    icon: Icons.crop_free,
                    tooltip: 'Fit Full Route',
                    onPressed: () {
                      _fitBounds(points);
                      setState(() => _followReplay = false);
                    },
                  ),
                  const SizedBox(height: 6),
                  _MapActionButton(
                    icon: Icons.my_location,
                    tooltip: 'Follow Rider Replay',
                    color: _followReplay ? theme.colorScheme.primary : null,
                    onPressed: () {
                      setState(() => _followReplay = true);
                      if (currentWp != null) {
                        _mapController.move(
                          LatLng(currentWp.latitude, currentWp.longitude),
                          15.0,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            // Top Telemetry HUD Pill (Instantaneous Replayed Speed & Waypoint Info)
            if (currentWp != null)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade700, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.two_wheeler,
                          color: Colors.amber, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${(currentWp.speedKmh ?? 0.0).toStringAsFixed(1)} km/h',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_replayController.distanceTraveledKm.toStringAsFixed(1)} / ${_replayController.totalDistanceKm.toStringAsFixed(1)} km',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Bottom Replay Bar
            if (widget.enableReplay)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Scrubber Slider
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6),
                          trackHeight: 3.5,
                          activeTrackColor: Colors.amber,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: Colors.amber,
                          overlayColor: Colors.amber.withOpacity(0.2),
                        ),
                        child: Slider(
                          value: _replayController.progress,
                          onChanged: (val) {
                            _replayController.seekToProgress(val);
                          },
                        ),
                      ),
                      Row(
                        children: [
                          // Play / Pause Button
                          IconButton(
                            icon: Icon(
                              _replayController.isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              color: Colors.amber,
                              size: 28,
                            ),
                            tooltip: _replayController.isPlaying
                                ? 'Pause Replay'
                                : 'Play Route Replay',
                            onPressed: _replayController.togglePlayPause,
                          ),
                          // Stop / Reset
                          IconButton(
                            icon: const Icon(Icons.replay,
                                color: Colors.white70, size: 20),
                            tooltip: 'Restart from Beginning',
                            onPressed: _replayController.stop,
                          ),
                          const Spacer(),
                          // Speed Multiplier Picker (1x, 2x, 5x, 10x)
                          ...[1.0, 2.0, 5.0, 10.0].map((spd) {
                            final isSel =
                                _replayController.playbackSpeed == spd;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: InkWell(
                                onTap: () =>
                                    _replayController.setPlaybackSpeed(spd),
                                borderRadius: BorderRadius.circular(4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color:
                                        isSel ? Colors.amber : Colors.white12,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${spd.toInt()}x',
                                    style: TextStyle(
                                      color:
                                          isSel ? Colors.black : Colors.white70,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MapActionButton extends StatelessWidget {
  const _MapActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: color ?? Colors.white),
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }
}
