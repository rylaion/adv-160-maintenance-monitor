/// Domain enums persisted as text (via [name]-style codes) in SQLite.
library;

/// Where a maintenance rule comes from.
enum MaintenanceSource {
  hondaManual('HONDA_MANUAL'),
  serviceManual('SERVICE_MANUAL'),
  custom('CUSTOM');

  const MaintenanceSource(this.code);
  final String code;

  static MaintenanceSource fromCode(String code) => values.firstWhere(
      (e) => e.code == code,
      orElse: () => throw ArgumentError('Unknown MaintenanceSource: $code'));
}

/// Computed maintenance status for an item or scheduled checkpoint.
enum MaintenanceStatus {
  completed('COMPLETED'),
  good('GOOD'),
  upcoming('UPCOMING'),
  due('DUE'),
  overdue('OVERDUE'),
  inspectionRequired('INSPECTION_REQUIRED'),
  replacementRequired('REPLACEMENT_REQUIRED');

  const MaintenanceStatus(this.code);
  final String code;

  static MaintenanceStatus fromCode(String code) => values.firstWhere(
      (e) => e.code == code,
      orElse: () => throw ArgumentError('Unknown MaintenanceStatus: $code'));
}

/// Honda manual action codes: I = Inspect, R = Replace, C = Clean.
enum ActionCode {
  inspect('I'),
  replace('R'),
  clean('C');

  const ActionCode(this.code);
  final String code;

  static ActionCode fromCode(String code) =>
      values.firstWhere((e) => e.code == code,
          orElse: () => throw ArgumentError('Unknown ActionCode: $code'));
}

/// Kind of schedule a rule describes.
enum RuleType {
  mileage('MILEAGE'),
  date('DATE'),
  combined('COMBINED'),
  condition('CONDITION'),
  custom('CUSTOM');

  const RuleType(this.code);
  final String code;

  static RuleType fromCode(String code) =>
      values.firstWhere((e) => e.code == code,
          orElse: () => throw ArgumentError('Unknown RuleType: $code'));
}

/// Action performed in a service record.
enum MaintenanceAction {
  inspection('INSPECTION'),
  cleaning('CLEANING'),
  adjustment('ADJUSTMENT'),
  replacement('REPLACEMENT'),
  repair('REPAIR'),
  lubrication('LUBRICATION'),
  other('OTHER');

  const MaintenanceAction(this.code);
  final String code;

  String get label => switch (this) {
        MaintenanceAction.inspection => 'Inspected',
        MaintenanceAction.cleaning => 'Cleaned',
        MaintenanceAction.adjustment => 'Adjusted',
        MaintenanceAction.replacement => 'Replaced',
        MaintenanceAction.repair => 'Repaired',
        MaintenanceAction.lubrication => 'Lubricated',
        MaintenanceAction.other => 'Other',
      };

  static MaintenanceAction fromCode(String code) => values.firstWhere(
      (e) => e.code == code,
      orElse: () => throw ArgumentError('Unknown MaintenanceAction: $code'));
}

/// Lifecycle of an odometer log entry (kept for the audit trail).
enum OdometerLogStatus {
  confirmed('CONFIRMED'),
  corrected('CORRECTED'),
  voided('VOIDED');

  const OdometerLogStatus(this.code);
  final String code;

  static OdometerLogStatus fromCode(String code) => values.firstWhere(
      (e) => e.code == code,
      orElse: () => throw ArgumentError('Unknown OdometerLogStatus: $code'));
}

/// Reminder categories.
enum ReminderType {
  upcoming('UPCOMING'),
  due('DUE'),
  overdue('OVERDUE'),
  dateBased('DATE_BASED'),
  custom('CUSTOM');

  const ReminderType(this.code);
  final String code;

  static ReminderType fromCode(String code) =>
      values.firstWhere((e) => e.code == code,
          orElse: () => throw ArgumentError('Unknown ReminderType: $code'));
}

/// Reminder delivery state.
enum ReminderStatus {
  pending('PENDING'),
  notified('NOTIFIED'),
  dismissed('DISMISSED');

  const ReminderStatus(this.code);
  final String code;

  static ReminderStatus fromCode(String code) =>
      values.firstWhere((e) => e.code == code,
          orElse: () => throw ArgumentError('Unknown ReminderStatus: $code'));
}

/// Ordering used to pick the "worst" status of an item.
extension MaintenanceStatusSeverity on MaintenanceStatus {
  int get severity => switch (this) {
        MaintenanceStatus.completed => 0,
        MaintenanceStatus.good => 0,
        MaintenanceStatus.upcoming => 1,
        MaintenanceStatus.due => 2,
        MaintenanceStatus.inspectionRequired => 3,
        MaintenanceStatus.overdue => 4,
        MaintenanceStatus.replacementRequired => 5,
      };

  String get label => switch (this) {
        MaintenanceStatus.completed => 'Completed',
        MaintenanceStatus.good => 'Good',
        MaintenanceStatus.upcoming => 'Upcoming',
        MaintenanceStatus.due => 'Due',
        MaintenanceStatus.overdue => 'Overdue',
        MaintenanceStatus.inspectionRequired => 'Inspection required',
        MaintenanceStatus.replacementRequired => 'Replacement required',
      };
}

/// Which logged actions satisfy a Honda action code.
/// Per Honda Owner's Manual (32K0WA100, p. 88), I = Inspect (clean, adjust,
/// lubricate, or replace, if necessary). Replacement also covers inspection and
/// cleaning of the same part.
extension ActionCodeSatisfaction on ActionCode {
  bool isSatisfiedBy(MaintenanceAction action) => switch (this) {
        ActionCode.inspect => action == MaintenanceAction.inspection ||
            action == MaintenanceAction.cleaning ||
            action == MaintenanceAction.adjustment ||
            action == MaintenanceAction.replacement ||
            action == MaintenanceAction.repair ||
            action == MaintenanceAction.lubrication ||
            action == MaintenanceAction.other,
        ActionCode.clean => action == MaintenanceAction.cleaning ||
            action == MaintenanceAction.replacement ||
            action == MaintenanceAction.repair,
        ActionCode.replace => action == MaintenanceAction.replacement,
      };

  MaintenanceAction get defaultMaintenanceAction => switch (this) {
        ActionCode.inspect => MaintenanceAction.inspection,
        ActionCode.replace => MaintenanceAction.replacement,
        ActionCode.clean => MaintenanceAction.cleaning,
      };

  String get label => switch (this) {
        ActionCode.inspect => 'Inspect',
        ActionCode.replace => 'Replace',
        ActionCode.clean => 'Clean',
      };
}
