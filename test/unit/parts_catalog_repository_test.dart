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
      expect(parts.length, greaterThanOrEqualTo(600));

      final belt = parts.firstWhere((p) => p.partNumber == '23100-K1Z-N21');
      expect(belt.officialName, 'BELT, DRIVE');
      expect(belt.category, 'CVT / Transmission');
      expect(belt.diagramNumber, 'E-17');
      expect(belt.referenceNumber, 7);
      expect(belt.maintenanceItemId, isNotNull);
    });

    test('Search by partial part number matches with or without hyphens',
        () async {
      // With hyphen partial
      final withHyphen = await repo.watchParts(query: '23100-K1Z').first;
      expect(withHyphen.any((p) => p.partNumber == '23100-K1Z-N21'), isTrue);

      // Without hyphens
      final withoutHyphen = await repo.watchParts(query: '23100K1ZN21').first;
      expect(withoutHyphen.any((p) => p.partNumber == '23100-K1Z-N21'), isTrue);

      // Raw code
      final k0wResults = await repo.watchParts(query: 'K0W').first;
      expect(k0wResults.length, greaterThan(5));
    });

    test('Search by part name or assembly matches correctly', () async {
      final brakePads = await repo.watchParts(query: 'PAD SET').first;
      expect(brakePads.length, greaterThanOrEqualTo(2));
      expect(brakePads.any((p) => p.officialName.contains('FR')), isTrue);
      expect(brakePads.any((p) => p.officialName.contains('RR')), isTrue);

      final airCleaner = await repo.watchParts(query: '17220-K2S-N00').first;
      expect(airCleaner.isNotEmpty, isTrue);
      expect(airCleaner.first.officialName, contains('ELEMENT SET'));
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
              (p) => p.referenceNumber == 1 && p.partNumber == '22100-K0W-NA0'),
          isTrue);
      expect(
          e17Parts.any(
              (p) => p.referenceNumber == 7 && p.partNumber == '23100-K1Z-N21'),
          isTrue);
      expect(
          e17Parts.any(
              (p) => p.referenceNumber == 8 && p.partNumber == '23205-K0W-NA0'),
          isTrue);
    });

    test('Official 54 diagrams are seeded with high-res image asset paths',
        () async {
      final diagrams = await repo.watchDiagrams().first;
      expect(diagrams.length, 54);

      // Verify F-10 is Steering Stem
      final f10 = diagrams.firstWhere((d) => d.diagramCode == 'F-10');
      expect(f10.title, contains('STEERING STEM'));
      expect(f10.imageAssetPath,
          'assets/images/parts_catalog/adv160_2023/pages/page_059.webp');

      final f10Parts = await repo.getPartsForDiagram('F-10');
      expect(f10Parts.isNotEmpty, isTrue);
      expect(
          f10Parts.any((p) => p.partNumber == '50301-GN5-901'), isTrue); // Race
      expect(
          f10Parts.any((p) => p.partNumber == '53219-K0W-N00'), isTrue); // Stem

      // Verify F-20-40 is Front Wheel
      final f20 = diagrams.firstWhere((d) => d.diagramCode == 'F-20-40');
      expect(f20.title, contains('FRONT WHEEL'));
      expect(f20.imageAssetPath,
          'assets/images/parts_catalog/adv160_2023/pages/page_073.webp');

      final f20Parts = await repo.getPartsForDiagram('F-20-40');
      expect(f20Parts.isNotEmpty, isTrue);
      expect(
          f20Parts.any((p) => p.partNumber == '45351-K0W-N01'), isTrue); // Disk
      expect(
          f20Parts.any((p) => p.partNumber == '44711-K0W-N01'), isTrue); // Tire

      // Verify Rear Brake diagrams map to authentic rear brake page images (Not Steering Stem / T-Post)
      final f6 = diagrams.firstWhere((d) => d.diagramCode == 'F-6');
      expect(f6.title, 'REAR BRAKE MASTER CYLINDER');
      expect(f6.imageAssetPath,
          'assets/images/parts_catalog/adv160_2023/pages/page_056.webp');

      final f7 = diagrams.firstWhere((d) => d.diagramCode == 'F-7-10');
      expect(f7.title, 'REAR BRAKE PIPE');
      expect(f7.imageAssetPath,
          'assets/images/parts_catalog/adv160_2023/pages/page_057.webp');

      final f21 = diagrams.firstWhere((d) => d.diagramCode == 'F-21');
      expect(f21.title, 'REAR BRAKE CALIPER');
      expect(f21.imageAssetPath,
          'assets/images/parts_catalog/adv160_2023/pages/page_074.webp');

      // Verify Front Shock (Front Fork) and Front Brake
      final f17 = diagrams.firstWhere((d) => d.diagramCode == 'F-17');
      expect(f17.title, 'FRONT FORK');
      expect(f17.imageAssetPath,
          'assets/images/parts_catalog/adv160_2023/pages/page_071.webp');

      final f18 = diagrams.firstWhere((d) => d.diagramCode == 'F-18');
      expect(f18.title, 'FRONT BRAKE CALIPER');
      expect(f18.imageAssetPath,
          'assets/images/parts_catalog/adv160_2023/pages/page_072.webp');

      // Verify official catalogue ordering (E-2 first, F-48 last)
      expect(diagrams.first.diagramCode, 'E-2');
      expect(diagrams.last.diagramCode, 'F-48');
    });

    test(
        'Record Replacement URI encoding produces valid URI without syntax errors',
        () async {
      final part = await repo.getPartByPartNumber('45351-K0W-N01');
      expect(part, isNotNull);

      final notesBuf = StringBuffer();
      notesBuf.write(
          'Replaced with genuine Honda OEM ${part!.officialName} (${part.partNumber}).');
      notesBuf.write(' Category: ${part.category}.');
      if (part.diagramNumber != null) {
        notesBuf.write(' Diagram: ${part.diagramReferenceLabel}.');
      }

      final uri = Uri(
        path: '/maintenance/record',
        queryParameters: {
          if (part.maintenanceItemId != null)
            'itemId': '${part.maintenanceItemId}',
          'action': 'REPLACE',
          'notes': notesBuf.toString(),
          'partName': part.officialName,
          'partNo': part.partNumber,
          'brand': 'Honda Genuine OEM',
        },
      );

      final uriString = uri.toString();
      expect(uriString, startsWith('/maintenance/record?'));
      expect(uriString, contains('action=REPLACE'));

      // Parsing the generated string must succeed without throwing FormatException
      final parsed = Uri.parse(uriString);
      expect(parsed.queryParameters['notes'], contains('45351-K0W-N01'));
      expect(parsed.queryParameters['partName'], part.officialName);
      expect(parsed.queryParameters['brand'], 'Honda Genuine OEM');
    });

    test(
        'Model compatibility reflects verified 2022-2023 Honda ADV 160 fitment',
        () async {
      final belt = await repo.getPartByPartNumber('23100-K1Z-N21');
      expect(belt, isNotNull);
      expect(belt!.compatibilities.isNotEmpty, isTrue);

      final compat = belt.compatibilities.first;
      expect(compat.modelName, 'Honda ADV 160');
      expect(compat.modelCode, 'ADV160AP');
      expect(compat.startYear, 2022);
      expect(compat.regionalVariant, contains('Philippines'));
    });
  });
}
