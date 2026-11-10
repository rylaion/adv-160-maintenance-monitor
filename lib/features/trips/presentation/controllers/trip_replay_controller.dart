import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/trip_models.dart';

/// Controller that manages playback and interactive replay of a recorded GPS trip.
class TripReplayController extends ChangeNotifier {
  TripReplayController({
    required List<TripWaypointItem> waypoints,
  }) : _waypoints = List.unmodifiable(waypoints) {
    _calculateCumulativeDistances();
  }

  final List<TripWaypointItem> _waypoints;
  final List<double> _cumulativeDistancesKm = [];

  int _currentIndex = 0;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0; // 1x, 2x, 5x, 10x
  Timer? _playbackTimer;

  List<TripWaypointItem> get waypoints => _waypoints;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  double get playbackSpeed => _playbackSpeed;
  int get totalWaypoints => _waypoints.length;

  bool get hasWaypoints => _waypoints.isNotEmpty;

  TripWaypointItem? get currentWaypoint =>
      _waypoints.isNotEmpty ? _waypoints[_currentIndex] : null;

  double get progress => _waypoints.isEmpty
      ? 0.0
      : (_currentIndex / (_waypoints.length - 1).clamp(1, double.infinity));

  double get currentSpeedKmh => currentWaypoint?.speedKmh ?? 0.0;
  double get currentHeading => currentWaypoint?.heading ?? 0.0;
  double? get currentAltitude => currentWaypoint?.altitude;
  DateTime? get currentTimestamp => currentWaypoint?.recordedAt;

  double get distanceTraveledKm {
    if (_cumulativeDistancesKm.isEmpty ||
        _currentIndex >= _cumulativeDistancesKm.length) {
      return 0.0;
    }
    return _cumulativeDistancesKm[_currentIndex];
  }

  double get totalDistanceKm {
    if (_cumulativeDistancesKm.isEmpty) return 0.0;
    return _cumulativeDistancesKm.last;
  }

  List<LatLng> get fullPolyline =>
      _waypoints.map((w) => LatLng(w.latitude, w.longitude)).toList();

  List<LatLng> get traveledPolyline {
    if (_waypoints.isEmpty) return const [];
    final count = (_currentIndex + 1).clamp(0, _waypoints.length);
    return _waypoints
        .take(count)
        .map((w) => LatLng(w.latitude, w.longitude))
        .toList();
  }

  void _calculateCumulativeDistances() {
    _cumulativeDistancesKm.clear();
    if (_waypoints.isEmpty) return;

    double sumMeters = 0.0;
    _cumulativeDistancesKm.add(0.0);

    for (int i = 1; i < _waypoints.length; i++) {
      final prev = _waypoints[i - 1];
      final curr = _waypoints[i];
      final d = Geolocator.distanceBetween(
        prev.latitude,
        prev.longitude,
        curr.latitude,
        curr.longitude,
      );
      sumMeters += d;
      _cumulativeDistancesKm.add(sumMeters / 1000.0);
    }
  }

  void play() {
    if (_waypoints.isEmpty || _isPlaying) return;
    if (_currentIndex >= _waypoints.length - 1) {
      _currentIndex = 0;
    }
    _isPlaying = true;
    _scheduleNextTick();
    notifyListeners();
  }

  void pause() {
    if (!_isPlaying) return;
    _isPlaying = false;
    _playbackTimer?.cancel();
    _playbackTimer = null;
    notifyListeners();
  }

  void togglePlayPause() {
    if (_isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void stop() {
    pause();
    _currentIndex = 0;
    notifyListeners();
  }

  void seekTo(int index) {
    if (_waypoints.isEmpty) return;
    final clamped = index.clamp(0, _waypoints.length - 1);
    if (_currentIndex != clamped) {
      _currentIndex = clamped;
      notifyListeners();
    }
  }

  void seekToProgress(double ratio) {
    if (_waypoints.isEmpty) return;
    final index = (ratio.clamp(0.0, 1.0) * (_waypoints.length - 1)).round();
    seekTo(index);
  }

  void setPlaybackSpeed(double speed) {
    if (_playbackSpeed == speed || speed <= 0) return;
    _playbackSpeed = speed;
    if (_isPlaying) {
      _playbackTimer?.cancel();
      _scheduleNextTick();
    }
    notifyListeners();
  }

  void _scheduleNextTick() {
    if (!_isPlaying || _waypoints.isEmpty) return;

    // Base tick interval: 600ms divided by playbackSpeed
    final intervalMs = (600 / _playbackSpeed).round().clamp(50, 2000);
    _playbackTimer = Timer(Duration(milliseconds: intervalMs), _onTick);
  }

  void _onTick() {
    if (!_isPlaying) return;

    if (_currentIndex < _waypoints.length - 1) {
      _currentIndex++;
      notifyListeners();
      _scheduleNextTick();
    } else {
      // Reached the end
      _isPlaying = false;
      _playbackTimer?.cancel();
      _playbackTimer = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }
}
