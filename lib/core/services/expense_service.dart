import '../enums/enums.dart';
import '../../features/maintenance/domain/maintenance_record_detail.dart';

/// Expense total for a single calendar month (`yyyy-MM`).
class MonthlyExpensePoint {
  const MonthlyExpensePoint({
    required this.year,
    required this.month,
    required this.totalCentavos,
  });

  final int year;
  final int month;
  final int totalCentavos;

  String get label =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}';
}

/// Expense total for a calendar year.
class AnnualExpensePoint {
  const AnnualExpensePoint({
    required this.year,
    required this.totalCentavos,
  });

  final int year;
  final int totalCentavos;
}

/// Expense total for a maintenance category.
class CategoryExpensePoint {
  const CategoryExpensePoint({
    required this.categoryId,
    required this.categoryName,
    required this.totalCentavos,
  });

  final int categoryId;
  final String categoryName;
  final int totalCentavos;
}

/// Complete expense & cost-per-kilometer report computed from maintenance
/// history and tracked odometer distance.
class ExpenseReportSummary {
  const ExpenseReportSummary({
    required this.totalExpensesCentavos,
    required this.partsReplacementCentavos,
    required this.laborExpensesCentavos,
    required this.trackedDistanceKm,
    required this.costPerKmCentavos,
    required this.monthly,
    required this.annual,
    required this.byCategory,
  });

  final int totalExpensesCentavos;
  final int partsReplacementCentavos;
  final int laborExpensesCentavos;
  final int? trackedDistanceKm;

  /// Null when tracked distance is zero or unknown.
  final double? costPerKmCentavos;
  final List<MonthlyExpensePoint> monthly;
  final List<AnnualExpensePoint> annual;
  final List<CategoryExpensePoint> byCategory;
}

/// Expense calculation & aggregation service (integer centavos).
class ExpenseService {
  const ExpenseService();

  /// Cost of one part line: quantity x unit cost.
  int partLineCentavos(int quantity, int unitCostCentavos) =>
      quantity * unitCostCentavos;

  /// Total for a service: labor plus every part line.
  int totalCentavos({
    required int laborCentavos,
    required Iterable<({int quantity, int unitCostCentavos})> parts,
  }) =>
      laborCentavos +
      parts.fold<int>(
          0, (a, p) => a + partLineCentavos(p.quantity, p.unitCostCentavos));

  /// Builds the full expense report from non-voided [records] and optional
  /// [trackedDistanceKm].
  ExpenseReportSummary summarize({
    required List<MaintenanceRecordDetail> records,
    required int? trackedDistanceKm,
  }) {
    var total = 0;
    var labor = 0;
    var partsTotal = 0;

    final byMonth = <String, MonthlyExpensePoint>{};
    final byYear = <int, int>{};
    final byCat = <int, ({String name, int total})>{};

    for (final r in records) {
      total += r.totalCostCentavos;
      labor += r.laborCostCentavos;

      final lineParts = r.partsCostCentavos;
      if (lineParts > 0) {
        partsTotal += lineParts;
      } else if (r.action == MaintenanceAction.replacement &&
          r.totalCostCentavos > r.laborCostCentavos) {
        partsTotal += r.totalCostCentavos - r.laborCostCentavos;
      }

      final y = r.performedDate.year;
      final m = r.performedDate.month;
      final mKey =
          '${y.toString().padLeft(4, '0')}-${m.toString().padLeft(2, '0')}';
      final prevM = byMonth[mKey];
      byMonth[mKey] = MonthlyExpensePoint(
        year: y,
        month: m,
        totalCentavos: (prevM?.totalCentavos ?? 0) + r.totalCostCentavos,
      );

      byYear.update(y, (v) => v + r.totalCostCentavos,
          ifAbsent: () => r.totalCostCentavos);

      final prevC = byCat[r.categoryId];
      byCat[r.categoryId] = (
        name: r.categoryName,
        total: (prevC?.total ?? 0) + r.totalCostCentavos,
      );
    }

    final monthlyList = byMonth.values.toList()
      ..sort((a, b) {
        final yc = a.year.compareTo(b.year);
        return yc != 0 ? yc : a.month.compareTo(b.month);
      });

    final annualList = [
      for (final e in byYear.entries)
        AnnualExpensePoint(year: e.key, totalCentavos: e.value),
    ]..sort((a, b) => a.year.compareTo(b.year));

    final catList = [
      for (final e in byCat.entries)
        CategoryExpensePoint(
          categoryId: e.key,
          categoryName: e.value.name,
          totalCentavos: e.value.total,
        ),
    ]..sort((a, b) => b.totalCentavos.compareTo(a.totalCentavos));

    final double? costPerKm =
        (trackedDistanceKm == null || trackedDistanceKm <= 0)
            ? null
            : total / trackedDistanceKm;

    return ExpenseReportSummary(
      totalExpensesCentavos: total,
      partsReplacementCentavos: partsTotal,
      laborExpensesCentavos: labor,
      trackedDistanceKm: trackedDistanceKm,
      costPerKmCentavos: costPerKm,
      monthly: monthlyList,
      annual: annualList,
      byCategory: catList,
    );
  }
}
