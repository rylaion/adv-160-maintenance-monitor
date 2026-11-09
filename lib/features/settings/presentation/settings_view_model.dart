import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/exceptions/user_facing_exception.dart';
import '../../../core/services/backup_service.dart';
import '../../../shared/providers/providers.dart';
import '../../maintenance/domain/maintenance_record_detail.dart';
import '../domain/app_settings.dart';

final appSettingsProvider = FutureProvider<AppSettings>((ref) {
  return ref.watch(settingsStorageProvider).load();
});

class SettingsActions extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> updateSettings(AppSettings next) {
    return _run(() async {
      if (next.dueThresholdKm < 0 ||
          next.upcomingThresholdKm < next.dueThresholdKm ||
          next.dueThresholdDays < 0 ||
          next.upcomingThresholdDays < next.dueThresholdDays) {
        throw const BackupException(
            'Upcoming thresholds must be >= due thresholds and non-negative.');
      }
      await ref.read(settingsStorageProvider).save(next);
      ref.invalidate(appSettingsProvider);
    });
  }

  Future<({String? path, String? error})> exportJsonBackup() =>
      _runWithPath(() => ref.read(backupServiceProvider).exportJsonBackup());

  Future<({String? path, String? error})> exportZipBackup() =>
      _runWithPath(() => ref.read(backupServiceProvider).exportZipBackup());

  Future<({String? path, String? error})> exportMaintenanceRecordsCsv() =>
      _runWithPath(() async {
        final records = await ref
            .read(maintenanceRepositoryProvider)
            .watchHistory(filter: const MaintenanceHistoryFilter())
            .first;
        return ref
            .read(backupServiceProvider)
            .exportMaintenanceRecordsCsv(records);
      });

  Future<({String? path, String? error})> exportExpensesCsv() =>
      _runWithPath(() async {
        final records = await ref
            .read(maintenanceRepositoryProvider)
            .watchHistory(filter: const MaintenanceHistoryFilter())
            .first;
        return ref.read(backupServiceProvider).exportExpensesCsv(records);
      });

  Future<({BackupPreview? preview, String? error})> inspectBackup(
      String filePath) async {
    try {
      final preview =
          await ref.read(backupServiceProvider).inspectBackupFile(filePath);
      return (preview: preview, error: null);
    } on UserFacingException catch (e) {
      return (preview: null, error: e.message);
    } catch (e) {
      return (preview: null, error: 'Invalid backup file: $e');
    }
  }

  Future<String?> restoreBackup(String filePath,
      {required bool confirmedByUser}) {
    return _run(() async {
      await ref
          .read(backupServiceProvider)
          .restoreFromFile(filePath, confirmedByUser: confirmedByUser);
      await ref.read(remindersRepositoryProvider).syncReminders();
    });
  }

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
      return 'Operation failed: $e';
    }
  }

  Future<({String? path, String? error})> _runWithPath(
      Future<String> Function() body) async {
    state = const AsyncLoading();
    try {
      final path = await body();
      state = const AsyncData(null);
      return (path: path, error: null);
    } on UserFacingException catch (e) {
      state = const AsyncData(null);
      return (path: null, error: e.message);
    } catch (e, st) {
      state = AsyncError(e, st);
      return (path: null, error: 'Export failed: $e');
    }
  }
}

final settingsActionsProvider =
    AsyncNotifierProvider<SettingsActions, void>(SettingsActions.new);
