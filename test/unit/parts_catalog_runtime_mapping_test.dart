import 'package:adv_mon/core/database/app_database.dart';
import 'package:adv_mon/core/database/seed/honda_parts_seed.dart';
import 'package:adv_mon/core/database/seed/initial_seed.dart';
import 'package:adv_mon/features/parts_catalog/data/parts_catalog_repository.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late PartsCatalogRepository repo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await InitialSeed(db).run();
    await HondaPartsSeed(db).run();
    repo = PartsCatalogRepository(db);
  });

  tearDown(() => db.close());

  group('Honda ADV160 Official Catalogue Runtime Mapping (18K0WP01)', () {
    /// Helper to test Part -> Diagram -> PDF Page -> Printed Page -> Image Asset
    Future<void> assertPartToDiagramMapping({
      required String partNumber,
      required String expectedDiagramCode,
      required String expectedDiagramTitle,
      required int expectedPrintedPage,
      required int expectedPdfPage,
      required String expectedImageAssetPath,
      int? expectedRefNo,
    }) async {
      // 1. Query part from repository
      final part = await repo.getPartByPartNumber(partNumber);
      expect(part, isNotNull,
          reason: 'Part $partNumber must exist in the database');
      expect(part!.diagramNumber, expectedDiagramCode,
          reason: 'Part $partNumber diagramNumber mismatch');
      if (expectedRefNo != null) {
        expect(part.referenceNumber, expectedRefNo,
            reason: 'Part $partNumber referenceNumber mismatch');
      }

      // 2. Query diagram from repository
      final diagrams = await repo.watchDiagrams().first;
      final diagram =
          diagrams.firstWhere((d) => d.diagramCode == expectedDiagramCode);
      expect(diagram.title, expectedDiagramTitle);
      expect(diagram.imageAssetPath, expectedImageAssetPath);
      expect(diagram.printedPageNumber, expectedPrintedPage);
      expect(diagram.pdfPageNumber, expectedPdfPage);

      // 3. Verify that the assigned asset file actually loads in rootBundle
      final byteData = await rootBundle.load(expectedImageAssetPath);
      expect(byteData.lengthInBytes, greaterThan(1000),
          reason:
              'Asset $expectedImageAssetPath must be non-empty and readable');

      // 4. Verify that getPartsForDiagram returns this part
      final diagramParts = await repo.getPartsForDiagram(expectedDiagramCode);
      expect(diagramParts.any((p) => p.partNumber == partNumber), isTrue,
          reason:
              'Diagram $expectedDiagramCode parts list must contain $partNumber');
    }

    test('1. Rear Brake Master Cylinder: F-6 -> p.56 (PDF p.59)', () async {
      await assertPartToDiagramMapping(
        partNumber: '43510-K1Z-J11', // CYLINDER SUB ASSY, RR MASTER
        expectedDiagramCode: 'F-6',
        expectedDiagramTitle: 'REAR BRAKE MASTER CYLINDER',
        expectedPrintedPage: 56,
        expectedPdfPage: 59,
        expectedImageAssetPath:
            'assets/images/parts_catalog/adv160_2023/pages/page_056.webp',
        expectedRefNo: 5,
      );
    });

    test('2. Rear Brake Pipe: F-7-10 -> p.57 (PDF p.60)', () async {
      await assertPartToDiagramMapping(
        partNumber: '43312-K0W-NB0', // PIPE COMP, RR BRAKE
        expectedDiagramCode: 'F-7-10',
        expectedDiagramTitle: 'REAR BRAKE PIPE',
        expectedPrintedPage: 57,
        expectedPdfPage: 60,
        expectedImageAssetPath:
            'assets/images/parts_catalog/adv160_2023/pages/page_057.webp',
        expectedRefNo: 4,
      );
    });

    test('3. Rear Brake Caliper: F-21 -> p.74 (PDF p.77)', () async {
      await assertPartToDiagramMapping(
        partNumber: '43150-K0W-N01', // CALIPER SUB ASSY, RR
        expectedDiagramCode: 'F-21',
        expectedDiagramTitle: 'REAR BRAKE CALIPER',
        expectedPrintedPage: 74,
        expectedPdfPage: 77,
        expectedImageAssetPath:
            'assets/images/parts_catalog/adv160_2023/pages/page_074.webp',
        expectedRefNo: 5,
      );
    });

    test('4. Front Brake Caliper: F-18 -> p.72 (PDF p.75)', () async {
      await assertPartToDiagramMapping(
        partNumber: '06455-K84-902', // PAD SET, FR BRAKE(NISSIN)
        expectedDiagramCode: 'F-18',
        expectedDiagramTitle: 'FRONT BRAKE CALIPER',
        expectedPrintedPage: 72,
        expectedPdfPage: 75,
        expectedImageAssetPath:
            'assets/images/parts_catalog/adv160_2023/pages/page_072.webp',
        expectedRefNo: 2,
      );
    });

    test('5. Front Fork: F-17 -> p.71 (PDF p.74)', () async {
      await assertPartToDiagramMapping(
        partNumber: '51400-K0W-NA1', // FORK ASSY, R FR
        expectedDiagramCode: 'F-17',
        expectedDiagramTitle: 'FRONT FORK',
        expectedPrintedPage: 71,
        expectedPdfPage: 74,
        expectedImageAssetPath:
            'assets/images/parts_catalog/adv160_2023/pages/page_071.webp',
        expectedRefNo: 1,
      );
    });

    test('6. Steering Stem / T-Post: F-10 -> p.59 (PDF p.62)', () async {
      await assertPartToDiagramMapping(
        partNumber: '53219-K0W-N00', // STEM SUB ASSY, STEERING
        expectedDiagramCode: 'F-10',
        expectedDiagramTitle: 'STEERING STEM',
        expectedPrintedPage: 59,
        expectedPdfPage: 62,
        expectedImageAssetPath:
            'assets/images/parts_catalog/adv160_2023/pages/page_059.webp',
        expectedRefNo: 10,
      );
    });

    test('7. Air Cleaner: F-28 -> p.80 (PDF p.83)', () async {
      await assertPartToDiagramMapping(
        partNumber: '17220-K2S-N00', // ELEMENT SET, AIR CLEANER(WL)
        expectedDiagramCode: 'F-28',
        expectedDiagramTitle: 'AIR CLEANER',
        expectedPrintedPage: 80,
        expectedPdfPage: 83,
        expectedImageAssetPath:
            'assets/images/parts_catalog/adv160_2023/pages/page_080.webp',
        expectedRefNo: 8,
      );
    });

    test('8. Fuel Tank: F-26 -> p.79 (PDF p.82)', () async {
      await assertPartToDiagramMapping(
        partNumber: '17506-K1Z-J10', // PLATE, FUEL TANK
        expectedDiagramCode: 'F-26',
        expectedDiagramTitle: 'FUEL TANK',
        expectedPrintedPage: 79,
        expectedPdfPage: 82,
        expectedImageAssetPath:
            'assets/images/parts_catalog/adv160_2023/pages/page_079.webp',
        expectedRefNo: 4,
      );
    });

    test('9. Front Wheel: F-20-40 -> p.73 (PDF p.76)', () async {
      await assertPartToDiagramMapping(
        partNumber: '44711-K0W-N01', // TIRE, FR(SRI)
        expectedDiagramCode: 'F-20-40',
        expectedDiagramTitle: 'FRONT WHEEL',
        expectedPrintedPage: 73,
        expectedPdfPage: 76,
        expectedImageAssetPath:
            'assets/images/parts_catalog/adv160_2023/pages/page_073.webp',
        expectedRefNo: 8,
      );
    });

    test('10. Rear Wheel: F-22-40 -> p.75 (PDF p.78)', () async {
      await assertPartToDiagramMapping(
        partNumber: '42711-K0W-N01', // TIRE, RR(SRI)
        expectedDiagramCode: 'F-22-40',
        expectedDiagramTitle: 'REAR WHEEL/SWINGARM',
        expectedPrintedPage: 75,
        expectedPdfPage: 78,
        expectedImageAssetPath:
            'assets/images/parts_catalog/adv160_2023/pages/page_075.webp',
        expectedRefNo: 5,
      );
    });

    test('11. Drive Face: E-16 -> p.40 (PDF p.43)', () async {
      await assertPartToDiagramMapping(
        partNumber: '22102-K1Z-N20', // FACE, DRIVE
        expectedDiagramCode: 'E-16',
        expectedDiagramTitle: 'DRIVE FACE',
        expectedPrintedPage: 40,
        expectedPdfPage: 43,
        expectedImageAssetPath:
            'assets/images/parts_catalog/adv160_2023/pages/page_040.webp',
        expectedRefNo: 2,
      );
    });

    test('12. Driven Face: E-17 -> p.41 (PDF p.44)', () async {
      await assertPartToDiagramMapping(
        partNumber: '23100-K1Z-N21', // BELT, DRIVE
        expectedDiagramCode: 'E-17',
        expectedDiagramTitle: 'DRIVEN FACE',
        expectedPrintedPage: 41,
        expectedPdfPage: 44,
        expectedImageAssetPath:
            'assets/images/parts_catalog/adv160_2023/pages/page_041.webp',
        expectedRefNo: 7,
      );
    });
  });

  group('Migration & Non-Destructive Update Verification', () {
    test('forceSyncCatalogue updates in place and preserves user data',
        () async {
      // 1. Simulate user creating a maintenance record referencing a part
      final part = await repo.getPartByPartNumber('23100-K1Z-N21');
      expect(part, isNotNull);

      final bike = await (db.select(db.motorcycles)).getSingle();
      final items = await (db.select(db.maintenanceItems)).get();
      final nowStr = DateTime.now().toIso8601String();

      final recordId = await db.into(db.maintenanceRecords).insert(
            MaintenanceRecordsCompanion.insert(
              motorcycleId: bike.id,
              itemId: items.first.id,
              action: 'REPLACEMENT',
              performedDate: '2026-11-10',
              odometerKm: 6500,
              totalCostCentavos: const Value(150000),
              notes: const Value('Installed new drive belt'),
              createdAt: nowStr,
            ),
          );

      final insertedPartId = await db.into(db.parts).insert(
            PartsCompanion.insert(
              name: part!.officialName,
              partNumber: Value(part.partNumber),
              createdAt: nowStr,
            ),
          );

      // Link part
      await db.into(db.maintenanceRecordParts).insert(
            MaintenanceRecordPartsCompanion.insert(
              recordId: recordId,
              partId: insertedPartId,
              quantity: const Value(1),
            ),
          );

      // 2. Corrupt one diagram's path and a part's diagram reference to simulate old stale state
      await (db.update(db.partsCatalogImages)
            ..where((t) => t.diagramCode.equals('F-6')))
          .write(
        const PartsCatalogImagesCompanion(
          imageAssetPath: Value('assets/images/old_stale_path.png'),
        ),
      );

      await (db.update(db.partsCatalog)
            ..where((t) => t.partNumber.equals('43510-K1Z-J11')))
          .write(
        const PartsCatalogCompanion(
          diagramNumber: Value('WRONG-CODE'),
        ),
      );

      // Verify corruption
      final staleDiagram = (await repo.watchDiagrams().first)
          .firstWhere((d) => d.diagramCode == 'F-6');
      expect(staleDiagram.imageAssetPath, 'assets/images/old_stale_path.png');

      final stalePart = await repo.getPartByPartNumber('43510-K1Z-J11');
      expect(stalePart!.diagramNumber, 'WRONG-CODE');

      // 3. Execute forceSyncCatalogue (migration v10 logic)
      await HondaPartsSeed(db).forceSyncCatalogue();

      // 4. Verify records are properly corrected
      final fixedDiagram = (await repo.watchDiagrams().first)
          .firstWhere((d) => d.diagramCode == 'F-6');
      expect(fixedDiagram.imageAssetPath,
          'assets/images/parts_catalog/adv160_2023/pages/page_056.webp');

      final fixedPart = await repo.getPartByPartNumber('43510-K1Z-J11');
      expect(fixedPart!.diagramNumber, 'F-6');

      // 5. Verify user data is 100% intact!
      final records = await (db.select(db.maintenanceRecords)
            ..where((t) => t.id.equals(recordId)))
          .get();
      expect(records.length, 1);
      expect(records.first.notes, 'Installed new drive belt');

      final recParts = await (db.select(db.maintenanceRecordParts)
            ..where((t) => t.recordId.equals(recordId)))
          .get();
      expect(recParts.length, 1);
      expect(recParts.first.partId, insertedPartId);
    });
  });
}
