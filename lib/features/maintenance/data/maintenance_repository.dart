import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/enums/enums.dart';
import '../../../core/exceptions/user_facing_exception.dart';
import '../../../core/services/attachment_service.dart';
import '../../../core/services/expense_service.dart';
import '../../../core/utils/date_utils.dart';
import '../../components/domain/component_models.dart';
import '../../motorcycle/domain/motorcycle.dart';
import '../../odometer/data/odometer_repository.dart';
import '../../parts/data/parts_repository.dart';
import '../../parts/domain/part_models.dart';
import '../domain/maintenance_models.dart';
import '../domain/maintenance_record_detail.dart';
import '../domain/maintenance_snapshot.dart';

/// Input for saving or editing a service record.
class NewMaintenanceRecord {
  const NewMaintenanceRecord({
    required this.motorcycleId,
    required this.itemId,
    required this.action,
    required this.date,
    required this.odometerKm,
    this.laborCostCentavos = 0,
    this.totalCostCentavos,
    this.serviceProvider,
    this.notes,
    this.parts = const [],
    this.photoPaths = const [],
    this.keepAttachmentIds = const [],
    this.measurementValue,
    this.measurementUnit,
    this.measurementType,
    this.measurementPosition,
  });

  final int motorcycleId;
  final int itemId;
  final MaintenanceAction action;
  final DateTime date;
  final int odometerKm;
  final int laborCostCentavos;

  /// If null, computed from [laborCostCentavos] + [parts] line totals.
  final int? totalCostCentavos;
  final String? serviceProvider;
  final String? notes;
  final List<RecordPartInput> parts;

  /// Newly picked photo source paths to copy & attach.
  final List<String> photoPaths;

  /// When editing an existing record, existing attachment IDs to retain.
  final List<int> keepAttachmentIds;

  /// Optional actual component measurement recorded during this service.
  final double? measurementValue;
  final String? measurementUnit;
  final MeasurementType? measurementType;
  final String? measurementPosition;
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
  MaintenanceRepository(
    this._db,
    this._odometer, {
    PartsRepository? parts,
    AttachmentService? attachments,
    ExpenseService expense = const ExpenseService(),
    DateTime Function()? clock,
  })  : _clock = clock ?? DateTime.now,
        _parts = parts ?? PartsRepository(_db, clock: clock),
        _attachments = attachments,
        _expense = expense;

  final AppDatabase _db;
  final OdometerRepository _odometer;
  final PartsRepository _parts;
  final AttachmentService? _attachments;
  final ExpenseService _expense;
  final DateTime Function() _clock;

