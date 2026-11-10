import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

/// Geocoding location search result.
@immutable
class SearchResultLocation {
  const SearchResultLocation({
    required this.displayName,
    required this.shortName,
    required this.latitude,
    required this.longitude,
    this.category = 'location',
    this.address,
  });

  final String displayName;
  final String shortName;
  final double latitude;
  final double longitude;
  final String category;
  final String? address;

  LatLng get coordinates => LatLng(latitude, longitude);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResultLocation &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          shortName == other.shortName;

  @override
  int get hashCode =>
      latitude.hashCode ^ longitude.hashCode ^ shortName.hashCode;
}

/// Preferences specific to motorcycle navigation.
/// For sub-400cc scooters like Honda ADV 160 (156.9cc), Philippine expressways
/// and restricted tollways are prohibited by law (RA 2000).
@immutable
class MotorcycleRoutingPreferences {
  const MotorcycleRoutingPreferences({
    this.avoidExpressways = true,
    this.avoidTolls = true,
    this.preferScenicSecondaryRoads = false,
  });

  final bool avoidExpressways;
  final bool avoidTolls;
  final bool preferScenicSecondaryRoads;

  MotorcycleRoutingPreferences copyWith({
    bool? avoidExpressways,
    bool? avoidTolls,
    bool? preferScenicSecondaryRoads,
  }) {
    return MotorcycleRoutingPreferences(
      avoidExpressways: avoidExpressways ?? this.avoidExpressways,
      avoidTolls: avoidTolls ?? this.avoidTolls,
      preferScenicSecondaryRoads:
          preferScenicSecondaryRoads ?? this.preferScenicSecondaryRoads,
    );
  }
}

/// Turn-by-turn route step instruction.
@immutable
class RouteStepInstruction {
  const RouteStepInstruction({
    required this.instruction,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.modifier,
    this.streetName,
    required this.coordinates,
  });

  final String instruction;
  final double distanceMeters;
  final int durationSeconds;
  final String modifier; // 'left', 'right', 'straight', 'u-turn', etc.
  final String? streetName;
  final LatLng coordinates;
}

/// Calculated planned route ready for display and navigation.
@immutable
class PlannedRoute {
  const PlannedRoute({
    required this.id,
    required this.name,
    required this.distanceKm,
    required this.durationMinutes,
    required this.polyline,
    this.isAlternative = false,
    required this.summary,
    this.steps = const [],
    this.isOfflineEstimated = false,
  });

  final String id;
  final String name;
  final double distanceKm;
  final int durationMinutes;
  final List<LatLng> polyline;
  final bool isAlternative;
  final String summary;
  final List<RouteStepInstruction> steps;
  final bool isOfflineEstimated;

  PlannedRoute copyWith({
    String? id,
    String? name,
    double? distanceKm,
    int? durationMinutes,
    List<LatLng>? polyline,
    bool? isAlternative,
    String? summary,
    List<RouteStepInstruction>? steps,
    bool? isOfflineEstimated,
  }) {
    return PlannedRoute(
      id: id ?? this.id,
      name: name ?? this.name,
      distanceKm: distanceKm ?? this.distanceKm,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      polyline: polyline ?? this.polyline,
      isAlternative: isAlternative ?? this.isAlternative,
      summary: summary ?? this.summary,
      steps: steps ?? this.steps,
      isOfflineEstimated: isOfflineEstimated ?? this.isOfflineEstimated,
    );
  }
}

/// Saved destination or waypoint item.
@immutable
class SavedLocationItem {
  const SavedLocationItem({
    required this.id,
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String category;
  final double latitude;
  final double longitude;
  final String? address;
  final DateTime createdAt;

  LatLng get coordinates => LatLng(latitude, longitude);
}
