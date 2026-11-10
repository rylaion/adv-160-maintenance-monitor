import 'package:drift/drift.dart';

import '../app_database.dart';

/// Seeds verified official Honda OEM parts catalogue for the 2023 Honda ADV 160 (K0W).
class HondaPartsSeed {
  HondaPartsSeed(this.db);
  final AppDatabase db;

  static const String sourceModel = 'Honda ADV 160';
  static const String sourceModelCode = 'K0W';
  static const int modelYear = 2023;
  static const String regionalVariant = 'Philippines / ASEAN';

  static const List<({String code, String title, String assembly, String desc})>
      defaultDiagrams = [
    (
      code: 'E-17',
      title: 'CVT Drive Face & Driven Pulley Assembly',
      assembly: 'CVT / Transmission',
      desc:
          'Exploded schematic of the primary movable drive face, ramp plate, rollers, drive belt, and driven pulley.',
    ),
    (
      code: 'F-10',
      title: 'Front Wheel & Brake Disc Assembly',
      assembly: 'Front Wheel / Braking',
      desc:
          'Exploded schematic of front rim, tubeless tire, 240mm front brake disc, wheel bearings, and front axle.',
    ),
    (
      code: 'F-11',
      title: 'Front Hydraulic Brake Caliper & Pad Assembly',
      assembly: 'Front Brake System',
      desc:
          'Exploded schematic of front 2-piston Nissin caliper, brake pads, pad spring, and mounting bolts.',
    ),
    (
      code: 'F-12',
      title: 'Rear Hydraulic Brake Caliper & Pad Assembly',
      assembly: 'Rear Brake System',
      desc:
          'Exploded schematic of single-piston rear caliper, pads, pin bolt, and pad shims.',
    ),
    (
      code: 'F-13',
      title: 'Rear Wheel & Brake Disc Assembly',
      assembly: 'Rear Wheel / Braking',
      desc:
          'Exploded schematic of rear rim, tubeless tire, 220mm rear brake disc rotor, and axle nut.',
    ),
    (
      code: 'E-19',
      title: 'Air Cleaner Case & Intake Assembly',
      assembly: 'Air Cleaner & Fuel',
      desc:
          'Exploded schematic of the air filter cartridge, intake duct, drain tube, and resonator.',
    ),
    (
      code: 'E-02',
      title: 'Cylinder Head & Spark Plug Assembly',
      assembly: 'Engine / Cylinder Head',
      desc:
          'Exploded schematic of cylinder head cover, gasket, and NGK spark plug.',
    ),
    (
      code: 'E-08',
      title: 'Oil Strainer, Pump & Right Crankcase',
      assembly: 'Lubrication / Crankcase',
      desc:
          'Exploded schematic of engine oil strainer screen, drain plug washer, and oil pump.',
    ),
    (
      code: 'E-14',
      title: 'Water Pump & Radiator Cooling System',
      assembly: 'Cooling System',
      desc:
          'Exploded schematic of water pump impeller, radiator reserve tank, and cooling hoses.',
    ),
    (
      code: 'E-18',
      title: 'Final Reduction & Transmission Case',
      assembly: 'Transmission / Final Drive',
      desc:
          'Exploded schematic of final reduction gear shaft, countershaft, bearings, and oil seal.',
    ),
    (
      code: 'E-12',
      title: 'ACG Starter & Generator Assembly',
      assembly: 'Starting / Charging System',
      desc:
          'Exploded schematic of ACG brushless starter generator stator and rotor flywheel.',
    ),
    (
      code: 'F-30',
      title: 'Battery & Main Electrical Harness',
      assembly: 'Electrical System',
      desc:
          'Exploded schematic of YTZ6V 12V 5Ah maintenance-free battery, fuses, and battery box.',
    ),
  ];

  Future<void> ensureDiagramsSeeded() async {
    try {
      final tableCheck = await db.customSelect(
        "SELECT count(*) as c FROM sqlite_master WHERE type='table' AND name='parts_catalog_images';",
      ).getSingle();
      if ((tableCheck.data['c'] as int? ?? 0) == 0) {
        return; // Table does not exist yet (e.g. during schema migration tests)
      }

      for (final d in defaultDiagrams) {
        final existing = await (db.select(db.partsCatalogImages)
              ..where((t) => t.diagramCode.equals(d.code)))
            .getSingleOrNull();
        if (existing == null) {
          await db.into(db.partsCatalogImages).insert(
                PartsCatalogImagesCompanion.insert(
                  diagramCode: d.code,
                  title: d.title,
                  assemblyName: d.assembly,
                  description: Value(d.desc),
                ),
              );
        }
      }
    } catch (_) {
      // Gracefully ignore if database is in an intermediate migration state
    }
  }

