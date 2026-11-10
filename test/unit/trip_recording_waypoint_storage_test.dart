import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:drift/native.dart';

import 'package:adv_mon/core/database/app_database.dart';
import 'package:adv_mon/features/odometer/data/odometer_repository.dart';
import 'package:adv_mon/features/trips/data/gps_tracking_service.dart';
import 'package:adv_mon/features/trips/data/trips_repository.dart';
import 'package:adv_mon/features/trips/domain/trip_models.dart';

void main() {
  group('Phase C: Manual Trip Recording and GPS Waypoint Storage', () {
    test(
        'GpsTrackingService filters out invalid null island and noisy GPS readings',
        () async {
      var simulatedTime = DateTime(2026, 11, 10, 8, 0, 0);
      final service = GpsTrackingService(
        positionStreamOverride: const Stream.empty(),
        clock: () => simulatedTime,
      );

      await service.startTracking();

      // 1. Invalid null island reading (0, 0)
      service.processIncomingPosition(Position(
        longitude: 0.0,
        latitude: 0.0,
        timestamp: simulatedTime,
        accuracy: 5.0,
        altitude: 10.0,
        altitudeAccuracy: 1.0,
        heading: 0.0,
        headingAccuracy: 1.0,
        speed: 10.0,
        speedAccuracy: 1.0,
      ));
      expect(service.currentSnapshot.waypoints, isEmpty);

      // 2. Inaccurate reading (> 35 meters)
      service.processIncomingPosition(Position(
        longitude: 121.0500,
        latitude: 14.5800,
        timestamp: simulatedTime,
        accuracy: 45.0, // too noisy
        altitude: 10.0,
        altitudeAccuracy: 1.0,
        heading: 0.0,
        headingAccuracy: 1.0,
        speed: 10.0,
        speedAccuracy: 1.0,
      ));
      expect(service.currentSnapshot.waypoints, isEmpty);

      // 3. Valid reading within tolerance
      service.processIncomingPosition(Position(
        longitude: 121.0500,
        latitude: 14.5800,
        timestamp: simulatedTime,
        accuracy: 5.0,
        altitude: 20.0,
        altitudeAccuracy: 1.0,
        heading: 90.0,
        headingAccuracy: 1.0,
        speed: 8.33, // 30 km/h
        speedAccuracy: 1.0,
      ));
      expect(service.currentSnapshot.waypoints.length, 1);
      final firstWp = service.currentSnapshot.waypoints.first;
      expect(firstWp.heading, 90.0);
      expect(firstWp.accuracyMeters, 5.0);
      expect(firstWp.speedKmh, closeTo(30.0, 0.1));

      service.stopTracking();
      service.dispose();
    });

    test(
        'GpsTrackingService avoids duplicate coordinates when stopped at red light',
        () async {
      var simulatedTime = DateTime(2026, 11, 10, 8, 0, 0);
      final service = GpsTrackingService(
        positionStreamOverride: const Stream.empty(),
        clock: () => simulatedTime,
      );

      await service.startTracking();

      // First fix
      service.processIncomingPosition(Position(
        longitude: 121.0500,
        latitude: 14.5800,
        timestamp: simulatedTime,
        accuracy: 4.0,
        altitude: 15.0,
        altitudeAccuracy: 1.0,
        heading: 180.0,
        headingAccuracy: 1.0,
        speed: 10.0,
        speedAccuracy: 1.0,
      ));
      expect(service.currentSnapshot.waypoints.length, 1);

      // Stationary fix at traffic light (0.5 meter drift)
      simulatedTime = simulatedTime.add(const Duration(seconds: 3));
      service.processIncomingPosition(Position(
        longitude: 121.050002,
        latitude: 14.580002,
        timestamp: simulatedTime,
        accuracy: 4.0,
        altitude: 15.0,
        altitudeAccuracy: 1.0,
        heading: 180.0,
        headingAccuracy: 1.0,
        speed: 0.0,
        speedAccuracy: 1.0,
      ));

      // Should not duplicate waypoint in database
      expect(service.currentSnapshot.waypoints.length, 1);
      expect(service.currentSnapshot.currentSpeedKmh, 0.0);

      // Movement resumes (> 15 meters)
      simulatedTime = simulatedTime.add(const Duration(seconds: 2));
      service.processIncomingPosition(Position(
        longitude: 121.0502,
        latitude: 14.5802,
        timestamp: simulatedTime,
        accuracy: 4.0,
        altitude: 15.0,
        altitudeAccuracy: 1.0,
        heading: 180.0,
        headingAccuracy: 1.0,
        speed: 11.1, // 40 km/h
        speedAccuracy: 1.0,
      ));
      expect(service.currentSnapshot.waypoints.length, 2);

      service.stopTracking();
      service.dispose();
    });

    test('GpsTrackingService rejects unrealistic teleport jumps', () async {
      var simulatedTime = DateTime(2026, 11, 10, 8, 0, 0);
      final service = GpsTrackingService(
        positionStreamOverride: const Stream.empty(),
        clock: () => simulatedTime,
      );

      await service.startTracking();

      // Point A
      service.processIncomingPosition(Position(
        longitude: 121.0500,
        latitude: 14.5800,
        timestamp: simulatedTime,
        accuracy: 5.0,
        altitude: 10.0,
        altitudeAccuracy: 1.0,
        heading: 0.0,
        headingAccuracy: 1.0,
        speed: 10.0,
        speedAccuracy: 1.0,
      ));
      expect(service.currentSnapshot.waypoints.length, 1);

      // 1 second later: Jump to 5 km away (impossible ~18,000 km/h teleportation)
      simulatedTime = simulatedTime.add(const Duration(seconds: 1));
      service.processIncomingPosition(Position(
        longitude: 121.1000,
        latitude: 14.6200,
        timestamp: simulatedTime,
        accuracy: 5.0,
        altitude: 10.0,
        altitudeAccuracy: 1.0,
        heading: 0.0,
        headingAccuracy: 1.0,
        speed: 10.0,
        speedAccuracy: 1.0,
      ));

      // Jump point rejected
      expect(service.currentSnapshot.waypoints.length, 1);

      service.stopTracking();
      service.dispose();
    });

    test(
        'GpsTrackingService restores interrupted trip session without data loss',
        () {
      final service = GpsTrackingService();
      final startTime = DateTime(2026, 11, 10, 7, 30);

      final waypoints = [
        TripWaypointItem(
          latitude: 14.5500,
          longitude: 121.0200,
          altitude: 12.0,
          speedKmh: 42.0,
          heading: 90.0,
          accuracyMeters: 4.0,
          recordedAt: startTime,
          sequence: 0,
        ),
        TripWaypointItem(
          latitude: 14.5520,
          longitude: 121.0230,
          altitude: 14.0,
          speedKmh: 45.0,
          heading: 85.0,
          accuracyMeters: 3.5,
          recordedAt: startTime.add(const Duration(seconds: 30)),
          sequence: 1,
        ),
      ];

      service.restoreInterruptedSession(
        savedWaypoints: waypoints,
        distanceKm: 0.45,
        startTime: startTime,
        durationSeconds: 30,
        maxSpeedKmh: 45.0,
      );

      final snapshot = service.currentSnapshot;
      expect(snapshot.state, TrackingState.paused);
      expect(snapshot.waypoints.length, 2);
      expect(snapshot.distanceKm, 0.45);
      expect(snapshot.durationSeconds, 30);
      expect(snapshot.maxSpeedKmh, 45.0);
    });

    test(
        'TripsRepository stores waypoints with heading and accuracy in SQLite v9',
        () async {
      final db = AppDatabase(NativeDatabase.memory());
      final odoRepo = OdometerRepository(db);
      final tripsRepo = TripsRepository(db, odoRepo);

      final testStartTime = DateTime(2026, 11, 10, 9, 0);

      final tripInput = NewTripInput(
        motorcycleId: 1,
        title: 'Morning Commute with Full Telemetry',
        category: TripCategory.commute,
        distanceKm: 12.8,
        startTime: testStartTime,
        endTime: testStartTime.add(const Duration(minutes: 25)),
        durationSeconds: 1500,
        avgSpeedKmh: 30.7,
        maxSpeedKmh: 68.5,
        isGpsTracked: true,
        waypoints: [
          TripWaypointItem(
            latitude: 14.5500,
            longitude: 121.0200,
            altitude: 15.0,
            speedKmh: 32.0,
            heading: 135.0,
            accuracyMeters: 4.2,
            recordedAt: testStartTime,
            sequence: 0,
          ),
          TripWaypointItem(
            latitude: 14.5600,
            longitude: 121.0300,
            altitude: 18.0,
            speedKmh: 55.0,
            heading: 140.0,
            accuracyMeters: 3.8,
            recordedAt: testStartTime.add(const Duration(minutes: 5)),
            sequence: 1,
          ),
        ],
      );

      final tripId = await tripsRepo.saveTrip(tripInput);
      expect(tripId, greaterThan(0));

      final savedTrip = await tripsRepo.getTripById(tripId);
      expect(savedTrip, isNotNull);
      expect(savedTrip!.title, 'Morning Commute with Full Telemetry');
      expect(savedTrip.waypoints.length, 2);

      final wp0 = savedTrip.waypoints[0];
      expect(wp0.heading, 135.0);
      expect(wp0.accuracyMeters, 4.2);
      expect(wp0.speedKmh, 32.0);

      final wp1 = savedTrip.waypoints[1];
      expect(wp1.heading, 140.0);
      expect(wp1.accuracyMeters, 3.8);
      expect(wp1.speedKmh, 55.0);

      await db.close();
    });
  });
}
