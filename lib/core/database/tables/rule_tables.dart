import 'package:drift/drift.dart';

import 'motorcycle_tables.dart';

/// A maintenance rule for an item. Manual-based rules must carry the source
/// document and page. Rules are never edited in place for manufacturer data;
/// custom overrides are separate rows with source CUSTOM.
@DataClassName('MaintenanceRuleRow')
@TableIndex(name: 'idx_rules_item', columns: {#itemId})
@TableIndex(name: 'idx_rules_motorcycle', columns: {#motorcycleId})
class MaintenanceRules extends Table {
  @override
  String get tableName => 'maintenance_rules';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get motorcycleId => integer().references(Motorcycles, #id)();
  IntColumn get itemId => integer().references(MaintenanceItems, #id)();

  /// MILEAGE | DATE | COMBINED | CONDITION | CUSTOM
  TextColumn get ruleType => text()();

  /// I | R | C
  TextColumn get actionCode => text()();

  /// HONDA_MANUAL | SERVICE_MANUAL | CUSTOM
  TextColumn get source => text()();
  TextColumn get sourceDocument => text().nullable()();
  IntColumn get sourcePage => integer().nullable()();

  /// Simple recurring intervals (steps table holds explicit checkpoints).
  IntColumn get intervalKm => integer().nullable()();
  IntColumn get intervalMonths => integer().nullable()();

  /// False until the entry is confirmed against the official manual.
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
}

/// Explicit checkpoints of a rule (e.g. initial 1,000 km, then every 6,000 km).
@DataClassName('MaintenanceRuleStepRow')
@TableIndex(name: 'idx_rule_steps_rule', columns: {#ruleId})
class MaintenanceRuleSteps extends Table {
  @override
  String get tableName => 'maintenance_rule_steps';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get ruleId => integer().references(MaintenanceRules, #id)();
  IntColumn get stepOrder => integer()();

  /// I | R | C
  TextColumn get actionCode => text()();
  IntColumn get atKm => integer().nullable()();
  IntColumn get atMonths => integer().nullable()();
  IntColumn get repeatEveryKm => integer().nullable()();
  IntColumn get repeatEveryMonths => integer().nullable()();
  TextColumn get notes => text().nullable()();
}