  static String? _clean(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

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
            instructions: i.instructions,
            isUserDefined: i.isUserDefined || i.name == 'Fuel Filter'))
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
        warningKm: r.warningKm,
        warningDays: r.warningDays,
        lastCompletedKm: r.lastCompletedKm,
        lastCompletedDate: AppDates.parseDateOnly(r.lastCompletedDate),
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

  /// Streams full non-voided maintenance records in chronological order
  /// (newest first), optionally filtered.
  Stream<List<MaintenanceRecordDetail>> watchHistory({
    MaintenanceHistoryFilter filter = const MaintenanceHistoryFilter(),
  }) async* {
    yield (await loadHistory()).where(filter.matches).toList();
    final updates = _db.tableUpdates(TableUpdateQuery.onAllTables([
      _db.maintenanceRecords,
      _db.maintenanceRecordParts,
      _db.parts,
      _db.attachments,
      _db.maintenanceItems,
      _db.maintenanceCategories,
    ]));
    await for (final _ in updates) {
      yield (await loadHistory()).where(filter.matches).toList();
    }
  }

  Future<MaintenanceRecordDetail?> findRecord(int id) async {
    final all = await loadHistory();
    return all.where((r) => r.id == id).firstOrNull;
  }

  Future<List<MaintenanceRecordDetail>> loadHistory() async {
    final cats = {
      for (final c in await _db.select(_db.maintenanceCategories).get())
        c.id: c.name
    };
    final items = {
      for (final i in await _db.select(_db.maintenanceItems).get()) i.id: i
    };
    final partsMap = {
      for (final p in await _db.select(_db.parts).get())
        p.id: PartInfo(
          id: p.id,
          itemId: p.itemId,
          name: p.name,
          brand: p.brand,
          partNumber: p.partNumber,
          specification: p.specification,
          purchasePriceCentavos: p.purchasePriceCentavos,
          purchaseDate: AppDates.parseDateOnly(p.purchaseDate),
          supplier: p.supplier,
          quantity: p.quantity,
        )
    };
    final recParts = await _db.select(_db.maintenanceRecordParts).get();
    final attRows = await (_db.select(_db.attachments)
          ..where((t) => t.recordId.isNotNull()))
        .get();

    final rows = await (_db.select(_db.maintenanceRecords)
          ..where((t) => t.voidedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.performedDate),
            (t) => OrderingTerm.desc(t.odometerKm),
            (t) => OrderingTerm.desc(t.id),
          ]))
        .get();

    final out = <MaintenanceRecordDetail>[];
    for (final r in rows) {
      final item = items[r.itemId];
      final date = AppDates.parseDateOnly(r.performedDate);
      if (item == null || date == null) continue;
      final rpList = <RecordPartDetail>[];
      for (final rp in recParts.where((x) => x.recordId == r.id)) {
        final p = partsMap[rp.partId];
        if (p != null) {
          rpList.add(RecordPartDetail(
            id: rp.id,
            part: p,
            quantity: rp.quantity,
            unitCostCentavos: rp.unitCostCentavos,
          ));
        }
      }
      final atts = [
        for (final a in attRows.where((x) => x.recordId == r.id))
          AttachmentInfo(
            id: a.id,
            filePath: a.filePath,
            mimeType: a.mimeType,
            caption: a.caption,
          ),
      ];
      out.add(MaintenanceRecordDetail(
        id: r.id,
        motorcycleId: r.motorcycleId,
        itemId: r.itemId,
        itemName: item.name,
        categoryId: item.categoryId,
        categoryName: cats[item.categoryId] ?? '',
        action: MaintenanceAction.fromCode(r.action),
        performedDate: date,
        odometerKm: r.odometerKm,
        laborCostCentavos: r.laborCostCentavos,
        totalCostCentavos: r.totalCostCentavos,
        serviceProvider: r.serviceProvider,
        notes: r.notes,
        supersedesRecordId: r.supersedesRecordId,
        parts: rpList,
        attachments: atts,
      ));
    }
    return out;
  }

  /// Saves a service record in one transaction. If the record's odometer is
  /// higher than the latest confirmed reading, that reading is logged too, so
  /// mileage-based statuses stay consistent. Records are never overwritten.
  Future<int> addRecord(NewMaintenanceRecord r) =>
      _saveRecord(r, supersedesId: null);

  /// Edits a service record by voiding the original (`voidedAt` set) and
  /// creating a new record pointing to it via `supersedesRecordId`, so history
  /// is never overwritten in place.
  Future<int> editRecord(int recordId, NewMaintenanceRecord updated) =>
      _saveRecord(updated, supersedesId: recordId);

  /// Soft-deletes a record (`voidedAt` set). Never removes rows from SQLite.
  Future<void> voidRecord(int recordId) async {
    final row = await (_db.select(_db.maintenanceRecords)
          ..where((t) => t.id.equals(recordId)))
        .getSingleOrNull();
    if (row == null) throw const MaintenanceException('Record not found.');
    if (row.voidedAt != null) {
      throw const MaintenanceException('Record is already voided.');
    }
    await (_db.update(_db.maintenanceRecords)
          ..where((t) => t.id.equals(recordId)))
        .write(MaintenanceRecordsCompanion(
            voidedAt: Value(_clock().toIso8601String())));
  }

  Future<int> _saveRecord(NewMaintenanceRecord r,
      {required int? supersedesId}) async {
    if (r.odometerKm < 0) {
      throw const MaintenanceException('Odometer cannot be negative.');
    }
    if (r.laborCostCentavos < 0) {
      throw const MaintenanceException('Costs cannot be negative.');
    }
    for (final p in r.parts) {
      if (p.quantity < 1) {
        throw const MaintenanceException('Part quantity must be at least 1.');
      }
      if (p.unitCostCentavos < 0) {
        throw const MaintenanceException('Part unit cost cannot be negative.');
      }
      if (p.existingPartId == null && p.name.trim().isEmpty) {
        throw const MaintenanceException('Part name is required.');
      }
    }
    final computedTotal = _expense.totalCentavos(
      laborCentavos: r.laborCostCentavos,
      parts: r.parts.map(
          (p) => (quantity: p.quantity, unitCostCentavos: p.unitCostCentavos)),
    );
    final total = r.totalCostCentavos ?? computedTotal;
    if (total < 0) {
      throw const MaintenanceException('Costs cannot be negative.');
    }
    if (r.laborCostCentavos > total) {
      throw const MaintenanceException('Labor cost cannot exceed total cost.');
    }
    if (r.parts.isNotEmpty && total < computedTotal) {
      throw const MaintenanceException(
          'Total cost cannot be less than labor plus parts.');
    }
    final day = AppDates.dateOnly(r.date);
    if (day.isAfter(AppDates.todayManila(_clock()))) {
      throw const MaintenanceException('Date cannot be in the future.');
    }
    if (r.measurementValue != null &&
        (r.measurementValue!.isNaN ||
            r.measurementValue!.isInfinite ||
            r.measurementValue! <= 0)) {
      throw const MaintenanceException(
          'Measurement value must be greater than zero.');
    }

    final storedPhotos = r.photoPaths.isEmpty
        ? const <StoredPhoto>[]
        : await (_attachments != null
            ? _attachments.store(r.photoPaths)
            : Future.value([
                for (final path in r.photoPaths) StoredPhoto(path: path),
              ]));

    try {
      return await _db.transaction(() async {
        final item = await (_db.select(_db.maintenanceItems)
              ..where((t) => t.id.equals(r.itemId)))
            .getSingleOrNull();
        if (item == null) {
          throw const MaintenanceException('Maintenance item not found.');
        }

        if (supersedesId == null) {
          final dup = await (_db.select(_db.maintenanceRecords)
                ..where((t) =>
                    t.motorcycleId.equals(r.motorcycleId) &
                    t.itemId.equals(r.itemId) &
                    t.action.equals(r.action.code) &
                    t.performedDate.equals(AppDates.toIsoDate(day)) &
                    t.odometerKm.equals(r.odometerKm) &
                    t.voidedAt.isNull()))
              .getSingleOrNull();
          if (dup != null) {
            throw const MaintenanceException(
              'A duplicate maintenance record for this item, action, date, '
              'and odometer already exists.',
            );
          }
        }

        List<AttachmentRow> keptAttachments = const [];
        if (supersedesId != null) {
          final old = await (_db.select(_db.maintenanceRecords)
                ..where((t) => t.id.equals(supersedesId)))
              .getSingleOrNull();
          if (old == null || old.voidedAt != null) {
            throw const MaintenanceException('Original record not found.');
          }
          await (_db.update(_db.maintenanceRecords)
                ..where((t) => t.id.equals(supersedesId)))
              .write(MaintenanceRecordsCompanion(
                  voidedAt: Value(_clock().toIso8601String())));
          if (r.keepAttachmentIds.isNotEmpty) {
            keptAttachments = await (_db.select(_db.attachments)
                  ..where((t) =>
                      t.recordId.equals(supersedesId) &
                      t.id.isIn(r.keepAttachmentIds)))
                .get();
          }
        }

        await _odometer.logIfHigher(
          motorcycleId: r.motorcycleId,
          readingKm: r.odometerKm,
          date: day,
          note: 'Logged from maintenance record',
          createdAt: _clock(),
        );

        final recordId = await _db.into(_db.maintenanceRecords).insert(
              MaintenanceRecordsCompanion.insert(
                motorcycleId: r.motorcycleId,
                itemId: r.itemId,
                action: r.action.code,
                performedDate: AppDates.toIsoDate(day),
                odometerKm: r.odometerKm,
                laborCostCentavos: Value(r.laborCostCentavos),
                totalCostCentavos: Value(total),
                serviceProvider: Value(_clean(r.serviceProvider)),
                notes: Value(_clean(r.notes)),
                supersedesRecordId: Value(supersedesId),
                createdAt: _clock().toIso8601String(),
              ),
            );

        if (supersedesId != null && r.parts.isEmpty) {
          await _parts.moveInstallationsToRecord(supersedesId, recordId);
        }

        for (final p in r.parts) {
          final int partId;
          if (p.existingPartId != null) {
            final existing = await _parts.findPart(p.existingPartId!);
            if (existing == null) {
              throw const MaintenanceException('Selected part not found.');
            }
            partId = existing.id;
          } else {
            partId = await _parts.addPart(NewPart(
              itemId: r.itemId,
              name: p.name,
              brand: p.brand,
              partNumber: p.partNumber,
              specification: p.specification,
              purchasePriceCentavos: p.unitCostCentavos,
              purchaseDate: day,
              quantity: p.quantity,
            ));
          }
          await _db.into(_db.maintenanceRecordParts).insert(
                MaintenanceRecordPartsCompanion.insert(
                  recordId: recordId,
                  partId: partId,
                  quantity: Value(p.quantity),
                  unitCostCentavos: Value(p.unitCostCentavos),
                ),
              );
          if (r.action == MaintenanceAction.replacement &&
              p.trackInstallation) {
            await _parts.install(
              partId: partId,
              motorcycleId: r.motorcycleId,
              date: day,
              odometerKm: r.odometerKm,
              position: p.position,
              recordId: recordId,
              notes: r.notes,
            );
          }
        }

        final nowIso = _clock().toIso8601String();
        for (final a in keptAttachments) {
          await _db.into(_db.attachments).insert(AttachmentsCompanion.insert(
                recordId: Value(recordId),
                motorcycleId: Value(r.motorcycleId),
                filePath: a.filePath,
                mimeType: Value(a.mimeType),
                caption: Value(a.caption),
                createdAt: nowIso,
              ));
        }
        for (final ph in storedPhotos) {
          await _db.into(_db.attachments).insert(AttachmentsCompanion.insert(
                recordId: Value(recordId),
                motorcycleId: Value(r.motorcycleId),
                filePath: ph.path,
                mimeType: Value(ph.mimeType),
                createdAt: nowIso,
              ));
        }

        if (r.measurementValue != null) {
          final mType = r.measurementType ?? MeasurementType.generalMeasurement;
          final mUnit =
              (r.measurementUnit == null || r.measurementUnit!.trim().isEmpty)
                  ? (mType.unit.isEmpty ? 'mm' : mType.unit)
                  : r.measurementUnit!.trim();
          await _db.into(_db.componentMeasurements).insert(
                ComponentMeasurementsCompanion.insert(
                  motorcycleId: r.motorcycleId,
                  itemId: r.itemId,
                  recordId: Value(recordId),
                  measuredDate: AppDates.toIsoDate(day),
                  odometerKm: Value(r.odometerKm),
                  measurementType: mType.code,
                  value: Value(r.measurementValue),
                  unit: mUnit,
                  position: Value(_clean(r.measurementPosition)),
                  notes: Value(_clean(r.notes)),
                  createdAt: nowIso,
                ),
              );
        }

        return recordId;
      });
    } catch (_) {
      if (_attachments != null && storedPhotos.isNotEmpty) {
        await _attachments.discard(storedPhotos);
      }
      rethrow;
    }
  }

  /// Creates a new user-defined custom maintenance item and configures its
  /// custom interval rule in a single transaction.
  Future<int> createCustomItemAndRule({
    required int motorcycleId,
    required String itemName,
    int? categoryId,
    required ActionCode action,
    int? intervalKm,
    int? intervalMonths,
    int? warningKm,
    int? warningDays,
    int? lastCompletedKm,
    DateTime? lastCompletedDate,
    String? notes,
  }) async {
    final cleanName = _clean(itemName);
    if (cleanName == null) {
      throw const MaintenanceException(
          'Custom maintenance item name is required.');
    }
    _validateCustomIntervalInputs(
      intervalKm: intervalKm,
      intervalMonths: intervalMonths,
      warningKm: warningKm,
      warningDays: warningDays,
      lastCompletedKm: lastCompletedKm,
    );

    return _db.transaction(() async {
      final allItems = await _db.select(_db.maintenanceItems).get();
      final existing = allItems
          .where((i) => i.name.toLowerCase() == cleanName.toLowerCase())
          .firstOrNull;

      int itemId;
      if (existing != null) {
        if (!existing.isUserDefined && existing.name != 'Fuel Filter') {
          throw MaintenanceException(
            '"${existing.name}" is already a Honda maintenance item. '
            'Set a custom interval on that item directly.',
          );
        }
        // Check if an active custom rule already exists to prevent duplicates.
        final existingCustomRules = await (_db.select(_db.maintenanceRules)
              ..where((r) =>
                  r.motorcycleId.equals(motorcycleId) &
                  r.itemId.equals(existing.id) &
                  r.source.equals(MaintenanceSource.custom.code) &
                  r.isActive.equals(true)))
            .get();
        if (existingCustomRules.isNotEmpty) {
          throw MaintenanceException(
            'A custom maintenance item named "${existing.name}" already exists.',
          );
        }
        if (!existing.isActive) {
          await (_db.update(_db.maintenanceItems)
                ..where((t) => t.id.equals(existing.id)))
              .write(const MaintenanceItemsCompanion(isActive: Value(true)));
        }
        itemId = existing.id;
      } else {
        int resolvedCategoryId;
        if (categoryId != null) {
          resolvedCategoryId = categoryId;
        } else {
          final cats = await (_db.select(_db.maintenanceCategories)
                ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
              .get();
          resolvedCategoryId = cats.first.id;
        }
        final maxSort = allItems.isEmpty
            ? 100
            : allItems.map((i) => i.sortOrder).reduce((a, b) => a > b ? a : b) +
                1;
        itemId = await _db.into(_db.maintenanceItems).insert(
              MaintenanceItemsCompanion.insert(
                categoryId: resolvedCategoryId,
                name: cleanName,
                instructions: Value(_clean(notes) ??
                    'User-defined custom maintenance item (not part of the '
                        'Honda ADV160 Owner\'s Manual 32K0WA100 schedule).'),
                sortOrder: Value(maxSort),
                isUserDefined: const Value(true),
              ),
            );
      }

      await saveCustomRule(
        motorcycleId: motorcycleId,
        itemId: itemId,
        action: action,
        intervalKm: intervalKm,
        intervalMonths: intervalMonths,
        warningKm: warningKm,
        warningDays: warningDays,
        lastCompletedKm: lastCompletedKm,
        lastCompletedDate: lastCompletedDate,
        notes: notes,
      );
      return itemId;
    });
  }

  /// Adds or updates a CUSTOM rule for an item. Never modifies Honda manual
  /// rules; both are stored and evaluated side by side. If a custom rule
  /// already exists for `(motorcycleId, itemId)`, updates it in place to
  /// prevent duplicate custom rules.
  Future<int> addCustomRule({
    int? ruleId,
    required int motorcycleId,
    required int itemId,
    required ActionCode action,
    int? intervalKm,
    int? intervalMonths,
    int? warningKm,
    int? warningDays,
    int? lastCompletedKm,
    DateTime? lastCompletedDate,
    String? notes,
  }) =>
      saveCustomRule(
        ruleId: ruleId,
        motorcycleId: motorcycleId,
        itemId: itemId,
        action: action,
        intervalKm: intervalKm,
        intervalMonths: intervalMonths,
        warningKm: warningKm,
        warningDays: warningDays,
        lastCompletedKm: lastCompletedKm,
        lastCompletedDate: lastCompletedDate,
        notes: notes,
      );

  Future<int> saveCustomRule({
    int? ruleId,
    required int motorcycleId,
    required int itemId,
    required ActionCode action,
    int? intervalKm,
    int? intervalMonths,
    int? warningKm,
    int? warningDays,
    int? lastCompletedKm,
    DateTime? lastCompletedDate,
    String? notes,
  }) async {
    _validateCustomIntervalInputs(
      intervalKm: intervalKm,
      intervalMonths: intervalMonths,
      warningKm: warningKm,
      warningDays: warningDays,
      lastCompletedKm: lastCompletedKm,
    );

    final type = (intervalKm != null && intervalMonths != null)
        ? RuleType.combined
        : intervalKm != null
            ? RuleType.mileage
            : RuleType.date;
    final lastDateIso = lastCompletedDate == null
        ? null
        : AppDates.toIsoDate(AppDates.dateOnly(lastCompletedDate));

    return _db.transaction(() async {
      final item = await (_db.select(_db.maintenanceItems)
            ..where((t) => t.id.equals(itemId)))
          .getSingleOrNull();
      if (item == null) {
        throw const MaintenanceException('Maintenance item not found.');
      }

      MaintenanceRuleRow? targetRule;
      if (ruleId != null) {
        targetRule = await (_db.select(_db.maintenanceRules)
              ..where((r) => r.id.equals(ruleId)))
            .getSingleOrNull();
        if (targetRule == null) {
          throw const MaintenanceException('Custom rule not found.');
        }
        if (targetRule.source != MaintenanceSource.custom.code) {
          throw const MaintenanceException(
              'Official Honda manual rules cannot be overwritten.');
        }
      } else {
        targetRule = await (_db.select(_db.maintenanceRules)
              ..where((r) =>
                  r.motorcycleId.equals(motorcycleId) &
                  r.itemId.equals(itemId) &
                  r.source.equals(MaintenanceSource.custom.code))
              ..orderBy([(r) => OrderingTerm.asc(r.id)])
              ..limit(1))
            .getSingleOrNull();
      }

      if (targetRule != null) {
        await (_db.update(_db.maintenanceRules)
              ..where((r) => r.id.equals(targetRule!.id)))
            .write(MaintenanceRulesCompanion(
          ruleType: Value(type.code),
          actionCode: Value(action.code),
          intervalKm: Value(intervalKm),
          intervalMonths: Value(intervalMonths),
          warningKm: Value(warningKm),
          warningDays: Value(warningDays),
          lastCompletedKm: Value(lastCompletedKm),
          lastCompletedDate: Value(lastDateIso),
          isActive: const Value(true),
          notes: Value(_clean(notes)),
        ));
        return targetRule.id;
      }

      return _db.into(_db.maintenanceRules).insert(
            MaintenanceRulesCompanion.insert(
              motorcycleId: motorcycleId,
              itemId: itemId,
              ruleType: type.code,
              actionCode: action.code,
              source: MaintenanceSource.custom.code,
              intervalKm: Value(intervalKm),
              intervalMonths: Value(intervalMonths),
              warningKm: Value(warningKm),
              warningDays: Value(warningDays),
              lastCompletedKm: Value(lastCompletedKm),
              lastCompletedDate: Value(lastDateIso),
              isVerified: const Value(false),
              isActive: const Value(true),
              notes: Value(_clean(notes)),
            ),
          );
    });
  }

  /// Deletes a user-defined custom rule. Never deletes official Honda rules.
  Future<void> deleteCustomRule(int ruleId) async {
    await _db.transaction(() async {
      final row = await (_db.select(_db.maintenanceRules)
            ..where((r) => r.id.equals(ruleId)))
          .getSingleOrNull();
      if (row == null) {
        throw const MaintenanceException('Custom interval not found.');
      }
      if (row.source != MaintenanceSource.custom.code) {
        throw const MaintenanceException(
            'Official Honda maintenance schedule rules cannot be deleted.');
      }
      await (_db.delete(_db.maintenanceRuleSteps)
            ..where((s) => s.ruleId.equals(ruleId)))
          .go();
      await (_db.delete(_db.maintenanceReminders)
            ..where((rem) => rem.ruleId.equals(ruleId)))
          .go();
      await (_db.delete(_db.maintenanceRules)
            ..where((r) => r.id.equals(ruleId)))
          .go();
    });
  }

  /// Deletes or deactivates a user-created custom maintenance item and its
  /// custom rules. Preserves any historical maintenance records.
  Future<void> deleteCustomItem(int itemId) async {
    await _db.transaction(() async {
      final item = await (_db.select(_db.maintenanceItems)
            ..where((i) => i.id.equals(itemId)))
          .getSingleOrNull();
      if (item == null) {
        throw const MaintenanceException('Maintenance item not found.');
      }
      if (!item.isUserDefined && item.name != 'Fuel Filter') {
        throw const MaintenanceException(
            'Official Honda maintenance items cannot be deleted.');
      }

      final customRules = await (_db.select(_db.maintenanceRules)
            ..where((r) =>
                r.itemId.equals(itemId) &
                r.source.equals(MaintenanceSource.custom.code)))
          .get();
      for (final r in customRules) {
        await (_db.delete(_db.maintenanceRuleSteps)
              ..where((s) => s.ruleId.equals(r.id)))
            .go();
        await (_db.delete(_db.maintenanceReminders)
              ..where((rem) => rem.ruleId.equals(r.id)))
            .go();
        await (_db.delete(_db.maintenanceRules)
              ..where((t) => t.id.equals(r.id)))
            .go();
      }

      if (item.name == 'Fuel Filter') {
        return;
      }

      final hasRecords = (await (_db.select(_db.maintenanceRecords)
                ..where((r) => r.itemId.equals(itemId))
                ..limit(1))
              .getSingleOrNull()) !=
          null;
      final hasMeas = (await (_db.select(_db.componentMeasurements)
                ..where((m) => m.itemId.equals(itemId))
                ..limit(1))
              .getSingleOrNull()) !=
          null;

      if (hasRecords || hasMeas) {
        await (_db.update(_db.maintenanceItems)
              ..where((i) => i.id.equals(itemId)))
            .write(const MaintenanceItemsCompanion(isActive: Value(false)));
      } else {
        await (_db.delete(_db.componentSpecs)
              ..where((s) => s.itemId.equals(itemId)))
            .go();
        await (_db.delete(_db.maintenanceItems)
              ..where((i) => i.id.equals(itemId)))
            .go();
      }
    });
  }

  static void _validateCustomIntervalInputs({
    int? intervalKm,
    int? intervalMonths,
    int? warningKm,
    int? warningDays,
    int? lastCompletedKm,
  }) {
    if (intervalKm == null && intervalMonths == null) {
      throw const MaintenanceException(
          'Enter a distance (km) and/or time (months) interval.');
    }
    if ((intervalKm != null && intervalKm <= 0) ||
        (intervalMonths != null && intervalMonths <= 0)) {
      throw const MaintenanceException('Intervals must be greater than zero.');
    }
    if (warningKm != null && warningKm < 0) {
      throw const MaintenanceException('Warning threshold cannot be negative.');
    }
    if (warningKm != null && intervalKm != null && warningKm >= intervalKm) {
      throw const MaintenanceException(
          'Warning threshold (km) must be less than the interval (km).');
    }
    if (warningDays != null && warningDays < 0) {
      throw const MaintenanceException(
          'Warning threshold (days) cannot be negative.');
    }
    if (lastCompletedKm != null && lastCompletedKm < 0) {
      throw const MaintenanceException(
          'Last completed odometer cannot be negative.');
    }
  }
}
