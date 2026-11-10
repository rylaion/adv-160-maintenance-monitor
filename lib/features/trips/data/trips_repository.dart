import 'dart:convert';
import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/exceptions/user_facing_exception.dart';
import '../../odometer/data/odometer_repository.dart';
import '../domain/trip_models.dart';

class TripException implements UserFacingException {
  const TripException(this.message);
  @override
  final String message;
  @override
  String toString() => message;
}

class TripsRepository {
  TripsRepository(this._db, this._odometer, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final OdometerRepository _odometer;
  final DateTime Function() _clock;

  Stream<List<TripDetail>> watchTrips(int motorcycleId) {
    final q = _db.select(_db.trips)
      ..where((t) => t.motorcycleId.equals(motorcycleId))
      ..orderBy([(t) => OrderingTerm.desc(t.startTime)]);

    return q
        .watch()
        .map((rows) => rows.map((r) => TripDetail.fromRow(r)).toList());
  }

  Future<List<TripDetail>> getRecentTrips(int motorcycleId,
      {int limit = 5}) async {
    final rows = await (_db.select(_db.trips)
          ..where((t) => t.motorcycleId.equals(motorcycleId))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
          ..limit(limit))
        .get();
    return rows.map((r) => TripDetail.fromRow(r)).toList();
  }

  Future<TripDetail?> getTripById(int tripId) async {
    final tripRow = await (_db.select(_db.trips)
          ..where((t) => t.id.equals(tripId)))
        .getSingleOrNull();
    if (tripRow == null) return null;

    final waypoints = await (_db.select(_db.tripWaypoints)
          ..where((t) => t.tripId.equals(tripId))
          ..orderBy([(t) => OrderingTerm.asc(t.sequence)]))
        .get();

    return TripDetail.fromRow(tripRow, waypoints);
  }

  Future<TripStats> getStats(int motorcycleId) async {
    final allTrips = await (_db.select(_db.trips)
          ..where((t) => t.motorcycleId.equals(motorcycleId)))
        .get();

    if (allTrips.isEmpty) {
      return const TripStats(
        totalDistanceKm: 0,
        totalTrips: 0,
        avgDistanceKm: 0,
        longestDistanceKm: 0,
        monthlyDistanceKm: 0,
      );
    }

    double totalDist = 0;
    double longest = 0;
    double monthly = 0;
    final now = _clock();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    for (final t in allTrips) {
      totalDist += t.distanceKm;
      if (t.distanceKm > longest) longest = t.distanceKm;
      if (t.startTime.isAfter(firstDayOfMonth) ||
          t.startTime.isAtSameMomentAs(firstDayOfMonth)) {
        monthly += t.distanceKm;
      }
    }

    final avg = totalDist / allTrips.length;

    return TripStats(
      totalDistanceKm: totalDist,
      totalTrips: allTrips.length,
      avgDistanceKm: avg,
      longestDistanceKm: longest,
      monthlyDistanceKm: monthly,
    );
  }

  Future<int> saveTrip(NewTripInput input) {
    return _db.transaction(() async {
      // 1. Validation
      if (input.title.trim().isEmpty) {
        throw const TripException('Trip title cannot be empty.');
      }
      if (input.distanceKm < 0) {
        throw const TripException('Distance cannot be negative.');
      }
      if (input.startOdometerKm != null && input.endOdometerKm != null) {
        if (input.endOdometerKm! < input.startOdometerKm!) {
          throw const TripException(
              'Ending odometer cannot be lower than starting odometer.');
        }
      }

      final photosJson =
          input.photoPaths.isEmpty ? null : jsonEncode(input.photoPaths);

      final tripId = await _db.into(_db.trips).insert(
            TripsCompanion.insert(
              motorcycleId: input.motorcycleId,
              title: input.title.trim(),
              category: input.category.code,
              origin: Value(input.origin?.trim()),
              destination: Value(input.destination?.trim()),
              startOdometerKm: Value(input.startOdometerKm),
              endOdometerKm: Value(input.endOdometerKm),
              distanceKm: input.distanceKm,
              startTime: input.startTime,
              endTime: Value(input.endTime),
              durationSeconds: Value(input.durationSeconds),
              avgSpeedKmh: Value(input.avgSpeedKmh),
              maxSpeedKmh: Value(input.maxSpeedKmh),
              isGpsTracked: Value(input.isGpsTracked),
              notes: Value(input.notes?.trim()),
              photoPaths: Value(photosJson),
              createdAt: _clock(),
            ),
          );

      // Insert waypoints if any
      if (input.waypoints.isNotEmpty) {
        for (var i = 0; i < input.waypoints.length; i++) {
          final wp = input.waypoints[i];
          await _db.into(_db.tripWaypoints).insert(
                TripWaypointsCompanion.insert(
                  tripId: tripId,
                  latitude: wp.latitude,
                  longitude: wp.longitude,
                  altitude: Value(wp.altitude),
                  speedKmh: Value(wp.speedKmh),
                  heading: Value(wp.heading),
                  accuracyMeters: Value(wp.accuracyMeters),
                  recordedAt: wp.recordedAt,
                  sequence: i,
                ),
              );
        }
      }

      // Odometer Integration:
      // If endOdometerKm is provided and valid, check against existing latest confirmed odometer.
      // Update the odometer ONLY when ending reading is strictly greater than latest confirmed odometer.
      if (input.endOdometerKm != null && input.endOdometerKm! > 0) {
        final latestOdo = await _odometer.latestConfirmed(input.motorcycleId);
        final currentKm = latestOdo?.readingKm ?? 0;
        if (input.endOdometerKm! > currentKm) {
          await _odometer.insert(
            motorcycleId: input.motorcycleId,
            readingKm: input.endOdometerKm!,
            date: input.endTime ?? input.startTime,
            notes: 'Recorded from trip: ${input.title.trim()}',
            createdAt: _clock(),
          );
        }
      }

      return tripId;
    });
  }

  Future<void> updateTrip({
    required int tripId,
    required String title,
    required TripCategory category,
    String? origin,
    String? destination,
    String? notes,
    List<String> photoPaths = const [],
  }) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      throw const TripException('Trip title cannot be empty.');
    }

    final photosJson = photoPaths.isEmpty ? null : jsonEncode(photoPaths);

    await (_db.update(_db.trips)..where((t) => t.id.equals(tripId))).write(
      TripsCompanion(
        title: Value(trimmedTitle),
        category: Value(category.code),
        origin: Value(origin?.trim()),
        destination: Value(destination?.trim()),
        notes: Value(notes?.trim()),
        photoPaths: Value(photosJson),
      ),
    );
  }

  Future<void> deleteTrip(int tripId) async {
    await (_db.delete(_db.trips)..where((t) => t.id.equals(tripId))).go();
  }
}
