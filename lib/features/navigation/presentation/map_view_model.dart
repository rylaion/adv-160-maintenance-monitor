import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../data/live_location_service.dart';
import '../domain/map_config.dart';
import '../domain/navigation_models.dart';

/// State of the interactive map viewer and navigation canvas.
class MapViewState {
  const MapViewState({
    required this.activeConfig,
    required this.center,
    this.zoom = 15.0,
    this.rotation = 0.0,
    this.isFollowLocationEnabled = true,
    this.isHeadingUpMode = false,
    this.isNightModeForced = false,
    this.isBatterySaverMode = false,
    this.availableConfigs = const [],
    this.currentPosition,
  });

  final MapTileConfig activeConfig;
  final LatLng center;
  final double zoom;
  final double rotation;
  final bool isFollowLocationEnabled;
  final bool isHeadingUpMode;
  final bool isNightModeForced;
  final bool isBatterySaverMode;
  final List<MapTileConfig> availableConfigs;
  final MotorcycleGpsPosition? currentPosition;

  MapViewState copyWith({
    MapTileConfig? activeConfig,
    LatLng? center,
    double? zoom,
    double? rotation,
    bool? isFollowLocationEnabled,
    bool? isHeadingUpMode,
    bool? isNightModeForced,
    bool? isBatterySaverMode,
    List<MapTileConfig>? availableConfigs,
    MotorcycleGpsPosition? currentPosition,
  }) {
    return MapViewState(
      activeConfig: activeConfig ?? this.activeConfig,
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
      rotation: rotation ?? this.rotation,
      isFollowLocationEnabled:
          isFollowLocationEnabled ?? this.isFollowLocationEnabled,
      isHeadingUpMode: isHeadingUpMode ?? this.isHeadingUpMode,
      isNightModeForced: isNightModeForced ?? this.isNightModeForced,
      isBatterySaverMode: isBatterySaverMode ?? this.isBatterySaverMode,
      availableConfigs: availableConfigs ?? this.availableConfigs,
      currentPosition: currentPosition ?? this.currentPosition,
    );
  }
}

class MapViewModel extends StateNotifier<MapViewState> {
  MapViewModel()
      : super(
          MapViewState(
            activeConfig: MapTileConfig.osmStandard(),
            center: const LatLng(14.5995, 120.9842),
            zoom: 15.0,
            rotation: 0.0,
            isFollowLocationEnabled: true,
            isHeadingUpMode: false,
            availableConfigs: [
              MapTileConfig.osmStandard(),
              MapTileConfig.nightMode(),
              MapTileConfig.dayVoyager(),
              MapTileConfig.openTopo(),
            ],
          ),
        );

  /// Select active tile style / server.
  void setTileProvider(MapTileConfig config) {
    state = state.copyWith(activeConfig: config);
  }

  /// Toggle high-contrast dark theme map for night riding.
  void toggleNightMode() {
    if (state.activeConfig.type == MapTileProviderType.cartoDbDarkMatter) {
      state = state.copyWith(
        activeConfig: MapTileConfig.osmStandard(),
        isNightModeForced: false,
      );
    } else {
      state = state.copyWith(
        activeConfig: MapTileConfig.nightMode(),
        isNightModeForced: true,
      );
    }
  }

  /// Update map camera parameters (center, zoom, rotation bearing).
  void updateCamera({
    LatLng? center,
    double? zoom,
    double? rotation,
    bool? fromUserGesture,
  }) {
    // If the camera moved because the user explicitly panned the map,
    // automatically disengage follow-my-location mode.
    final follow =
        fromUserGesture == true ? false : state.isFollowLocationEnabled;

    state = state.copyWith(
      center: center,
      zoom: zoom,
      rotation: rotation,
      isFollowLocationEnabled: follow,
    );
  }

  /// Toggle battery saver mode: enables OLED dark mode and dampens micro-rotations.
  void toggleBatterySaverMode() {
    final next = !state.isBatterySaverMode;
    if (next) {
      state = state.copyWith(
        isBatterySaverMode: true,
        activeConfig: MapTileConfig.nightMode(),
      );
    } else {
      state = state.copyWith(
        isBatterySaverMode: false,
        activeConfig: state.isNightModeForced
            ? MapTileConfig.nightMode()
            : MapTileConfig.osmStandard(),
      );
    }
  }

  /// Handle incoming GPS telemetry from live location stream.
  void onLocationUpdated(MotorcycleGpsPosition pos) {
    LatLng newCenter = state.center;
    double newRotation = state.rotation;

    if (state.isFollowLocationEnabled) {
      if (!state.isBatterySaverMode || pos.speedKmh > 1.5) {
        newCenter = pos.latLng;
      }
    }

    if (state.isHeadingUpMode && pos.speedKmh > 1.5) {
      final deltaHeading = (pos.heading - state.rotation).abs();
      final normalizedDelta =
          deltaHeading > 180 ? 360 - deltaHeading : deltaHeading;
      final minAngle = state.isBatterySaverMode ? 3.5 : 1.5;
      if (normalizedDelta >= minAngle) {
        newRotation = pos.heading;
      }
    }

    state = state.copyWith(
      currentPosition: pos,
      center: newCenter,
      rotation: newRotation,
    );
  }

  /// Re-center map camera on the motorcycle and re-engage follow mode.
  void recenterOnMotorcycle() {
    if (state.currentPosition != null) {
      state = state.copyWith(
        center: state.currentPosition!.latLng,
        isFollowLocationEnabled: true,
      );
    } else {
      state = state.copyWith(isFollowLocationEnabled: true);
    }
  }

  /// Toggle Heading-Up mode (map rotates with motorcycle heading vs North-Up).
  void toggleHeadingUpMode() {
    final next = !state.isHeadingUpMode;
    if (!next) {
      // Switching to North-Up: reset bearing to 0
      state = state.copyWith(
        isHeadingUpMode: false,
        rotation: 0.0,
      );
    } else {
      final currentHeading = state.currentPosition?.heading ?? 0.0;
      state = state.copyWith(
        isHeadingUpMode: true,
        rotation: currentHeading,
      );
    }
  }

  /// Toggle auto-follow mode.
  void toggleFollowLocation() {
    state = state.copyWith(
      isFollowLocationEnabled: !state.isFollowLocationEnabled,
    );
  }

  /// Set auto-follow state explicitly.
  void setFollowLocation(bool enabled) {
    state = state.copyWith(isFollowLocationEnabled: enabled);
  }

  /// Add custom self-hosted tile provider config.
  void registerCustomTileServer(MapTileConfig customConfig) {
    final updated = List<MapTileConfig>.from(state.availableConfigs);
    updated.removeWhere((c) => c.name == customConfig.name);
    updated.add(customConfig);
    state = state.copyWith(
      availableConfigs: updated,
      activeConfig: customConfig,
    );
  }

  /// Reset map bearing to true north (0.0 degrees) and disable Heading-Up mode.
  void resetNorth() {
    state = state.copyWith(
      rotation: 0.0,
      isHeadingUpMode: false,
    );
  }
}

final mapViewModelProvider =
    StateNotifierProvider<MapViewModel, MapViewState>((ref) {
  return MapViewModel();
});

final liveLocationServiceProvider = Provider<LiveLocationService>((ref) {
  final service = LiveLocationService();
  ref.onDispose(() => service.dispose());
  return service;
});

final liveMotorcyclePositionProvider =
    StreamProvider<MotorcycleGpsPosition>((ref) {
  final service = ref.watch(liveLocationServiceProvider);
  return service.positionStream;
});
