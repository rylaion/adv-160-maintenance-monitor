import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adv_mon/core/enums/enums.dart';
import 'package:adv_mon/features/components/domain/component_models.dart';
import 'package:adv_mon/features/components/presentation/component_detail_screen.dart';
import 'package:adv_mon/features/components/presentation/components_screen.dart';
import 'package:adv_mon/features/components/presentation/components_view_model.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_overview.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_record_detail.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_snapshot.dart';
import 'package:adv_mon/features/maintenance/presentation/maintenance_form_screen.dart';
import 'package:adv_mon/features/maintenance/presentation/maintenance_history_screen.dart';
import 'package:adv_mon/features/maintenance/presentation/maintenance_view_model.dart';
import 'package:adv_mon/features/motorcycle/domain/motorcycle.dart';
import 'package:adv_mon/features/motorcycle/presentation/motorcycle_view_model.dart';
import 'package:adv_mon/features/parts/domain/part_models.dart';
import 'package:adv_mon/features/parts/presentation/parts_screen.dart';
import 'package:adv_mon/features/parts/presentation/parts_view_model.dart';
import 'package:adv_mon/shared/providers/providers.dart';
import 'package:adv_mon/shared/widgets/measurement_trend_chart.dart';

void main() {
  final fixedNow = DateTime.utc(2026, 11, 9, 2, 0);
  final today = DateTime.utc(2026, 11, 9);

  const bike = Motorcycle(
    id: 1,
    brand: 'Honda',
    model: 'ADV 160',
    modelYear: 2023,
  );

  const categories = [
    CategoryInfo(id: 1, name: 'Engine'),
    CategoryInfo(id: 2, name: 'CVT'),
  ];

  const items = [
    ItemInfo(id: 1, name: 'Engine Oil', categoryId: 1),
    ItemInfo(id: 2, name: 'CVT Drive Belt', categoryId: 2),
  ];

  final overview = MaintenanceOverview.build(
    snapshot: const MaintenanceSnapshot(
      motorcycle: bike,
      categories: categories,
      items: items,
      rules: [],
      records: [],
      currentKm: 18000,
      baselineKm: 0,
    ),
    today: today,
  );

  Widget wrap(
    Widget child, {
    List<MaintenanceRecordDetail> history = const [],
    List<ComponentMeasurement> measurements = const [],
    List<PartInfo> parts = const [],
    List<InstallationInfo> installations = const [],
  }) {
    return ProviderScope(
      overrides: [
        clockProvider.overrideWithValue(() => fixedNow),
        primaryMotorcycleProvider.overrideWith((_) => Stream.value(bike)),
        maintenanceOverviewProvider.overrideWith((_) => Stream.value(overview)),
        maintenanceHistoryProvider.overrideWith((_) => Stream.value(history)),
        itemHistoryProvider.overrideWith((_, __) => Stream.value(history)),
        componentMeasurementsProvider
            .overrideWith((_, __) => Stream.value(measurements)),
        partsListProvider.overrideWith((_) => Stream.value(parts)),
        installationsProvider
            .overrideWith((_, __) => Stream.value(installations)),
      ],
      child: MaterialApp(home: child),
    );
  }

  testWidgets('ComponentsScreen lists all 8 monitored components',
      (tester) async {
    await tester.pumpWidget(wrap(const ComponentsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('CVT Belt'), findsOneWidget);
    expect(find.text('Fuel Filter'), findsOneWidget);
    expect(find.text('Brake Pads'), findsOneWidget);
    expect(find.text('Brake Fluid'), findsOneWidget);
    expect(find.text('Battery'), findsOneWidget);
    expect(find.text('Tires'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Final Drive Oil'), 200);
    expect(find.text('Coolant'), findsOneWidget);
    expect(find.text('Final Drive Oil'), findsOneWidget);
  });

  testWidgets(
      'ComponentDetailScreen shows safety notice, trend chart, and measurements',
      (tester) async {
    final mList = [
      ComponentMeasurement(
        id: 1,
        motorcycleId: 1,
        itemId: 2,
        measuredDate: today,
        odometerKm: 18000,
        measurementType: MeasurementType.thicknessMm,
        value: 21.5,
        unit: 'mm',
        brand: 'Bando',
        visualCondition: 'Normal wear',
      ),
    ];

    await tester.pumpWidget(
      wrap(
        const ComponentDetailScreen(slug: 'cvt_belt'),
        measurements: mList,
      ),
    );
    await tester.pumpAndSettle();

    expect(
        find.textContaining('Verified Specification Limits'), findsOneWidget);
    expect(
        find.textContaining('does not automatically declare a component safe'),
        findsOneWidget);
    expect(find.byType(MeasurementTrendChart), findsOneWidget);

    await tester.scrollUntilVisible(
      find.textContaining('Thickness: 21.50 mm'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('Thickness: 21.50 mm'), findsOneWidget);
  });

  testWidgets('MaintenanceFormScreen validates inputs and computes total cost',
      (tester) async {
    await tester.pumpWidget(wrap(const MaintenanceFormScreen()));
    await tester.pumpAndSettle();

    expect(find.text('18000'), findsOneWidget);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Labor cost (₱)'), '150');
    await tester.pump();
    expect(find.text('150.00'), findsOneWidget);
  });

  testWidgets('MaintenanceHistoryScreen displays recorded service',
      (tester) async {
    final record = MaintenanceRecordDetail(
      id: 1,
      motorcycleId: 1,
      itemId: 1,
      itemName: 'Engine Oil',
      categoryId: 1,
      categoryName: 'Engine',
      action: MaintenanceAction.replacement,
      performedDate: today,
      odometerKm: 1000,
      laborCostCentavos: 15000,
      totalCostCentavos: 55000,
      notes: 'Break-in oil service',
    );

    await tester.pumpWidget(
      wrap(const MaintenanceHistoryScreen(), history: [record]),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Engine Oil · Replacement'), findsOneWidget);
    expect(find.textContaining('Break-in oil service'), findsOneWidget);
  });

  testWidgets('PartsScreen renders lifecycle and catalog tabs', (tester) async {
    await tester.pumpWidget(wrap(const PartsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Installed Lifecycle'), findsOneWidget);
    expect(find.text('Parts Catalog'), findsOneWidget);
    expect(find.text('Add Part'), findsOneWidget);
  });
}
