import 'dart:async';
import 'package:geolocator/geolocator.dart';

import '../domain/navigation_models.dart';

/// Status of the motorcycle location service and permissions.
enum LocationServiceState {
  ready,
  disabled,
  permissionDenied,
  permissionPermanentlyDenied,
}

/// Service that provides continuous real-time motorcycle GPS telemetry.
class LiveLocationService {
  LiveLocationService({
    Stream<Position>? positionStreamOverride,
  }) : _streamOverride = positionStreamOverride;

  final Stream<Position>? _streamOverride;

  StreamSubscription<Position>? _subscription;
  final _controller = StreamController<MotorcycleGpsPosition>.broadcast();
  MotorcycleGpsPosition? _lastKnownPosition;
  LocationServiceState _state = LocationServiceState.ready;
  String? _errorMessage;
  bool _isBatterySaverMode = false;

  Stream<MotorcycleGpsPosition> get positionStream => _controller.stream;
  MotorcycleGpsPosition? get lastKnownPosition => _lastKnownPosition;
  LocationServiceState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isBatterySaverMode => _isBatterySaverMode;

  /// Toggles battery saver mode by adapting distance filtering and polling accuracy.
  void setBatterySaverMode(bool enabled) {
    if (_isBatterySaverMode == enabled) return;
    _isBatterySaverMode = enabled;
    if (_subscription != null) {
      startLocationUpdates(
        accuracy: enabled ? LocationAccuracy.medium : LocationAccuracy.high,
        distanceFilter: enabled ? 5 : 2,
      );
    }
  }

  /// Check permissions and start streaming real-time location.
  Future<bool> startLocationUpdates({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 2, // minimum 2 meters change for responsiveness
  }) async {
    if (_streamOverride == null) {
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isEnabled) {
        _state = LocationServiceState.disabled;
        _errorMessage = 'Location services are disabled.';
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _state = LocationServiceState.permissionDenied;
          _errorMessage = 'Location permission was denied.';
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _state = LocationServiceState.permissionPermanentlyDenied;
        _errorMessage = 'Location permission is permanently denied.';
        return false;
      }
    }

    _state = LocationServiceState.ready;
    _errorMessage = null;

    final stream = _streamOverride ??
        Geolocator.getPositionStream(
          locationSettings: LocationSettings(
            accuracy: accuracy,
            distanceFilter: distanceFilter,
          ),
        );

    await _subscription?.cancel();
    _subscription = stream.listen(
      _handlePositionUpdate,
      onError: (err) {
        _errorMessage = 'GPS update error: $err';
      },
    );

    return true;
  }

  void _handlePositionUpdate(Position pos) {
    // Filter out readings with severe noise (> 50m accuracy error)
    if (pos.accuracy > 50) return;

    final speedKmh = pos.speed >= 0 ? (pos.speed * 3.6) : 0.0;
    final heading =
        pos.heading >= 0 ? pos.heading : (_lastKnownPosition?.heading ?? 0.0);

    final telemetry = MotorcycleGpsPosition(
      latitude: pos.latitude,
      longitude: pos.longitude,
      altitude: pos.altitude,
      speedKmh: speedKmh,
      heading: heading,
      accuracyMeters: pos.accuracy,
      timestamp: pos.timestamp,
    );

    _lastKnownPosition = telemetry;
    if (!_controller.isClosed) {
      _controller.add(telemetry);
    }
  }

  /// Manually inject position (useful for unit testing or simulated rides).
  void emitPosition(MotorcycleGpsPosition position) {
    _lastKnownPosition = position;
    if (!_controller.isClosed) {
      _controller.add(position);
    }
  }

  void stopLocationUpdates() {
    _subscription?.cancel();
    _subscription = null;
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
