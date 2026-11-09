import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../constants/app_constants.dart';

/// Platform abstraction for offline local notifications so unit and database
/// tests can verify scheduling and deduplication without platform channels.
abstract class LocalNotificationsGateway {
  Future<void> initialize();
  Future<bool> requestPermissions();
  Future<void> showImmediate({
    required int id,
    required String title,
    required String body,
  });
  Future<void> scheduleAtDate({
    required int id,
    required String title,
    required String body,
    required DateTime date,
  });
  Future<void> cancel(int id);
  Future<void> cancelAll();
}

/// Production implementation backed by `flutter_local_notifications`.
class FlutterLocalNotificationsGateway implements LocalNotificationsGateway {
  FlutterLocalNotificationsGateway([FlutterLocalNotificationsPlugin? plugin])
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  static const _channelId = 'adv_mon_maintenance';
  static const _channelName = 'Maintenance Reminders';
  static const _channelDesc = 'Offline maintenance reminders for Honda ADV 160';

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
      );

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidInit);
    await _plugin.initialize(settings);
    _initialized = true;
  }

  @override
  Future<bool> requestPermissions() async {
    await initialize();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return true;
    final granted = await android.requestNotificationsPermission();
    return granted ?? false;
  }

  @override
  Future<void> showImmediate({
    required int id,
    required String title,
    required String body,
  }) async {
    await initialize();
    await _plugin.show(id, title, body, _details);
  }

  @override
  Future<void> scheduleAtDate({
    required int id,
    required String title,
    required String body,
    required DateTime date,
  }) async {
    await initialize();
    tz.Location loc;
    try {
      loc = tz.getLocation(kAppTimeZone);
    } catch (_) {
      loc = tz.UTC;
    }
    // Schedule for 08:00 Asia/Manila on the target date.
    final scheduled = tz.TZDateTime(loc, date.year, date.month, date.day, 8);
    final now = tz.TZDateTime.now(loc);
    if (!scheduled.isAfter(now)) {
      await showImmediate(id: id, title: title, body: body);
      return;
    }
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> cancel(int id) async {
    await initialize();
    await _plugin.cancel(id);
  }

  @override
  Future<void> cancelAll() async {
    await initialize();
    await _plugin.cancelAll();
  }
}

/// High-level notification service used by the reminder engine.
class NotificationService {
  NotificationService(this._gateway);
  final LocalNotificationsGateway _gateway;

  Future<bool> requestPermissions() => _gateway.requestPermissions();

  Future<void> notifyNow({
    required int id,
    required String title,
    required String body,
  }) =>
      _gateway.showImmediate(id: id, title: title, body: body);

  Future<void> scheduleDateReminder({
    required int id,
    required String title,
    required String body,
    required DateTime dueDate,
  }) =>
      _gateway.scheduleAtDate(id: id, title: title, body: body, date: dueDate);

  Future<void> cancel(int id) => _gateway.cancel(id);
  Future<void> cancelAll() => _gateway.cancelAll();
}
