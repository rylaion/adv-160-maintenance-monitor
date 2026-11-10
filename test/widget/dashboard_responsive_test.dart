import 'package:adv_mon/app.dart';
import 'package:adv_mon/core/enums/enums.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_models.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_overview.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_snapshot.dart';
import 'package:adv_mon/features/maintenance/presentation/maintenance_view_model.dart';
import 'package:adv_mon/features/motorcycle/domain/motorcycle.dart';
import 'package:adv_mon/features/motorcycle/presentation/motorcycle_view_model.dart';
import 'package:adv_mon/features/reminders/domain/reminder_models.dart';
import 'package:adv_mon/features/reminders/presentation/reminders_view_model.dart';
import 'package:adv_mon/features/settings/domain/app_settings.dart';
import 'package:adv_mon/features/settings/presentation/settings_view_model.dart';
import 'package:adv_mon/features/trips/domain/trip_models.dart';
import 'package:adv_mon/features/trips/presentation/trips_view_model.dart';
import 'package:adv_mon/shared/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const bike = Motorcycle(
    id: 1,
    brand: 'Honda',
    model: 'ADV 160',
    modelYear: 2023,
    plateNumber: 'ABC 123',
  );

  const categories = [
    CategoryInfo(id: 1, name: 'Engine'),
    CategoryInfo(id: 2, name: 'Chassis'),
    CategoryInfo(id: 3, name: 'CVT / Transmission'),
  ];

  const items = [
    ItemInfo(id: 1, name: 'Engine Oil', categoryId: 1),
    ItemInfo(id: 2, name: 'Brake Fluid', categoryId: 2),
    ItemInfo(id: 3, name: 'Drive Belt', categoryId: 3),
  ];

  const rules = [
    RuleDef(
      id: 1,
      itemId: 1,
      ruleType: RuleType.mileage,
      actionCode: ActionCode.replace,
      source: MaintenanceSource.hondaManual,
      steps: [
        RuleStepDef(
          actionCode: ActionCode.replace,
          atKm: 6000,
          repeatEveryKm: 6000,
        ),
      ],
    ),
    RuleDef(
      id: 2,
      itemId: 2,
      ruleType: RuleType.mileage,
      actionCode: ActionCode.replace,
      source: MaintenanceSource.hondaManual,
      steps: [
        RuleStepDef(
          actionCode: ActionCode.replace,
          atKm: 12000,
          repeatEveryKm: 12000,
        ),
      ],
    ),
    RuleDef(
      id: 3,
      itemId: 3,
      ruleType: RuleType.mileage,
      actionCode: ActionCode.inspect,
      source: MaintenanceSource.hondaManual,
      steps: [
        RuleStepDef(
          actionCode: ActionCode.inspect,
          atKm: 12000,
          repeatEveryKm: 12000,
        ),
      ],
    ),
  ];

  final today = DateTime.utc(2026, 11, 10);
  final fixedNow = DateTime.utc(2026, 11, 10, 8, 0);

  final snapshot = MaintenanceSnapshot(
    motorcycle: bike,
    categories: categories,
    items: items,
    rules: rules,
    records: const [],
    currentKm: 10250,
    baselineKm: 0,
    firstLogDate: DateTime.utc(2026, 1, 1),
  );

  final overview = MaintenanceOverview.build(snapshot: snapshot, today: today);

  const sampleStats = TripStats(
    totalDistanceKm: 250.0,
    totalTrips: 12,
    avgDistanceKm: 20.8,
    longestDistanceKm: 65.0,
    monthlyDistanceKm: 85.0,
  );

  Widget buildTestApp() {
    return ProviderScope(
      overrides: [
        clockProvider.overrideWithValue(() => fixedNow),
        appSettingsProvider.overrideWith((ref) async => const AppSettings()),
        activeRemindersProvider
            .overrideWith((ref) => Stream.value(const <MaintenanceReminder>[])),
        primaryMotorcycleProvider.overrideWith((ref) => Stream.value(bike)),
        maintenanceOverviewProvider.overrideWith(
          (ref) => Stream.value(overview),
        ),
        tripStatsProvider.overrideWith(
          (ref) => Future.value(sampleStats),
        ),
      ],
      child: const AdvMonApp(),
    );
  }

  testWidgets(
      'Dashboard renders cleanly without overflow on Small Screen (360x640)',
      (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // Verify AppBar
    expect(find.text('ADV-MON'), findsOneWidget);
    expect(find.text('HONDA ADV 160 COMPANION'), findsOneWidget);

    // Verify Motorcycle Information Card
    expect(find.text('Honda ADV 160'), findsWidgets);
    expect(find.text('10,250 km'), findsWidgets);
    expect(find.text('Current Odometer'), findsOneWidget);

    // Verify Quick Actions Grid exists with all 8 action cards by scrolling into view
    await tester.scrollUntilVisible(find.text('Quick Actions'), 150);
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('Update Odometer'), findsOneWidget);
    expect(find.text('Add Maintenance'), findsOneWidget);
    expect(find.text('Inspection Guide'), findsOneWidget);
    expect(find.text('Record Measurement'), findsOneWidget);
    expect(find.text('Live Map & GPS'), findsOneWidget);
    expect(find.text('Ride History & Trips'), findsOneWidget);
    expect(find.text('CVT Configurations'), findsOneWidget);
    expect(find.text('OEM Parts Catalogue'), findsOneWidget);

    // Verify Bottom Navigation tabs
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Maintenance'), findsOneWidget);
    expect(find.text('Components'), findsOneWidget);
    expect(find.text('Reports'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // Verify no rendering overflow exceptions
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Dashboard renders cleanly without overflow on Standard Screen (412x915)',
      (tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('ADV-MON'), findsOneWidget);
    expect(find.text('Next major maintenance checkpoint'), findsOneWidget);
    expect(find.text('12,000 km'), findsWidgets);

    // Scroll down to test full view
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Dashboard adapts to Large/Tablet Screen (800x1280) with 4-column quick actions',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1280);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('ADV-MON'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('Update Odometer'), findsOneWidget);
    expect(find.text('Add Maintenance'), findsOneWidget);
    expect(find.text('OEM Parts Catalogue'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });
}
