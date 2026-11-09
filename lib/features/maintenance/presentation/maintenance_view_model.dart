import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/maintenance_calculator.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/providers/providers.dart';
import '../domain/maintenance_overview.dart';

final maintenanceCalculatorProvider =
    Provider<MaintenanceCalculator>((ref) => const MaintenanceCalculator());

/// Live, fully recalculated overview. Re-emits whenever the odometer, rules,
/// items, or maintenance records change.
final maintenanceOverviewProvider = StreamProvider<MaintenanceOverview>((ref) {
  final repo = ref.watch(maintenanceRepositoryProvider);
  final calc = ref.watch(maintenanceCalculatorProvider);
  final clock = ref.watch(clockProvider);
  return repo.watchSnapshot().map((snapshot) => MaintenanceOverview.build(
        snapshot: snapshot,
        today: AppDates.todayManila(clock()),
        calculator: calc,
      ));
});

