import 'package:adv_mon/core/database/app_database.dart';
import 'package:adv_mon/features/odometer/data/odometer_repository.dart';
import 'package:adv_mon/features/trips/data/trips_repository.dart';
import 'package:adv_mon/features/trips/domain/trip_models.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late OdometerRepository odoRepo;
  late TripsRepository tripsRepo;
  DateTime fixedClock() => DateTime.utc(2026, 11, 10, 10, 0);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    odoRepo = OdometerRepository(db);
    tripsRepo = TripsRepository(db, odoRepo, clock: fixedClock);

    // Seed a motorcycle
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

  group('Ride History and Trip Logger (Phase 1)', () {
    test('Manual trip entry saves trip and updates odometer correctly',
        () async {
      // 1. Initial confirmed odometer at 10,000 km
      await odoRepo.insert(
        motorcycleId: 1,
        readingKm: 10000,
        date: DateTime.utc(2026, 11, 9),
        notes: 'Initial odometer',
        createdAt: fixedClock(),
      );

      final initialOdo = await odoRepo.latestConfirmed(1);
      expect(initialOdo?.readingKm, 10000);

      // 2. Save a manual trip from 10,000 km to 10,085 km (85 km)
      final tripId = await tripsRepo.saveTrip(
        NewTripInput(
          motorcycleId: 1,
          title: 'Marilaque Sunday Ride',
          category: TripCategory.leisure,
          origin: 'Marikina',
          destination: 'Infanta',
          startOdometerKm: 10000,
          endOdometerKm: 10085,
          distanceKm: 85.0,
          startTime: DateTime.utc(2026, 11, 10, 6, 0),
          endTime: DateTime.utc(2026, 11, 10, 9, 0),
          durationSeconds: 10800,
          avgSpeedKmh: 28.3,
          maxSpeedKmh: 75.0,
          isGpsTracked: false,
          notes: 'Smooth curves, tested throttle response.',
        ),
      );

      expect(tripId, isPositive);

      // 3. Verify trip record retrieval
      final savedTrip = await tripsRepo.getTripById(tripId);
      expect(savedTrip, isNotNull);
      expect(savedTrip!.title, 'Marilaque Sunday Ride');
      expect(savedTrip.category, TripCategory.leisure);
      expect(savedTrip.distanceKm, 85.0);

      // 4. Verify Odometer Integration (ending odometer updated to 10,085 km)
      final updatedOdo = await odoRepo.latestConfirmed(1);
      expect(updatedOdo?.readingKm, 10085);
      expect(updatedOdo?.notes,
          contains('Recorded from trip: Marilaque Sunday Ride'));

      // 5. Verify stats calculation
      final stats = await tripsRepo.getStats(1);
      expect(stats.totalTrips, 1);
      expect(stats.totalDistanceKm, 85.0);
      expect(stats.longestDistanceKm, 85.0);
      expect(stats.avgDistanceKm, 85.0);
      expect(stats.monthlyDistanceKm, 85.0);
    });

    test(
        'Odometer is NOT downgraded if trip ending odometer is less than latest confirmed',
        () async {
      // 1. Initial confirmed odometer at 15,000 km
      await odoRepo.insert(
        motorcycleId: 1,
        readingKm: 15000,
        date: DateTime.utc(2026, 11, 10),
        notes: 'Confirmed 15k',
        createdAt: fixedClock(),
      );

      // 2. Log a backdated or short trip with end odometer 14,500 km
      await tripsRepo.saveTrip(
        NewTripInput(
          motorcycleId: 1,
          title: 'Past Commute',
          category: TripCategory.commute,
          startOdometerKm: 14450,
          endOdometerKm: 14500,
          distanceKm: 50.0,
          startTime: DateTime.utc(2026, 11, 1, 8, 0),
          endTime: DateTime.utc(2026, 11, 1, 9, 30),
          durationSeconds: 5400,
        ),
      );

      // 3. Odometer must remain at 15,000 km (never reduced)
      final currentOdo = await odoRepo.latestConfirmed(1);
      expect(currentOdo?.readingKm, 15000);
    });

    test('GPS waypoints are saved and linked to trip', () async {
      final tripId = await tripsRepo.saveTrip(
        NewTripInput(
          motorcycleId: 1,
          title: 'Live GPS Commute',
          category: TripCategory.commute,
          distanceKm: 12.4,
          startTime: DateTime.utc(2026, 11, 10, 7, 0),
          endTime: DateTime.utc(2026, 11, 10, 7, 35),
          durationSeconds: 2100,
          isGpsTracked: true,
          waypoints: [
            TripWaypointItem(
              latitude: 14.5995,
              longitude: 120.9842,
              speedKmh: 35.0,
              recordedAt: DateTime.utc(2026, 11, 10, 7, 5),
              sequence: 0,
            ),
            TripWaypointItem(
              latitude: 14.6050,
              longitude: 120.9900,
              speedKmh: 42.0,
              recordedAt: DateTime.utc(2026, 11, 10, 7, 10),
              sequence: 1,
            ),
          ],
        ),
      );

      final trip = await tripsRepo.getTripById(tripId);
      expect(trip, isNotNull);
      expect(trip!.isGpsTracked, isTrue);
      expect(trip.waypoints.length, 2);
      expect(trip.waypoints.first.latitude, 14.5995);
      expect(trip.waypoints.last.latitude, 14.6050);
    });

    test('Trip edit and delete operations function correctly', () async {
      final tripId = await tripsRepo.saveTrip(
        NewTripInput(
          motorcycleId: 1,
          title: 'Original Title',
          category: TripCategory.work,
          distanceKm: 25.0,
          startTime: DateTime.utc(2026, 11, 10, 10, 0),
          durationSeconds: 1800,
        ),
      );

      // Edit
      await tripsRepo.updateTrip(
        tripId: tripId,
        title: 'Updated Work Trip',
        category: TripCategory.touring,
        origin: 'Office',
        destination: 'Client Site',
        notes: 'Updated notes',
      );

      final updated = await tripsRepo.getTripById(tripId);
      expect(updated?.title, 'Updated Work Trip');
      expect(updated?.category, TripCategory.touring);
      expect(updated?.origin, 'Office');
      expect(updated?.destination, 'Client Site');

      // Delete
      await tripsRepo.deleteTrip(tripId);
      final deleted = await tripsRepo.getTripById(tripId);
      expect(deleted, isNull);
    });
  });
}
