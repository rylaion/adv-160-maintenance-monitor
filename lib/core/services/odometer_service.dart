import '../../features/odometer/data/odometer_repository.dart';
import '../../features/odometer/domain/odometer_log.dart';
import '../enums/enums.dart';
import '../utils/date_utils.dart';

/// Business rules for odometer entry and correction.
///
/// * Negative readings are rejected.
/// * A reading lower than the latest confirmed one is rejected (never silently
///   accepted); use [correct] to fix an erroneous entry.
/// * Corrections require a reason, keep the original row (audit trail) and must
///   stay within the readings recorded before and after the entry.
class OdometerService {
  OdometerService(this._repo, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final OdometerRepository _repo;
  final DateTime Function() _clock;

  /// Highest confirmed reading, or null if none.
  Future<int?> currentKm(int motorcycleId) async =>
      (await _repo.latestConfirmed(motorcycleId))?.readingKm;

  /// Records a new reading and returns its id.
  Future<int> record({
    required int motorcycleId,
    required int readingKm,
    required DateTime date,
    String? notes,
  }) async {
    _validateReading(readingKm);
    final day = AppDates.dateOnly(date);
    if (day.isAfter(AppDates.todayManila(_clock()))) {
      throw const OdometerException('Date cannot be in the future.');
    }
    final latest = await _repo.latestConfirmed(motorcycleId);
    if (latest != null && readingKm < latest.readingKm) {
      throw OdometerException(
          'Reading is lower than the latest confirmed reading '
          '(${latest.readingKm} km). If that entry is wrong, correct it instead.');
    }
    final trimmed = notes?.trim();
    return _repo.insert(
      motorcycleId: motorcycleId,
      readingKm: readingKm,
      date: day,
      notes: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
      createdAt: _clock(),
    );
  }

  /// Corrects an erroneous confirmed entry. Returns the new entry's id.
  Future<int> correct({
    required int logId,
    required int newReadingKm,
    required String reason,
  }) async {
    _validateReading(newReadingKm);
    if (reason.trim().isEmpty) {
      throw const OdometerException('A reason is required for a correction.');
    }
    final old = await _repo.findById(logId);
    if (old == null) throw const OdometerException('Entry not found.');
    if (old.status != OdometerLogStatus.confirmed) {
      throw const OdometerException('Only confirmed entries can be corrected.');
    }

    final all = await _repo.confirmedChronological(old.motorcycleId);
    final idx = all.indexWhere((l) => l.id == old.id);
    if (idx > 0 && newReadingKm < all[idx - 1].readingKm) {
      throw OdometerException('Corrected value is lower than the previous '
          'reading (${all[idx - 1].readingKm} km).');
    }
    if (idx >= 0 &&
        idx < all.length - 1 &&
        newReadingKm > all[idx + 1].readingKm) {
      throw OdometerException('Corrected value is higher than the next '
          'reading (${all[idx + 1].readingKm} km).');
    }
    return _repo.applyCorrection(
      old: old,
      newReadingKm: newReadingKm,
      reason: reason.trim(),
      createdAt: _clock(),
    );
  }

  void _validateReading(int km) {
    if (km < 0) {
      throw const OdometerException('Odometer cannot be negative.');
    }
  }
}
