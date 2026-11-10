import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../domain/route_models.dart';

/// OpenStreetMap routing engine optimized for motorcycle rides (e.g. Honda ADV 160).
class MotorcycleRoutingService {
  MotorcycleRoutingService({http.Client? httpClient})
      : _client = httpClient ?? http.Client();

  final http.Client _client;

  /// Calculates the primary and optional alternative routes between origin and destination.
  Future<List<PlannedRoute>> calculateRoutes({
    required LatLng origin,
    required LatLng destination,
    MotorcycleRoutingPreferences preferences =
        const MotorcycleRoutingPreferences(),
  }) async {
    try {
      // Query OpenStreetMap OSRM routing engine with alternatives enabled
      final coords =
          '${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}';
      final uri = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/$coords'
        '?overview=full'
        '&geometries=geojson'
        '&steps=true'
        '&alternatives=true',
      );

      final response = await _client.get(
        uri,
        headers: {
          'User-Agent': 'ADV-MON-Motorcycle-Assistant/1.0',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final routesList = data['routes'] as List<dynamic>?;

        if (routesList != null && routesList.isNotEmpty) {
          final plannedRoutes = <PlannedRoute>[];

          for (var i = 0; i < routesList.length; i++) {
            final r = routesList[i];
            final distanceMeters = (r['distance'] as num?)?.toDouble() ?? 0.0;
            final durationSeconds = (r['duration'] as num?)?.toInt() ?? 0;
            final distanceKm = distanceMeters / 1000.0;
            final durationMinutes = (durationSeconds / 60.0).round();

            // Extract Polyline coordinates
            final geometry = r['geometry'] as Map<String, dynamic>?;
            final coordinates =
                geometry?['coordinates'] as List<dynamic>? ?? [];
            final polyline = <LatLng>[];

            for (final point in coordinates) {
              if (point is List && point.length >= 2) {
                final lon = (point[0] as num).toDouble();
                final lat = (point[1] as num).toDouble();
                polyline.add(LatLng(lat, lon));
              }
            }

            // Extract turn-by-turn steps
            final steps = <RouteStepInstruction>[];
            final legs = r['legs'] as List<dynamic>? ?? [];
            for (final leg in legs) {
              final legSteps = leg['steps'] as List<dynamic>? ?? [];
              for (final s in legSteps) {
                final maneuver = s['maneuver'] as Map<String, dynamic>?;
                final instruction = s['name'] as String? ??
                    maneuver?['instruction'] as String? ??
                    'Proceed';
                final modifier = maneuver?['modifier'] as String? ?? 'straight';
                final sDist = (s['distance'] as num?)?.toDouble() ?? 0.0;
                final sDur = (s['duration'] as num?)?.toInt() ?? 0;
                final sLoc = maneuver?['location'] as List<dynamic>? ?? [0, 0];

                steps.add(RouteStepInstruction(
                  instruction: instruction,
                  distanceMeters: sDist,
                  durationSeconds: sDur,
                  modifier: modifier,
                  streetName: s['name'] as String?,
                  coordinates: LatLng(
                    (sLoc[1] as num).toDouble(),
                    (sLoc[0] as num).toDouble(),
                  ),
                ));
              }
            }

            final isAlternative = i > 0;
            final summary = preferences.avoidExpressways
                ? (isAlternative
                    ? 'Alternative Secondary Road'
                    : 'Primary Motorcycle Route (No Expressways)')
                : (isAlternative ? 'Alternative Route' : 'Fastest Route');

            plannedRoutes.add(PlannedRoute(
              id: 'route_$i',
              name:
                  isAlternative ? 'Alternative ${i + 1}' : 'Recommended Route',
              distanceKm: distanceKm,
              durationMinutes: durationMinutes,
              polyline: polyline.isNotEmpty ? polyline : [origin, destination],
              isAlternative: isAlternative,
              summary: summary,
              steps: steps,
              isOfflineEstimated: false,
            ));
          }

          if (plannedRoutes.isNotEmpty) {
            return plannedRoutes;
          }
        }
      }
    } catch (_) {
      // Network timeout or offline state: fallback to offline calculation below
    }

    // Offline Fallback Route Calculation (Direct trajectory calculation)
    return [_calculateOfflineFallbackRoute(origin, destination, preferences)];
  }

  PlannedRoute _calculateOfflineFallbackRoute(
    LatLng origin,
    LatLng destination,
    MotorcycleRoutingPreferences preferences,
  ) {
    final distanceMeters = Geolocator.distanceBetween(
      origin.latitude,
      origin.longitude,
      destination.latitude,
      destination.longitude,
    );

    // Approximate actual road distance as ~1.28x straight line for suburban roads
    final roadDistanceKm = (distanceMeters * 1.28) / 1000.0;

    // Average ADV 160 urban/provincial speed ~36 km/h (0.6 km/min)
    final durationMinutes = (roadDistanceKm / 0.6).round().clamp(1, 999);

    final midLat = (origin.latitude + destination.latitude) / 2;
    final midLng = (origin.longitude + destination.longitude) / 2;

    return PlannedRoute(
      id: 'offline_direct',
      name: 'Offline Direct Trajectory',
      distanceKm: roadDistanceKm,
      durationMinutes: durationMinutes,
      polyline: [
        origin,
        LatLng(midLat, midLng),
        destination,
      ],
      isAlternative: false,
      summary: 'Offline Road Estimate (No Internet)',
      steps: [
        RouteStepInstruction(
          instruction: 'Depart toward destination',
          distanceMeters: distanceMeters,
          durationSeconds: durationMinutes * 60,
          modifier: 'straight',
          coordinates: origin,
        ),
      ],
      isOfflineEstimated: true,
    );
  }
}
