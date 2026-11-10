import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:drift/native.dart';

import 'package:adv_mon/core/database/app_database.dart';
import 'package:adv_mon/features/navigation/data/geocoding_service.dart';
import 'package:adv_mon/features/navigation/data/motorcycle_routing_service.dart';
import 'package:adv_mon/features/navigation/data/saved_routes_repository.dart';
import 'package:adv_mon/features/navigation/domain/route_models.dart';
import 'package:adv_mon/features/navigation/presentation/route_planning_view_model.dart';

void main() {
  group('Phase D: Route Planning and Destination Search', () {
    test('GeocodingService matches curated motorcycle landmarks offline',
        () async {
      final service = GeocodingService();

      final results = await service.search('Marilaque');
      expect(results, isNotEmpty);
      final marilaque = results.first;
      expect(marilaque.shortName, 'Marilaque Highway Viewpoint');
      expect(marilaque.category, 'scenic');
      expect(marilaque.latitude, closeTo(14.6152, 0.001));
      expect(marilaque.longitude, closeTo(121.3654, 0.001));

      final honda = await service.search('Honda Safety');
      expect(honda, isNotEmpty);
      expect(honda.first.shortName, contains('Honda Safety Driving Center'));
      expect(honda.first.category, 'service');
    });

    test(
        'MotorcycleRoutingPreferences defaults to avoiding expressways for ADV 160',
        () {
      const prefs = MotorcycleRoutingPreferences();
      // ADV 160 (156.9cc) is legally prohibited from expressways in the Philippines
      expect(prefs.avoidExpressways, isTrue);
      expect(prefs.avoidTolls, isTrue);
      expect(prefs.preferScenicSecondaryRoads, isFalse);
    });

    test(
        'MotorcycleRoutingService produces valid offline trajectory with distance & duration',
        () async {
      final routing = MotorcycleRoutingService();
      const origin = LatLng(14.5547, 121.0244); // Makati
      const destination = LatLng(14.6152, 121.3654); // Tanay Sierra Madre

      final routes = await routing.calculateRoutes(
        origin: origin,
        destination: destination,
        preferences: const MotorcycleRoutingPreferences(avoidExpressways: true),
      );

      expect(routes, isNotEmpty);
      final primary = routes.first;
      expect(primary.distanceKm, greaterThan(0));
      expect(primary.durationMinutes, greaterThan(0));
      expect(primary.polyline.length, greaterThanOrEqualTo(2));
      expect(primary.summary, contains('Motorcycle Route'));
    });

    test(
        'SavedRoutesRepository saves, lists, and deletes locations and routes in Drift SQLite',
        () async {
      final db = AppDatabase(NativeDatabase.memory());
      final repo = SavedRoutesRepository(db);

      // 1. Save favorite destination
      final locId = await repo.saveLocation(
        name: 'Marilaque Coffee Stop',
        category: 'scenic',
        latitude: 14.6152,
        longitude: 121.3654,
        address: 'Marilaque Hwy, Tanay',
      );
      expect(locId, greaterThan(0));

      final locations = await repo.watchSavedLocations().first;
      expect(locations.length, 1);
      expect(locations.first.name, 'Marilaque Coffee Stop');
      expect(locations.first.category, 'scenic');

      // 2. Save planned motorcycle route
      const mockRoute = PlannedRoute(
        id: 'route_0',
        name: 'Sierra Madre Loop',
        distanceKm: 52.4,
        durationMinutes: 85,
        polyline: [
          LatLng(14.55, 121.02),
          LatLng(14.58, 121.15),
          LatLng(14.61, 121.36),
        ],
        summary: 'Via Antipolo - Teresa - Tanay Bypass (No Expressways)',
      );

      final routeId = await repo.saveRoute(
        motorcycleId: 1,
        name: 'Sierra Madre Loop',
        route: mockRoute,
        originName: 'Home',
        destinationName: 'Tanay Cafe',
        notes: 'Great winding curves, avoid afternoon rain',
      );
      expect(routeId, greaterThan(0));

      final routes = await repo.watchSavedRoutes(1).first;
      expect(routes.length, 1);
      final saved = routes.first;
      expect(saved.name, 'Sierra Madre Loop');
      expect(saved.distanceKm, 52.4);
      expect(saved.durationMinutes, 85);
      expect(saved.originName, 'Home');

      // Parse stored JSON polyline back
      final points =
          SavedRoutesRepository.parseWaypointsJson(saved.waypointsJson);
      expect(points.length, 3);
      expect(points.first.latitude, 14.55);

      // 3. Delete location & route
      await repo.deleteLocation(locId);
      final locationsAfter = await repo.watchSavedLocations().first;
      expect(locationsAfter, isEmpty);

      await repo.deleteRoute(routeId);
      final routesAfter = await repo.watchSavedRoutes(1).first;
      expect(routesAfter, isEmpty);

      await db.close();
    });

    test('RoutePlanningViewModel manages state and route calculation correctly',
        () async {
      final geocoding = GeocodingService();
      final routing = MotorcycleRoutingService();
      final vm = RoutePlanningViewModel(geocoding, routing);

      // Set origin
      vm.setOriginFromCurrentLocation(const LatLng(14.5547, 121.0244));
      expect(vm.state.origin, isNotNull);
      expect(vm.state.origin!.shortName, 'Current Location');

      // Search and set destination
      await vm.searchLocations('Marilaque');
      expect(vm.state.searchResults, isNotEmpty);

      vm.setDestination(vm.state.searchResults.first);
      expect(vm.state.destination, isNotNull);
      expect(vm.state.destination!.shortName, 'Marilaque Highway Viewpoint');

      // Calculate route
      await vm.calculateRoute();
      expect(vm.state.routes, isNotEmpty);
      expect(vm.state.selectedRoute, isNotNull);
      expect(vm.state.selectedRoute!.distanceKm, greaterThan(0));

      // Swap origin and destination
      final prevOrigin = vm.state.origin;
      final prevDest = vm.state.destination;
      vm.swapOriginDestination();
      expect(vm.state.origin, prevDest);
      expect(vm.state.destination, prevOrigin);

      // Toggle expressway avoidance
      expect(vm.state.preferences.avoidExpressways, isTrue);
      vm.toggleAvoidExpressways();
      expect(vm.state.preferences.avoidExpressways, isFalse);
    });
  });
}
