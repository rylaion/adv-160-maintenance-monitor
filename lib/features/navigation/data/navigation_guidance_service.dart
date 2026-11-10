import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../domain/navigation_models.dart';
import '../domain/route_models.dart';
import 'motorcycle_routing_service.dart';
import 'voice_guidance_service.dart';

/// Live state of turn-by-turn guidance.
class GuidanceSnapshot {
  const GuidanceSnapshot({
    required this.isActive,
    this.route,
    this.currentStepIndex = 0,
    this.distanceToNextTurnMeters = 0.0,
    this.currentInstruction = '',
    this.streetName,
    this.modifier = 'straight',
    this.remainingDistanceKm = 0.0,
    this.remainingDurationMinutes = 0,
    this.isOffRoute = false,
    this.hasArrived = false,
  });

  final bool isActive;
  final PlannedRoute? route;
  final int currentStepIndex;
  final double distanceToNextTurnMeters;
  final String currentInstruction;
  final String? streetName;
  final String modifier;
  final double remainingDistanceKm;
  final int remainingDurationMinutes;
  final bool isOffRoute;
  final bool hasArrived;

  static const empty = GuidanceSnapshot(isActive: false);
}

/// Turn-by-Turn navigation tracking engine with off-route detection and voice prompts.
class NavigationGuidanceService {
  NavigationGuidanceService({
    required MotorcycleRoutingService routingService,
    required VoiceGuidanceService voiceService,
  })  : _routingService = routingService,
        _voiceService = voiceService;

  final MotorcycleRoutingService _routingService;
  final VoiceGuidanceService _voiceService;

  PlannedRoute? _route;
  int _currentStepIndex = 0;
  bool _isActive = false;
  bool _isOffRoute = false;
  bool _hasArrived = false;
  int _offRouteCount = 0;
  bool _announced300m = false;
  bool _announced100m = false;
  bool _announcedNow = false;

  final _controller = StreamController<GuidanceSnapshot>.broadcast();
  Stream<GuidanceSnapshot> get snapshotStream => _controller.stream;

  GuidanceSnapshot get currentSnapshot {
    if (!_isActive || _route == null) return GuidanceSnapshot.empty;

    final steps = _route!.steps;
    final currentStep = steps.isNotEmpty && _currentStepIndex < steps.length
        ? steps[_currentStepIndex]
        : null;

    return GuidanceSnapshot(
      isActive: _isActive,
      route: _route,
      currentStepIndex: _currentStepIndex,
      distanceToNextTurnMeters: _lastDistanceToNextManeuver,
      currentInstruction: currentStep?.instruction ?? 'Proceed on route',
      streetName: currentStep?.streetName,
      modifier: currentStep?.modifier ?? 'straight',
      remainingDistanceKm: _remainingDistanceKm,
      remainingDurationMinutes: _remainingDurationMinutes,
      isOffRoute: _isOffRoute,
      hasArrived: _hasArrived,
    );
  }

  double _lastDistanceToNextManeuver = 0.0;
  double _remainingDistanceKm = 0.0;
  int _remainingDurationMinutes = 0;

  /// Starts turn-by-turn guidance along a planned route.
  void startGuidance(PlannedRoute route) {
    _route = route;
    _currentStepIndex = 0;
    _isActive = true;
    _isOffRoute = false;
    _hasArrived = false;
    _offRouteCount = 0;
    _announced300m = false;
    _announced100m = false;
    _announcedNow = false;

    _remainingDistanceKm = route.distanceKm;
    _remainingDurationMinutes = route.durationMinutes;

    if (route.steps.isNotEmpty) {
      _lastDistanceToNextManeuver = route.steps.first.distanceMeters;
      _voiceService.speak(
        'Starting navigation along ${route.summary}. In ${(route.steps.first.distanceMeters).round()} meters, ${route.steps.first.instruction}.',
      );
    } else {
      _lastDistanceToNextManeuver = route.distanceKm * 1000.0;
      _voiceService.speak('Starting navigation to destination.');
    }

    _notify();
  }

