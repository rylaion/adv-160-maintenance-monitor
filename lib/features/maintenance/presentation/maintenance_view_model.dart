import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/enums.dart';
import '../../../core/exceptions/user_facing_exception.dart';
import '../../../core/services/maintenance_calculator.dart';
import '../../../core/utils/date_utils.dart';
import '../../../shared/providers/providers.dart';
import '../../settings/domain/app_settings.dart';
import '../../settings/presentation/settings_view_model.dart';
import '../data/maintenance_repository.dart';
import '../domain/maintenance_models.dart';
import '../domain/maintenance_overview.dart';
import '../domain/maintenance_record_detail.dart';

final maintenanceCalculatorProvider = Provider<MaintenanceCalculator>((ref) {
  final settings =
      ref.watch(appSettingsProvider).valueOrNull ?? const AppSettings();
  return MaintenanceCalculator(
    thresholds: MaintenanceThresholds(
      dueKm: settings.dueThresholdKm,
      upcomingKm: settings.upcomingThresholdKm,
      dueDays: settings.dueThresholdDays,
      upcomingDays: settings.upcomingThresholdDays,
    ),
  );
});

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

/// Filter state for the Maintenance History screen.
final maintenanceHistoryFilterProvider =
    StateProvider<MaintenanceHistoryFilter>(
        (ref) => const MaintenanceHistoryFilter());

/// Filtered stream of maintenance records.
final maintenanceHistoryProvider =
    StreamProvider<List<MaintenanceRecordDetail>>((ref) {
  final filter = ref.watch(maintenanceHistoryFilterProvider);
  return ref.watch(maintenanceRepositoryProvider).watchHistory(filter: filter);
});

/// Unfiltered stream of records for one item.
final itemHistoryProvider =
    StreamProvider.family<List<MaintenanceRecordDetail>, int>((ref, itemId) {
  return ref.watch(maintenanceRepositoryProvider).watchHistory(
        filter: MaintenanceHistoryFilter(itemId: itemId),
      );
});

/// Actions for recording, editing, voiding maintenance records and custom rules.
class MaintenanceActions extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> addRecord(NewMaintenanceRecord r) =>
      _run(() => ref.read(maintenanceRepositoryProvider).addRecord(r));

  Future<String?> editRecord(int recordId, NewMaintenanceRecord r) => _run(
      () => ref.read(maintenanceRepositoryProvider).editRecord(recordId, r));

  Future<String?> voidRecord(int recordId) =>
      _run(() => ref.read(maintenanceRepositoryProvider).voidRecord(recordId));

  Future<String?> addCustomRule({
    int? ruleId,
    required int motorcycleId,
    required int itemId,
    required ActionCode action,
    int? intervalKm,
    int? intervalMonths,
    int? warningKm,
    int? warningDays,
    int? lastCompletedKm,
    DateTime? lastCompletedDate,
    String? notes,
  }) =>
      _run(() => ref.read(maintenanceRepositoryProvider).saveCustomRule(
            ruleId: ruleId,
            motorcycleId: motorcycleId,
            itemId: itemId,
            action: action,
            intervalKm: intervalKm,
            intervalMonths: intervalMonths,
            warningKm: warningKm,
            warningDays: warningDays,
            lastCompletedKm: lastCompletedKm,
            lastCompletedDate: lastCompletedDate,
            notes: notes,
          ));

  Future<String?> createCustomItemAndRule({
    required int motorcycleId,
    required String itemName,
    int? categoryId,
    required ActionCode action,
    int? intervalKm,
    int? intervalMonths,
    int? warningKm,
    int? warningDays,
    int? lastCompletedKm,
    DateTime? lastCompletedDate,
    String? notes,
  }) =>
      _run(
          () => ref.read(maintenanceRepositoryProvider).createCustomItemAndRule(
                motorcycleId: motorcycleId,
                itemName: itemName,
                categoryId: categoryId,
                action: action,
                intervalKm: intervalKm,
                intervalMonths: intervalMonths,
                warningKm: warningKm,
                warningDays: warningDays,
                lastCompletedKm: lastCompletedKm,
                lastCompletedDate: lastCompletedDate,
                notes: notes,
              ));

  Future<String?> deleteCustomRule(int ruleId) => _run(
      () => ref.read(maintenanceRepositoryProvider).deleteCustomRule(ruleId));

  Future<String?> deleteCustomItem(int itemId) => _run(
      () => ref.read(maintenanceRepositoryProvider).deleteCustomItem(itemId));

  Future<String?> _run(Future<void> Function() body) async {
    state = const AsyncLoading();
    try {
      await body();
      ref.invalidate(maintenanceOverviewProvider);
      ref.invalidate(maintenanceHistoryProvider);
      state = const AsyncData(null);
      return null;
    } on UserFacingException catch (e) {
      state = const AsyncData(null);
      return e.message;
    } catch (e, st) {
      state = AsyncError(e, st);
      return 'Could not save: $e';
    }
  }
}

final maintenanceActionsProvider =
    AsyncNotifierProvider<MaintenanceActions, void>(MaintenanceActions.new);
