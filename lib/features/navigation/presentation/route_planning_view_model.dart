import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../shared/providers/providers.dart';
import '../data/geocoding_service.dart';
import '../data/motorcycle_routing_service.dart';
import '../data/navigation_guidance_service.dart';
import '../data/saved_routes_repository.dart';
import '../data/voice_guidance_service.dart';
import '../domain/route_models.dart';

class RoutePlanningState {
  const RoutePlanningState({
    this.origin,
    this.destination,
    this.preferences = const MotorcycleRoutingPreferences(),
    this.routes = const [],
    this.selectedRouteIndex = 0,
    this.isSearching = false,
    this.isCalculating = false,
    this.searchResults = const [],
    this.errorMessage,
  });

  final SearchResultLocation? origin;
  final SearchResultLocation? destination;
  final MotorcycleRoutingPreferences preferences;
  final List<PlannedRoute> routes;
  final int selectedRouteIndex;
  final bool isSearching;
  final bool isCalculating;
  final List<SearchResultLocation> searchResults;
  final String? errorMessage;

  PlannedRoute? get selectedRoute =>
      routes.isNotEmpty && selectedRouteIndex < routes.length
          ? routes[selectedRouteIndex]
          : null;

  RoutePlanningState copyWith({
    SearchResultLocation? origin,
    SearchResultLocation? destination,
    MotorcycleRoutingPreferences? preferences,
    List<PlannedRoute>? routes,
    int? selectedRouteIndex,
    bool? isSearching,
    bool? isCalculating,
    List<SearchResultLocation>? searchResults,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RoutePlanningState(
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      preferences: preferences ?? this.preferences,
      routes: routes ?? this.routes,
      selectedRouteIndex: selectedRouteIndex ?? this.selectedRouteIndex,
      isSearching: isSearching ?? this.isSearching,
      isCalculating: isCalculating ?? this.isCalculating,
      searchResults: searchResults ?? this.searchResults,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class RoutePlanningViewModel extends StateNotifier<RoutePlanningState> {
  RoutePlanningViewModel(this._geocoding, this._routing)
      : super(const RoutePlanningState());

  final GeocodingService _geocoding;
  final MotorcycleRoutingService _routing;

  void setOrigin(SearchResultLocation loc) {
    state = state.copyWith(origin: loc, clearError: true);
    if (state.destination != null) {
      calculateRoute();
    }
  }

  void setDestination(SearchResultLocation loc) {
    state = state.copyWith(destination: loc, clearError: true);
    calculateRoute();
  }

  void setOriginFromCurrentLocation(LatLng currentCoords) {
    final currentLoc = SearchResultLocation(
      displayName:
          'My Current Location (${currentCoords.latitude.toStringAsFixed(4)}, ${currentCoords.longitude.toStringAsFixed(4)})',
      shortName: 'Current Location',
      latitude: currentCoords.latitude,
      longitude: currentCoords.longitude,
      category: 'current_location',
    );
    setOrigin(currentLoc);
  }

  void swapOriginDestination() {
    final oldOrigin = state.origin;
    final oldDest = state.destination;
    state = state.copyWith(origin: oldDest, destination: oldOrigin);
    if (state.origin != null && state.destination != null) {
      calculateRoute();
    }
  }

  void toggleAvoidExpressways() {
    final next = state.preferences.copyWith(
      avoidExpressways: !state.preferences.avoidExpressways,
    );
    state = state.copyWith(preferences: next);
    if (state.origin != null && state.destination != null) {
      calculateRoute();
    }
  }

  void selectRoute(int index) {
    if (index >= 0 && index < state.routes.length) {
      state = state.copyWith(selectedRouteIndex: index);
    }
  }

  Future<void> searchLocations(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(searchResults: [], isSearching: false);
      return;
    }

    state = state.copyWith(isSearching: true, clearError: true);
    try {
      final results = await _geocoding.search(query);
      state = state.copyWith(searchResults: results, isSearching: false);
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        errorMessage: 'Search failed: $e',
      );
    }
  }

  Future<void> calculateRoute() async {
    if (state.origin == null || state.destination == null) return;

    state = state.copyWith(isCalculating: true, clearError: true);
    try {
      final routes = await _routing.calculateRoutes(
        origin: state.origin!.coordinates,
        destination: state.destination!.coordinates,
        preferences: state.preferences,
      );

      state = state.copyWith(
        routes: routes,
        selectedRouteIndex: 0,
        isCalculating: false,
      );
    } catch (e) {
      state = state.copyWith(
        isCalculating: false,
        errorMessage: 'Route calculation failed: $e',
      );
    }
  }

  void clearRoutes() {
    state = const RoutePlanningState();
  }
}

final geocodingServiceProvider = Provider<GeocodingService>((ref) {
  return GeocodingService();
});

final motorcycleRoutingServiceProvider =
    Provider<MotorcycleRoutingService>((ref) {
  return MotorcycleRoutingService();
});

final savedRoutesRepositoryProvider = Provider<SavedRoutesRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final clock = ref.watch(clockProvider);
  return SavedRoutesRepository(db, clock: clock);
});

final savedLocationsProvider = StreamProvider<List<SavedLocationItem>>((ref) {
  return ref.watch(savedRoutesRepositoryProvider).watchSavedLocations();
});

final routePlanningViewModelProvider =
    StateNotifierProvider<RoutePlanningViewModel, RoutePlanningState>((ref) {
  final geocoding = ref.watch(geocodingServiceProvider);
  final routing = ref.watch(motorcycleRoutingServiceProvider);
  return RoutePlanningViewModel(geocoding, routing);
});

final voiceGuidanceServiceProvider = Provider<VoiceGuidanceService>((ref) {
  return VoiceGuidanceService();
});

final navigationGuidanceServiceProvider =
    Provider<NavigationGuidanceService>((ref) {
  final routing = ref.watch(motorcycleRoutingServiceProvider);
  final voice = ref.watch(voiceGuidanceServiceProvider);
  final service = NavigationGuidanceService(
    routingService: routing,
    voiceService: voice,
  );
  ref.onDispose(() => service.dispose());
  return service;
});

final activeGuidanceProvider = StreamProvider<GuidanceSnapshot>((ref) {
  final service = ref.watch(navigationGuidanceServiceProvider);
  return service.snapshotStream;
});
