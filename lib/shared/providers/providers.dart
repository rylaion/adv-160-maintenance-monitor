import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/database/app_database.dart';
import '../../core/services/attachment_service.dart';
import '../../core/services/backup_service.dart';
import '../../core/services/expense_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/odometer_service.dart';
import '../../features/components/data/components_repository.dart';
import '../../features/maintenance/data/maintenance_repository.dart';
import '../../features/motorcycle/data/motorcycle_repository.dart';
import '../../features/odometer/data/odometer_repository.dart';
import '../../features/parts/data/parts_repository.dart';
import '../../features/reminders/data/reminders_repository.dart';
import '../../features/settings/data/settings_storage.dart';

/// Root database provider. Overridden in tests with an in-memory database.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
});

final motorcycleRepositoryProvider = Provider<MotorcycleRepository>(
  (ref) => MotorcycleRepository(ref.watch(appDatabaseProvider)),
);

/// Current time source. Overridden in tests for deterministic dates.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final photoPickerProvider =
    Provider<PhotoPicker>((ref) => ImagePickerPhotoPicker());

final backupFilePickerProvider =
    Provider<BackupFilePicker>((ref) => FilePickerBackupFilePicker());

final attachmentServiceProvider = Provider<AttachmentService>(
  (ref) => AttachmentService(getApplicationDocumentsDirectory),
);

final expenseServiceProvider =
    Provider<ExpenseService>((ref) => const ExpenseService());

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(
    ref.watch(appDatabaseProvider),
    getApplicationDocumentsDirectory,
    clock: ref.watch(clockProvider),
  ),
);

final settingsStorageProvider = Provider<SettingsStorage>(
  (ref) => SettingsStorage(getApplicationDocumentsDirectory),
);

final localNotificationsGatewayProvider = Provider<LocalNotificationsGateway>(
  (ref) => FlutterLocalNotificationsGateway(),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(ref.watch(localNotificationsGatewayProvider)),
);

final notificationPreferencesStorageProvider =
    Provider<NotificationPreferencesStorage>(
  (ref) => NotificationPreferencesStorage(getApplicationDocumentsDirectory),
);

final odometerRepositoryProvider = Provider<OdometerRepository>(
  (ref) => OdometerRepository(ref.watch(appDatabaseProvider)),
);

final odometerServiceProvider = Provider<OdometerService>(
  (ref) => OdometerService(ref.watch(odometerRepositoryProvider),
      clock: ref.watch(clockProvider)),
);

final partsRepositoryProvider = Provider<PartsRepository>(
  (ref) => PartsRepository(ref.watch(appDatabaseProvider),
      clock: ref.watch(clockProvider)),
);

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>(
  (ref) => MaintenanceRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(odometerRepositoryProvider),
    parts: ref.watch(partsRepositoryProvider),
    attachments: ref.watch(attachmentServiceProvider),
    expense: ref.watch(expenseServiceProvider),
    clock: ref.watch(clockProvider),
  ),
);

final componentsRepositoryProvider = Provider<ComponentsRepository>(
  (ref) => ComponentsRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(odometerRepositoryProvider),
    attachments: ref.watch(attachmentServiceProvider),
    clock: ref.watch(clockProvider),
  ),
);

final remindersRepositoryProvider = Provider<RemindersRepository>(
  (ref) => RemindersRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(maintenanceRepositoryProvider),
    ref.watch(notificationServiceProvider),
    ref.watch(notificationPreferencesStorageProvider),
    clock: ref.watch(clockProvider),
  ),
);