  /// Processes rider's real-time GPS position to calculate turn distances,
  /// step progressions, voice announcements, and off-route rerouting.
  Future<void> updateRiderLocation(MotorcycleGpsPosition position) async {
    if (!_isActive || _route == null || _hasArrived) return;

    final riderCoord = position.latLng;
    final destinationCoord =
        _route!.polyline.isNotEmpty ? _route!.polyline.last : riderCoord;

    // 1. Check destination arrival (< 30 meters)
    final distToDest = Geolocator.distanceBetween(
      riderCoord.latitude,
      riderCoord.longitude,
      destinationCoord.latitude,
      destinationCoord.longitude,
    );

    if (distToDest <= 30.0) {
      _hasArrived = true;
      _voiceService.speak('You have arrived at your destination.');
      _notify();
      return;
    }

    // 2. Step Maneuver Progress
    final steps = _route!.steps;
    if (steps.isNotEmpty && _currentStepIndex < steps.length) {
      final currentStep = steps[_currentStepIndex];
      final distToStep = Geolocator.distanceBetween(
        riderCoord.latitude,
        riderCoord.longitude,
        currentStep.coordinates.latitude,
        currentStep.coordinates.longitude,
      );

      _lastDistanceToNextManeuver = distToStep;

      // Voice announcements
      if (distToStep <= 320 && distToStep > 200 && !_announced300m) {
        _announced300m = true;
        _voiceService.speak('In 300 meters, ${currentStep.instruction}.');
      } else if (distToStep <= 120 && distToStep > 40 && !_announced100m) {
        _announced100m = true;
        _voiceService.speak('In 100 meters, ${currentStep.instruction}.');
      } else if (distToStep <= 30 && !_announcedNow) {
        _announcedNow = true;
        _voiceService.speak('${currentStep.instruction} now.');
      }

      // Step completion: advance to next maneuver
      if (distToStep <= 18.0) {
        if (_currentStepIndex < steps.length - 1) {
          _currentStepIndex++;
          _announced300m = false;
          _announced100m = false;
          _announcedNow = false;
          final nextStep = steps[_currentStepIndex];
          _voiceService.speak('Next, ${nextStep.instruction}.');
        }
      }
    }

    // 3. Off-route detection (distance from nearest point on polyline)
    final minDistanceToPolyline =
        _calculateMinDistanceToPolyline(riderCoord, _route!.polyline);

    if (minDistanceToPolyline > 45.0) {
      _offRouteCount++;
      if (_offRouteCount >= 3 && !_isOffRoute) {
        _isOffRoute = true;
        _voiceService.speak('Off route. Recalculating route...');
        _notify();
        await _performReroute(riderCoord, destinationCoord);
        return;
      }
    } else {
      _offRouteCount = 0;
      if (_isOffRoute) {
        _isOffRoute = false;
        _voiceService.speak('Route resumed.');
      }
    }

    // Update remaining trip distance
    _remainingDistanceKm = (distToDest / 1000.0).clamp(0.0, _route!.distanceKm);
    _remainingDurationMinutes =
        (_remainingDistanceKm / 0.6).round().clamp(1, 999);

    _notify();
  }

  /// Calculates minimum distance in meters between coordinate and polyline.
  double _calculateMinDistanceToPolyline(LatLng point, List<LatLng> polyline) {
    if (polyline.isEmpty) return 0.0;
    double minMeters = double.infinity;

    for (final p in polyline) {
      final d = Geolocator.distanceBetween(
        point.latitude,
        point.longitude,
        p.latitude,
        p.longitude,
      );
      if (d < minMeters) {
        minMeters = d;
      }
    }
    return minMeters;
  }

  /// Automatically recalculates new route from current off-route position to destination.
  Future<void> _performReroute(LatLng currentRider, LatLng dest) async {
    try {
      final newRoutes = await _routingService.calculateRoutes(
        origin: currentRider,
        destination: dest,
      );

      if (newRoutes.isNotEmpty) {
        _route = newRoutes.first;
        _currentStepIndex = 0;
        _isOffRoute = false;
        _offRouteCount = 0;
        _announced300m = false;
        _announced100m = false;
        _announcedNow = false;
        _voiceService.speak('New route calculated. Continue straight.');
        _notify();
      }
    } catch (_) {}
  }

  /// Cancels active navigation guidance.
  void cancelGuidance() {
    _isActive = false;
    _route = null;
    _currentStepIndex = 0;
    _isOffRoute = false;
    _hasArrived = false;
    _voiceService.stop();
    _notify();
  }

  void _notify() {
    if (!_controller.isClosed) {
      _controller.add(currentSnapshot);
    }
  }

  void dispose() {
    _voiceService.stop();
    _controller.close();
  }
}
