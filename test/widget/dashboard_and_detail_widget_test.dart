import 'package:adv_mon/app.dart';
import 'package:adv_mon/core/enums/enums.dart';
import 'package:adv_mon/features/components/domain/component_models.dart';
import 'package:adv_mon/features/components/presentation/components_view_model.dart';
import 'package:adv_mon/features/maintenance/data/maintenance_repository.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_models.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_overview.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_record_detail.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_snapshot.dart';
import 'package:adv_mon/features/maintenance/presentation/maintenance_form_screen.dart';
import 'package:adv_mon/features/maintenance/presentation/maintenance_item_detail_screen.dart';
import 'package:adv_mon/features/maintenance/presentation/maintenance_view_model.dart';
import 'package:adv_mon/features/motorcycle/domain/motorcycle.dart';
import 'package:adv_mon/features/motorcycle/presentation/motorcycle_view_model.dart';
import 'package:adv_mon/features/reminders/domain/reminder_models.dart';
import 'package:adv_mon/features/reminders/presentation/reminders_view_model.dart';
import 'package:adv_mon/features/settings/domain/app_settings.dart';
import 'package:adv_mon/features/settings/presentation/settings_view_model.dart';
import 'package:adv_mon/shared/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final _recordsStateProvider =
    StateProvider<List<RecordInfo>>((ref) => const []);
final _measurementsStateProvider =
    StateProvider<List<ComponentMeasurement>>((ref) => const []);

class _TestMaintenanceActions extends MaintenanceActions {
  @override
  Future<void> build() async {}

  @override
  Future<String?> addRecord(NewMaintenanceRecord r) async {
    final currentRecords = ref.read(_recordsStateProvider);
    ref.read(_recordsStateProvider.notifier).state = [
      ...currentRecords,
      RecordInfo(
        id: currentRecords.length + 1,
        itemId: r.itemId,
        action: r.action,
        date: r.date,
        odometerKm: r.odometerKm,
        totalCostCentavos: r.totalCostCentavos ?? r.laborCostCentavos,
      ),
    ];
    if (r.measurementValue != null) {
      final currentMeas = ref.read(_measurementsStateProvider);
      ref.read(_measurementsStateProvider.notifier).state = [
        ComponentMeasurement(
          id: currentMeas.length + 1,
          motorcycleId: r.motorcycleId,
          itemId: r.itemId,
          measuredDate: r.date,
          odometerKm: r.odometerKm,
          measurementType:
              r.measurementType ?? MeasurementType.generalMeasurement,
          value: r.measurementValue,
          unit: r.measurementUnit ?? 'mm',
          position: r.measurementPosition,
        ),
        ...currentMeas,
      ];
    }
    return null;
  }
}

