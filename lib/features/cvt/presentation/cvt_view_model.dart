import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/providers.dart';
import '../../motorcycle/presentation/motorcycle_view_model.dart';
import '../data/cvt_repository.dart';
import '../domain/cvt_models.dart';

final cvtRepositoryProvider = Provider<CvtRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final clock = ref.watch(clockProvider);
  return CvtRepository(db, clock: clock);
});

final cvtConfigurationsProvider =
    StreamProvider<List<CvtConfigurationDetail>>((ref) {
  final bike = ref.watch(primaryMotorcycleProvider).valueOrNull;
  if (bike == null) return const Stream.empty();
  return ref.watch(cvtRepositoryProvider).watchConfigurations(bike.id);
});

final activeCvtConfigurationProvider =
    FutureProvider<CvtConfigurationDetail?>((ref) async {
  final bike = await ref.watch(primaryMotorcycleProvider.future);
  if (bike == null) return null;
  return ref.watch(cvtRepositoryProvider).getActiveConfiguration(bike.id);
});

class CvtActionsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> saveConfiguration(NewCvtConfigurationInput input) async {
    state = const AsyncLoading();
    try {
      await ref.read(cvtRepositoryProvider).saveConfiguration(input);
      ref.invalidate(cvtConfigurationsProvider);
      ref.invalidate(activeCvtConfigurationProvider);
      state = const AsyncData(null);
      return null;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return e.toString();
    }
  }

  Future<String?> updateConfiguration({
    required int id,
    required String name,
    String? pulleyBrandModel,
    double? flyballWeightGrams,
    String? flyballArrangement,
    int? centerSpringRpm,
    int? clutchSpringRpm,
    String? beltBrandPartNumber,
    double? pulleyWasherThicknessMm,
    String? clutchBellSpec,
    String? exhaustSpec,
    String? otherMods,
    required DateTime installedDate,
    int? installedOdometerKm,
    String? notes,
    List<String> photoPaths = const [],
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(cvtRepositoryProvider).updateConfiguration(
            id: id,
            name: name,
            pulleyBrandModel: pulleyBrandModel,
            flyballWeightGrams: flyballWeightGrams,
            flyballArrangement: flyballArrangement,
            centerSpringRpm: centerSpringRpm,
            clutchSpringRpm: clutchSpringRpm,
            beltBrandPartNumber: beltBrandPartNumber,
            pulleyWasherThicknessMm: pulleyWasherThicknessMm,
            clutchBellSpec: clutchBellSpec,
            exhaustSpec: exhaustSpec,
            otherMods: otherMods,
            installedDate: installedDate,
            installedOdometerKm: installedOdometerKm,
            notes: notes,
            photoPaths: photoPaths,
          );
      ref.invalidate(cvtConfigurationsProvider);
      ref.invalidate(activeCvtConfigurationProvider);
      state = const AsyncData(null);
      return null;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return e.toString();
    }
  }

  Future<String?> setActive(int id, int motorcycleId) async {
    state = const AsyncLoading();
    try {
      await ref.read(cvtRepositoryProvider).setActive(id, motorcycleId);
      ref.invalidate(cvtConfigurationsProvider);
      ref.invalidate(activeCvtConfigurationProvider);
      state = const AsyncData(null);
      return null;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return e.toString();
    }
  }

  Future<String?> setArchived(int id, bool archived) async {
    state = const AsyncLoading();
    try {
      await ref.read(cvtRepositoryProvider).setArchived(id, archived);
      ref.invalidate(cvtConfigurationsProvider);
      ref.invalidate(activeCvtConfigurationProvider);
      state = const AsyncData(null);
      return null;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return e.toString();
    }
  }

  Future<String?> duplicateConfiguration(int id) async {
    state = const AsyncLoading();
    try {
      await ref.read(cvtRepositoryProvider).duplicateConfiguration(id);
      ref.invalidate(cvtConfigurationsProvider);
      ref.invalidate(activeCvtConfigurationProvider);
      state = const AsyncData(null);
      return null;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return e.toString();
    }
  }

  Future<String?> deleteConfiguration(int id) async {
    state = const AsyncLoading();
    try {
      await ref.read(cvtRepositoryProvider).deleteConfiguration(id);
      ref.invalidate(cvtConfigurationsProvider);
      ref.invalidate(activeCvtConfigurationProvider);
      state = const AsyncData(null);
      return null;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return e.toString();
    }
  }

  Future<String?> addPerformanceLog(NewCvtPerformanceLogInput input) async {
    state = const AsyncLoading();
    try {
      await ref.read(cvtRepositoryProvider).addPerformanceLog(input);
      ref.invalidate(cvtConfigurationsProvider);
      ref.invalidate(activeCvtConfigurationProvider);
      state = const AsyncData(null);
      return null;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return e.toString();
    }
  }

  Future<String?> deletePerformanceLog(int logId) async {
    state = const AsyncLoading();
    try {
      await ref.read(cvtRepositoryProvider).deletePerformanceLog(logId);
      ref.invalidate(cvtConfigurationsProvider);
      ref.invalidate(activeCvtConfigurationProvider);
      state = const AsyncData(null);
      return null;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return e.toString();
    }
  }
}

final cvtActionsProvider =
    AsyncNotifierProvider<CvtActionsNotifier, void>(CvtActionsNotifier.new);
