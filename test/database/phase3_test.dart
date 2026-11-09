import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:adv_mon/core/database/app_database.dart';
import 'package:adv_mon/core/database/migrations/migrations.dart';
import 'package:adv_mon/core/enums/enums.dart';
import 'package:adv_mon/core/services/attachment_service.dart';
import 'package:adv_mon/features/components/data/components_repository.dart';
import 'package:adv_mon/features/components/domain/component_models.dart';
import 'package:adv_mon/features/maintenance/data/maintenance_repository.dart';
import 'package:adv_mon/features/maintenance/domain/maintenance_record_detail.dart';
import 'package:adv_mon/features/odometer/data/odometer_repository.dart';
import 'package:adv_mon/features/parts/data/parts_repository.dart';
import 'package:adv_mon/features/parts/domain/part_models.dart';

void main() {
  late AppDatabase db;
  late OdometerRepository odoRepo;
  late PartsRepository partsRepo;
  late MaintenanceRepository maintRepo;
  late ComponentsRepository compRepo;
  late Directory tempDir;
  late AttachmentService attachmentService;
  late int bikeId;
  late Map<String, int> itemIds;

  final fixedNow = DateTime.utc(2026, 11, 9, 2, 0);
  DateTime clock() => fixedNow;
  final day = DateTime.utc(2026, 11, 9);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tempDir = await Directory.systemTemp.createTemp('adv_mon_p3_test_');
    attachmentService = AttachmentService(() async => tempDir);
    odoRepo = OdometerRepository(db);
    partsRepo = PartsRepository(db, clock: clock);
    maintRepo = MaintenanceRepository(
      db,
      odoRepo,
      parts: partsRepo,
      attachments: attachmentService,
      clock: clock,
    );
    compRepo = ComponentsRepository(
      db,
      odoRepo,
      attachments: attachmentService,
      clock: clock,
    );
    bikeId = (await db.select(db.motorcycles).getSingle()).id;
    itemIds = {
      for (final i in await db.select(db.maintenanceItems).get()) i.name: i.id
    };
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  Future<String> createTempPhoto(String name) async {
    final file = File(p.join(tempDir.path, name));
    await file.writeAsBytes([1, 2, 3, 4]);
    return file.path;
  }

  group('migration v2 -> v3', () {
    test('preserves existing records and measurements across v2 -> v3',
        () async {
      await maintRepo.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Engine Oil']!,
        action: MaintenanceAction.replacement,
        date: day,
        odometerKm: 1000,
      ));
      await compRepo.addMeasurement(NewComponentMeasurement(
        motorcycleId: bikeId,
        itemId: itemIds['Drive Belt']!,
        measuredDate: day,
        odometerKm: 1000,
        measurementType: MeasurementType.thicknessMm,
        value: 21.8,
      ));

      await runMigrations(db, db.createMigrator(), 2, 3);
      expect(await db.select(db.maintenanceRecords).get(), hasLength(1));
      final meas = await db.select(db.componentMeasurements).get();
      expect(meas, hasLength(1));
      expect(meas.single.value, 21.8);
      expect(meas.single.voidedAt, isNull);
    });
  });

  group('maintenance records, parts, attachments & editing', () {
    test('records parts, installations and photo attachments atomically',
        () async {
      final srcPhoto = await createTempPhoto('oil_receipt.jpg');
      final recId = await maintRepo.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Engine Oil']!,
        action: MaintenanceAction.replacement,
        date: day,
        odometerKm: 1000,
        laborCostCentavos: 15000,
        serviceProvider: 'Honda Wing Shop',
        notes: 'First 1,000 km change',
        photoPaths: [srcPhoto],
        parts: const [
          RecordPartInput(
            name: 'Pro Honda 10W-30 MB',
            brand: 'Honda',
            partNumber: '08232-M99-K1LT1',
            specification: '10W-30 JASO MB 0.8L',
            quantity: 1,
            unitCostCentavos: 42000,
          ),
        ],
      ));

      final history = await maintRepo.loadHistory();
      expect(history, hasLength(1));
      final detail = history.single;
      expect(detail.id, recId);
      expect(detail.totalCostCentavos, 57000); // 150 + 420 pesos
      expect(detail.partsCostCentavos, 42000);
      expect(detail.parts.single.part.brand, 'Honda');
      expect(detail.attachments, hasLength(1));
      expect(detail.attachments.single.mimeType, 'image/jpeg');
      expect(File(detail.attachments.single.filePath).existsSync(), isTrue);

      final installs =
          await partsRepo.loadInstallations(itemId: itemIds['Engine Oil']);
      expect(installs, hasLength(1));
      expect(installs.single.installedKm, 1000);
      expect(installs.single.isInstalled, isTrue);
    });

    test('editing a record never overwrites the original row', () async {
      final origId = await maintRepo.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Engine Oil']!,
        action: MaintenanceAction.replacement,
        date: DateTime.utc(2026, 10, 1),
        odometerKm: 1000,
        laborCostCentavos: 10000,
        totalCostCentavos: 45000,
        notes: 'Initial note',
      ));

      final editedId = await maintRepo.editRecord(
        origId,
        NewMaintenanceRecord(
          motorcycleId: bikeId,
          itemId: itemIds['Engine Oil']!,
          action: MaintenanceAction.replacement,
          date: DateTime.utc(2026, 10, 1),
          odometerKm: 1020,
          laborCostCentavos: 12000,
          totalCostCentavos: 52000,
          notes: 'Corrected odometer and cost',
        ),
      );

      expect(editedId, isNot(origId));

      // Both rows remain in SQLite; original is voided, new one points to it.
      final allRows = await db.select(db.maintenanceRecords).get();
      expect(allRows, hasLength(2));
      final origRow = allRows.firstWhere((r) => r.id == origId);
      final newRow = allRows.firstWhere((r) => r.id == editedId);
      expect(origRow.voidedAt, isNotNull);
      expect(origRow.odometerKm, 1000);
      expect(origRow.notes, 'Initial note');
      expect(newRow.voidedAt, isNull);
      expect(newRow.supersedesRecordId, origId);
      expect(newRow.odometerKm, 1020);

      // Active history shows only the active version.
      final active = await maintRepo.loadHistory();
      expect(active, hasLength(1));
      expect(active.single.id, editedId);
      expect(active.single.supersedesRecordId, origId);
    });

    test('history filtering by date, category and maintenance item', () async {
      await maintRepo.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Engine Oil']!,
        action: MaintenanceAction.replacement,
        date: DateTime.utc(2026, 9, 1),
        odometerKm: 1000,
      ));
      await maintRepo.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Brake Pads Wear']!,
        action: MaintenanceAction.inspection,
        date: DateTime.utc(2026, 10, 15),
        odometerKm: 3000,
      ));
      await maintRepo.addRecord(NewMaintenanceRecord(
        motorcycleId: bikeId,
        itemId: itemIds['Engine Oil']!,
        action: MaintenanceAction.replacement,
        date: DateTime.utc(2026, 11, 5),
        odometerKm: 6000,
      ));

      final all = await maintRepo.loadHistory();
      expect(all.map((r) => r.odometerKm), [6000, 3000, 1000]);

      final byItem = await maintRepo
          .watchHistory(
            filter: MaintenanceHistoryFilter(itemId: itemIds['Engine Oil']),
          )
          .first;
      expect(byItem, hasLength(2));

      final brakesCatId = all
          .firstWhere((r) => r.itemId == itemIds['Brake Pads Wear'])
          .categoryId;
      final byCat = await maintRepo
          .watchHistory(
            filter: MaintenanceHistoryFilter(categoryId: brakesCatId),
          )
          .first;
      expect(byCat, hasLength(1));
      expect(byCat.single.itemName, 'Brake Pads Wear');

      final byDate = await maintRepo
          .watchHistory(
            filter: MaintenanceHistoryFilter(
              fromDate: DateTime.utc(2026, 10, 1),
              toDate: DateTime.utc(2026, 10, 31),
            ),
          )
          .first;
      expect(byDate, hasLength(1));
      expect(byDate.single.odometerKm, 3000);
    });
  });

  group('parts management & fuel filter / tire lifecycle', () {
    test('tracks fuel filter installation and replacement without overwriting',
        () async {
      final filterItemId = itemIds['Fuel Filter']!;
      final p1 = await partsRepo.addPart(NewPart(
        itemId: filterItemId,
        name: 'Fuel Filter',
        brand: 'Honda',
        partNumber: '16707-K1Z-J11',
        purchasePriceCentavos: 65000,
        purchaseDate: DateTime.utc(2026, 5, 1),
      ));
      await partsRepo.install(
        partId: p1,
        motorcycleId: bikeId,
        date: DateTime.utc(2026, 5, 1),
        odometerKm: 5000,
      );

      final p2 = await partsRepo.addPart(NewPart(
        itemId: filterItemId,
        name: 'Fuel Filter',
        brand: 'Honda',
        partNumber: '16707-K1Z-J11',
        purchasePriceCentavos: 68000,
        purchaseDate: DateTime.utc(2026, 11, 1),
      ));
      await partsRepo.install(
        partId: p2,
        motorcycleId: bikeId,
        date: DateTime.utc(2026, 11, 1),
        odometerKm: 15000,
      );

      final list = await partsRepo.loadInstallations(itemId: filterItemId);
      expect(list, hasLength(2));
      final current = list.firstWhere((i) => i.part.id == p2);
      final previous = list.firstWhere((i) => i.part.id == p1);

      expect(current.isInstalled, isTrue);
      expect(current.installedKm, 15000);
      expect(previous.isInstalled, isFalse);
      expect(previous.installedKm, 5000);
      expect(previous.removedKm, 15000);
      expect(previous.removedDate, DateTime.utc(2026, 11, 1));
      expect(previous.distanceKm(null), 10000);
    });

    test('front and rear positions have independent lifecycles', () async {
      final tireItemId = itemIds['Wheels/Tyres']!;
      final front1 = await partsRepo.addPart(
          NewPart(itemId: tireItemId, name: 'Front Tire', brand: 'IRC'));
      final rear1 = await partsRepo.addPart(
          NewPart(itemId: tireItemId, name: 'Rear Tire', brand: 'IRC'));
      final front2 = await partsRepo.addPart(
          NewPart(itemId: tireItemId, name: 'Front Tire 2', brand: 'Michelin'));

      await partsRepo.install(
        partId: front1,
        motorcycleId: bikeId,
        date: DateTime.utc(2026, 1, 1),
        odometerKm: 0,
        position: 'FRONT',
      );
      await partsRepo.install(
        partId: rear1,
        motorcycleId: bikeId,
        date: DateTime.utc(2026, 1, 1),
        odometerKm: 0,
        position: 'REAR',
      );
      // Replacing FRONT must close front1 but leave rear1 installed.
      await partsRepo.install(
        partId: front2,
        motorcycleId: bikeId,
        date: DateTime.utc(2026, 10, 1),
        odometerKm: 12000,
        position: 'FRONT',
      );

      final list = await partsRepo.loadInstallations(itemId: tireItemId);
      expect(list.firstWhere((i) => i.part.id == front1).isInstalled, isFalse);
      expect(list.firstWhere((i) => i.part.id == rear1).isInstalled, isTrue);
      expect(list.firstWhere((i) => i.part.id == front2).isInstalled, isTrue);
    });

    test('validates part inputs and removal rules', () async {
      expect(() => partsRepo.addPart(const NewPart(name: '   ')),
          throwsA(isA<PartsException>()));
      expect(() => partsRepo.addPart(const NewPart(name: 'X', quantity: 0)),
          throwsA(isA<PartsException>()));
      expect(
          () => partsRepo
              .addPart(const NewPart(name: 'X', purchasePriceCentavos: -10)),
          throwsA(isA<PartsException>()));
    });
  });

  group('component condition measurements', () {
    test('records CVT belt, brake pads, battery, tires & fluids with history',
        () async {
      final photoPath = await createTempPhoto('cvt_belt.png');

      // CVT Belt thickness + damage + photo
      await compRepo.addMeasurement(NewComponentMeasurement(
        motorcycleId: bikeId,
        itemId: itemIds['Drive Belt']!,
        measuredDate: DateTime.utc(2026, 10, 1),
        odometerKm: 18000,
        measurementType: MeasurementType.thicknessMm,
        value: 21.4,
        brand: 'Bando',
        partNumber: '23100-K1Z-J11',
        visualCondition: 'Minor glazing',
        hasDamage: false,
        notes: 'Checked at 18k service',
        photoPaths: [photoPath],
      ));

      // Brake pads front & rear
      await compRepo.addMeasurement(NewComponentMeasurement(
        motorcycleId: bikeId,
        itemId: itemIds['Brake Pads Wear']!,
        measuredDate: day,
        odometerKm: 18500,
        measurementType: MeasurementType.thicknessMm,
        value: 4.2,
        position: 'FRONT',
        visualCondition: 'Even wear',
      ));
      await compRepo.addMeasurement(NewComponentMeasurement(
        motorcycleId: bikeId,
        itemId: itemIds['Brake Pads Wear']!,
        measuredDate: day,
        odometerKm: 18500,
        measurementType: MeasurementType.thicknessMm,
        value: 3.8,
        position: 'REAR',
        visualCondition: 'Normal',
      ));

      // Battery voltage with context
      await compRepo.addMeasurement(NewComponentMeasurement(
        motorcycleId: bikeId,
        itemId: itemIds['Battery']!,
        measuredDate: day,
        odometerKm: 18500,
        measurementType: MeasurementType.voltageV,
        value: 12.75,
        measurementContext: BatteryMeasurementContext.engineOff.code,
        brand: 'Yuasa',
        partNumber: 'YTZ6V',
        visualCondition: 'Clean terminals',
      ));

      // Tire pressure + tread depth pair
      await compRepo.addMeasurements([
        NewComponentMeasurement(
          motorcycleId: bikeId,
          itemId: itemIds['Wheels/Tyres']!,
          measuredDate: day,
          odometerKm: 18500,
          measurementType: MeasurementType.pressureKpa,
          value: 200.0,
          position: 'FRONT',
          brand: 'Federal',
        ),
        NewComponentMeasurement(
          motorcycleId: bikeId,
          itemId: itemIds['Wheels/Tyres']!,
          measuredDate: day,
          odometerKm: 18500,
          measurementType: MeasurementType.treadDepthMm,
          value: 3.5,
          position: 'FRONT',
          brand: 'Federal',
        ),
      ]);

      // Fluid condition observation (no numeric value required)
      await compRepo.addMeasurement(NewComponentMeasurement(
        motorcycleId: bikeId,
        itemId: itemIds['Brake Fluid']!,
        measuredDate: day,
        odometerKm: 18500,
        measurementType: MeasurementType.conditionObservation,
        partNumber: 'DOT 4',
        visualCondition: 'Clear amber',
      ));

      final cvt =
          await compRepo.loadMeasurements(itemId: itemIds['Drive Belt']);
      expect(cvt, hasLength(1));
      expect(cvt.single.value, 21.4);
      expect(cvt.single.attachments, hasLength(1));
      expect(cvt.single.attachments.single.mimeType, 'image/png');

      final pads =
          await compRepo.loadMeasurements(itemId: itemIds['Brake Pads Wear']);
      expect(pads, hasLength(2));

      final batt = await compRepo.loadMeasurements(itemId: itemIds['Battery']);
      expect(batt.single.measurementContext, 'ENGINE_OFF');
      expect(batt.single.value, 12.75);

      final tires =
          await compRepo.loadMeasurements(itemId: itemIds['Wheels/Tyres']);
      expect(tires, hasLength(2));

      // Latest odometer updated to 18,500 km.
      final latestOdo = await odoRepo.latestConfirmed(bikeId);
      expect(latestOdo?.readingKm, 18500);
    });

    test('validates measurement inputs and preserves soft-deleted rows',
        () async {
      expect(
        () => compRepo.addMeasurement(NewComponentMeasurement(
          motorcycleId: bikeId,
          itemId: itemIds['Battery']!,
          measuredDate: day,
          measurementType: MeasurementType.voltageV,
          value: -12.0,
        )),
        throwsA(isA<ComponentException>()),
      );
      expect(
        () => compRepo.addMeasurement(NewComponentMeasurement(
          motorcycleId: bikeId,
          itemId: itemIds['Battery']!,
          measuredDate: DateTime.utc(2026, 11, 15),
          measurementType: MeasurementType.voltageV,
          value: 12.6,
        )),
        throwsA(isA<ComponentException>()),
      );

      final id = await compRepo.addMeasurement(NewComponentMeasurement(
        motorcycleId: bikeId,
        itemId: itemIds['Battery']!,
        measuredDate: day,
        measurementType: MeasurementType.voltageV,
        value: 12.6,
      ));
      await compRepo.voidMeasurement(id);

      // Active query excludes it, but the SQLite row is preserved.
      expect(
          await compRepo.loadMeasurements(itemId: itemIds['Battery']), isEmpty);
      expect(await db.select(db.componentMeasurements).get(), hasLength(1));
    });
  });
}
