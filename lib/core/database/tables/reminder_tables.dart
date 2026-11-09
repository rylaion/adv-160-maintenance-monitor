import 'package:drift/drift.dart';

import 'history_tables.dart';
import 'motorcycle_tables.dart';
import 'rule_tables.dart';

@DataClassName('MaintenanceReminderRow')
@TableIndex(name: 'idx_reminders_status_due', columns: {#status, #dueDate})
@TableIndex(name: 'idx_reminders_motorcycle', columns: {#motorcycleId})
class MaintenanceReminders extends Table {
  @override
  String get tableName => 'maintenance_reminders';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get motorcycleId => integer().references(Motorcycles, #id)();
  IntColumn get itemId =>
      integer().nullable().references(MaintenanceItems, #id)();
  IntColumn get ruleId =>
      integer().nullable().references(MaintenanceRules, #id)();

  /// UPCOMING | DUE | OVERDUE | DATE_BASED | CUSTOM
  TextColumn get reminderType => text()();
  TextColumn get title => text()();
  TextColumn get body => text().nullable()();
  TextColumn get dueDate => text().nullable()();
  IntColumn get dueOdometerKm => integer().nullable()();

  /// Unique key (e.g. rule + checkpoint + type) preventing duplicate reminders.
  TextColumn get dedupeKey => text().unique()();

  /// PENDING | NOTIFIED | DISMISSED
  TextColumn get status => text().withDefault(const Constant('PENDING'))();
  TextColumn get notifiedAt => text().nullable()();
  TextColumn get createdAt => text()();
}

/// Attachment (photo) linked to a record, measurement, or the motorcycle.
@DataClassName('AttachmentRow')
@TableIndex(name: 'idx_attachments_record', columns: {#recordId})
@TableIndex(name: 'idx_attachments_measurement', columns: {#measurementId})
class Attachments extends Table {
  @override
  String get tableName => 'attachments';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get recordId =>
      integer().nullable().references(MaintenanceRecords, #id)();
  IntColumn get measurementId =>
      integer().nullable().references(ComponentMeasurements, #id)();
  IntColumn get motorcycleId =>
      integer().nullable().references(Motorcycles, #id)();
  TextColumn get filePath => text()();
  TextColumn get mimeType => text().nullable()();
  TextColumn get caption => text().nullable()();
  TextColumn get createdAt => text()();
}
