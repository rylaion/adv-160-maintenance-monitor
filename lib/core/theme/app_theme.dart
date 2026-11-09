import 'package:flutter/material.dart';

/// Material 3 themes (light + dark) with a motorcycle-dashboard feel.
class AppTheme {
  AppTheme._();

  static const Color _seed = Color(0xFFD32F2F); // Honda-style red

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness b) {
    final scheme = ColorScheme.fromSeed(seedColor: _seed, brightness: b);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      cardTheme: CardTheme(
        elevation: 0,
        color: scheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(centerTitle: false),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}

/// Semantic colors for maintenance status indicators (used from Phase 2).
class StatusColors {
  StatusColors._();
  static const good = Color(0xFF2E7D32);
  static const upcoming = Color(0xFFF9A825);
  static const due = Color(0xFFEF6C00);
  static const overdue = Color(0xFFC62828);
  static const inspection = Color(0xFF1565C0);
  static const replacement = Color(0xFF6A1B9A);
}
