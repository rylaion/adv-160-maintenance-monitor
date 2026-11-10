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
      scaffoldBackgroundColor: scheme.surface,
      cardTheme: CardTheme(
        elevation: 0,
        color: scheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: scheme.outlineVariant.withOpacity(0.25),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scheme.surface,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 66,
        backgroundColor: scheme.surfaceContainerLow,
        indicatorColor: scheme.primary.withOpacity(0.20),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.primary, size: 24);
          }
          return IconThemeData(
            color: scheme.onSurfaceVariant.withOpacity(0.7),
            size: 22,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: scheme.primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            );
          }
          return TextStyle(
            color: scheme.onSurfaceVariant.withOpacity(0.7),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          );
        }),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withOpacity(0.25),
        space: 20,
        thickness: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: scheme.outlineVariant.withOpacity(0.4),
          ),
        ),
      ),
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
