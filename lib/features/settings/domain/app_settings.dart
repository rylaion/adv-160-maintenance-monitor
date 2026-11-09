import 'package:flutter/material.dart';

/// User-configurable application settings (persisted offline in local JSON).
///
/// Default warning distance (`upcomingThresholdKm`) is 500 km and default due
/// threshold (`dueThresholdKm`) is 0 km (checkpoint reached).
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.dueThresholdKm = 0,
    this.upcomingThresholdKm = 500,
    this.dueThresholdDays = 7,
    this.upcomingThresholdDays = 30,
  });

  final ThemeMode themeMode;
  final int dueThresholdKm;
  final int upcomingThresholdKm;
  final int dueThresholdDays;
  final int upcomingThresholdDays;

  AppSettings copyWith({
    ThemeMode? themeMode,
    int? dueThresholdKm,
    int? upcomingThresholdKm,
    int? dueThresholdDays,
    int? upcomingThresholdDays,
  }) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        dueThresholdKm: dueThresholdKm ?? this.dueThresholdKm,
        upcomingThresholdKm: upcomingThresholdKm ?? this.upcomingThresholdKm,
        dueThresholdDays: dueThresholdDays ?? this.dueThresholdDays,
        upcomingThresholdDays:
            upcomingThresholdDays ?? this.upcomingThresholdDays,
      );

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode.name,
        'dueThresholdKm': dueThresholdKm,
        'upcomingThresholdKm': upcomingThresholdKm,
        'dueThresholdDays': dueThresholdDays,
        'upcomingThresholdDays': upcomingThresholdDays,
      };

  factory AppSettings.fromJson(Map<String, dynamic> m) {
    final modeName = m['themeMode'] as String? ?? 'system';
    final mode = ThemeMode.values.firstWhere(
      (e) => e.name == modeName,
      orElse: () => ThemeMode.system,
    );
    return AppSettings(
      themeMode: mode,
      dueThresholdKm: (m['dueThresholdKm'] as int?) ?? 0,
      upcomingThresholdKm: (m['upcomingThresholdKm'] as int?) ?? 500,
      dueThresholdDays: (m['dueThresholdDays'] as int?) ?? 7,
      upcomingThresholdDays: (m['upcomingThresholdDays'] as int?) ?? 30,
    );
  }
}
