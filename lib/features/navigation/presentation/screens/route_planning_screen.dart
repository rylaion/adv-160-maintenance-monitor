import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:adv_mon/features/motorcycle/presentation/motorcycle_view_model.dart';
import '../../domain/route_models.dart';
import '../map_view_model.dart';
import '../route_planning_view_model.dart';
import '../widgets/interactive_osm_map.dart';

/// Dedicated Route Planning & Destination Search Screen for ADV 160 riders.
class RoutePlanningScreen extends ConsumerStatefulWidget {
  const RoutePlanningScreen({super.key});

  @override
  ConsumerState<RoutePlanningScreen> createState() =>
      _RoutePlanningScreenState();
}

class _RoutePlanningScreenState extends ConsumerState<RoutePlanningScreen> {
  final TextEditingController _destSearchCtrl = TextEditingController();
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentPos = ref.read(mapViewModelProvider).currentPosition;
      if (currentPos != null) {
        ref
            .read(routePlanningViewModelProvider.notifier)
            .setOriginFromCurrentLocation(currentPos.latLng);
      }
    });
  }

  @override
  void dispose() {
    _destSearchCtrl.dispose();
    super.dispose();
  }

  Future<void> _savePlannedRoute(PlannedRoute route) async {
    final bike = await ref.read(primaryMotorcycleProvider.future);
    if (bike == null || !mounted) return;

    final repo = ref.read(savedRoutesRepositoryProvider);
    final planState = ref.read(routePlanningViewModelProvider);

    final nameCtrl = TextEditingController(
      text: '${planState.destination?.shortName ?? "Planned"} Ride',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Save Planned Route'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(
            labelText: 'Route Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await repo.saveRoute(
        motorcycleId: bike.id,
        name: nameCtrl.text.trim().isEmpty
            ? 'Planned Ride'
            : nameCtrl.text.trim(),
        route: route,
        originName: planState.origin?.shortName,
        destinationName: planState.destination?.shortName,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Route saved to Saved Routes!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(routePlanningViewModelProvider);
    final planNotifier = ref.read(routePlanningViewModelProvider.notifier);
    final theme = Theme.of(context);

    // Build polylines for interactive map
    final polylines = <Polyline>[];
    for (var i = 0; i < planState.routes.length; i++) {
      final r = planState.routes[i];
      final isSelected = i == planState.selectedRouteIndex;
      polylines.add(
        Polyline(
          points: r.polyline,
          strokeWidth: isSelected ? 5.0 : 3.5,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withAlpha(150),
        ),
      );
    }

    final selectedRoute = planState.selectedRoute;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Motorcycle Route Planning'),
        actions: [
          if (selectedRoute != null)
            IconButton(
              icon: const Icon(Icons.bookmark_add_outlined),
              tooltip: 'Save Route',
              onPressed: () => _savePlannedRoute(selectedRoute),
            ),
        ],
      ),
      body: Column(
        children: [
          // Input Header Section
          Material(
            elevation: 3,
            color: theme.colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Origin Row
                  Row(
                    children: [
                      const Icon(Icons.my_location,
                          color: Colors.green, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          planState.origin?.displayName ??
                              'Select Origin (Tap to set)',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.swap_vert),
                        tooltip: 'Swap Origin and Destination',
                        onPressed: planNotifier.swapOriginDestination,
                      ),
                    ],
                  ),
                  const Divider(height: 12),

                  // Destination Row
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.redAccent, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _destSearchCtrl,
                          decoration: InputDecoration(
                            hintText: 'Search destination or landmark...',
                            isDense: true,
                            border: InputBorder.none,
                            suffixIcon: _destSearchCtrl.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _destSearchCtrl.clear();
                                      planNotifier.searchLocations('');
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (val) => planNotifier.searchLocations(val),
                        ),
                      ),
                    ],
                  ),

                  // Motorcycle expressway avoidance badge toggle
                  const SizedBox(height: 8),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: planNotifier.toggleAvoidExpressways,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            planState.preferences.avoidExpressways
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Avoid Expressways & Tollways (Honda ADV 160 sub-400cc safe)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Search Results Dropdown Overlay
                  if (planState.isSearching)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: LinearProgressIndicator(),
                    ),
                  if (planState.searchResults.isNotEmpty)
                    Container(
                      constraints: const BoxConstraints(maxHeight: 180),
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: planState.searchResults.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (ctx, i) {
                          final item = planState.searchResults[i];
                          return ListTile(
                            dense: true,
                            leading: Icon(
                              item.category == 'scenic'
                                  ? Icons.landscape
                                  : item.category == 'service'
                                      ? Icons.build
                                      : item.category == 'gas_station'
                                          ? Icons.local_gas_station
                                          : Icons.place,
                              size: 20,
                            ),
                            title: Text(item.shortName),
                            subtitle: Text(
                              item.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              _destSearchCtrl.text = item.shortName;
                              planNotifier.setDestination(item);
                              planNotifier.searchLocations('');
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Interactive Map Area showing calculated route
          Expanded(
            child: Stack(
              children: [
                InteractiveOsmMap(
                  mapController: _mapController,
                  showControls: true,
                  initialCenter: planState.origin?.coordinates,
                  extraLayers: [
                    if (polylines.isNotEmpty)
                      PolylineLayer(polylines: polylines),
                    if (planState.origin != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: planState.origin!.coordinates,
                            width: 32,
                            height: 32,
                            child: const Icon(Icons.trip_origin,
                                color: Colors.green, size: 28),
                          ),
                        ],
                      ),
                    if (planState.destination != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: planState.destination!.coordinates,
                            width: 36,
                            height: 36,
                            child: const Icon(Icons.location_on,
                                color: Colors.redAccent, size: 32),
                          ),
                        ],
                      ),
                  ],
                ),

                if (planState.isCalculating)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

                // Bottom Route Comparison Drawer
                if (planState.routes.isNotEmpty)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 20,
                    child: Material(
                      color: theme.colorScheme.surface.withAlpha(245),
                      borderRadius: BorderRadius.circular(20),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Route Option Selector Pills
                            Row(
                              children: [
                                for (var idx = 0;
                                    idx < planState.routes.length;
                                    idx++) ...[
                                  Expanded(
                                    child: ChoiceChip(
                                      selected:
                                          planState.selectedRouteIndex == idx,
                                      label: Text(
                                        '${planState.routes[idx].distanceKm.toStringAsFixed(1)} km · ${planState.routes[idx].durationMinutes}m',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      onSelected: (_) =>
                                          planNotifier.selectRoute(idx),
                                    ),
                                  ),
                                  if (idx < planState.routes.length - 1)
                                    const SizedBox(width: 8),
                                ],
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Selected Route Details
                            if (selectedRoute != null) ...[
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${selectedRoute.durationMinutes} min',
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      Text(
                                        '${selectedRoute.distanceKm.toStringAsFixed(1)} km · ${selectedRoute.summary}',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  FilledButton.icon(
                                    icon: const Icon(Icons.navigation),
                                    label: const Text('Start'),
                                    onPressed: () {
                                      ref
                                          .read(
                                              navigationGuidanceServiceProvider)
                                          .startGuidance(selectedRoute);
                                      if (!ref
                                          .read(mapViewModelProvider)
                                          .isHeadingUpMode) {
                                        ref
                                            .read(mapViewModelProvider.notifier)
                                            .toggleHeadingUpMode();
                                      }
                                      context.push('/map');
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
