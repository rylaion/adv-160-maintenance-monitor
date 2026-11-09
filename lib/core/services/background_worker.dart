import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:workmanager/workmanager.dart';

import '../../features/maintenance/data/maintenance_repository.dart';
import '../../features/odometer/data/odometer_repository.dart';
import '../../features/reminders/data/reminders_repository.dart';
import '../database/app_database.dart';
import 'notification_service.dart';

const String kPeriodicReminderTaskName = 'adv_mon_periodic_reminder_check';

@pragma('vm:entry-point')
void advMonWorkmanagerDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      tzdata.initializeTimeZones();
      final db = AppDatabase.open();
      try {
        final odo = OdometerRepository(db);
        final maint = MaintenanceRepository(db, odo);
        final notif = NotificationService(FlutterLocalNotificationsGateway());
        final prefs =
            NotificationPreferencesStorage(getApplicationDocumentsDirectory);
        final reminders = RemindersRepository(db, maint, notif, prefs);
        await reminders.syncReminders();
        await reminders.rescheduleDateNotifications();
      } finally {
        await db.close();
      }
      return true;
    } catch (_) {
      return false;
    }
  });
}

/// Initializes WorkManager for periodic background reminder checks on Android.
/// Does not depend on exact execution timing.
class BackgroundWorker {
  BackgroundWorker._();

  static Future<void> initializeAndSchedule() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await Workmanager().initialize(advMonWorkmanagerDispatcher);
      await Workmanager().registerPeriodicTask(
        kPeriodicReminderTaskName,
        kPeriodicReminderTaskName,
        frequency: const Duration(hours: 12),
        existingWorkPolicy: ExistingWorkPolicy.keep,
      );
    } catch (_) {
      // WorkManager is optional; mileage & date reminders are also synced
      // immediately in-process.
    }
  }
}
