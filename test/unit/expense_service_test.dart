import 'package:flutter_test/flutter_test.dart';

import 'package:adv_mon/core/enums/enums.dart';
import 'package:adv_mon/core/services/expense_service.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_record_detail.dart';
import 'package:adv_mon/features/parts/domain/part_models.dart';

void main() {
  const service = ExpenseService();

  MaintenanceRecordDetail rec({
    required int id,
    required DateTime date,
    required int odometerKm,
    required int categoryId,
    required String categoryName,
    MaintenanceAction action = MaintenanceAction.replacement,
    int labor = 0,
    int total = 0,
    List<RecordPartDetail> parts = const [],
  }) =>
      MaintenanceRecordDetail(
        id: id,
        motorcycleId: 1,
        itemId: 1,
        itemName: 'Engine Oil',
        categoryId: categoryId,
        categoryName: categoryName,
        action: action,
        performedDate: date,
        odometerKm: odometerKm,
        laborCostCentavos: labor,
        totalCostCentavos: total,
        parts: parts,
      );

  test('summarizes monthly, annual, category, parts, labor & cost/km', () {
    const partOil = PartInfo(id: 1, name: 'Pro Honda 10W-30');
    final records = [
      rec(
        id: 1,
        date: DateTime.utc(2025, 11, 10),
        odometerKm: 1000,
        categoryId: 1,
        categoryName: 'Engine',
        labor: 15000,
        total: 57000,
        parts: const [
          RecordPartDetail(
            id: 1,
            part: partOil,
            quantity: 1,
            unitCostCentavos: 42000,
          ),
        ],
      ),
      rec(
        id: 2,
        date: DateTime.utc(2026, 5, 1),
        odometerKm: 6000,
        categoryId: 1,
        categoryName: 'Engine',
        labor: 15000,
        total: 60000,
      ),
      rec(
        id: 3,
        date: DateTime.utc(2026, 5, 20),
        odometerKm: 6500,
        categoryId: 4,
        categoryName: 'Brakes',
        action: MaintenanceAction.inspection,
        labor: 20000,
        total: 20000,
      ),
    ];

    final summary = service.summarize(
      records: records,
      trackedDistanceKm: 5500,
    );

    expect(summary.totalExpensesCentavos, 137000);
    expect(summary.laborExpensesCentavos, 50000);
    // Record 1 part line (42,000) + Record 2 replacement diff (60,000 - 15,000 = 45,000)
    expect(summary.partsReplacementCentavos, 87000);
    expect(summary.trackedDistanceKm, 5500);
    expect(summary.costPerKmCentavos, closeTo(137000 / 5500, 0.01));

    expect(summary.monthly.map((m) => m.label), ['2025-11', '2026-05']);
    expect(summary.monthly.map((m) => m.totalCentavos), [57000, 80000]);

    expect(summary.annual.map((a) => a.year), [2025, 2026]);
    expect(summary.annual.map((a) => a.totalCentavos), [57000, 80000]);

    expect(summary.byCategory.map((c) => c.categoryName), ['Engine', 'Brakes']);
    expect(summary.byCategory.map((c) => c.totalCentavos), [117000, 20000]);
  });

  test('costPerKm is null when tracked distance is zero or null', () {
    final s1 = service.summarize(records: const [], trackedDistanceKm: null);
    expect(s1.costPerKmCentavos, isNull);

    final s2 = service.summarize(records: const [], trackedDistanceKm: 0);
    expect(s2.costPerKmCentavos, isNull);
  });
}
