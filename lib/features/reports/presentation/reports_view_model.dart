import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/expense_service.dart';
import '../../../shared/providers/providers.dart';
import '../../maintenance/domain/maintenance_record_detail.dart';
import '../../maintenance/presentation/maintenance_view_model.dart';

/// Computes a live [ExpenseReportSummary] from maintenance history and the
/// current tracked distance.
final expenseReportProvider = FutureProvider<ExpenseReportSummary>((ref) async {
  final overview = await ref.watch(maintenanceOverviewProvider.future);
  final records = await ref
      .watch(maintenanceRepositoryProvider)
      .watchHistory(filter: const MaintenanceHistoryFilter())
      .first;
  return ref.watch(expenseServiceProvider).summarize(
        records: records,
        trackedDistanceKm: overview.trackedKm,
      );
});