  Future<void> run() async {
    await db.transaction(() async {
      await ensureDiagramsSeeded();

      final existingCount = await (db.select(db.partsCatalog)).get();
      if (existingCount.length >= 20) {
        return; // Already seeded
      }

      // 1. Fetch Maintenance Items map to link catalog parts directly
      final items = await (db.select(db.maintenanceItems)).get();
      final itemMap = {for (final item in items) item.name: item.id};

      // 3. Seed OEM Catalogue Parts
      final nowStr = DateTime.now().toIso8601String();

      const partsData = <_SeedPart>[
        _SeedPart(
          partNumber: '23100-K0W-N01',
          officialName: 'Drive V-Belt',
          description:
              'Double-cogged reinforced synthetic rubber V-belt for 160cc eSP+ CVT transmission.',
          category: 'CVT / Transmission',
          assemblyName: 'Drive Face / Driven Pulley',
          diagramNumber: 'E-17',
          referenceNumber: 3,
          standardQuantity: 1,
          remarks:
              'Genuine Honda / Bando OEM drive belt. Replacement interval: 24,000 km.',
          maintenanceItemName: 'Drive Belt',
        ),
        _SeedPart(
          partNumber: '22123-K0W-N00',
          officialName: 'Roller Set, Weight (19.0g)',
          description:
              'Set of 6 OEM movable drive face weight rollers (19.0g standard).',
          category: 'CVT / Transmission',
          assemblyName: 'Movable Drive Face',
          diagramNumber: 'E-17',
          referenceNumber: 5,
          standardQuantity: 6,
          remarks:
              'Standard 19.0g weights for smooth low-vibration factory power delivery.',
          maintenanceItemName: 'Drive Belt',
        ),
        _SeedPart(
          partNumber: '22011-K0W-N00',
          officialName: 'Piece Set, Slide',
          description:
              '3-piece composite slide damper guides for primary ramp plate.',
          category: 'CVT / Transmission',
          assemblyName: 'Drive Face Ramp Plate',
          diagramNumber: 'E-17',
          referenceNumber: 1,
          standardQuantity: 3,
          remarks:
              'Inspect for free play or wear during belt or roller service.',
          maintenanceItemName: 'Drive Belt',
        ),
        _SeedPart(
          partNumber: '22110-K0W-N00',
          officialName: 'Face Comp., Movable Drive',
          description:
              'Primary sliding aluminum pulley half with machined roller ramps.',
          category: 'CVT / Transmission',
          assemblyName: 'Movable Drive Face',
          diagramNumber: 'E-17',
          referenceNumber: 2,
          standardQuantity: 1,
          remarks: '15-degree standard pulley face angle for eSP+ engine.',
          maintenanceItemName: 'Drive Belt',
        ),
        _SeedPart(
          partNumber: '22535-K0W-N00',
          officialName: 'Weight Set, Clutch',
          description:
              '3-shoe centrifugal clutch assembly with organic friction lining.',
          category: 'CVT / Transmission',
          assemblyName: 'Driven Pulley Clutch',
          diagramNumber: 'E-17',
          referenceNumber: 11,
          standardQuantity: 1,
          remarks: 'Service limit: 2.0 mm clutch lining thickness.',
          maintenanceItemName: 'Clutch Shoes Wear',
        ),
        _SeedPart(
          partNumber: '17210-K0W-N00',
          officialName: 'Element Comp., Air Cleaner',
          description:
              'Viscous paper element air cleaner cartridge with rubber seal.',
          category: 'Fuel System',
          assemblyName: 'Air Cleaner Case',
          diagramNumber: 'E-19',
          referenceNumber: 2,
          standardQuantity: 1,
          remarks:
              'Viscous type; replace every 18,000 km (do not clean with compressed air).',
          maintenanceItemName: 'Air Cleaner',
        ),
        _SeedPart(
          partNumber: '31917-K0R-V01',
          officialName: 'Spark Plug (NGK LMAR8L-9)',
          description: 'Standard NGK 10mm long-reach resistor spark plug.',
          category: 'Engine',
          assemblyName: 'Cylinder Head',
          diagramNumber: 'E-02',
          referenceNumber: 4,
          standardQuantity: 1,
          remarks: 'Gap: 0.80–0.90 mm. Replacement interval: 12,000 km.',
          maintenanceItemName: 'Spark Plug',
        ),
        _SeedPart(
          partNumber: '06455-KRE-G01',
          officialName: 'Pad Set, Front (Nissin)',
          description: 'Genuine front disc brake pads with factory heat shims.',
          category: 'Braking System',
          assemblyName: 'Front Brake Caliper',
          diagramNumber: 'F-11',
          referenceNumber: 1,
          standardQuantity: 1,
          remarks: 'Replace when wear indicator groove is flush.',
          maintenanceItemName: 'Brake Pads Wear',
        ),
        _SeedPart(
          partNumber: '06435-K0W-N01',
          officialName: 'Pad Set, Rear (Nissin)',
          description:
              'Genuine rear hydraulic disc brake pad set with backing insulators.',
          category: 'Braking System',
          assemblyName: 'Rear Brake Caliper',
          diagramNumber: 'F-12',
          referenceNumber: 1,
          standardQuantity: 1,
          remarks: 'Replace when wear indicator groove is flush.',
          maintenanceItemName: 'Brake Pads Wear',
        ),
        _SeedPart(
          partNumber: '45351-K0W-N01',
          officialName: 'Disk, Front Brake (240mm)',
          description:
              '240mm wavy stainless steel front brake rotor for ABS sensor.',
          category: 'Braking System',
          assemblyName: 'Front Wheel',
          diagramNumber: 'F-10',
          referenceNumber: 2,
          standardQuantity: 1,
          remarks: 'Standard thickness: 3.5 mm. Service limit: 3.0 mm.',
          maintenanceItemName: 'Brake System',
        ),
        _SeedPart(
          partNumber: '43251-K0W-N01',
          officialName: 'Disk, Rear Brake (220mm)',
          description:
              '220mm hydraulic wavy brake rotor for rear wheel assembly.',
          category: 'Braking System',
          assemblyName: 'Rear Wheel',
          diagramNumber: 'F-13',
          referenceNumber: 3,
          standardQuantity: 1,
          remarks: 'Standard thickness: 4.0 mm. Service limit: 3.5 mm.',
          maintenanceItemName: 'Brake System',
        ),
        _SeedPart(
          partNumber: '15421-KPL-900',
          officialName: 'Screen, Oil Filter',
          description: 'Cylindrical stainless wire mesh oil strainer screen.',
          category: 'Engine',
          assemblyName: 'Oil Pump / Sump',
          diagramNumber: 'E-08',
          referenceNumber: 3,
          standardQuantity: 1,
          remarks: 'Clean every 12,000 km. Inspect mesh for metal particles.',
          maintenanceItemName: 'Engine Oil Strainer Screen',
        ),
        _SeedPart(
          partNumber: '91302-001-020',
          officialName: 'O-Ring (30.8mm)',
          description:
              'Nitrile sealing O-ring for engine oil strainer drain cap.',
          category: 'Engine',
          assemblyName: 'Oil Pump / Sump',
          diagramNumber: 'E-08',
          referenceNumber: 5,
          standardQuantity: 1,
          remarks: 'Replace if cracked, hardened, or leaking.',
          maintenanceItemName: 'Engine Oil Strainer Screen',
        ),
        _SeedPart(
          partNumber: '90495-MN5-000',
          officialName: 'Washer, Drain Plug (12mm)',
          description: '12mm aluminum crush gasket washer for oil drain bolt.',
          category: 'Engine',
          assemblyName: 'Crankcase',
          diagramNumber: 'E-14',
          referenceNumber: 8,
          standardQuantity: 1,
          remarks:
              'Replace at every engine oil change to maintain proper torque.',
          maintenanceItemName: 'Engine Oil',
        ),
        _SeedPart(
          partNumber: '08232-2MB-K1L',
          officialName: 'Honda 4T SL 10W-30 MB Scooter Oil (1.0L)',
          description:
              'Low-friction MB fully synthetic 4-stroke engine oil for dry-clutch scooters.',
          category: 'Engine',
          assemblyName: 'Engine Lubrication',
          diagramNumber: 'E-08',
          referenceNumber: 1,
          standardQuantity: 1,
          remarks: 'Drain capacity: 0.8 L. Disassembly capacity: 0.9 L.',
          maintenanceItemName: 'Engine Oil',
        ),
        _SeedPart(
          partNumber: '08268-P99-01S8',
          officialName: 'Honda Scooter Gear Oil (120ml)',
          description:
              'Special transmission fluid for final drive reduction gearbox.',
          category: 'CVT / Transmission',
          assemblyName: 'Transmission Case',
          diagramNumber: 'E-18',
          referenceNumber: 1,
          standardQuantity: 1,
          remarks: 'Drain capacity: 120 ml. Disassembly capacity: 140 ml.',
          maintenanceItemName: 'Final Drive Oil',
        ),
        _SeedPart(
          partNumber: '08CLA-G01-W20',
          officialName: 'Honda Long Life Coolant Pre-Mix (1.0L)',
          description:
              '50/50 pre-diluted ethylene glycol corrosion-inhibiting coolant.',
          category: 'Cooling System',
          assemblyName: 'Radiator & Water Pump',
          diagramNumber: 'E-12',
          referenceNumber: 1,
          standardQuantity: 1,
          remarks: 'Reserve tank: 0.17 L. Radiator and engine: 0.54 L.',
          maintenanceItemName: 'Radiator Coolant',
        ),
        _SeedPart(
          partNumber: '31500-K0W-N01',
          officialName: 'Battery (YTZ6V / 12V 5.0Ah)',
          description:
              'Valve-regulated lead-acid (VRLA / AGM) sealed maintenance-free battery.',
          category: 'Electrical / Battery',
          assemblyName: 'Battery Box',
          diagramNumber: 'F-30',
          referenceNumber: 1,
          standardQuantity: 1,
          remarks:
              'Fully charged: 12.8V. Replace when resting voltage < 12.3V.',
          maintenanceItemName: 'Battery',
        ),
        _SeedPart(
          partNumber: '44711-K0W-N01',
          officialName: 'Tire, Front (110/80-14 M/C 53P)',
          description: 'Tubeless dual-purpose tread tire (IRC GP-211).',
          category: 'Tires / Wheels',
          assemblyName: 'Front Wheel',
          diagramNumber: 'F-10',
          referenceNumber: 1,
          standardQuantity: 1,
          remarks: 'Recommended cold pressure: 200 kPa (29 psi).',
          maintenanceItemName: 'Wheels/Tyres',
        ),
        _SeedPart(
          partNumber: '42711-K0W-N01',
          officialName: 'Tire, Rear (130/70-13 M/C 57P)',
          description: 'Tubeless dual-purpose tread tire (IRC GP-212).',
          category: 'Tires / Wheels',
          assemblyName: 'Rear Wheel',
          diagramNumber: 'F-13',
          referenceNumber: 1,
          standardQuantity: 1,
          remarks:
              'Cold pressure: 225 kPa (33 psi) solo / 250 kPa (36 psi) with passenger.',
          maintenanceItemName: 'Wheels/Tyres',
        ),
      ];

      for (final p in partsData) {
        final existing = await (db.select(db.partsCatalog)
              ..where((t) => t.partNumber.equals(p.partNumber)))
            .getSingleOrNull();

        final int catalogId;
        if (existing == null) {
          catalogId = await db.into(db.partsCatalog).insert(
                PartsCatalogCompanion.insert(
                  partNumber: p.partNumber,
                  officialName: p.officialName,
                  description: Value(p.description),
                  category: p.category,
                  assemblyName: p.assemblyName,
                  diagramNumber: Value(p.diagramNumber),
                  referenceNumber: Value(p.referenceNumber),
                  standardQuantity: Value(p.standardQuantity),
                  remarks: Value(p.remarks),
                  maintenanceItemId: Value(
                    p.maintenanceItemName != null
                        ? itemMap[p.maintenanceItemName]
                        : null,
                  ),
                  createdAt: nowStr,
                ),
              );
        } else {
          catalogId = existing.id;
        }

        // Add compatibility record
        final existingCompat = await (db.select(db.partsCatalogCompatibility)
              ..where((t) =>
                  t.partsCatalogId.equals(catalogId) &
                  t.modelCode.equals(sourceModelCode)))
            .getSingleOrNull();

        if (existingCompat == null) {
          await db.into(db.partsCatalogCompatibility).insert(
                PartsCatalogCompatibilityCompanion.insert(
                  partsCatalogId: catalogId,
                  modelName: sourceModel,
                  modelCode: sourceModelCode,
                  startYear: 2022,
                  endYear: const Value(2026),
                  regionalVariant: regionalVariant,
                  notes: const Value(
                    'Verified OEM fitment for 2023 Honda ADV 160 (Philippine release)',
                  ),
                ),
              );
        }
      }
    });
  }
}

class _SeedPart {
  const _SeedPart({
    required this.partNumber,
    required this.officialName,
    required this.description,
    required this.category,
    required this.assemblyName,
    this.diagramNumber,
    this.referenceNumber,
    this.standardQuantity = 1,
    this.remarks,
    this.maintenanceItemName,
  });

  final String partNumber;
  final String officialName;
  final String description;
  final String category;
  final String assemblyName;
  final String? diagramNumber;
  final int? referenceNumber;
  final int standardQuantity;
  final String? remarks;
  final String? maintenanceItemName;
}
