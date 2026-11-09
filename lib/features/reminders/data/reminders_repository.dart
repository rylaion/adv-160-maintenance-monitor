import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../../core/database/app_database.dart';
import '../../../core/enums/enums.dart';
import '../../../core/services/maintenance_calculator.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/utils/date_utils.dart';
import '../../maintenance/data/maintenance_repository.dart';
import '../../maintenance/domain/maintenance_overview.dart';
import '../../maintenance/presentation/status_text.dart';
import '../domain/reminder_models.dart';

/// Persists notification preferences in a local JSON file (offline).
class NotificationPreferencesStorage {
  NotificationPreferencesStorage(this._baseDir);
  final Future<Directory> Function() _baseDir;

  Future<File> _file() async {
    final dir = await _baseDir();
    await dir.create(recursive: true);
    return File(p.join(dir.path, 'notification_preferences.json'));
  }

  Future<NotificationPreferences> load() async {
    try {
      final f = await _file();
      if (!await f.exists()) return const NotificationPreferences();
      final map = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
      return NotificationPreferences.fromJson(map);
    } catch (_) {
      return const NotificationPreferences();
    }
  }

  Future<void> save(NotificationPreferences prefs) async {
    final f = await _file();
    await f.writeAsString(jsonEncode(prefs.toJson()));
  }
}

/// Repository + synchronization engine for offline maintenance reminders.
///
/// Responsibilities:
/// * Recalculates reminders immediately when odometer or maintenance records
///   change.
/// * Generates deterministic `dedupe_key` values (`auto:<ruleId>:<dueKm>:<dueDate>:<type>`)
///   so identical reminders are never duplicated or re-notified.
/// * Dismisses outdated auto reminders when maintenance is recorded or a
///   reminder transitions to a new state (e.g. UPCOMING -> DUE -> OVERDUE).
/// * Evaluates custom reminders against current odometer and date.
/// * Supports rescheduling date-based reminders after device reboot or app
///   startup.
class RemindersRepository {
  RemindersRepository(
    this._db,
    this._maintenanceRepo,
    this._notifications,
    this._prefsStorage, {
    MaintenanceCalculator calculator = const MaintenanceCalculator(),
    DateTime Function()? clock,
  })  : _calculator = calculator,
        _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final MaintenanceRepository _maintenanceRepo;
  final NotificationService _notifications;
  final NotificationPreferencesStorage _prefsStorage;
  final MaintenanceCalculator _calculator;
  final DateTime Function() _clock;

