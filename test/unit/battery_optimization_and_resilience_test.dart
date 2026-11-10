import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

import 'package:adv_mon/features/navigation/data/live_location_service.dart';
import 'package:adv_mon/features/navigation/domain/map_config.dart';
import 'package:adv_mon/features/navigation/domain/navigation_models.dart';
import 'package:adv_mon/features/navigation/presentation/map_view_model.dart';
import 'package:adv_mon/features/trips/data/gps_tracking_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase H: Testing, Optimization, and Battery Usage Improvements', () {
    test('GpsTrackingService adapts distance threshold for battery efficiency',
        () async {
      final service = GpsTrackingService(
        positionStreamOverride: const Stream.empty(),
      );

      await service.startTracking();

      // First point
      service.processIncomingPosition(
        Position(
          longitude: 121.0500,
          latitude: 14.5800,
          timestamp: DateTime.now(),
          accuracy: 5.0,
          altitude: 20.0,
          heading: 90.0,
          speed: 0.0,
          speedAccuracy: 1.0,
          altitudeAccuracy: 1.0,
          headingAccuracy: 1.0,
        ),
      );

      expect(service.currentSnapshot.waypoints.length, 1);

      // Micro drift when stationary (1.8 meters away) is filtered
      service.processIncomingPosition(
        Position(
          longitude: 121.05001,
          latitude: 14.58001,
          timestamp: DateTime.now().add(const Duration(seconds: 1)),
          accuracy: 5.0,
          altitude: 20.0,
          heading: 90.0,
          speed: 0.5 / 3.6, // 0.5 km/h
          speedAccuracy: 1.0,
          altitudeAccuracy: 1.0,
          headingAccuracy: 1.0,
        ),
      );

      expect(service.currentSnapshot.waypoints.length, 1); // ignored

      // Enable Battery Saver mode
      service.setBatterySaver(true);
      expect(service.isBatterySaverEnabled, isTrue);

      // 3.0 meters drift when stationary is filtered under battery saver mode
      service.processIncomingPosition(
        Position(
          longitude: 121.050025,
          latitude: 14.580025,
          timestamp: DateTime.now().add(const Duration(seconds: 2)),
          accuracy: 5.0,
          altitude: 20.0,
          heading: 90.0,
          speed: 0.5 / 3.6,
          speedAccuracy: 1.0,
          altitudeAccuracy: 1.0,
          headingAccuracy: 1.0,
        ),
      );

      expect(service.currentSnapshot.waypoints.length,
          1); // filtered by battery saver threshold (3.5m)

      service.stopTracking();
    });

    test(
        'GpsTrackingService preserves hairpin turn apex even below cruising threshold',
        () async {
      final service = GpsTrackingService(
        positionStreamOverride: const Stream.empty(),
      );

      await service.startTracking();

      final t0 = DateTime(2026, 11, 10, 10, 0, 0);

      // Point 1: entering Marilaque curve heading east (90 deg)
      service.processIncomingPosition(
        Position(
          longitude: 121.0500,
          latitude: 14.5800,
          timestamp: t0,
          accuracy: 4.0,
          altitude: 300.0,
          heading: 90.0,
          speed: 50.0 / 3.6, // 50 km/h cruising
          speedAccuracy: 1.0,
          altitudeAccuracy: 1.0,
          headingAccuracy: 1.0,
        ),
      );

      expect(service.currentSnapshot.waypoints.length, 1);

      // Point 2: 4 meters later, rider executes a sharp hairpin turn (heading changes from 90 to 145 = 55 deg turn)
      service.processIncomingPosition(
        Position(
          longitude: 121.050035,
          latitude: 14.58002,
          timestamp: t0.add(const Duration(milliseconds: 300)),
          accuracy: 4.0,
          altitude: 302.0,
          heading: 145.0, // > 18 deg turn!
          speed: 48.0 / 3.6,
          speedAccuracy: 1.0,
          altitudeAccuracy: 1.0,
          headingAccuracy: 1.0,
        ),
      );

      // Hairpin apex must be preserved despite being under the 6m cruising threshold
      expect(service.currentSnapshot.waypoints.length, 2);
      expect(service.currentSnapshot.waypoints.last.heading, 145.0);

      service.stopTracking();
    });

    test(
        'LiveLocationService toggles battery saver mode without breaking stream',
        () {
      final service = LiveLocationService(
        positionStreamOverride: const Stream.empty(),
      );

      expect(service.isBatterySaverMode, isFalse);

      service.setBatterySaverMode(true);
      expect(service.isBatterySaverMode, isTrue);

      service.setBatterySaverMode(false);
      expect(service.isBatterySaverMode, isFalse);

      service.dispose();
    });

    test(
        'MapViewModel battery saver mode activates OLED dark matter and dampens heading jitter',
        () {
      final vm = MapViewModel();

      expect(vm.state.isBatterySaverMode, isFalse);
      expect(vm.state.activeConfig.type, MapTileProviderType.openStreetMap);

      // Enable Battery Saver Mode
      vm.toggleBatterySaverMode();
      expect(vm.state.isBatterySaverMode, isTrue);
      // OLED night mode reduces display power on motorcycle handlebar mounts
      expect(vm.state.activeConfig.type, MapTileProviderType.cartoDbDarkMatter);

      // Simulate heading-up mode
      vm.toggleHeadingUpMode();
      expect(vm.state.isHeadingUpMode, isTrue);

      // Heading update with minor jitter (2.0 degrees change)
      final posJitter = MotorcycleGpsPosition(
        latitude: 14.5800,
        longitude: 121.0500,
        speedKmh: 30.0,
        heading: 2.0, // change from 0.0 is 2.0 < 3.5 deg threshold
        accuracyMeters: 4.0,
        timestamp: DateTime.now(),
      );

      vm.onLocationUpdated(posJitter);
      // Rotation remains dampened (0.0) to save GPU/rendering cycles
      expect(vm.state.rotation, 0.0);

      // Heading update with deliberate turn (35.0 degrees change)
      final posTurn = MotorcycleGpsPosition(
        latitude: 14.5805,
        longitude: 121.0505,
        speedKmh: 30.0,
        heading: 35.0, // > 3.5 deg threshold
        accuracyMeters: 4.0,
        timestamp: DateTime.now(),
      );

      vm.onLocationUpdated(posTurn);
      expect(vm.state.rotation, 35.0);

      // Disable Battery Saver Mode
      vm.toggleBatterySaverMode();
      expect(vm.state.isBatterySaverMode, isFalse);
      expect(vm.state.activeConfig.type, MapTileProviderType.openStreetMap);
    });
  });
}
