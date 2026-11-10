import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../domain/trip_models.dart';

enum TrackingState {
  stopped,
  recording,
  paused,
}

class GpsTrackingSnapshot {
  const GpsTrackingSnapshot({
    required this.state,
    required this.waypoints,
    required this.distanceKm,
    required this.currentSpeedKmh,
    required this.avgSpeedKmh,
    required this.maxSpeedKmh,
    required this.startTime,
    required this.durationSeconds,
    this.isSignalLost = false,
    this.errorMessage,
  });

  final TrackingState state;
  final List<TripWaypointItem> waypoints;
  final double distanceKm;
  final double currentSpeedKmh;
  final double avgSpeedKmh;
  final double maxSpeedKmh;
  final DateTime? startTime;
  final int durationSeconds;
  final bool isSignalLost;
  final String? errorMessage;
}

class GpsTrackingService {
  GpsTrackingService({
    Stream<Position>? positionStreamOverride,
    DateTime Function()? clock,
  })  : _streamOverride = positionStreamOverride,
        _clock = clock ?? DateTime.now;

  final Stream<Position>? _streamOverride;
  final DateTime Function() _clock;

  StreamSubscription<Position>? _positionSub;
  Timer? _timer;

  TrackingState _state = TrackingState.stopped;
  final List<TripWaypointItem> _waypoints = [];
  double _distanceMeters = 0;
  double _currentSpeedKmh = 0;
  double _maxSpeedKmh = 0;
  DateTime? _startTime;
  DateTime? _lastFixTime;
  int _durationSeconds = 0;
  bool _isSignalLost = false;
  bool _isBatterySaverEnabled = false;
  String? _errorMessage;

  bool get isBatterySaverEnabled => _isBatterySaverEnabled;

  void setBatterySaver(bool enabled) {
    _isBatterySaverEnabled = enabled;
    _notify();
  }

  double _getAdaptiveDistanceThreshold(double speedKmh) {
    if (_isBatterySaverEnabled) {
      if (speedKmh < 3.0) return 3.5;
      if (speedKmh < 40.0) return 5.0;
      return 10.0;
    } else {
      if (speedKmh < 3.0) return 2.5;
      if (speedKmh < 40.0) return 3.0;
      return 6.0;
    }
  }

  final _controller = StreamController<GpsTrackingSnapshot>.broadcast();
  Stream<GpsTrackingSnapshot> get snapshotStream => _controller.stream;

  GpsTrackingSnapshot get currentSnapshot => GpsTrackingSnapshot(
        state: _state,
        waypoints: List.unmodifiable(_waypoints),
        distanceKm: _distanceMeters / 1000.0,
        currentSpeedKmh: _currentSpeedKmh,
        avgSpeedKmh: _durationSeconds > 0
            ? (_distanceMeters / 1000.0) / (_durationSeconds / 3600.0)
            : 0,
        maxSpeedKmh: _maxSpeedKmh,
        startTime: _startTime,
        durationSeconds: _durationSeconds,
        isSignalLost: _isSignalLost,
        errorMessage: _errorMessage,
      );

  Future<bool> checkAndRequestPermission() async {
    if (_streamOverride != null) return true;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _errorMessage = 'Location services are disabled on this device.';
      _notify();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _errorMessage = 'Location permission denied.';
        _notify();
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _errorMessage = 'Location permissions are permanently denied.';
      _notify();
      return false;
    }

