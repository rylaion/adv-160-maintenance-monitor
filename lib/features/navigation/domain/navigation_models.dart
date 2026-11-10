import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

/// GPS accuracy quality classification.
enum GpsSignalQuality {
  searching,
  poor,
  fair,
  good,
}

/// Real-time motorcycle GPS telemetry and position information.
@immutable
class MotorcycleGpsPosition {
  const MotorcycleGpsPosition({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.speedKmh = 0.0,
    this.heading = 0.0,
    this.accuracyMeters = 0.0,
    required this.timestamp,
  });

  final double latitude;
  final double longitude;
  final double? altitude;
  final double speedKmh;
  final double heading; // 0.0 to 360.0 degrees (0 = North)
  final double accuracyMeters;
  final DateTime timestamp;

  LatLng get latLng => LatLng(latitude, longitude);

  /// Classifies current GPS precision quality.
  GpsSignalQuality get signalQuality {
    if (accuracyMeters <= 0) return GpsSignalQuality.searching;
    if (accuracyMeters <= 10) return GpsSignalQuality.good;
    if (accuracyMeters <= 30) return GpsSignalQuality.fair;
    return GpsSignalQuality.poor;
  }

  MotorcycleGpsPosition copyWith({
    double? latitude,
    double? longitude,
    double? altitude,
    double? speedKmh,
    double? heading,
    double? accuracyMeters,
    DateTime? timestamp,
  }) {
    return MotorcycleGpsPosition(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      speedKmh: speedKmh ?? this.speedKmh,
      heading: heading ?? this.heading,
      accuracyMeters: accuracyMeters ?? this.accuracyMeters,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MotorcycleGpsPosition &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          speedKmh == other.speedKmh &&
          heading == other.heading &&
          accuracyMeters == other.accuracyMeters &&
          timestamp == other.timestamp;

  @override
  int get hashCode =>
      latitude.hashCode ^
      longitude.hashCode ^
      speedKmh.hashCode ^
      heading.hashCode ^
      accuracyMeters.hashCode ^
      timestamp.hashCode;
}
