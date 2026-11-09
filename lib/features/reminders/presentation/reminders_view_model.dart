import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/exceptions/user_facing_exception.dart';
import '../../../shared/providers/providers.dart';
import '../../maintenance/presentation/maintenance_view_model.dart';
import '../../motorcycle/presentation/motorcycle_view_model.dart';
import '../domain/reminder_models.dart';

/// Watches active (non-dismissed) reminders. Also triggers a background
/// synchronization whenever `maintenanceOverviewProvider` emits a new snapshot
/// (odometer update or service record saved).
final activeRemindersProvider =
    StreamProvider<List<MaintenanceReminder>>((ref) {
  ref.listen(maintenanceOverviewProvider, (_, next) {
    if (next.hasValue) {
      ref.read(remindersRepositoryProvider).syncReminders();
    }
  }, fireImmediately: true);
  return ref.watch(remindersRepositoryProvider).watchActiveReminders();
});

final notificationPreferencesProvider =
    FutureProvider<NotificationPreferences>((ref) {
  return ref.watch(remindersRepositoryProvider).loadPreferences();
});

class RemindersActions extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> requestPermissions() =>
      ref.read(notificationServiceProvider).requestPermissions();

  Future<String?> updatePreferences(NotificationPreferences prefs) {
    return _run(() async {
      await ref.read(remindersRepositoryProvider).savePreferences(prefs);
      ref.invalidate(notificationPreferencesProvider);
    });
  }

  Future<String?> addCustomReminder({
    required String title,
    int? itemId,
    String? body,
    DateTime? dueDate,
    int? dueOdometerKm,
  }) {
    return _run(() async {
      final bike = await ref.read(primaryMotorcycleProvider.future);
      if (bike == null) {
        throw const ReminderException('No motorcycle found.');
      }
      await ref.read(remindersRepositoryProvider).addCustomReminder(
            NewCustomReminder(
              motorcycleId: bike.id,
              itemId: itemId,
              title: title,
              body: body,
              dueDate: dueDate,
              dueOdometerKm: dueOdometerKm,
            ),
          );
    });
  }

  Future<String?> dismiss(int id) =>
      _run(() => ref.read(remindersRepositoryProvider).dismissReminder(id));

  Future<String?> syncNow() =>
      _run(() => ref.read(remindersRepositoryProvider).syncReminders());

  Future<String?> _run(Future<void> Function() body) async {
    state = const AsyncLoading();
    try {
      await body();
      state = const AsyncData(null);
      return null;
    } on UserFacingException catch (e) {
      state = const AsyncData(null);
      return e.message;
    } catch (e, st) {
      state = AsyncError(e, st);
      return 'Could not complete action: $e';
    }
  }
}

final remindersActionsProvider =
    AsyncNotifierProvider<RemindersActions, void>(RemindersActions.new);
