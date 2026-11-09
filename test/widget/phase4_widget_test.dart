import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adv_mon/core/enums/enums.dart';
import 'package:adv_mon/core/services/expense_service.dart';
import 'package:adv_mon/features/components/domain/component_models.dart';
import 'package:adv_mon/features/components/presentation/components_view_model.dart';
import 'package:adv_mon/features/reminders/domain/reminder_models.dart';
import 'package:adv_mon/features/reminders/presentation/reminders_screen.dart';
import 'package:adv_mon/features/reminders/presentation/reminders_view_model.dart';
import 'package:adv_mon/features/reports/presentation/reports_screen.dart';
import 'package:adv_mon/features/reports/presentation/reports_view_model.dart';

void main() {
  testWidgets(
      'ReportsScreen displays expense breakdown, cost/km, and component trends',
      (tester) async {
    const summary = ExpenseReportSummary(
      totalExpensesCentavos: 120000,
      partsReplacementCentavos: 85000,
      laborExpensesCentavos: 35000,
      trackedDistanceKm: 2000,
      costPerKmCentavos: 60.0,
      monthly: [
        MonthlyExpensePoint(year: 2026, month: 11, totalCentavos: 120000),
      ],
      annual: [
        AnnualExpensePoint(year: 2026, totalCentavos: 120000),
      ],
      byCategory: [
        CategoryExpensePoint(
          categoryId: 1,
          categoryName: 'Engine',
          totalCentavos: 120000,
        ),
      ],
    );

    final measurements = [
      ComponentMeasurement(
        id: 1,
        motorcycleId: 1,
        itemId: 2,
        measuredDate: DateTime.utc(2026, 11, 9),
        odometerKm: 2000,
        measurementType: MeasurementType.voltageV,
        value: 12.75,
        unit: 'V',
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          expenseReportProvider.overrideWith((_) async => summary),
          componentMeasurementsProvider
              .overrideWith((_, __) => Stream.value(measurements)),
        ],
        child: const MaterialApp(home: ReportsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Expense Summary'), findsOneWidget);
    expect(find.textContaining('₱1,200.00'), findsWidgets);
    expect(find.textContaining('₱0.60 / km'), findsOneWidget);
    expect(find.text('2026-11'), findsWidgets);

    // Switch to Component Trends tab.
    await tester.tap(find.text('Component Trends'));
    await tester.pumpAndSettle();
    expect(find.text('Battery Voltage (V)'), findsOneWidget);
  });

  testWidgets('RemindersScreen renders active reminders and preferences tabs',
      (tester) async {
    final reminders = [
      const MaintenanceReminder(
        id: 1,
        motorcycleId: 1,
        reminderType: ReminderType.upcoming,
        title: 'Engine Oil · Upcoming',
        body: 'Replace at 1,000 km (in 500 km)',
        dueOdometerKm: 1000,
        dedupeKey: 'auto:1:1000:-:UPCOMING',
        status: ReminderStatus.notified,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeRemindersProvider.overrideWith((_) => Stream.value(reminders)),
          notificationPreferencesProvider
              .overrideWith((_) async => const NotificationPreferences()),
        ],
        child: const MaterialApp(home: RemindersScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Engine Oil · Upcoming'), findsOneWidget);
    await tester.tap(find.text('Preferences'));
    await tester.pumpAndSettle();
    expect(find.text('Enable offline notifications'), findsOneWidget);
    expect(find.text('Overdue maintenance'), findsOneWidget);
  });
}
