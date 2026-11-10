import 'dart:convert';
import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/exceptions/user_facing_exception.dart';
import '../domain/cvt_models.dart';

class CvtException implements UserFacingException {
  const CvtException(this.message);
  @override
  final String message;
  @override
  String toString() => message;
}

class CvtRepository {
  CvtRepository(this._db, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  Stream<List<CvtConfigurationDetail>> watchConfigurations(int motorcycleId,
      {bool includeArchived = false}) {
    final q = _db.select(_db.cvtConfigurations)
      ..where((t) => t.motorcycleId.equals(motorcycleId));

    if (!includeArchived) {
      q.where((t) => t.isArchived.equals(false));
    }

    q.orderBy([
      (t) => OrderingTerm.desc(t.isActive),
      (t) => OrderingTerm.desc(t.installedDate),
    ]);

    return q
        .watch()
        .map((rows) => rows.map(CvtConfigurationDetail.fromRow).toList());
  }

  Future<CvtConfigurationDetail?> getActiveConfiguration(
      int motorcycleId) async {
    final row = await (_db.select(_db.cvtConfigurations)
          ..where((t) =>
              t.motorcycleId.equals(motorcycleId) & t.isActive.equals(true))
          ..limit(1))
        .getSingleOrNull();

    if (row == null) return null;
    return getConfigurationById(row.id);
  }

  Future<CvtConfigurationDetail?> getConfigurationById(int id) async {
    final row = await (_db.select(_db.cvtConfigurations)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;

    final logs = await (_db.select(_db.cvtPerformanceLogs)
          ..where((t) => t.configurationId.equals(id))
          ..orderBy([(t) => OrderingTerm.desc(t.logDate)]))
        .get();

    return CvtConfigurationDetail.fromRow(row, logs);
  }

  Future<int> saveConfiguration(NewCvtConfigurationInput input) {
    return _db.transaction(() async {
      final trimmedName = input.name.trim();
      if (trimmedName.isEmpty) {
        throw const CvtException('Configuration name cannot be empty.');
      }

      final now = _clock();
      final photosJson =
          input.photoPaths.isEmpty ? null : jsonEncode(input.photoPaths);

      // If set to active, deactivate all other configs for this motorcycle first
      if (input.isActive) {
        await (_db.update(_db.cvtConfigurations)
              ..where((t) => t.motorcycleId.equals(input.motorcycleId)))
            .write(const CvtConfigurationsCompanion(isActive: Value(false)));
      }

      final id = await _db.into(_db.cvtConfigurations).insert(
            CvtConfigurationsCompanion.insert(
              motorcycleId: input.motorcycleId,
              name: trimmedName,
              pulleyBrandModel: Value(input.pulleyBrandModel?.trim()),
              flyballWeightGrams: Value(input.flyballWeightGrams),
              flyballArrangement: Value(input.flyballArrangement?.trim()),
              centerSpringRpm: Value(input.centerSpringRpm),
              clutchSpringRpm: Value(input.clutchSpringRpm),
              beltBrandPartNumber: Value(input.beltBrandPartNumber?.trim()),
              pulleyWasherThicknessMm: Value(input.pulleyWasherThicknessMm),
              clutchBellSpec: Value(input.clutchBellSpec?.trim()),
              exhaustSpec: Value(input.exhaustSpec?.trim()),
              otherMods: Value(input.otherMods?.trim()),
              installedDate: input.installedDate,
              installedOdometerKm: Value(input.installedOdometerKm),
              isActive: Value(input.isActive),
              isArchived: const Value(false),
              notes: Value(input.notes?.trim()),
              photoPaths: Value(photosJson),
              createdAt: now,
              updatedAt: now,
            ),
          );

      return id;
    });
  }

  Future<void> updateConfiguration({
    required int id,
    required String name,
    String? pulleyBrandModel,
    double? flyballWeightGrams,
    String? flyballArrangement,
    int? centerSpringRpm,
    int? clutchSpringRpm,
    String? beltBrandPartNumber,
    double? pulleyWasherThicknessMm,
    String? clutchBellSpec,
    String? exhaustSpec,
    String? otherMods,
    required DateTime installedDate,
    int? installedOdometerKm,
    String? notes,
    List<String> photoPaths = const [],
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const CvtException('Configuration name cannot be empty.');
    }

    final photosJson = photoPaths.isEmpty ? null : jsonEncode(photoPaths);

    await (_db.update(_db.cvtConfigurations)..where((t) => t.id.equals(id)))
        .write(
      CvtConfigurationsCompanion(
        name: Value(trimmedName),
        pulleyBrandModel: Value(pulleyBrandModel?.trim()),
        flyballWeightGrams: Value(flyballWeightGrams),
        flyballArrangement: Value(flyballArrangement?.trim()),
        centerSpringRpm: Value(centerSpringRpm),
        clutchSpringRpm: Value(clutchSpringRpm),
        beltBrandPartNumber: Value(beltBrandPartNumber?.trim()),
        pulleyWasherThicknessMm: Value(pulleyWasherThicknessMm),
        clutchBellSpec: Value(clutchBellSpec?.trim()),
        exhaustSpec: Value(exhaustSpec?.trim()),
        otherMods: Value(otherMods?.trim()),
        installedDate: Value(installedDate),
        installedOdometerKm: Value(installedOdometerKm),
        notes: Value(notes?.trim()),
        photoPaths: Value(photosJson),
        updatedAt: Value(_clock()),
      ),
    );
  }

  Future<void> setActive(int id, int motorcycleId) async {
    await _db.transaction(() async {
      await (_db.update(_db.cvtConfigurations)
            ..where((t) => t.motorcycleId.equals(motorcycleId)))
          .write(const CvtConfigurationsCompanion(isActive: Value(false)));

      await (_db.update(_db.cvtConfigurations)..where((t) => t.id.equals(id)))
          .write(const CvtConfigurationsCompanion(
              isActive: Value(true), isArchived: Value(false)));
    });
  }

  Future<void> setArchived(int id, bool archived) async {
    await (_db.update(_db.cvtConfigurations)..where((t) => t.id.equals(id)))
        .write(CvtConfigurationsCompanion(
            isArchived: Value(archived), isActive: const Value(false)));
  }

  Future<int> duplicateConfiguration(int id) async {
    final existing = await getConfigurationById(id);
    if (existing == null) throw const CvtException('Configuration not found.');

    return saveConfiguration(
      NewCvtConfigurationInput(
        motorcycleId: existing.motorcycleId,
        name: '${existing.name} (Copy)',
        pulleyBrandModel: existing.pulleyBrandModel,
        flyballWeightGrams: existing.flyballWeightGrams,
        flyballArrangement: existing.flyballArrangement,
        centerSpringRpm: existing.centerSpringRpm,
        clutchSpringRpm: existing.clutchSpringRpm,
        beltBrandPartNumber: existing.beltBrandPartNumber,
        pulleyWasherThicknessMm: existing.pulleyWasherThicknessMm,
        clutchBellSpec: existing.clutchBellSpec,
        exhaustSpec: existing.exhaustSpec,
        otherMods: existing.otherMods,
        installedDate: _clock(),
        installedOdometerKm: existing.installedOdometerKm,
        isActive: false,
        notes: existing.notes,
        photoPaths: existing.photoPaths,
      ),
    );
  }

  Future<void> deleteConfiguration(int id) async {
    await (_db.delete(_db.cvtConfigurations)..where((t) => t.id.equals(id)))
        .go();
  }

  Future<int> addPerformanceLog(NewCvtPerformanceLogInput input) async {
    return _db.into(_db.cvtPerformanceLogs).insert(
          CvtPerformanceLogsCompanion.insert(
            configurationId: input.configurationId,
            logDate: input.logDate,
            odometerKm: Value(input.odometerKm),
            accelerationRating: Value(input.accelerationRating),
            topSpeedKmh: Value(input.topSpeedKmh),
            rpmObserved: Value(input.rpmObserved),
            fuelConsumptionKpl: Value(input.fuelConsumptionKpl),
            vibrationRating: Value(input.vibrationRating),
            comfortRating: Value(input.comfortRating),
            overallAssessment: Value(input.overallAssessment?.trim()),
            notes: Value(input.notes?.trim()),
            isMeasured: Value(input.isMeasured),
            createdAt: _clock(),
          ),
        );
  }

  Future<void> deletePerformanceLog(int logId) async {
    await (_db.delete(_db.cvtPerformanceLogs)..where((t) => t.id.equals(logId)))
        .go();
  }
}
