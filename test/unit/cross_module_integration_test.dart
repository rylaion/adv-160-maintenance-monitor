import 'package:adv_mon/core/database/app_database.dart';
import 'package:adv_mon/core/database/seed/honda_parts_seed.dart';
import 'package:adv_mon/core/database/seed/honda_schedule_seed.dart';
import 'package:adv_mon/core/database/seed/initial_seed.dart';
import 'package:adv_mon/core/enums/enums.dart';
import 'package:adv_mon/features/cvt/data/cvt_repository.dart';
import 'package:adv_mon/features/cvt/domain/cvt_models.dart';
import 'package:adv_mon/features/maintenance/data/maintenance_repository.dart';
import 'package:adv_mon/features/odometer/data/odometer_repository.dart';
import 'package:adv_mon/features/parts/domain/part_models.dart';
import 'package:adv_mon/features/parts_catalog/data/parts_catalog_repository.dart';
import 'package:adv_mon/features/trips/data/trips_repository.dart';
import 'package:adv_mon/features/trips/domain/trip_models.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late OdometerRepository odoRepo;
  late TripsRepository tripsRepo;
  late CvtRepository cvtRepo;
  late PartsCatalogRepository catalogRepo;
  late MaintenanceRepository maintenanceRepo;

  DateTime fixedClock() => DateTime.utc(2026, 11, 10, 10, 0);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    odoRepo = OdometerRepository(db);
    tripsRepo = TripsRepository(db, odoRepo, clock: fixedClock);
    cvtRepo = CvtRepository(db, clock: fixedClock);
    catalogRepo = PartsCatalogRepository(db);
    maintenanceRepo = MaintenanceRepository(db, odoRepo, clock: fixedClock);

    await InitialSeed(db).run();
    await HondaScheduleSeed(db).run();
    await HondaPartsSeed(db).run();
  });

  tearDown(() => db.close());

  group('Cross-Module Integration (Phase 4)', () {
    test(
        'Complete End-to-End Workflow: Trip -> Odometer Update -> OEM Catalog Lookup -> Maintenance Replacement -> CVT Configuration Sync',
        () async {
      // 1. Initial baseline odometer at 10,000 km
      await odoRepo.insert(
        motorcycleId: 1,
        readingKm: 10000,
        date: DateTime.utc(2026, 11, 1),
        notes: 'Initial confirmed odometer',
        createdAt: fixedClock(),
      );

      var latestOdo = await odoRepo.latestConfirmed(1);
      expect(latestOdo?.readingKm, 10000);

      // 2. Active CVT configuration initially installed at 10,000 km
      final cvtId = await cvtRepo.saveConfiguration(
        NewCvtConfigurationInput(
          motorcycleId: 1,
          name: 'Weekend Touring Setup',
          flyballWeightGrams: 17.0,
          centerSpringRpm: 1200,
          beltBrandPartNumber: '23100-K0W-N01',
          installedDate: DateTime.utc(2026, 11, 1),
          installedOdometerKm: 10000,
          isActive: true,
        ),
      );

      final initialCvt = await cvtRepo.getActiveConfiguration(1);
      expect(initialCvt?.id, cvtId);
      expect(initialCvt?.installedOdometerKm, 10000);

      // 3. Step 1: User logs a 250 km trip from 10,000 km to 10,250 km
      final tripId = await tripsRepo.saveTrip(
        NewTripInput(
          motorcycleId: 1,
          title: 'Marilaque Highway Ride',
          category: TripCategory.leisure,
          origin: 'Marikina',
          destination: 'Infanta',
          startOdometerKm: 10000,
          endOdometerKm: 10250,
          distanceKm: 250.0,
          startTime: DateTime.utc(2026, 11, 10, 6, 0),
          endTime: DateTime.utc(2026, 11, 10, 11, 30),
          durationSeconds: 19800,
          avgSpeedKmh: 45.5,
          maxSpeedKmh: 92.0,
        ),
      );
      expect(tripId, greaterThan(0));

      // Verify odometer progressed to 10,250 km
      latestOdo = await odoRepo.latestConfirmed(1);
      expect(latestOdo?.readingKm, 10250,
          reason: 'Odometer should have updated from trip ending odometer');

      // 4. Step 2: User opens Parts Catalogue to find genuine Drive V-Belt
      final searchResults = await catalogRepo.watchParts(query: 'BELT').first;
      expect(searchResults.isNotEmpty, isTrue);

      final oemBelt =
          searchResults.firstWhere((p) => p.partNumber == '23100-K1Z-N21');
      expect(oemBelt.officialName, 'BELT, DRIVE');
      expect(oemBelt.diagramNumber, 'E-17');
      expect(oemBelt.referenceNumber, 7);
      expect(oemBelt.maintenanceItemId, isNotNull);

      // 5. Step 3: User records replacement using the OEM Part info
      final driveBeltItemId = oemBelt.maintenanceItemId!;
      final recordId = await maintenanceRepo.addRecord(
        NewMaintenanceRecord(
          motorcycleId: 1,
          itemId: driveBeltItemId,
          action: MaintenanceAction.replacement,
          date: DateTime.utc(2026, 11, 10),
          odometerKm: 10250,
          laborCostCentavos: 35000, // ₱350
          totalCostCentavos: 125000, // ₱1,250
          serviceProvider: 'Honda Desmark Service Center',
          notes:
              'Replaced with genuine Honda OEM ${oemBelt.officialName} (${oemBelt.partNumber})',
          parts: [
            RecordPartInput(
              name: oemBelt.officialName,
              brand: 'Honda Genuine OEM',
              partNumber: oemBelt.partNumber,
              specification: 'Double-cogged synthetic V-belt',
              quantity: 1,
              unitCostCentavos: 90000,
              trackInstallation: true,
            ),
          ],
        ),
      );
      expect(recordId, greaterThan(0));

      // 6. Step 4: Verify maintenance record and part installation lifecycle
      final history = await maintenanceRepo.loadHistory();
      final savedRecord = history.firstWhere((r) => r.id == recordId);
      expect(savedRecord.action, MaintenanceAction.replacement);
      expect(savedRecord.odometerKm, 10250);
      expect(savedRecord.parts.length, 1);
      expect(savedRecord.parts.first.part.partNumber, '23100-K1Z-N21');

      // 7. Step 5: Active CVT setup synchronization
      await cvtRepo.updateConfiguration(
        id: initialCvt!.id,
        name: initialCvt.name,
        flyballWeightGrams: initialCvt.flyballWeightGrams,
        centerSpringRpm: initialCvt.centerSpringRpm,
        beltBrandPartNumber: oemBelt.partNumber,
        installedDate: DateTime.utc(2026, 11, 10),
        installedOdometerKm: 10250,
        notes: 'Drive belt replaced with genuine Honda OEM at 10,250 km',
      );

      final updatedCvt = await cvtRepo.getActiveConfiguration(1);
      expect(updatedCvt!.installedOdometerKm, 10250,
          reason:
              'CVT installed odometer should now reflect the service at 10,250 km');
      expect(updatedCvt.beltBrandPartNumber, '23100-K1Z-N21');
      expect(updatedCvt.notes, contains('replaced with genuine Honda OEM'));
    });
  });
}
