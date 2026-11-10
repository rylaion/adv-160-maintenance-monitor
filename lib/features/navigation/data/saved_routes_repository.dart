import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/database/app_database.dart';
import '../domain/route_models.dart';

/// Repository for persistent saved favorite destinations and planned routes in Drift SQLite.
class SavedRoutesRepository {
  SavedRoutesRepository(this._db, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  Stream<List<SavedLocationItem>> watchSavedLocations() {
    final q = _db.select(_db.savedLocations)
      ..orderBy([(l) => OrderingTerm.asc(l.name)]);

    return q.watch().map((rows) => rows.map((r) {
          return SavedLocationItem(
            id: r.id,
            name: r.name,
            category: r.category,
            latitude: r.latitude,
            longitude: r.longitude,
            address: r.address,
            createdAt: r.createdAt,
          );
        }).toList());
  }

  Future<int> saveLocation({
    required String name,
    required String category,
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    return _db.into(_db.savedLocations).insert(
          SavedLocationsCompanion.insert(
            name: name.trim(),
            category: category.trim(),
            latitude: latitude,
            longitude: longitude,
            address: Value(address?.trim()),
            createdAt: _clock(),
          ),
        );
  }

  Future<void> deleteLocation(int id) async {
    await (_db.delete(_db.savedLocations)..where((l) => l.id.equals(id))).go();
  }

  Stream<List<SavedRoute>> watchSavedRoutes(int motorcycleId) {
    final q = _db.select(_db.savedRoutes)
      ..where((r) => r.motorcycleId.equals(motorcycleId))
      ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]);

    return q.watch();
  }

  Future<int> saveRoute({
    required int motorcycleId,
    required String name,
    required PlannedRoute route,
    String? originName,
    String? destinationName,
    String? notes,
  }) async {
    final waypointsList =
        route.polyline.map((p) => [p.latitude, p.longitude]).toList();
    final waypointsJson = jsonEncode(waypointsList);

    return _db.into(_db.savedRoutes).insert(
          SavedRoutesCompanion.insert(
            motorcycleId: motorcycleId,
            name: name.trim(),
            originName: Value(originName?.trim()),
            destinationName: Value(destinationName?.trim()),
            originLat: route.polyline.first.latitude,
            originLng: route.polyline.first.longitude,
            destLat: route.polyline.last.latitude,
            destLng: route.polyline.last.longitude,
            waypointsJson: Value(waypointsJson),
            distanceKm: Value(route.distanceKm),
            durationMinutes: Value(route.durationMinutes),
            notes: Value(notes?.trim()),
            createdAt: _clock(),
          ),
        );
  }

  Future<void> deleteRoute(int id) async {
    await (_db.delete(_db.savedRoutes)..where((r) => r.id.equals(id))).go();
  }

  static List<LatLng> parseWaypointsJson(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return [];
    try {
      final list = jsonDecode(jsonString) as List<dynamic>;
      return list.map((item) {
        final pair = item as List<dynamic>;
        return LatLng((pair[0] as num).toDouble(), (pair[1] as num).toDouble());
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
