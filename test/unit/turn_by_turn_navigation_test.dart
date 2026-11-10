import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import 'package:adv_mon/features/navigation/data/motorcycle_routing_service.dart';
import 'package:adv_mon/features/navigation/data/navigation_guidance_service.dart';
import 'package:adv_mon/features/navigation/data/voice_guidance_service.dart';
import 'package:adv_mon/features/navigation/domain/navigation_models.dart';
import 'package:adv_mon/features/navigation/domain/route_models.dart';

class MockVoiceService extends VoiceGuidanceService {
  final List<String> spoken = [];

  @override
  Future<void> speak(String text) async {
    if (isMuted) return;
    spoken.add(text);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase E: Turn-by-Turn Navigation and Voice Guidance', () {
    late MotorcycleRoutingService routing;
    late MockVoiceService voice;
    late NavigationGuidanceService guidance;

    setUp(() {
      routing = MotorcycleRoutingService();
      voice = MockVoiceService();
      guidance = NavigationGuidanceService(
        routingService: routing,
        voiceService: voice,
      );
    });

    const testRoute = PlannedRoute(
      id: 'test_route_1',
      name: 'Tanay Mountain Run',
      distanceKm: 12.0,
      durationMinutes: 20,
      polyline: [
        LatLng(14.5800, 121.0500),
        LatLng(14.5850, 121.0550),
        LatLng(14.5900, 121.0600),
      ],
      summary: 'Via Marilaque Scenic Road',
      steps: [
        RouteStepInstruction(
          instruction: 'Turn left on Marikina-Infanta Hwy',
          distanceMeters: 500.0,
          durationSeconds: 60,
          modifier: 'left',
          streetName: 'Marikina-Infanta Hwy',
          coordinates: LatLng(14.5850, 121.0550),
        ),
        RouteStepInstruction(
          instruction: 'Continue straight to Viewpoint',
          distanceMeters: 800.0,
          durationSeconds: 100,
          modifier: 'straight',
          streetName: 'Sierra Madre Ridge',
          coordinates: LatLng(14.5900, 121.0600),
        ),
      ],
    );

    test('Guidance service initializes and announces route start', () {
      expect(guidance.currentSnapshot.isActive, isFalse);

      guidance.startGuidance(testRoute);

      final snapshot = guidance.currentSnapshot;
      expect(snapshot.isActive, isTrue);
      expect(snapshot.currentStepIndex, 0);
      expect(snapshot.currentInstruction, 'Turn left on Marikina-Infanta Hwy');
      expect(snapshot.modifier, 'left');
      expect(snapshot.streetName, 'Marikina-Infanta Hwy');
      expect(voice.spoken, isNotEmpty);
      expect(voice.spoken.first, contains('Starting navigation'));
    });

    test(
        'Rider location update decreases turn distance and triggers voice countdown',
        () async {
      guidance.startGuidance(testRoute);
      voice.spoken.clear();

      // Rider approaches turn step (approx 100 meters away from 14.5850, 121.0550)
      final posApproaching = MotorcycleGpsPosition(
        latitude: 14.5843,
        longitude: 121.0545,
        speedKmh: 40.0,
        heading: 45.0,
        accuracyMeters: 4.0,
        timestamp: DateTime.now(),
      );

      await guidance.updateRiderLocation(posApproaching);

      expect(
          guidance.currentSnapshot.distanceToNextTurnMeters, lessThan(500.0));
      expect(
          voice.spoken
              .any((s) => s.contains('100 meters') || s.contains('meters')),
          isTrue);
    });

    test('Arriving at turn maneuver advances step index to next instruction',
        () async {
      guidance.startGuidance(testRoute);
      expect(guidance.currentSnapshot.currentStepIndex, 0);

      // Rider reaches exactly at the turn point
      final posAtTurn = MotorcycleGpsPosition(
        latitude: 14.5850,
        longitude: 121.0550,
        speedKmh: 20.0,
        heading: 45.0,
        accuracyMeters: 3.0,
        timestamp: DateTime.now(),
      );

      await guidance.updateRiderLocation(posAtTurn);

      // Step advances to next step (index 1)
      expect(guidance.currentSnapshot.currentStepIndex, 1);
      expect(guidance.currentSnapshot.currentInstruction,
          'Continue straight to Viewpoint');
      expect(guidance.currentSnapshot.modifier, 'straight');
    });

    test('Off-route detection flags rerouting when rider deviates > 45 meters',
        () async {
      guidance.startGuidance(testRoute);
      expect(guidance.currentSnapshot.isOffRoute, isFalse);

      final snapshots = <GuidanceSnapshot>[];
      final sub = guidance.snapshotStream.listen(snapshots.add);

      // Rider takes wrong detour 500 meters away from route
      final posDetour = MotorcycleGpsPosition(
        latitude: 14.5700, // way south off polyline
        longitude: 121.0400,
        speedKmh: 45.0,
        heading: 270.0,
        accuracyMeters: 4.0,
        timestamp: DateTime.now(),
      );

      // Send 3 consecutive off-route GPS fixes
      await guidance.updateRiderLocation(posDetour);
      await guidance.updateRiderLocation(posDetour);
      await guidance.updateRiderLocation(posDetour);

      // Verifies off-route event was triggered and rerouting completed
      expect(snapshots.any((s) => s.isOffRoute), isTrue);
      expect(voice.spoken.any((s) => s.contains('Off route')), isTrue);
      expect(
          voice.spoken.any((s) => s.contains('New route calculated')), isTrue);

      await sub.cancel();
    });

    test('Destination arrival detects reaching endpoint and announces arrival',
        () async {
      guidance.startGuidance(testRoute);
      voice.spoken.clear();

      // Rider reaches final destination point
      final posDest = MotorcycleGpsPosition(
        latitude: 14.5900,
        longitude: 121.0600,
        speedKmh: 5.0,
        heading: 0.0,
        accuracyMeters: 3.0,
        timestamp: DateTime.now(),
      );

      await guidance.updateRiderLocation(posDest);

      expect(guidance.currentSnapshot.hasArrived, isTrue);
      expect(voice.spoken.any((s) => s.contains('arrived')), isTrue);
    });

    test('Cancel guidance stops active navigation and clears route state', () {
      guidance.startGuidance(testRoute);
      expect(guidance.currentSnapshot.isActive, isTrue);

      guidance.cancelGuidance();
      expect(guidance.currentSnapshot.isActive, isFalse);
      expect(guidance.currentSnapshot.route, isNull);
    });

    test('Voice guidance mute toggle silences audio announcements', () async {
      voice.setMuted(true);
      expect(voice.isMuted, isTrue);

      voice.spoken.clear();
      await voice.speak('Turn right');
      expect(voice.spoken, isEmpty);

      voice.toggleMute();
      expect(voice.isMuted, isFalse);
      await voice.speak('Turn right');
      expect(voice.spoken, contains('Turn right'));
    });
  });
}
