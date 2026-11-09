import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adv_mon/features/settings/domain/app_settings.dart';
import 'package:adv_mon/features/settings/presentation/settings_screen.dart';
import 'package:adv_mon/features/settings/presentation/settings_view_model.dart';

void main() {
  testWidgets(
      'SettingsScreen renders theme mode, thresholds, backup/restore, and CSV exports',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appSettingsProvider.overrideWith((_) async => const AppSettings()),
        ],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Settings & Backup'), findsOneWidget);
    expect(find.text('Theme mode'), findsOneWidget);
    expect(find.text('Upcoming & Due thresholds'), findsOneWidget);
    expect(find.text('Full JSON Backup'), findsOneWidget);
    expect(find.text('ZIP Backup (with inspection photos)'), findsOneWidget);
    expect(find.text('Restore Backup'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Export Expenses (CSV)'),
      200,
    );
    expect(find.text('Export Maintenance Records (CSV)'), findsOneWidget);
    expect(find.text('Export Expenses (CSV)'), findsOneWidget);
  });
}
