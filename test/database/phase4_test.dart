import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adv_mon/core/database/app_database.dart';
import 'package:adv_mon/core/enums/enums.dart';
import 'package:adv_mon/core/services/notification_service.dart';
import 'package:adv_mon/core/services/odometer_service.dart';
import 'package:adv_mon/features/maintenance/data/maintenance_repository.dart';
import 'package:adv_mon/features/odometer/data/odometer_repository.dart';
import 'package:adv_mon/features/reminders/data/reminders_repository.dart';
import 'package:adv_mon/features/reminders/domain/reminder_models.dart';

/// Fake notification gateway recording all immediate, scheduled, and cancelled
/// notifications in memory.
class FakeNotificationsGateway implements LocalNotificationsGateway {
  final List<({int id, String title, String body})> shown = [];
  final List<({int id, String title, String body, DateTime date})> scheduled =
      [];
  final List<int> cancelled = [];
  int cancelAllCount = 0;
  bool initialized = false;

  @override
  Future<void> initialize() async {
    initialized = true;
  }

  @override
  Future<bool> requestPermissions() async => true;

  @override
  Future<void> showImmediate({
    required int id,
    required String title,
    required String body,
  }) async {
    shown.add((id: id, title: title, body: body));
  }

  @override
  Future<void> scheduleAtDate({
    required int id,
    required String title,
    required String body,
    required DateTime date,
  }) async {
    scheduled.add((id: id, title: title, body: body, date: date));
  }

  @override
  Future<void> cancel(int id) async {
    cancelled.add(id);
  }

  @override
  Future<void> cancelAll() async {
    cancelAllCount++;
  }
}

void main() {
  late AppDatabase db;
  late Directory tempDir;
  late FakeNotificationsGateway gateway;
  late OdometerRepository odoRepo;
  late OdometerService odoService;
  late MaintenanceRepository maintRepo;
  late RemindersRepository remindersRepo;
  late int bikeId;
  late Map<String, int> itemIds;

  final fixedNow = DateTime.utc(2026, 11, 9, 2, 0);
  DateTime clock() => fixedNow;
  final day = DateTime.utc(2026, 11, 9);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tempDir = await Directory.systemTemp.createTemp('adv_mon_p4_test_');
    gateway = FakeNotificationsGateway();
    odoRepo = OdometerRepository(db);
    odoService = OdometerService(odoRepo, clock: clock);
    maintRepo = MaintenanceRepository(db, odoRepo, clock: clock);
    remindersRepo = RemindersRepository(
      db,
      maintRepo,
      NotificationService(gateway),
      NotificationPreferencesStorage(() async => tempDir),
      clock: clock,
    );
    bikeId = (await db.select(db.motorcycles).getSingle()).id;
    itemIds = {
      for (final i in await db.select(db.maintenanceItems).get()) i.name: i.id
    };
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('mileage, date & status reminders + deduplication', () {
    test(
        'generates upcoming/overdue reminders, schedules date reminders, and '
        'never duplicates notifications across repeated syncs', () async {
      await odoService.record(motorcycleId: bikeId, readingKm: 500, date: day);
      await remindersRepo.syncReminders();

      // At 500 km, the 4 items with 1,000 km checkpoints (Engine Oil, Engine
      // Idle Speed, Brake System, Nuts, Bolts, Fasteners) are UPCOMING.
      // Brake Fluid (24m), Radiator Coolant (36m), Final Drive Oil (24m) are future DATE_BASED.
      expect(gateway.shown, hasLength(4));
      expect(
          gateway.shown.map((s) => s.title), contains(contains('Engine Oil')));
      expect(gateway.scheduled, hasLength(3));

      final shownBefore = gateway.shown.length;
      final schedBefore = gateway.scheduled.length;

      // Second sync with no changes must NOT fire or schedule duplicates.
      await remindersRepo.syncReminders();
      expect(gateway.shown, hasLength(shownBefore));
      expect(gateway.scheduled, hasLength(schedBefore));
    });

    test(
        'recalculates reminders when odometer updates to overdue and dismisses '
        'when maintenance is recorded', () async {
      await odoService.record(
          motorcycleId: bikeId,
          readingKm: 500,
          date: DateTime.utc(2026, 11, 1));
      await remindersRepo.syncReminders();

      final initialActive = await remindersRepo.loadActiveReminders();
      final upcomingOil = initialActive.firstWhere((r) =>
          r.reminderType == ReminderType.upcoming &&
          r.title.contains('Engine Oil'));
      expect(upcomingOil.title, contains('Engine Oil'));

      // Odometer rises to 1,200 km -> Engine Oil becomes OVERDUE.
      await odoService.record(motorcycleId: bikeId, readingKm: 1200, date: day);
      await remindersRepo.syncReminders();

      final afterOdo = await remindersRepo.loadActiveReminders();
      expect(
          afterOdo.where((r) =>
              r.reminderType == ReminderType.upcoming &&
              r.title.contains('Engine Oil')),
          isEmpty);
      final overdueOil = afterOdo.firstWhere((r) =>
          r.reminderType == ReminderType.overdue &&
          r.title.contains('Engine Oil'));
      expect(overdueOil.title, contains('Engine Oil'));
      expect(gateway.cancelled, contains(upcomingOil.id));

      // Recording the Engine Oil replacement dismisses the OVERDUE reminder.
      await maintRepo.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Engine Oil']!,
        action: MaintenanceAction.replacement,
        date: day,
        odometerKm: 1200,
      ));
      await remindersRepo.syncReminders();

      final afterService = await remindersRepo.loadActiveReminders();
      expect(afterService.where((r) => r.itemId == itemIds['Engine Oil']),
          isEmpty);
      expect(gateway.cancelled, contains(overdueOil.id));
    });

    test('reschedules date-based notifications after reboot', () async {
      await odoService.record(motorcycleId: bikeId, readingKm: 500, date: day);
      await remindersRepo.syncReminders();
      gateway.scheduled.clear();

      await remindersRepo.rescheduleDateNotifications();
      expect(gateway.scheduled, hasLength(3));
      expect(
        gateway.scheduled.map((s) => s.date).toSet(),
        containsAll([
          DateTime.utc(2028, 11, 9),
          DateTime.utc(2029, 11, 9),
        ]),
      );
    });

    test('respects notification preferences and custom reminders', () async {
      await odoService.record(motorcycleId: bikeId, readingKm: 500, date: day);

      // Disable upcoming notifications before syncing.
      await remindersRepo.savePreferences(
        const NotificationPreferences(notifyUpcoming: false),
      );
      gateway.shown.clear();
      await remindersRepo.syncReminders();
      expect(gateway.shown.where((s) => s.title.contains('Upcoming')), isEmpty);

      // Add a custom reminder due at 500 km -> triggers immediately.
      await remindersRepo.addCustomReminder(NewCustomReminder(
        motorcycleId: bikeId,
        title: 'Check chain/drive & fasteners',
        dueOdometerKm: 500,
      ));
      expect(
        gateway.shown.map((s) => s.title),
        contains('Check chain/drive & fasteners'),
      );

      // Duplicate custom reminder is rejected.
      expect(
        () => remindersRepo.addCustomReminder(NewCustomReminder(
          motorcycleId: bikeId,
          title: 'Check chain/drive & fasteners',
          dueOdometerKm: 500,
        )),
        throwsA(isA<ReminderException>()),
      );

      // Disabling master toggle cancels all notifications.
      await remindersRepo.savePreferences(
        const NotificationPreferences(enabled: false),
      );
      expect(gateway.cancelAllCount, greaterThanOrEqualTo(1));
    });
  });
}
