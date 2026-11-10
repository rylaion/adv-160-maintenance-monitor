import 'package:adv_mon/core/database/app_database.dart';
import 'package:adv_mon/core/database/seed/honda_parts_seed.dart';
import 'package:adv_mon/core/database/seed/initial_seed.dart';
import 'package:adv_mon/features/parts_catalog/data/parts_catalog_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late PartsCatalogRepository repo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await InitialSeed(db).run();
    await HondaPartsSeed(db).run();
    repo = PartsCatalogRepository(db);
  });

  tearDown(() => db.close());

  group('Honda ADV 160 OEM Parts Catalogue (Phase 3)', () {
    test('Seeded catalogue contains verified official Honda OEM parts',
        () async {
      final parts = await repo.watchParts().first;
      expect(parts.length, greaterThanOrEqualTo(20));

      final belt = parts.firstWhere((p) => p.partNumber == '23100-K0W-N01');
      expect(belt.officialName, 'Drive V-Belt');
      expect(belt.category, 'CVT / Transmission');
      expect(belt.diagramNumber, 'E-17');
      expect(belt.referenceNumber, 3);
      expect(belt.maintenanceItemId, isNotNull);
    });

    test('Search by partial part number matches with or without hyphens',
        () async {
      // With hyphen partial
      final withHyphen = await repo.watchParts(query: '23100-K0W').first;
      expect(withHyphen.any((p) => p.partNumber == '23100-K0W-N01'), isTrue);

      // Without hyphens
      final withoutHyphen = await repo.watchParts(query: '23100K0WN01').first;
      expect(withoutHyphen.any((p) => p.partNumber == '23100-K0W-N01'), isTrue);

      // Raw code
      final k0wResults = await repo.watchParts(query: 'K0W').first;
      expect(k0wResults.length, greaterThan(5));
    });

    test('Search by part name or assembly matches correctly', () async {
      final brakePads = await repo.watchParts(query: 'Brake Pad').first;
      expect(brakePads.length, greaterThanOrEqualTo(2));
      expect(brakePads.any((p) => p.officialName.contains('Front')), isTrue);
      expect(brakePads.any((p) => p.officialName.contains('Rear')), isTrue);

      final airCleaner = await repo.watchParts(query: 'Air Cleaner').first;
      expect(airCleaner.any((p) => p.partNumber == '17210-K0W-N00'), isTrue);
    });

    test('Filter by category returns only parts belonging to that category',
        () async {
      final cvtParts =
          await repo.watchParts(category: 'CVT / Transmission').first;
      expect(cvtParts.isNotEmpty, isTrue);
      for (final p in cvtParts) {
        expect(p.category, 'CVT / Transmission');
      }

      final brakeParts =
          await repo.watchParts(category: 'Braking System').first;
      expect(brakeParts.isNotEmpty, isTrue);
      for (final p in brakeParts) {
        expect(p.category, 'Braking System');
      }
    });

    test('Exploded diagram lookup returns components in reference order',
        () async {
      final e17Parts = await repo.getPartsForDiagram('E-17');
      expect(e17Parts.isNotEmpty, isTrue);

      // Verify reference numbers are in ascending order
      for (int i = 0; i < e17Parts.length - 1; i++) {
        final a = e17Parts[i].referenceNumber ?? 0;
        final b = e17Parts[i + 1].referenceNumber ?? 0;
        expect(a, lessThanOrEqualTo(b));
      }

      expect(
          e17Parts.any(
              (p) => p.referenceNumber == 1 && p.partNumber == '22011-K0W-N00'),
          isTrue);
      expect(
          e17Parts.any(
              (p) => p.referenceNumber == 3 && p.partNumber == '23100-K0W-N01'),
          isTrue);
      expect(
          e17Parts.any(
              (p) => p.referenceNumber == 5 && p.partNumber == '22123-K0W-N00'),
          isTrue);
    });

    test('Model compatibility reflects verified 2023 Honda ADV 160 fitment',
        () async {
      final belt = await repo.getPartByPartNumber('23100-K0W-N01');
      expect(belt, isNotNull);
      expect(belt!.compatibilities.isNotEmpty, isTrue);

      final compat = belt.compatibilities.first;
      expect(compat.modelName, 'Honda ADV 160');
      expect(compat.modelCode, 'K0W');
      expect(compat.startYear, 2022);
      expect(compat.regionalVariant, contains('Philippines'));
    });
  });
}
