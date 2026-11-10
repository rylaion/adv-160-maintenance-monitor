import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/map_config.dart';
import '../map_view_model.dart';

/// Interactive OpenStreetMap widget built on flutter_map.
/// Features:
/// - Smooth multi-touch pan, pinch-zoom, and rotation gestures
/// - Large motorcycle-friendly on-screen zoom and compass controls
/// - Proper OpenStreetMap attribution widget
/// - Configurable tile server (Standard OSM, Night Ride, Topo, Voyager, Self-hosted)
/// - Extensible layer slots for markers, routes, and waypoints
class InteractiveOsmMap extends ConsumerStatefulWidget {
  const InteractiveOsmMap({
    super.key,
    this.mapController,
    this.onTap,
    this.onLongPress,
    this.extraLayers = const [],
    this.showControls = true,
    this.initialCenter,
    this.initialZoom,
    this.initialRotation,
  });

  final MapController? mapController;
  final void Function(TapPosition, LatLng)? onTap;
  final void Function(TapPosition, LatLng)? onLongPress;
  final List<Widget> extraLayers;
  final bool showControls;
  final LatLng? initialCenter;
  final double? initialZoom;
  final double? initialRotation;

  @override
  ConsumerState<InteractiveOsmMap> createState() => _InteractiveOsmMapState();
}

class _InteractiveOsmMapState extends ConsumerState<InteractiveOsmMap> {
  late final MapController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.mapController != null) {
      _controller = widget.mapController!;
    } else {
      _controller = MapController();
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _zoomIn() {
    final currentZoom = _controller.camera.zoom;
    final maxZoom = ref.read(mapViewModelProvider).activeConfig.maxZoom;
    final newZoom = math.min(currentZoom + 1.0, maxZoom);
    _controller.move(_controller.camera.center, newZoom);
  }

  void _zoomOut() {
    final currentZoom = _controller.camera.zoom;
    final minZoom = ref.read(mapViewModelProvider).activeConfig.minZoom;
    final newZoom = math.max(currentZoom - 1.0, minZoom);
    _controller.move(_controller.camera.center, newZoom);
  }

  void _resetNorth() {
    _controller.rotate(0.0);
    ref.read(mapViewModelProvider.notifier).resetNorth();
  }

  void _showTileServerPicker(BuildContext context) {
    final state = ref.read(mapViewModelProvider);
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.layers_outlined,
                          color: Colors.blueAccent),
                      const SizedBox(width: 10),
                      Text(
                        'Map Tile Provider',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ...state.availableConfigs.map((cfg) {
                  final isSelected = cfg.type == state.activeConfig.type;
                  return ListTile(
                    leading: Icon(
                      cfg.isDarkThemed
                          ? Icons.nightlight_round
                          : cfg.type == MapTileProviderType.openTopoMap
                              ? Icons.terrain
                              : Icons.map,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      cfg.name,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      cfg.attribution,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle,
                            color: theme.colorScheme.primary)
                        : null,
                    onTap: () {
                      ref
                          .read(mapViewModelProvider.notifier)
                          .setTileProvider(cfg);
                      Navigator.of(ctx).pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapViewModelProvider);

    final initialCenter = widget.initialCenter ?? mapState.center;
    final initialZoom = widget.initialZoom ?? mapState.zoom;
    final initialRotation = widget.initialRotation ?? mapState.rotation;

    return Stack(
      children: [
        FlutterMap(
          mapController: _controller,
          options: MapOptions(
            initialCenter: initialCenter,
            initialZoom: initialZoom,
            initialRotation: initialRotation,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            onPositionChanged: (camera, hasGesture) {
              if (hasGesture) {
                ref.read(mapViewModelProvider.notifier).updateCamera(
                      center: camera.center,
                      zoom: camera.zoom,
                      rotation: camera.rotation,
                      fromUserGesture: true,
                    );
              }
            },
          ),
          children: [
            // OpenStreetMap Configurable Tile Layer
            TileLayer(
              key: ValueKey(mapState.activeConfig.urlTemplate),
              urlTemplate: mapState.activeConfig.urlTemplate,
              subdomains: mapState.activeConfig.subdomains,
              userAgentPackageName: mapState.activeConfig.userAgentPackageName,
              minZoom: mapState.activeConfig.minZoom,
              maxZoom: mapState.activeConfig.maxZoom,
              tileProvider: NetworkTileProvider(),
            ),

            // Additional dynamic layers (e.g., polylines, waypoints, routes)
            ...widget.extraLayers,

            // Compliant OpenStreetMap attribution banner
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  mapState.activeConfig.attribution,
                  prependCopyright: false,
                ),
              ],
            ),
          ],
        ),

        // Floating On-Screen Map Controls (Optimized for motorcycle gloves)
        if (widget.showControls)
          Positioned(
            right: 16,
            bottom: 32,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Compass / Reset North
                _MapControlButton(
                  tooltip: 'Reset North',
                  icon: Transform.rotate(
                    angle: -(mapState.rotation * (math.pi / 180)),
                    child:
                        const Icon(Icons.navigation, color: Colors.redAccent),
                  ),
                  onPressed: _resetNorth,
                ),
                const SizedBox(height: 8),

                // Tile Layer Selector
                _MapControlButton(
                  tooltip: 'Map Styles & Providers',
                  icon: const Icon(Icons.layers),
                  onPressed: () => _showTileServerPicker(context),
                ),
                const SizedBox(height: 8),

                // Zoom In
                _MapControlButton(
                  tooltip: 'Zoom In',
                  icon: const Icon(Icons.add),
                  onPressed: _zoomIn,
                ),
                const SizedBox(height: 4),

                // Zoom Out
                _MapControlButton(
                  tooltip: 'Zoom Out',
                  icon: const Icon(Icons.remove),
                  onPressed: _zoomOut,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final Widget icon;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface.withAlpha(230),
      elevation: 4,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        iconSize: 26,
        padding: const EdgeInsets.all(12),
        tooltip: tooltip,
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}
