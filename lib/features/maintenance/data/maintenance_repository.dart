import '../../../core/exceptions/user_facing_exception.dart';
import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/enums/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../motorcycle/domain/motorcycle.dart';
import '../../odometer/data/odometer_repository.dart';
import '../domain/maintenance_models.dart';
import '../domain/maintenance_snapshot.dart';

/// Input for saving a service record (the full recording UI arrives in Phase 3).
class NewMaintenanceRecord {
  const NewMaintenanceRecord({
    required this.motorcycleId,
    required this.itemId,
    required this.action,
    required this.date,
    required this.odometerKm,
    this.laborCostCentavos = 0,
    this.totalCostCentavos = 0,
    this.serviceProvider,
    this.notes,
  });

  final int motorcycleId;
  final int itemId;
  final MaintenanceAction action;
  final DateTime date;
  final int odometerKm;
  final int laborCostCentavos;
  final int totalCostCentavos;
  final String? serviceProvider;
  final String? notes;
}

class MaintenanceException implements UserFacingException {
  const MaintenanceException(this.message);
  @override
  final String message;
  @override
  String toString() => message;
}

/// Repository for schedule rules, service records and the calculation snapshot.
class MaintenanceRepository {
  MaintenanceRepository(this._db, this._odometer, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final OdometerRepository _odometer;
  final DateTime Function() _clock;

  /// Emits a fresh snapshot now and after any relevant table changes, so every
  /// status is recalculated after an odometer update or service record.
  Stream<MaintenanceSnapshot> watchSnapshot() async* {
    yield await loadSnapshot();
    final updates = _db.tableUpdates(TableUpdateQuery.onAllTables([
      _db.motorcycles,
      _db.maintenanceItems,
      _db.maintenanceCategories,
      _db.maintenanceRules,
      _db.maintenanceRuleSteps,
      _db.maintenanceRecords,
      _db.odometerLogs,
    ]));
    await for (final _ in updates) {
      yield await loadSnapshot();
    }
  }

  Future<MaintenanceSnapshot> loadSnapshot() async {
    final bikeRow = await (_db.select(_db.motorcycles)
          ..orderBy([(t) => OrderingTerm.asc(t.id)])
          ..limit(1))
        .getSingleOrNull();
    final bike = bikeRow == null ? null : Motorcycle.fromRow(bikeRow);

    final categories = (await (_db.select(_db.maintenanceCategories)
              ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
            .get())
        .map((c) => CategoryInfo(id: c.id, name: c.name))
        .toList();

    final items = (await (_db.select(_db.maintenanceItems)
              ..where((t) => t.isActive.equals(true))
              ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
            .get())
        .map((i) => ItemInfo(
            id: i.id,
            name: i.name,
            categoryId: i.categoryId,
            instructions: i.instructions))
        .toList();

    final ruleRows = await _db.select(_db.maintenanceRules).get();
    final stepRows = await (_db.select(_db.maintenanceRuleSteps)
          ..orderBy([(t) => OrderingTerm.asc(t.stepOrder)]))
        .get();
    final rules = ruleRows.map((r) {
      final steps = stepRows
          .where((s) => s.ruleId == r.id)
          .map((s) => RuleStepDef(
                actionCode: ActionCode.fromCode(s.actionCode),
                atKm: s.atKm,
                atMonths: s.atMonths,
                repeatEveryKm: s.repeatEveryKm,
                repeatEveryMonths: s.repeatEveryMonths,
              ))
          .toList();
      return RuleDef(
        id: r.id,
        itemId: r.itemId,
        ruleType: RuleType.fromCode(r.ruleType),
        actionCode: ActionCode.fromCode(r.actionCode),
        source: MaintenanceSource.fromCode(r.source),
        sourceDocument: r.sourceDocument,
        sourcePage: r.sourcePage,
        intervalKm: r.intervalKm,
        intervalMonths: r.intervalMonths,
        isVerified: r.isVerified,
        isActive: r.isActive,
        notes: r.notes,
        steps: steps,
      );
    }).toList();

    final recordRows = await (_db.select(_db.maintenanceRecords)
          ..where((t) => t.voidedAt.isNull()))
        .get();
    final records = [
      for (final r in recordRows)
        if (AppDates.parseDateOnly(r.performedDate) != null)
          RecordInfo(
            id: r.id,
            itemId: r.itemId,
            action: MaintenanceAction.fromCode(r.action),
            date: AppDates.parseDateOnly(r.performedDate)!,
            odometerKm: r.odometerKm,
            totalCostCentavos: r.totalCostCentavos,
          ),
    ];

    int? currentKm;
    int? baselineKm;
    DateTime? firstDate;
    if (bike != null) {
      final confirmed = await _odometer.confirmedChronological(bike.id);
      if (confirmed.isNotEmpty) {
        currentKm =
            confirmed.map((l) => l.readingKm).reduce((a, b) => a > b ? a : b);
        baselineKm =
            confirmed.map((l) => l.readingKm).reduce((a, b) => a < b ? a : b);
        firstDate = confirmed.first.recordedDate;
      }
    }

    return MaintenanceSnapshot(
      motorcycle: bike,
      categories: categories,
      items: items,
      rules: rules,
      records: records,
      currentKm: currentKm,
      baselineKm: baselineKm,
      firstLogDate: firstDate,
    );
  }

  /// Saves a service record in one transaction. If the record's odometer is
  /// higher than the latest confirmed reading, that reading is logged too, so
  /// mileage-based statuses stay consistent. Records are never overwritten.
  Future<int> addRecord(NewMaintenanceRecord r) async {
    if (r.odometerKm < 0) {
      throw const MaintenanceException('Odometer cannot be negative.');
    }
    if (r.laborCostCentavos < 0 || r.totalCostCentavos < 0) {
      throw const MaintenanceException('Costs cannot be negative.');
    }
    if (r.laborCostCentavos > r.totalCostCentavos) {
      throw const MaintenanceException('Labor cost cannot exceed total cost.');
    }
    final day = AppDates.dateOnly(r.date);
    if (day.isAfter(AppDates.todayManila(_clock()))) {
      throw const MaintenanceException('Date cannot be in the future.');
    }

    return _db.transaction(() async {
      final item = await (_db.select(_db.maintenanceItems)
            ..where((t) => t.id.equals(r.itemId)))
          .getSingleOrNull();
      if (item == null) {
        throw const MaintenanceException('Maintenance item not found.');
      }

      final latest = await _odometer.latestConfirmed(r.motorcycleId);
      if (latest == null || r.odometerKm > latest.readingKm) {
        await _odometer.insert(
          motorcycleId: r.motorcycleId,
          readingKm: r.odometerKm,
          date: day,
          notes: 'Logged from maintenance record',
          createdAt: _clock(),
        );
      }

      return _db.into(_db.maintenanceRecords).insert(
            MaintenanceRecordsCompanion.insert(
              motorcycleId: r.motorcycleId,
              itemId: r.itemId,
              action: r.action.code,
              performedDate: AppDates.toIsoDate(day),
              odometerKm: r.odometerKm,
              laborCostCentavos: Value(r.laborCostCentavos),
              totalCostCentavos: Value(r.totalCostCentavos),
              serviceProvider: Value(r.serviceProvider),
              notes: Value(r.notes),
              createdAt: _clock().toIso8601String(),
            ),
          );
    });
  }

  /// Adds a CUSTOM rule (e.g. a fuel filter replacement interval). Never
  /// modifies Honda manual rules; both are evaluated side by side.
  Future<int> addCustomRule({
    required int motorcycleId,
    required int itemId,
    required ActionCode action,
    int? intervalKm,
    int? intervalMonths,
    String? notes,
  }) async {
    if (intervalKm == null && intervalMonths == null) {
      throw const MaintenanceException(
          'Enter a distance and/or time interval.');
    }
    if ((intervalKm != null && intervalKm <= 0) ||
        (intervalMonths != null && intervalMonths <= 0)) {
      throw const MaintenanceException('Intervals must be greater than zero.');
    }
    final type = (intervalKm != null && intervalMonths != null)
        ? RuleType.combined
        : intervalKm != null
            ? RuleType.mileage
            : RuleType.date;
    return _db
        .into(_db.maintenanceRules)
        .insert(MaintenanceRulesCompanion.insert(
          motorcycleId: motorcycleId,
          itemId: itemId,
          ruleType: type.code,
          actionCode: action.code,
          source: MaintenanceSource.custom.code,
          intervalKm: Value(intervalKm),
          intervalMonths: Value(intervalMonths),
          isVerified: const Value(false),
          notes: Value(notes),
        ));
  }
}

