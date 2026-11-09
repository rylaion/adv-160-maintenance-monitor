/// Expense arithmetic in integer centavos.
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
}

