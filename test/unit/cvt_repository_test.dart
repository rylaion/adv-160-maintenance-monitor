import 'package:adv_mon/core/database/app_database.dart';
import 'package:adv_mon/features/cvt/data/cvt_repository.dart';
import 'package:adv_mon/features/cvt/domain/cvt_models.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late CvtRepository cvtRepo;
  DateTime fixedClock() => DateTime.utc(2026, 11, 10, 10, 0);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    cvtRepo = CvtRepository(db, clock: fixedClock);

    // Seed primary motorcycle
    await db.into(db.motorcycles).insert(
          MotorcyclesCompanion.insert(
            brand: 'Honda',
            model: 'ADV 160',
            modelYear: 2023,
            createdAt: fixedClock().toIso8601String(),
            updatedAt: fixedClock().toIso8601String(),
          ),
        );
  });

  tearDown(() => db.close());

  group('CVT Configuration Manager (Phase 2)', () {
    test('Save CVT configuration with full specifications', () async {
      final configId = await cvtRepo.saveConfiguration(
        NewCvtConfigurationInput(
          motorcycleId: 1,
          name: 'OEM Stock ADV 160',
          pulleyBrandModel: 'Honda OEM K0W 15°',
          flyballWeightGrams: 19.0,
          flyballArrangement: 'Straight 6x 19.0g',
          centerSpringRpm: 1000,
          clutchSpringRpm: 1000,
          beltBrandPartNumber: '23100-K0W-N01 Bando',
          pulleyWasherThicknessMm: 0.5,
          clutchBellSpec: 'Honda OEM Stock',
          exhaustSpec: 'Honda OEM Stock',
          installedDate: DateTime.utc(2026, 11, 1),
          installedOdometerKm: 5000,
          isActive: true,
          notes: 'Standard OEM factory transmission baseline',
        ),
      );

      expect(configId, greaterThan(0));

      final config = await cvtRepo.getConfigurationById(configId);
      expect(config, isNotNull);
      expect(config!.name, 'OEM Stock ADV 160');
      expect(config.flyballWeightGrams, 19.0);
      expect(config.centerSpringRpm, 1000);
      expect(config.beltBrandPartNumber, '23100-K0W-N01 Bando');
      expect(config.pulleyWasherThicknessMm, 0.5);
      expect(config.isActive, isTrue);
    });

    test('Empty name throws CvtException', () async {
      expect(
        () => cvtRepo.saveConfiguration(
          NewCvtConfigurationInput(
            motorcycleId: 1,
            name: '   ',
            installedDate: DateTime.utc(2026, 11, 1),
          ),
        ),
        throwsA(isA<CvtException>()),
      );
    });

    test(
        'Setting new configuration as active deactivates previous active configuration',
        () async {
      final config1Id = await cvtRepo.saveConfiguration(
        NewCvtConfigurationInput(
          motorcycleId: 1,
          name: 'Setup 1',
          flyballWeightGrams: 19.0,
          installedDate: DateTime.utc(2026, 10, 1),
          isActive: true,
        ),
      );

      final config2Id = await cvtRepo.saveConfiguration(
        NewCvtConfigurationInput(
          motorcycleId: 1,
          name: 'Setup 2 (Touring)',
          flyballWeightGrams: 17.0,
          centerSpringRpm: 1200,
          installedDate: DateTime.utc(2026, 11, 1),
          isActive: true,
        ),
      );

      final c1 = await cvtRepo.getConfigurationById(config1Id);
      final c2 = await cvtRepo.getConfigurationById(config2Id);

      expect(c1!.isActive, isFalse,
          reason: 'Setup 1 should have been deactivated');
      expect(c2!.isActive, isTrue, reason: 'Setup 2 should now be active');

      final active = await cvtRepo.getActiveConfiguration(1);
      expect(active?.id, config2Id);
      expect(active?.name, 'Setup 2 (Touring)');
    });

    test('Duplicate configuration clones parameters with (Copy) name',
        () async {
      final origId = await cvtRepo.saveConfiguration(
        NewCvtConfigurationInput(
          motorcycleId: 1,
          name: 'City Commute 15g',
          flyballWeightGrams: 15.0,
          flyballArrangement: 'Straight 6x 15g',
          centerSpringRpm: 1500,
          clutchSpringRpm: 1000,
          beltBrandPartNumber: '23100-K0W-N01',
          pulleyWasherThicknessMm: 1.0,
          installedDate: DateTime.utc(2026, 11, 5),
          installedOdometerKm: 8200,
          isActive: true,
          notes: 'High responsiveness for stop-and-go traffic',
        ),
      );

      final cloneId = await cvtRepo.duplicateConfiguration(origId);
      final clone = await cvtRepo.getConfigurationById(cloneId);

      expect(clone, isNotNull);
      expect(clone!.name, 'City Commute 15g (Copy)');
      expect(clone.flyballWeightGrams, 15.0);
      expect(clone.centerSpringRpm, 1500);
      expect(clone.pulleyWasherThicknessMm, 1.0);
      expect(clone.isActive, isFalse,
          reason: 'Cloned setup should start inactive');
    });

    test('Update configuration modifies specifications correctly', () async {
      final configId = await cvtRepo.saveConfiguration(
        NewCvtConfigurationInput(
          motorcycleId: 1,
          name: 'Initial Setup',
          flyballWeightGrams: 18.0,
          installedDate: DateTime.utc(2026, 11, 1),
        ),
      );

      await cvtRepo.updateConfiguration(
        id: configId,
        name: 'Revised Setup',
        flyballWeightGrams: 16.0,
        centerSpringRpm: 1200,
        pulleyWasherThicknessMm: 0.8,
        installedDate: DateTime.utc(2026, 11, 8),
        installedOdometerKm: 9500,
        notes: 'Adjusted washer to 0.8mm',
      );

      final updated = await cvtRepo.getConfigurationById(configId);
      expect(updated!.name, 'Revised Setup');
      expect(updated.flyballWeightGrams, 16.0);
      expect(updated.centerSpringRpm, 1200);
      expect(updated.pulleyWasherThicknessMm, 0.8);
      expect(updated.notes, 'Adjusted washer to 0.8mm');
    });

    test('Add, list, and delete performance logs for a configuration',
        () async {
      final configId = await cvtRepo.saveConfiguration(
        NewCvtConfigurationInput(
          motorcycleId: 1,
          name: 'Highway Tune',
          flyballWeightGrams: 17.0,
          installedDate: DateTime.utc(2026, 11, 1),
        ),
      );

      final logId = await cvtRepo.addPerformanceLog(
        NewCvtPerformanceLogInput(
          configurationId: configId,
          logDate: DateTime.utc(2026, 11, 5),
          accelerationRating: 5,
          topSpeedKmh: 118.5,
          rpmObserved: 8200,
          fuelConsumptionKpl: 42.5,
          vibrationRating: 2,
          comfortRating: 4,
          overallAssessment:
              'Excellent high-speed cruising, smooth power delivery',
          isMeasured: true,
        ),
      );

      expect(logId, greaterThan(0));

      final configWithLogs = await cvtRepo.getConfigurationById(configId);
      expect(configWithLogs!.performanceLogs.length, 1);
      final log = configWithLogs.performanceLogs.first;
      expect(log.accelerationRating, 5);
      expect(log.topSpeedKmh, 118.5);
      expect(log.isMeasured, isTrue);
      expect(log.overallAssessment, contains('cruising'));

      // Delete log
      await cvtRepo.deletePerformanceLog(logId);
      final configAfterDelete = await cvtRepo.getConfigurationById(configId);
      expect(configAfterDelete!.performanceLogs.isEmpty, isTrue);
    });

    test(
        'Delete configuration removes configuration and associated performance logs',
        () async {
      final configId = await cvtRepo.saveConfiguration(
        NewCvtConfigurationInput(
          motorcycleId: 1,
          name: 'Temporary Experiment',
          flyballWeightGrams: 13.0,
          installedDate: DateTime.utc(2026, 11, 1),
        ),
      );

      await cvtRepo.addPerformanceLog(
        NewCvtPerformanceLogInput(
          configurationId: configId,
          logDate: DateTime.utc(2026, 11, 2),
          accelerationRating: 5,
          vibrationRating: 4,
          overallAssessment: 'Too much RPM, high fuel consumption',
        ),
      );

      await cvtRepo.deleteConfiguration(configId);

      final config = await cvtRepo.getConfigurationById(configId);
      expect(config, isNull);
    });
  });
}
