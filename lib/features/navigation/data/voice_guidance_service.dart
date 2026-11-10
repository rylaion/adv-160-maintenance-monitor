import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Voice speech synthesis service for turn-by-turn motorcycle helmet audio.
class VoiceGuidanceService {
  VoiceGuidanceService({FlutterTts? ttsOverride}) : _ttsInstance = ttsOverride;

  FlutterTts? _ttsInstance;
  bool _initialized = false;
  bool _isMuted = false;
  String? _lastSpokenPrompt;
  DateTime? _lastSpokenTime;

  FlutterTts get _tts {
    _ttsInstance ??= FlutterTts();
    if (!_initialized) {
      _initialized = true;
      _initTts();
    }
    return _ttsInstance!;
  }

  bool get isMuted => _isMuted;
  String? get lastSpokenPrompt => _lastSpokenPrompt;

  Future<void> _initTts() async {
    try {
      await _ttsInstance?.setLanguage('en-US');
      await _ttsInstance
          ?.setSpeechRate(0.5); // Clear and legible at highway speeds
      await _ttsInstance?.setVolume(1.0);
      await _ttsInstance?.setPitch(1.0);
    } catch (_) {}
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      stop();
    }
  }

  void setMuted(bool muted) {
    _isMuted = muted;
    if (_isMuted) {
      stop();
    }
  }

  /// Speaks a navigation instruction prompt.
  /// Deduplicates identical prompts within a 4-second window to prevent audio stutter.
  Future<void> speak(String text) async {
    if (_isMuted || text.trim().isEmpty) return;

    final now = DateTime.now();
    if (_lastSpokenPrompt == text &&
        _lastSpokenTime != null &&
        now.difference(_lastSpokenTime!).inSeconds < 4) {
      return;
    }

    _lastSpokenPrompt = text;
    _lastSpokenTime = now;

    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
