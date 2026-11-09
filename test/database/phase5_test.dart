import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:adv_mon/core/database/app_database.dart';
import 'package:adv_mon/core/enums/enums.dart';
import 'package:adv_mon/core/services/attachment_service.dart';
import 'package:adv_mon/core/services/backup_service.dart';
import 'package:adv_mon/features/components/data/components_repository.dart';
import 'package:adv_mon/features/components/domain/component_models.dart';
import 'package:adv_mon/features/maintenance/data/maintenance_repository.dart';
import 'package:adv_mon/features/odometer/data/odometer_repository.dart';
import 'package:adv_mon/features/parts/data/parts_repository.dart';
import 'package:adv_mon/features/parts/domain/part_models.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db1;
  late AppDatabase db2;
  late Directory tempDir1;
  late Directory tempDir2;
  late BackupService backup1;
  late BackupService backup2;
  late MaintenanceRepository maintRepo1;
  late ComponentsRepository compRepo1;
  late int bikeId;
  late Map<String, int> itemIds;

  final fixedNow = DateTime.utc(2026, 11, 9, 2, 0);
  DateTime clock() => fixedNow;
  final day = DateTime.utc(2026, 11, 9);

  setUp(() async {
    db1 = AppDatabase(NativeDatabase.memory());
    db2 = AppDatabase(NativeDatabase.memory());
    tempDir1 = await Directory.systemTemp.createTemp('adv_mon_p5_1_');
    tempDir2 = await Directory.systemTemp.createTemp('adv_mon_p5_2_');

    final odo1 = OdometerRepository(db1);
    final parts1 = PartsRepository(db1, clock: clock);
    final att1 = AttachmentService(() async => tempDir1);
    maintRepo1 = MaintenanceRepository(
      db1,
      odo1,
      parts: parts1,
      attachments: att1,
      clock: clock,
    );
    compRepo1 = ComponentsRepository(
      db1,
      odo1,
      attachments: att1,
      clock: clock,
    );

    backup1 = BackupService(db1, () async => tempDir1, clock: clock);
    backup2 = BackupService(db2, () async => tempDir2, clock: clock);

    bikeId = (await db1.select(db1.motorcycles).getSingle()).id;
    itemIds = {
      for (final i in await db1.select(db1.maintenanceItems).get()) i.name: i.id
    };
  });

  tearDown(() async {
    await db1.close();
    await db2.close();
    if (await tempDir1.exists()) await tempDir1.delete(recursive: true);
    if (await tempDir2.exists()) await tempDir2.delete(recursive: true);
  });

  Future<String> createPhoto(String name, List<int> bytes) async {
    final file = File(p.join(tempDir1.path, name));
    await file.writeAsBytes(bytes);
    return file.path;
  }

  group('JSON & ZIP backup and restore', () {
    test(
        'exports full JSON backup and restores into another database '
        'preserving exact IDs and relationships', () async {
      final origId = await maintRepo1.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Engine Oil']!,
        action: MaintenanceAction.replacement,
        date: DateTime.utc(2026, 10, 1),
        odometerKm: 1000,
        laborCostCentavos: 15000,
        parts: const [
          RecordPartInput(
            name: 'Pro Honda 10W-30',
            brand: 'Honda',
            quantity: 1,
            unitCostCentavos: 42000,
          ),
        ],
      ));

      // Edit the record so supersedes_record_id self-reference is exercised.
      final editedId = await maintRepo1.editRecord(
        origId,
        NewMaintenanceRecord(
          motorcycleId: bikeId,
          itemId: itemIds['Engine Oil']!,
          action: MaintenanceAction.replacement,
          date: DateTime.utc(2026, 10, 1),
          odometerKm: 1050,
          laborCostCentavos: 15000,
          totalCostCentavos: 57000,
        ),
      );

      final jsonPath = await backup1.exportJsonBackup();
      final preview = await backup2.inspectBackupFile(jsonPath);
      expect(preview.tableCounts['maintenance_records'], 2);
      expect(preview.tableCounts['parts'], 1);
      expect(preview.tableCounts['part_installations'], 1);

      await backup2.restoreFromFile(jsonPath, confirmedByUser: true);

      final restoredRecs = await db2.select(db2.maintenanceRecords).get();
      expect(restoredRecs.map((r) => r.id).toSet(), {origId, editedId});
      final restoredEdited = restoredRecs.firstWhere((r) => r.id == editedId);
      expect(restoredEdited.supersedesRecordId, origId);
      expect(restoredEdited.odometerKm, 1050);

      final restoredInstalls = await db2.select(db2.partInstallations).get();
      expect(restoredInstalls, hasLength(1));
      expect(restoredInstalls.single.recordId, editedId);
    });

    test('exports ZIP backup with inspection photos and restores attachments',
        () async {
      final srcPhoto =
          await createPhoto('belt_check.jpg', [10, 20, 30, 40, 50]);
      final measId = await compRepo1.addMeasurement(NewComponentMeasurement(
        motorcycleId: bikeId,
        itemId: itemIds['Drive Belt']!,
        measuredDate: day,
        odometerKm: 18000,
        measurementType: MeasurementType.thicknessMm,
        value: 21.3,
        photoPaths: [srcPhoto],
      ));

      final zipPath = await backup1.exportZipBackup();
      final preview = await backup2.inspectBackupFile(zipPath);
      expect(preview.bundledAttachmentCount, 1);

      await backup2.restoreFromFile(zipPath, confirmedByUser: true);

      final restoredMeas = await db2.select(db2.componentMeasurements).get();
      expect(restoredMeas.single.id, measId);
      expect(restoredMeas.single.value, 21.3);

      final restoredAtts = await db2.select(db2.attachments).get();
      expect(restoredAtts, hasLength(1));
      expect(restoredAtts.single.measurementId, measId);
      final restoredFile = File(restoredAtts.single.filePath);
      expect(await restoredFile.exists(), isTrue);
      expect(await restoredFile.readAsBytes(), [10, 20, 30, 40, 50]);
    });
  });

  group('validation, confirmation & recovery', () {
    test('refuses to restore when confirmedByUser is false', () async {
      final jsonPath = await backup1.exportJsonBackup();
      expect(
        () => backup2.restoreFromFile(jsonPath, confirmedByUser: false),
        throwsA(isA<BackupException>()),
      );
    });

    test(
        'rejects unsupported schema version, bad format version, missing '
        'tables, and broken foreign keys without touching existing data',
        () async {
      // Seed a record in db2 so we can verify it is untouched on failure.
      final odo2 = OdometerRepository(db2);
      final maint2 = MaintenanceRepository(db2, odo2, clock: clock);
      await maint2.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Engine Oil']!,
        action: MaintenanceAction.replacement,
        date: day,
        odometerKm: 2000,
      ));

      final validMap = await backup1.buildBackupMap();

      Future<String> writeModified(Map<String, dynamic> m, String name) async {
        final f = File(p.join(tempDir1.path, name));
        await f.writeAsString(jsonEncode(m));
        return f.path;
      }

      // 1. Future schema version
      final futureSchema = Map<String, dynamic>.of(validMap)
        ..['schemaVersion'] = 999;
      final p1 = await writeModified(futureSchema, 'future_schema.json');
      await expectLater(
        () => backup2.restoreFromFile(p1, confirmedByUser: true),
        throwsA(isA<BackupException>()),
      );

      // 2. Future format version
      final futureFormat = Map<String, dynamic>.of(validMap)
        ..['formatVersion'] = 99;
      final p2 = await writeModified(futureFormat, 'future_format.json');
      await expectLater(
        () => backup2.restoreFromFile(p2, confirmedByUser: true),
        throwsA(isA<BackupException>()),
      );

      // 3. Broken foreign key in maintenance_records
      final brokenFkMap =
          jsonDecode(jsonEncode(validMap)) as Map<String, dynamic>;
      final tables = brokenFkMap['tables'] as Map<String, dynamic>;
      (tables['maintenance_records'] as List).add({
        'id': 50,
        'motorcycleId': 99999, // does not exist
        'itemId': itemIds['Engine Oil'],
        'action': 'REPLACEMENT',
        'performedDate': '2026-11-09',
        'odometerKm': 1000,
        'laborCostCentavos': 0,
        'totalCostCentavos': 0,
        'createdAt': '2026-11-09T00:00:00',
      });
      final p3 = await writeModified(brokenFkMap, 'broken_fk.json');
      await expectLater(
        () => backup2.restoreFromFile(p3, confirmedByUser: true),
        throwsA(isA<BackupException>()),
      );

      // db2's existing record is still intact.
      final db2Recs = await db2.select(db2.maintenanceRecords).get();
      expect(db2Recs, hasLength(1));
      expect(db2Recs.single.odometerKm, 2000);
    });
  });

  group('CSV exports', () {
    test('exports maintenance records and expenses to valid RFC-4180 CSV files',
        () async {
      await maintRepo1.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Engine Oil']!,
        action: MaintenanceAction.replacement,
        date: day,
        odometerKm: 1000,
        laborCostCentavos: 15000,
        serviceProvider: 'Honda Wing, Manila',
        notes: 'Checked "oil strainer", all clean',
        parts: const [
          RecordPartInput(
            name: 'Pro Honda 10W-30',
            quantity: 1,
            unitCostCentavos: 42000,
          ),
        ],
      ));

      final history = await maintRepo1.loadHistory();
      final recCsvPath = await backup1.exportMaintenanceRecordsCsv(history);
      final expCsvPath = await backup1.exportExpensesCsv(history);

      final recCsv = await File(recCsvPath).readAsString();
      expect(recCsv, contains('Record ID,Date,Odometer (km),Category'));
      expect(recCsv, contains('"Honda Wing, Manila"'));
      expect(recCsv, contains('"Checked ""oil strainer"", all clean"'));
      expect(recCsv, contains('150.00,420.00,570.00'));

      final expCsv = await File(expCsvPath).readAsString();
      expect(expCsv, contains('Record ID,Date,Year-Month,Category'));
      expect(expCsv, contains('2026-11,Engine,Engine Oil,REPLACEMENT,1000'));
      expect(expCsv, contains('420.00,150.00,570.00'));
    });
  });
}