void main() {
  testWidgets(
      'Dashboard Due and Overdue items are clickable, open MaintenanceItemDetailScreen '
      'with specs, and adding a Maintenance Log updates the item and refreshes Dashboard',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final fixedNow = DateTime.utc(2026, 11, 9, 9, 0);
    final today = DateTime.utc(2026, 11, 9);

    const bike = Motorcycle(
      id: 1,
      brand: 'Honda',
      model: 'ADV 160',
      modelYear: 2023,
    );

    const categories = [
      CategoryInfo(id: 1, name: 'Engine'),
      CategoryInfo(id: 2, name: 'Fuel System'),
      CategoryInfo(id: 3, name: 'CVT / Transmission'),
    ];

    const items = [
      ItemInfo(
        id: 1,
        name: 'Engine Oil',
        categoryId: 1,
        instructions: 'Replace at 1,000 km, then every 6,000 km.',
      ),
      ItemInfo(
        id: 2,
        name: 'Throttle Operation',
        categoryId: 2,
        instructions: 'Inspect every 6,000 km (p. 110).',
      ),
      ItemInfo(
        id: 3,
        name: 'Drive Belt',
        categoryId: 3,
        instructions: 'Inspect at 12,000 km & 36,000 km; replace at 24,000 km.',
      ),
    ];

    const rules = [
      // Engine Oil: 1,000 km (Overdue at 6,000 km) & every 6,000 km
      RuleDef(
        id: 1,
        itemId: 1,
        ruleType: RuleType.mileage,
        actionCode: ActionCode.replace,
        source: MaintenanceSource.hondaManual,
        sourceDocument: 'Honda ADV160 2023 Owner\'s Manual (32K0WA100)',
        sourcePage: 88,
        isVerified: true,
        steps: [
          RuleStepDef(
            actionCode: ActionCode.replace,
            atKm: 1000,
            repeatEveryKm: 6000,
          ),
        ],
      ),
      // Throttle Operation: 6,000 km (Due at 6,000 km)
      RuleDef(
        id: 2,
        itemId: 2,
        ruleType: RuleType.mileage,
        actionCode: ActionCode.inspect,
        source: MaintenanceSource.hondaManual,
        sourceDocument: 'Honda ADV160 2023 Owner\'s Manual (32K0WA100)',
        sourcePage: 88,
        isVerified: true,
        steps: [
          RuleStepDef(
            actionCode: ActionCode.inspect,
            atKm: 6000,
            repeatEveryKm: 6000,
          ),
        ],
      ),
      // Drive Belt: 12,000 km (Good at 6,000 km)
      RuleDef(
        id: 3,
        itemId: 3,
        ruleType: RuleType.mileage,
        actionCode: ActionCode.inspect,
        source: MaintenanceSource.hondaManual,
        sourceDocument: 'Honda ADV160 2023 Owner\'s Manual (32K0WA100)',
        sourcePage: 89,
        isVerified: true,
        steps: [
          RuleStepDef(
            actionCode: ActionCode.inspect,
            atKm: 12000,
            repeatEveryKm: 24000,
          ),
        ],
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clockProvider.overrideWithValue(() => fixedNow),
          appSettingsProvider.overrideWith((ref) async => const AppSettings()),
          activeRemindersProvider.overrideWith(
              (ref) => Stream.value(const <MaintenanceReminder>[])),
          primaryMotorcycleProvider.overrideWith((ref) => Stream.value(bike)),
          maintenanceOverviewProvider.overrideWith((ref) {
            final records = ref.watch(_recordsStateProvider);
            final snapshot = MaintenanceSnapshot(
              motorcycle: bike,
              categories: categories,
              items: items,
              rules: rules,
              records: records,
              currentKm: 6000,
              baselineKm: 0,
              firstLogDate: DateTime.utc(2026, 1, 1),
            );
            return Stream.value(
              MaintenanceOverview.build(snapshot: snapshot, today: today),
            );
          }),
          componentMeasurementsProvider.overrideWith((ref, itemId) {
            final all = ref.watch(_measurementsStateProvider);
            final filtered = itemId == null
                ? all
                : all.where((m) => m.itemId == itemId).toList();
            return Stream.value(filtered);
          }),
          userComponentSpecsProvider.overrideWith(
            (ref) => Stream.value(const <String, UserComponentSpec>{}),
          ),
          itemHistoryProvider.overrideWith((ref, itemId) {
            final records = ref
                .watch(_recordsStateProvider)
                .where((r) => r.itemId == itemId)
                .toList();
            return Stream.value([
              for (final r in records)
                MaintenanceRecordDetail(
                  id: r.id,
                  motorcycleId: 1,
                  itemId: r.itemId,
                  itemName: items.firstWhere((i) => i.id == r.itemId).name,
                  categoryId: 1,
                  categoryName: 'Fuel System',
                  action: r.action,
                  performedDate: r.date,
                  odometerKm: r.odometerKm,
                  laborCostCentavos: 0,
                  totalCostCentavos: r.totalCostCentavos,
                ),
            ]);
          }),
          maintenanceHistoryProvider.overrideWith(
            (ref) => Stream.value(const <MaintenanceRecordDetail>[]),
          ),
          maintenanceActionsProvider.overrideWith(_TestMaintenanceActions.new),
        ],
        child: const AdvMonApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Dashboard shows Overdue and Due sections
    expect(find.text('Overdue maintenance (1)'), findsOneWidget);
    expect(find.text('Due maintenance (1)'), findsOneWidget);

    // 1. Tap Overdue item ("Engine Oil") on the Dashboard
    final engineOilFinder = find.text('Engine Oil').first;
    await tester.ensureVisible(engineOilFinder);
    await tester.tap(engineOilFinder);
    await tester.pumpAndSettle();

    // Verify MaintenanceItemDetailScreen opened for Engine Oil
    expect(find.byType(MaintenanceItemDetailScreen), findsOneWidget);
    expect(find.text('Engine Oil'), findsWidgets);
    expect(find.text('Current odometer reading'), findsOneWidget);
    expect(find.text('6,000 km'), findsWidgets);
    expect(find.text('Recommended next service odometer'), findsOneWidget);
    expect(
      find.text('Component Measurement & Wear Specifications'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('add_maintenance_log_button')), findsOneWidget);

    // Navigate back to Dashboard
    await tester.pageBack();
    await tester.pumpAndSettle();

    // 2. Tap Due item ("Throttle Operation") on the Dashboard
    final throttleFinder = find.text('Throttle Operation').first;
    await tester.ensureVisible(throttleFinder);
    await tester.tap(throttleFinder);
    await tester.pumpAndSettle();

    // Verify MaintenanceItemDetailScreen opened for Throttle Operation with Honda-verified spec
    expect(find.byType(MaintenanceItemDetailScreen), findsOneWidget);
    expect(find.text('Throttle Operation'), findsWidgets);
    expect(find.text('Throttle Grip Freeplay'), findsOneWidget);
    expect(find.textContaining('2.0 – 6.0 mm (Honda-specified)'), findsWidgets);

    // 3. Tap "Add Maintenance Log" button
    await tester.tap(find.byKey(const Key('add_maintenance_log_button')));
    await tester.pumpAndSettle();

    // Verify MaintenanceFormScreen opened with Throttle Operation pre-populated
    expect(find.byType(MaintenanceFormScreen), findsOneWidget);
    expect(find.text('Throttle Operation'), findsWidgets);

    // Enter actual measurement (3.5 mm) in the Add Maintenance Log form
    await tester.enterText(
      find.byKey(const Key('maintenance_measurement_field')),
      '3.5',
    );

    // Save the maintenance record
    final saveBtn = find.text('Save Service Record');
    await tester.ensureVisible(saveBtn);
    await tester.tap(saveBtn);
    await tester.pumpAndSettle();

    // Back on MaintenanceItemDetailScreen: verify status is now Good (next due at 12,000 km)
    // and measurement 3.50 mm is shown with status Good!
    expect(find.byType(MaintenanceItemDetailScreen), findsOneWidget);
    expect(find.textContaining('12,000 km'), findsWidgets);
    expect(find.text('3.50 mm'), findsWidgets);
    expect(find.text('Good'), findsWidgets);

    // Navigate back to Dashboard and verify Due maintenance is cleared and Recently completed is updated
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.textContaining('Due maintenance'), findsNothing);
    expect(find.text('Throttle Operation'), findsWidgets);
  });
}
