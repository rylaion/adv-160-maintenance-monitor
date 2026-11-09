import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adv_mon/core/database/seed/initial_seed.dart';
import 'package:adv_mon/core/enums/enums.dart';
import 'package:adv_mon/features/dashboard/presentation/dashboard_screen.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_models.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_overview.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_snapshot.dart';
import 'package:adv_mon/features/maintenance/presentation/maintenance_screen.dart';
import 'package:adv_mon/features/maintenance/presentation/maintenance_view_model.dart';
import 'package:adv_mon/features/motorcycle/domain/motorcycle.dart';
import 'package:adv_mon/features/reminders/presentation/reminders_view_model.dart';
import 'package:adv_mon/features/settings/domain/app_settings.dart';
import 'package:adv_mon/features/settings/presentation/settings_screen.dart';
import 'package:adv_mon/features/settings/presentation/settings_view_model.dart';

MaintenanceOverview _buildSampleOverview() {
  final today = DateTime.utc(2026, 11, 9);
  const categories = [
    CategoryInfo(id: 1, name: 'Engine'),
    CategoryInfo(id: 2, name: 'Fuel System'),
    CategoryInfo(id: 3, name: 'CVT / Transmission'),
    CategoryInfo(id: 4, name: 'Braking System'),
    CategoryInfo(id: 5, name: 'Cooling System'),
    CategoryInfo(id: 6, name: 'Electrical / Battery'),
    CategoryInfo(id: 7, name: 'Tires / Wheels'),
    CategoryInfo(id: 8, name: 'Chassis / Suspension'),
  ];
  const items = [
    ItemInfo(id: 1, name: 'Engine Oil', categoryId: 1),
    ItemInfo(id: 2, name: 'Fuel Line', categoryId: 2),
    ItemInfo(id: 3, name: 'Air Cleaner', categoryId: 2),
    ItemInfo(
      id: 4,
      name: 'Fuel Filter',
      categoryId: 2,
      instructions: InitialSeed.fuelFilterCustomLabel,
    ),
  ];
  const rules = [
    RuleDef(
      id: 1,
      itemId: 1,
      ruleType: RuleType.mileage,
      actionCode: ActionCode.replace,
      source: MaintenanceSource.hondaManual,
      sourceDocument: '32K0WA100',
      sourcePage: 88,
      isVerified: true,
      steps: [
        RuleStepDef(actionCode: ActionCode.replace, atKm: 1000),
        RuleStepDef(
            actionCode: ActionCode.replace, atKm: 6000, repeatEveryKm: 6000),
      ],
    ),
    RuleDef(
      id: 2,
      itemId: 2,
      ruleType: RuleType.mileage,
      actionCode: ActionCode.inspect,
      source: MaintenanceSource.hondaManual,
      sourceDocument: '32K0WA100',
      sourcePage: 88,
      isVerified: true,
      steps: [
        RuleStepDef(
            actionCode: ActionCode.inspect, atKm: 12000, repeatEveryKm: 6000),
      ],
    ),
    RuleDef(
      id: 3,
      itemId: 3,
      ruleType: RuleType.mileage,
      actionCode: ActionCode.replace,
      source: MaintenanceSource.hondaManual,
      sourceDocument: '32K0WA100',
      sourcePage: 88,
      isVerified: true,
      steps: [
        RuleStepDef(
            actionCode: ActionCode.replace, atKm: 18000, repeatEveryKm: 18000),
      ],
    ),
  ];
  final snapshot = MaintenanceSnapshot(
    motorcycle: const Motorcycle(
      id: 1,
      brand: 'Honda',
      model: 'ADV 160',
      modelYear: 2023,
    ),
    categories: categories,
    items: items,
    rules: rules,
    records: [
      RecordInfo(
        id: 1,
        itemId: 1,
        action: MaintenanceAction.replacement,
        date: today,
        odometerKm: 1000,
        totalCostCentavos: 65000,
      ),
    ],
    currentKm: 11500,
    baselineKm: 1000,
    firstLogDate: today,
  );
  return MaintenanceOverview.build(snapshot: snapshot, today: today);
}

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

  testWidgets(
      'DashboardScreen displays Next Major Checkpoint, Overdue, Upcoming, and Completed sections',
      (tester) async {
    final overview = _buildSampleOverview();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          maintenanceOverviewProvider
              .overrideWith((_) => Stream.value(overview)),
          activeRemindersProvider.overrideWith((_) => Stream.value(const [])),
        ],
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Honda ADV 160'), findsOneWidget);
    expect(find.text('Model year 2023'), findsOneWidget);
    expect(find.text('11,500 km'), findsOneWidget);
    expect(find.text('Next major maintenance checkpoint'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('Overdue maintenance (1)'), findsOneWidget);
    expect(find.text('Upcoming maintenance (2)'), findsOneWidget);
  });

  testWidgets(
      'MaintenanceScreen renders By Category and Inspection Guide tabs with Fuel Filter badge',
      (tester) async {
    final overview = _buildSampleOverview();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          maintenanceOverviewProvider
              .overrideWith((_) => Stream.value(overview)),
        ],
        child: const MaterialApp(home: MaintenanceScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('By Category'), findsOneWidget);
    expect(find.text('Inspection Guide'), findsOneWidget);
    expect(find.text('Engine'), findsWidgets);
    await tester.drag(find.byType(ListView).first, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'User-defined maintenance task (not a Honda-prescribed interval '
        'in Owner\'s Manual 32K0WA100)',
      ),
      findsOneWidget,
    );

    // Switch to Inspection Guide tab
    await tester.tap(find.text('Inspection Guide'));
    await tester.pumpAndSettle();

    expect(find.text('Active Status Summary'), findsOneWidget);
    expect(find.text('12,000 km'), findsWidgets);
    expect(find.text('Upcoming Checkpoints (2)'), findsOneWidget);
  });
}
