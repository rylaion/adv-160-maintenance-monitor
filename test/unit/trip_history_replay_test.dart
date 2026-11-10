import 'package:flutter_test/flutter_test.dart';
import 'package:adv_mon/features/trips/domain/trip_models.dart';
import 'package:adv_mon/features/trips/presentation/controllers/trip_replay_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase F: Trip History Route Visualization and Replay', () {
    late List<TripWaypointItem> mockWaypoints;
    final baseTime = DateTime(2026, 11, 10, 8, 0, 0);

    setUp(() {
      mockWaypoints = [
        TripWaypointItem(
          latitude: 14.5800,
          longitude: 121.0500,
          altitude: 15.0,
          speedKmh: 0.0,
          heading: 90.0,
          accuracyMeters: 3.5,
          recordedAt: baseTime,
          sequence: 0,
        ),
        TripWaypointItem(
          latitude: 14.5820,
          longitude: 121.0530,
          altitude: 20.0,
          speedKmh: 35.5,
          heading: 85.0,
          accuracyMeters: 4.0,
          recordedAt: baseTime.add(const Duration(seconds: 30)),
          sequence: 1,
        ),
        TripWaypointItem(
          latitude: 14.5850,
          longitude: 121.0580,
          altitude: 28.0,
          speedKmh: 62.0,
          heading: 75.0,
          accuracyMeters: 3.0,
          recordedAt: baseTime.add(const Duration(seconds: 60)),
          sequence: 2,
        ),
        TripWaypointItem(
          latitude: 14.5900,
          longitude: 121.0650,
          altitude: 35.0,
          speedKmh: 58.0,
          heading: 60.0,
          accuracyMeters: 3.2,
          recordedAt: baseTime.add(const Duration(seconds: 90)),
          sequence: 3,
        ),
        TripWaypointItem(
          latitude: 14.5950,
          longitude: 121.0700,
          altitude: 40.0,
          speedKmh: 12.0,
          heading: 45.0,
          accuracyMeters: 3.8,
          recordedAt: baseTime.add(const Duration(seconds: 120)),
          sequence: 4,
        ),
      ];
    });

    test(
        'TripReplayController initializes with valid coordinates and distance metrics',
        () {
      final controller = TripReplayController(waypoints: mockWaypoints);

      expect(controller.totalWaypoints, 5);
      expect(controller.currentIndex, 0);
      expect(controller.isPlaying, isFalse);
      expect(controller.playbackSpeed, 1.0);
      expect(controller.progress, 0.0);
      expect(controller.currentSpeedKmh, 0.0);
      expect(controller.currentHeading, 90.0);
      expect(controller.fullPolyline.length, 5);
      expect(controller.traveledPolyline.length, 1);
      expect(controller.totalDistanceKm, greaterThan(0.5));

      controller.dispose();
    });

    test(
        'TripReplayController seeking to index updates current waypoint and progress',
        () {
      final controller = TripReplayController(waypoints: mockWaypoints);

      controller.seekTo(2);

      expect(controller.currentIndex, 2);
      expect(controller.progress, 0.5); // 2 of 4 steps = 50%
      expect(controller.currentSpeedKmh, 62.0);
      expect(controller.currentHeading, 75.0);
      expect(controller.traveledPolyline.length, 3);
      expect(controller.distanceTraveledKm, greaterThan(0.0));
      expect(
          controller.distanceTraveledKm, lessThan(controller.totalDistanceKm));

      controller.dispose();
    });

    test('TripReplayController seekToProgress ratio clamps within 0.0 and 1.0',
        () {
      final controller = TripReplayController(waypoints: mockWaypoints);

      controller.seekToProgress(0.75);
      expect(controller.currentIndex, 3);

      controller.seekToProgress(1.0);
      expect(controller.currentIndex, 4);
      expect(controller.traveledPolyline.length, 5);

      // Clamp overflow
      controller.seekToProgress(1.5);
      expect(controller.currentIndex, 4);

      // Clamp underflow
      controller.seekToProgress(-0.5);
      expect(controller.currentIndex, 0);

      controller.dispose();
    });

    test('TripReplayController playback speed change adjusts multiplier', () {
      final controller = TripReplayController(waypoints: mockWaypoints);

      expect(controller.playbackSpeed, 1.0);
      controller.setPlaybackSpeed(5.0);
      expect(controller.playbackSpeed, 5.0);

      controller.setPlaybackSpeed(10.0);
      expect(controller.playbackSpeed, 10.0);

      // Negative or zero speed is ignored
      controller.setPlaybackSpeed(0.0);
      expect(controller.playbackSpeed, 10.0);

      controller.dispose();
    });

    test('TripReplayController play, pause, togglePlayPause and stop lifecycle',
        () {
      final controller = TripReplayController(waypoints: mockWaypoints);

      expect(controller.isPlaying, isFalse);

      controller.play();
      expect(controller.isPlaying, isTrue);

      controller.pause();
      expect(controller.isPlaying, isFalse);

      controller.togglePlayPause();
      expect(controller.isPlaying, isTrue);

      controller.seekTo(3);
      expect(controller.currentIndex, 3);

      controller.stop();
      expect(controller.isPlaying, isFalse);
      expect(controller.currentIndex, 0);
      expect(controller.traveledPolyline.length, 1);

      controller.dispose();
    });

    test(
        'TripReplayController handles empty waypoints gracefully without crashing',
        () {
      final controller = TripReplayController(waypoints: const []);

      expect(controller.hasWaypoints, isFalse);
      expect(controller.totalWaypoints, 0);
      expect(controller.currentIndex, 0);
      expect(controller.currentWaypoint, isNull);
      expect(controller.progress, 0.0);
      expect(controller.currentSpeedKmh, 0.0);
      expect(controller.distanceTraveledKm, 0.0);
      expect(controller.totalDistanceKm, 0.0);
      expect(controller.fullPolyline, isEmpty);
      expect(controller.traveledPolyline, isEmpty);

      // Operations do not throw
      controller.play();
      expect(controller.isPlaying, isFalse);
      controller.seekTo(10);
      controller.seekToProgress(0.5);
      controller.stop();

      controller.dispose();
    });
  });
}