  static String? _clean(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  static MaintenanceReminder _fromRow(MaintenanceReminderRow r) =>
      MaintenanceReminder(
        id: r.id,
        motorcycleId: r.motorcycleId,
        itemId: r.itemId,
        ruleId: r.ruleId,
        reminderType: ReminderType.fromCode(r.reminderType),
        title: r.title,
        body: r.body,
        dueDate: AppDates.parseDateOnly(r.dueDate),
        dueOdometerKm: r.dueOdometerKm,
        dedupeKey: r.dedupeKey,
        status: ReminderStatus.fromCode(r.status),
        notifiedAt: AppDates.parseIso(r.notifiedAt),
      );

  Future<NotificationPreferences> loadPreferences() => _prefsStorage.load();

  Future<void> savePreferences(NotificationPreferences prefs) async {
    await _prefsStorage.save(prefs);
    if (!prefs.enabled) {
      await _notifications.cancelAll();
    } else {
      await syncReminders();
    }
  }

  /// Watches active (non-dismissed) reminders, newest / most urgent first.
  Stream<List<MaintenanceReminder>> watchActiveReminders() async* {
    yield await loadActiveReminders();
    final updates = _db
        .tableUpdates(TableUpdateQuery.onAllTables([_db.maintenanceReminders]));
    await for (final _ in updates) {
      yield await loadActiveReminders();
    }
  }

  Future<List<MaintenanceReminder>> loadActiveReminders() async {
    final rows = await (_db.select(_db.maintenanceReminders)
          ..where((t) => t.status.isNotValue(ReminderStatus.dismissed.code))
          ..orderBy([
            (t) => OrderingTerm.asc(t.dueDate),
            (t) => OrderingTerm.asc(t.dueOdometerKm),
            (t) => OrderingTerm.desc(t.id),
          ]))
        .get();
    return rows.map(_fromRow).toList();
  }

  /// Creates a custom reminder and dispatches/schedules it if allowed.
  Future<int> addCustomReminder(NewCustomReminder r) async {
    final title = r.title.trim();
    if (title.isEmpty) {
      throw const ReminderException('Reminder title is required.');
    }
    if (r.dueDate == null && r.dueOdometerKm == null) {
      throw const ReminderException(
          'Provide a due date and/or a due odometer reading.');
    }
    if (r.dueOdometerKm != null && r.dueOdometerKm! < 0) {
      throw const ReminderException('Due odometer cannot be negative.');
    }
    final dueDay = r.dueDate == null ? null : AppDates.dateOnly(r.dueDate!);
    final dedupeKey = 'custom:${r.motorcycleId}:${r.itemId ?? 0}:$title:'
        '${dueDay == null ? '-' : AppDates.toIsoDate(dueDay)}:'
        '${r.dueOdometerKm ?? '-'}';

    final existing = await (_db.select(_db.maintenanceReminders)
          ..where((t) => t.dedupeKey.equals(dedupeKey)))
        .getSingleOrNull();
    if (existing != null) {
      throw const ReminderException('This custom reminder already exists.');
    }

    final id = await _db.into(_db.maintenanceReminders).insert(
          MaintenanceRemindersCompanion.insert(
            motorcycleId: r.motorcycleId,
            itemId: Value(r.itemId),
            reminderType: ReminderType.custom.code,
            title: title,
            body: Value(_clean(r.body)),
            dueDate: Value(dueDay == null ? null : AppDates.toIsoDate(dueDay)),
            dueOdometerKm: Value(r.dueOdometerKm),
            dedupeKey: dedupeKey,
            status: Value(ReminderStatus.pending.code),
            createdAt: _clock().toIso8601String(),
          ),
        );
    await syncReminders();
    return id;
  }

  /// Dismisses a reminder and cancels any scheduled OS notification.
  Future<void> dismissReminder(int id) async {
    await (_db.update(_db.maintenanceReminders)..where((t) => t.id.equals(id)))
        .write(MaintenanceRemindersCompanion(
            status: Value(ReminderStatus.dismissed.code)));
    await _notifications.cancel(id);
  }

  /// Re-schedules all active future date-based reminders with the OS
  /// notification scheduler (e.g. after device reboot or app launch).
  Future<void> rescheduleDateNotifications() async {
    final prefs = await loadPreferences();
    if (!prefs.enabled) return;
    final today = AppDates.todayManila(_clock());
    final active = await loadActiveReminders();
    for (final r in active) {
      if (r.dueDate != null &&
          r.dueDate!.isAfter(today) &&
          prefs.allows(r.reminderType)) {
        await _notifications.scheduleDateReminder(
          id: r.id,
          title: r.title,
          body: r.body ?? r.title,
          dueDate: r.dueDate!,
        );
      }
    }
  }

  /// Synchronizes `maintenance_reminders` with the current maintenance overview
  /// and dispatches/schedules offline notifications without duplicates.
  Future<void> syncReminders() async {
    final snapshot = await _maintenanceRepo.loadSnapshot();
    final bike = snapshot.motorcycle;
    if (bike == null) return;

    final today = AppDates.todayManila(_clock());
    final overview = MaintenanceOverview.build(
      snapshot: snapshot,
      today: today,
      calculator: _calculator,
    );
    final prefs = await loadPreferences();

    final desiredByKey = <String, _DesiredReminder>{};

    for (final itemStatus in overview.scheduled) {
      final item = itemStatus.item;
      for (final ruleEval in itemStatus.evaluation.ruleEvaluations) {
        final cp = ruleEval.next;
        if (cp == null) continue;
        final dueDateIso =
            cp.dueDate == null ? '-' : AppDates.toIsoDate(cp.dueDate!);
        final dueKmStr = '${cp.dueKm ?? '-'}';
        final baseKey = 'auto:${ruleEval.rule.id}:$dueKmStr:$dueDateIso';

        // 1. Status-based reminder (UPCOMING, DUE, OVERDUE)
        final statusType = switch (ruleEval.status) {
          MaintenanceStatus.upcoming => ReminderType.upcoming,
          MaintenanceStatus.due ||
          MaintenanceStatus.inspectionRequired =>
            ReminderType.due,
          MaintenanceStatus.overdue ||
          MaintenanceStatus.replacementRequired =>
            ReminderType.overdue,
          MaintenanceStatus.good || MaintenanceStatus.completed => null,
        };

        if (statusType != null) {
          final key = '$baseKey:${statusType.code}';
          final title = '${item.name} · ${ruleEval.status.label}';
          final lines = StatusText.nextLines(ruleEval);
          desiredByKey[key] = _DesiredReminder(
            motorcycleId: bike.id,
            itemId: item.id,
            ruleId: ruleEval.rule.id,
            type: statusType,
            title: title,
            body: lines.isEmpty ? title : lines.join(' | '),
            dueDate: cp.dueDate,
            dueKm: cp.dueKm,
            dedupeKey: key,
            fireImmediately: true,
          );
        } else if (cp.dueDate != null && cp.dueDate!.isAfter(today)) {
          // 2. Future date-based scheduled reminder (DATE_BASED)
          final key = '$baseKey:${ReminderType.dateBased.code}';
          final title = '${item.name} · Scheduled ${cp.actionCode.label}';
          final body =
              '${cp.actionCode.label} due on ${AppDates.formatDate(cp.dueDate!)}';
          desiredByKey[key] = _DesiredReminder(
            motorcycleId: bike.id,
            itemId: item.id,
            ruleId: ruleEval.rule.id,
            type: ReminderType.dateBased,
            title: title,
            body: body,
            dueDate: cp.dueDate,
            dueKm: cp.dueKm,
            dedupeKey: key,
            fireImmediately: false,
          );
        }
      }
    }

    final existingRows = await _db.select(_db.maintenanceReminders).get();
    final existingByKey = {for (final r in existingRows) r.dedupeKey: r};

    // Dismiss auto reminders that are no longer desired (completed or state changed).
    for (final row in existingRows) {
      if (row.dedupeKey.startsWith('auto:') &&
          !desiredByKey.containsKey(row.dedupeKey) &&
          row.status != ReminderStatus.dismissed.code) {
        await (_db.update(_db.maintenanceReminders)
              ..where((t) => t.id.equals(row.id)))
            .write(MaintenanceRemindersCompanion(
                status: Value(ReminderStatus.dismissed.code)));
        await _notifications.cancel(row.id);
      }
    }

    final nowIso = _clock().toIso8601String();

    // Insert or dispatch desired auto reminders.
    for (final d in desiredByKey.values) {
      var row = existingByKey[d.dedupeKey];
      if (row == null) {
        final id = await _db.into(_db.maintenanceReminders).insert(
              MaintenanceRemindersCompanion.insert(
                motorcycleId: d.motorcycleId,
                itemId: Value(d.itemId),
                ruleId: Value(d.ruleId),
                reminderType: d.type.code,
                title: d.title,
                body: Value(d.body),
                dueDate: Value(
                    d.dueDate == null ? null : AppDates.toIsoDate(d.dueDate!)),
                dueOdometerKm: Value(d.dueKm),
                dedupeKey: d.dedupeKey,
                status: Value(ReminderStatus.pending.code),
                createdAt: nowIso,
              ),
            );
        row = await (_db.select(_db.maintenanceReminders)
              ..where((t) => t.id.equals(id)))
            .getSingle();
      }

      // Never re-notify if already notified or dismissed by user.
      if (row.status != ReminderStatus.pending.code) continue;
      if (!prefs.allows(d.type)) continue;

      if (d.fireImmediately) {
        await _notifications.notifyNow(
          id: row.id,
          title: d.title,
          body: d.body,
        );
        await (_db.update(_db.maintenanceReminders)
              ..where((t) => t.id.equals(row!.id)))
            .write(MaintenanceRemindersCompanion(
          status: Value(ReminderStatus.notified.code),
          notifiedAt: Value(nowIso),
        ));
      } else if (d.dueDate != null) {
        await _notifications.scheduleDateReminder(
          id: row.id,
          title: d.title,
          body: d.body,
          dueDate: d.dueDate!,
        );
        await (_db.update(_db.maintenanceReminders)
              ..where((t) => t.id.equals(row!.id)))
            .write(MaintenanceRemindersCompanion(
          status: Value(ReminderStatus.notified.code),
          notifiedAt: Value(nowIso),
        ));
      }
    }

    // Evaluate pending custom reminders against current odometer & date.
    final customPending = await (_db.select(_db.maintenanceReminders)
          ..where((t) =>
              t.reminderType.equals(ReminderType.custom.code) &
              t.status.equals(ReminderStatus.pending.code)))
        .get();
    final currentKm = snapshot.currentKm ?? 0;

    for (final c in customPending) {
      if (!prefs.allows(ReminderType.custom)) continue;
      final dueDay = AppDates.parseDateOnly(c.dueDate);
      final kmReached =
          c.dueOdometerKm != null && currentKm >= c.dueOdometerKm!;
      final dateReached = dueDay != null && !dueDay.isAfter(today);

      if (kmReached || dateReached) {
        await _notifications.notifyNow(
          id: c.id,
          title: c.title,
          body: c.body ?? c.title,
        );
        await (_db.update(_db.maintenanceReminders)
              ..where((t) => t.id.equals(c.id)))
            .write(MaintenanceRemindersCompanion(
          status: Value(ReminderStatus.notified.code),
          notifiedAt: Value(nowIso),
        ));
      } else if (dueDay != null && dueDay.isAfter(today)) {
        await _notifications.scheduleDateReminder(
          id: c.id,
          title: c.title,
          body: c.body ?? c.title,
          dueDate: dueDay,
        );
      }
    }
  }
}

class _DesiredReminder {
  const _DesiredReminder({
    required this.motorcycleId,
    required this.itemId,
    required this.ruleId,
    required this.type,
    required this.title,
    required this.body,
    required this.dedupeKey,
    required this.fireImmediately,
    this.dueDate,
    this.dueKm,
  });

  final int motorcycleId;
  final int itemId;
  final int ruleId;
  final ReminderType type;
  final String title;
  final String body;
  final DateTime? dueDate;
  final int? dueKm;
  final String dedupeKey;
  final bool fireImmediately;
}