    _errorMessage = null;
    return true;
  }

  Future<void> startTracking() async {
    final hasPerm = await checkAndRequestPermission();
    if (!hasPerm) return;

    _state = TrackingState.recording;
    _waypoints.clear();
    _distanceMeters = 0;
    _currentSpeedKmh = 0;
    _maxSpeedKmh = 0;
    _startTime = _clock();
    _lastFixTime = _startTime;
    _durationSeconds = 0;
    _isSignalLost = false;
    _errorMessage = null;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_state == TrackingState.recording) {
        _durationSeconds++;
        final now = _clock();
        if (_lastFixTime != null &&
            now.difference(_lastFixTime!).inSeconds >= 10) {
          _isSignalLost = true;
        } else {
          _isSignalLost = false;
        }
        _notify();
      }
    });

    _startLocationStream();
    _notify();
  }

  void _startLocationStream() {
    _positionSub?.cancel();
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 3, // minimum 3 meters change
    );

    final stream = _streamOverride ??
        Geolocator.getPositionStream(locationSettings: locationSettings);

    _positionSub = stream.listen(
      processIncomingPosition,
      onError: (e) {
        _errorMessage = 'GPS tracking error: $e';
        _notify();
      },
    );
  }

  /// Processes raw incoming GPS telemetry with anti-jump, stationary duplicate,
  /// and precision accuracy filters.
  void processIncomingPosition(Position position) {
    if (_state != TrackingState.recording) return;

    // 1. Filter invalid GPS coordinates (null island or corrupted readings)
    if (position.latitude.abs() < 0.0001 && position.longitude.abs() < 0.0001) {
      return;
    }

    // 2. Inaccurate readings filter (> 35 meters accuracy radius is unreliable)
    if (position.accuracy > 35) {
      return;
    }

    final now = _clock();
    final speed =
        position.speed >= 0 ? (position.speed * 3.6) : 0.0; // m/s to km/h

    // 3. Stationary duplicate coordinate filter & jump validation
    if (_waypoints.isNotEmpty) {
      final last = _waypoints.last;
      final dMeters = Geolocator.distanceBetween(
        last.latitude,
        last.longitude,
        position.latitude,
        position.longitude,
      );

      // Adaptive distance filter with hairpin apex curve preservation
      final minDeltaMeters = _getAdaptiveDistanceThreshold(speed);
      if (dMeters < minDeltaMeters) {
        final headingChange = (last.heading != null && position.heading >= 0)
            ? (position.heading - last.heading!).abs()
            : 0.0;
        final normalizedHeadingChange =
            headingChange > 180 ? 360 - headingChange : headingChange;

        // Skip point unless rider makes a sharp turn (> 18 degrees)
        if (normalizedHeadingChange < 18.0) {
          _currentSpeedKmh = speed;
          _lastFixTime = now;
          _isSignalLost = false;
          _notify();
          return;
        }
      }

      // Check for sudden GPS jumps / teleportation (> 160 km/h)
      final dtSeconds =
          (now.difference(last.recordedAt).inMilliseconds) / 1000.0;
      if (dtSeconds > 0) {
        final calculatedSpeedKmh = (dMeters / dtSeconds) * 3.6;
        if (calculatedSpeedKmh > 160) {
          // Obvious GPS jump anomaly; ignore this point
          return;
        }
      }

      _distanceMeters += dMeters;
    }

    _lastFixTime = now;
    _isSignalLost = false;
    _currentSpeedKmh = speed;
    if (speed > _maxSpeedKmh) {
      _maxSpeedKmh = speed;
    }

    _waypoints.add(TripWaypointItem(
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude,
      speedKmh: speed,
      heading: position.heading >= 0 ? position.heading : null,
      accuracyMeters: position.accuracy,
      recordedAt: now,
      sequence: _waypoints.length,
    ));

    _notify();
  }

  /// Restores an interrupted trip session (e.g. after app restart or unexpected kill).
  void restoreInterruptedSession({
    required List<TripWaypointItem> savedWaypoints,
    required double distanceKm,
    required DateTime startTime,
    required int durationSeconds,
    required double maxSpeedKmh,
  }) {
    _state = TrackingState.paused;
    _waypoints.clear();
    _waypoints.addAll(savedWaypoints);
    _distanceMeters = distanceKm * 1000.0;
    _startTime = startTime;
    _durationSeconds = durationSeconds;
    _maxSpeedKmh = maxSpeedKmh;
    _currentSpeedKmh = 0;
    _notify();
  }

  void pauseTracking() {
    if (_state == TrackingState.recording) {
      _state = TrackingState.paused;
      _currentSpeedKmh = 0;
      _notify();
    }
  }

  void resumeTracking() {
    if (_state == TrackingState.paused) {
      _state = TrackingState.recording;
      _lastFixTime = _clock();
      _isSignalLost = false;
      _notify();
    }
  }

  void stopTracking() {
    _state = TrackingState.stopped;
    _positionSub?.cancel();
    _timer?.cancel();
    _currentSpeedKmh = 0;
    _isSignalLost = false;
    _notify();
  }

  void _notify() {
    if (!_controller.isClosed) {
      _controller.add(currentSnapshot);
    }
  }

  void dispose() {
    _positionSub?.cancel();
    _timer?.cancel();
    _controller.close();
  }
}
