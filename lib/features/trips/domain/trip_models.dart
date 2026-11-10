import 'dart:convert';
import '../../../core/database/app_database.dart';

enum TripCategory {
  commute('COMMUTE', 'Daily Commute'),
  work('WORK', 'Work'),
  leisure('LEISURE', 'Leisure'),
  touring('TOURING', 'Long-Distance / Touring'),
  other('OTHER', 'Other');

  const TripCategory(this.code, this.label);
  final String code;
  final String label;

  static TripCategory fromCode(String code) {
    for (final c in values) {
      if (c.code == code) return c;
    }
    return TripCategory.other;
  }
}

class TripWaypointItem {
  const TripWaypointItem({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.speedKmh,
    this.heading,
    this.accuracyMeters,
    required this.recordedAt,
    required this.sequence,
  });

  final double latitude;
  final double longitude;
  final double? altitude;
  final double? speedKmh;
  final double? heading;
  final double? accuracyMeters;
  final DateTime recordedAt;
  final int sequence;

  factory TripWaypointItem.fromRow(TripWaypoint row) {
    return TripWaypointItem(
      latitude: row.latitude,
      longitude: row.longitude,
      altitude: row.altitude,
      speedKmh: row.speedKmh,
      heading: row.heading,
      accuracyMeters: row.accuracyMeters,
      recordedAt: row.recordedAt,
      sequence: row.sequence,
    );
  }
}

class TripDetail {
  const TripDetail({
    required this.id,
    required this.motorcycleId,
    required this.title,
    required this.category,
    this.origin,
    this.destination,
    this.startOdometerKm,
    this.endOdometerKm,
    required this.distanceKm,
    required this.startTime,
    this.endTime,
    required this.durationSeconds,
    this.avgSpeedKmh,
    this.maxSpeedKmh,
    required this.isGpsTracked,
    this.notes,
    this.photoPaths = const [],
    required this.createdAt,
    this.waypoints = const [],
  });

  final int id;
  final int motorcycleId;
  final String title;
  final TripCategory category;
  final String? origin;
  final String? destination;
  final int? startOdometerKm;
  final int? endOdometerKm;
  final double distanceKm;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds;
  final double? avgSpeedKmh;
  final double? maxSpeedKmh;
  final bool isGpsTracked;
  final String? notes;
  final List<String> photoPaths;
  final DateTime createdAt;
  final List<TripWaypointItem> waypoints;

  factory TripDetail.fromRow(Trip row,
      [List<TripWaypoint> waypoints = const []]) {
    List<String> photos = [];
    if (row.photoPaths != null && row.photoPaths!.isNotEmpty) {
      try {
        final decoded = jsonDecode(row.photoPaths!);
        if (decoded is List) {
          photos = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }

    return TripDetail(
      id: row.id,
      motorcycleId: row.motorcycleId,
      title: row.title,
      category: TripCategory.fromCode(row.category),
      origin: row.origin,
      destination: row.destination,
      startOdometerKm: row.startOdometerKm,
      endOdometerKm: row.endOdometerKm,
      distanceKm: row.distanceKm,
      startTime: row.startTime,
      endTime: row.endTime,
      durationSeconds: row.durationSeconds,
      avgSpeedKmh: row.avgSpeedKmh,
      maxSpeedKmh: row.maxSpeedKmh,
      isGpsTracked: row.isGpsTracked,
      notes: row.notes,
      photoPaths: photos,
      createdAt: row.createdAt,
      waypoints: waypoints.map(TripWaypointItem.fromRow).toList(),
    );
  }
}

class NewTripInput {
  const NewTripInput({
    required this.motorcycleId,
    required this.title,
    required this.category,
    this.origin,
    this.destination,
    this.startOdometerKm,
    this.endOdometerKm,
    required this.distanceKm,
    required this.startTime,
    this.endTime,
    required this.durationSeconds,
    this.avgSpeedKmh,
    this.maxSpeedKmh,
    this.isGpsTracked = false,
    this.notes,
    this.photoPaths = const [],
    this.waypoints = const [],
  });

  final int motorcycleId;
  final String title;
  final TripCategory category;
  final String? origin;
  final String? destination;
  final int? startOdometerKm;
  final int? endOdometerKm;
  final double distanceKm;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds;
  final double? avgSpeedKmh;
  final double? maxSpeedKmh;
  final bool isGpsTracked;
  final String? notes;
  final List<String> photoPaths;
  final List<TripWaypointItem> waypoints;
}

class TripStats {
  const TripStats({
    required this.totalDistanceKm,
    required this.totalTrips,
    required this.avgDistanceKm,
    required this.longestDistanceKm,
    required this.monthlyDistanceKm,
  });

  final double totalDistanceKm;
  final int totalTrips;
  final double avgDistanceKm;
  final double longestDistanceKm;
  final double monthlyDistanceKm;
}
