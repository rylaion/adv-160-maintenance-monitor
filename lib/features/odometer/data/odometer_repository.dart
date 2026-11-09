import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/enums/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../domain/odometer_log.dart';

/// Repository for odometer logs. Entries are never deleted or edited in
/// place: corrections add a new row and mark the old one CORRECTED.
class OdometerRepository {
  OdometerRepository(this._db);
  final AppDatabase _db;

  /// All logs for the motorcycle, newest first (includes superseded rows for
  /// the audit trail).
  Stream<List<OdometerLog>> watchLogs(int motorcycleId) {
    final q = _db.select(_db.odometerLogs)
      ..where((t) => t.motorcycleId.equals(motorcycleId))
      ..orderBy([
        (t) => OrderingTerm.desc(t.recordedDate),
        (t) => OrderingTerm.desc(t.id),
      ]);
    return q.watch().map((rows) => rows.map(OdometerLog.fromRow).toList());
  }

  /// Confirmed log with the highest reading, or null.
  Future<OdometerLog?> latestConfirmed(int motorcycleId) async {
    final q = _db.select(_db.odometerLogs)
      ..where((t) =>
          t.motorcycleId.equals(motorcycleId) &
          t.status.equals(OdometerLogStatus.confirmed.code))
      ..orderBy([
        (t) => OrderingTerm.desc(t.readingKm),
        (t) => OrderingTerm.desc(t.id),
      ])
      ..limit(1);
    final row = await q.getSingleOrNull();
    return row == null ? null : OdometerLog.fromRow(row);
  }

  Future<OdometerLog?> findById(int id) async {
    final row = await (_db.select(_db.odometerLogs)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : OdometerLog.fromRow(row);
  }

  /// Confirmed logs ordered chronologically (date, then id).
  Future<List<OdometerLog>> confirmedChronological(int motorcycleId) async {
    final rows = await (_db.select(_db.odometerLogs)
          ..where((t) =>
              t.motorcycleId.equals(motorcycleId) &
              t.status.equals(OdometerLogStatus.confirmed.code))
          ..orderBy([
            (t) => OrderingTerm.asc(t.recordedDate),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .get();
    return rows.map(OdometerLog.fromRow).toList();
  }

  Future<int> insert({
    required int motorcycleId,
    required int readingKm,
    required DateTime date,
    String? notes,
    required DateTime createdAt,
  }) {
    return _db.into(_db.odometerLogs).insert(OdometerLogsCompanion.insert(
          motorcycleId: motorcycleId,
          readingKm: readingKm,
          recordedDate: AppDates.toIsoDate(date),
          notes: Value(notes),
          createdAt: createdAt.toIso8601String(),
        ));
  }

  /// Logs [readingKm] only if it is higher than the latest confirmed reading
  /// (or none exists), keeping mileage-based statuses consistent when a
  /// record or measurement carries a newer odometer value.
  Future<void> logIfHigher({
    required int motorcycleId,
    required int readingKm,
    required DateTime date,
    required String note,
    required DateTime createdAt,
  }) async {
    final latest = await latestConfirmed(motorcycleId);
    if (latest == null || readingKm > latest.readingKm) {
      await insert(
        motorcycleId: motorcycleId,
        readingKm: readingKm,
        date: date,
        notes: note,
        createdAt: createdAt,
      );
    }
  }

  /// Atomically supersedes [old] with a corrected entry, keeping both rows.
  Future<int> applyCorrection({
    required OdometerLog old,
    required int newReadingKm,
    required String reason,
    required DateTime createdAt,
  }) {
    return _db.transaction(() async {
      await (_db.update(_db.odometerLogs)..where((t) => t.id.equals(old.id)))
          .write(OdometerLogsCompanion(
              status: Value(OdometerLogStatus.corrected.code)));
      return _db.into(_db.odometerLogs).insert(OdometerLogsCompanion.insert(
            motorcycleId: old.motorcycleId,
            readingKm: newReadingKm,
            recordedDate: AppDates.toIsoDate(old.recordedDate),
            notes: Value(old.notes),
            supersedesLogId: Value(old.id),
            correctionReason: Value(reason),
            createdAt: createdAt.toIso8601String(),
          ));
    });
  }
}
