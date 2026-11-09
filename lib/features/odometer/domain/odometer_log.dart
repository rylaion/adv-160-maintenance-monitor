import '../../../core/exceptions/user_facing_exception.dart';
import '../../../core/database/app_database.dart';
import '../../../core/enums/enums.dart';
import '../../../core/utils/date_utils.dart';

/// Domain model for an odometer log entry.
class OdometerLog {
  const OdometerLog({
    required this.id,
    required this.motorcycleId,
    required this.readingKm,
    required this.recordedDate,
    required this.status,
    this.notes,
    this.supersedesLogId,
    this.correctionReason,
  });

  final int id;
  final int motorcycleId;
  final int readingKm;

  /// Date only (UTC midnight).
  final DateTime recordedDate;
  final OdometerLogStatus status;
  final String? notes;
  final int? supersedesLogId;
  final String? correctionReason;

  factory OdometerLog.fromRow(OdometerLogRow r) => OdometerLog(
        id: r.id,
        motorcycleId: r.motorcycleId,
        readingKm: r.readingKm,
        recordedDate: AppDates.parseDateOnly(r.recordedDate) ??
            AppDates.dateOnly(DateTime.now()),
        status: OdometerLogStatus.fromCode(r.status),
        notes: r.notes,
        supersedesLogId: r.supersedesLogId,
        correctionReason: r.correctionReason,
      );
}

/// A user-facing validation failure for odometer input.
class OdometerException implements UserFacingException {
  const OdometerException(this.message);
  @override
  final String message;

  @override
  String toString() => message;
}
