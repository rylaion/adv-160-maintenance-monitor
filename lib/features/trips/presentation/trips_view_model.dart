import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/providers.dart';
import '../../maintenance/presentation/maintenance_view_model.dart';
import '../../motorcycle/presentation/motorcycle_view_model.dart';
import '../data/gps_tracking_service.dart';
import '../data/trips_repository.dart';
import '../domain/trip_models.dart';

final tripsRepositoryProvider = Provider<TripsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final odoRepo = ref.watch(odometerRepositoryProvider);
  final clock = ref.watch(clockProvider);
  return TripsRepository(db, odoRepo, clock: clock);
});

final gpsTrackingServiceProvider = Provider<GpsTrackingService>((ref) {
  final clock = ref.watch(clockProvider);
  final service = GpsTrackingService(clock: clock);
  ref.onDispose(() => service.dispose());
  return service;
});

final liveGpsTrackingProvider = StreamProvider<GpsTrackingSnapshot>((ref) {
  final service = ref.watch(gpsTrackingServiceProvider);
  return service.snapshotStream;
});

final tripsListProvider = StreamProvider<List<TripDetail>>((ref) {
  final bike = ref.watch(primaryMotorcycleProvider).valueOrNull;
  if (bike == null) return const Stream.empty();
  return ref.watch(tripsRepositoryProvider).watchTrips(bike.id);
});

final tripStatsProvider = FutureProvider<TripStats>((ref) async {
  final bike = await ref.watch(primaryMotorcycleProvider.future);
  if (bike == null) {
    return const TripStats(
      totalDistanceKm: 0,
      totalTrips: 0,
      avgDistanceKm: 0,
      longestDistanceKm: 0,
      monthlyDistanceKm: 0,
    );
  }
  return ref.watch(tripsRepositoryProvider).getStats(bike.id);
});

final recentTripsProvider = FutureProvider<List<TripDetail>>((ref) async {
  final bike = await ref.watch(primaryMotorcycleProvider.future);
  if (bike == null) return const [];
  return ref.watch(tripsRepositoryProvider).getRecentTrips(bike.id, limit: 5);
});

class TripActionsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> saveTrip(NewTripInput input) async {
    state = const AsyncLoading();
    try {
      await ref.read(tripsRepositoryProvider).saveTrip(input);
      ref.invalidate(tripsListProvider);
      ref.invalidate(tripStatsProvider);
      ref.invalidate(recentTripsProvider);
      ref.invalidate(primaryMotorcycleProvider);
      ref.invalidate(maintenanceOverviewProvider);
      state = const AsyncData(null);
      return null;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return e.toString();
    }
  }

  Future<String?> updateTrip({
    required int tripId,
    required String title,
    required TripCategory category,
    String? origin,
    String? destination,
    String? notes,
    List<String> photoPaths = const [],
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(tripsRepositoryProvider).updateTrip(
            tripId: tripId,
            title: title,
            category: category,
            origin: origin,
            destination: destination,
            notes: notes,
            photoPaths: photoPaths,
          );
      ref.invalidate(tripsListProvider);
      ref.invalidate(recentTripsProvider);
      state = const AsyncData(null);
      return null;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return e.toString();
    }
  }

  Future<String?> deleteTrip(int tripId) async {
    state = const AsyncLoading();
    try {
      await ref.read(tripsRepositoryProvider).deleteTrip(tripId);
      ref.invalidate(tripsListProvider);
      ref.invalidate(tripStatsProvider);
      ref.invalidate(recentTripsProvider);
      state = const AsyncData(null);
      return null;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return e.toString();
    }
  }
}

final tripActionsProvider =
    AsyncNotifierProvider<TripActionsNotifier, void>(TripActionsNotifier.new);
