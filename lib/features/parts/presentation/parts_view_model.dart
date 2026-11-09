import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/exceptions/user_facing_exception.dart';
import '../../../shared/providers/providers.dart';
import '../../motorcycle/presentation/motorcycle_view_model.dart';
import '../domain/part_models.dart';

final partsListProvider = StreamProvider<List<PartInfo>>((ref) {
  return ref.watch(partsRepositoryProvider).watchParts();
});

final installationsProvider =
    StreamProvider.family<List<InstallationInfo>, int?>((ref, itemId) {
  return ref.watch(partsRepositoryProvider).watchInstallations(itemId: itemId);
});

class PartsActions extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> addPart({
    required NewPart part,
    DateTime? installDate,
    int? installOdometerKm,
    String? position,
    String? installNotes,
  }) {
    return _run(() async {
      final repo = ref.read(partsRepositoryProvider);
      final partId = await repo.addPart(part);
      if (installDate != null && installOdometerKm != null) {
        final bike = await ref.read(primaryMotorcycleProvider.future);
        if (bike == null) throw const PartsException('No motorcycle found.');
        await repo.install(
          partId: partId,
          motorcycleId: bike.id,
          date: installDate,
          odometerKm: installOdometerKm,
          position: position,
          notes: installNotes,
        );
      }
    });
  }

  Future<String?> install({
    required int partId,
    required DateTime date,
    required int odometerKm,
    String? position,
    String? notes,
  }) {
    return _run(() async {
      final bike = await ref.read(primaryMotorcycleProvider.future);
      if (bike == null) throw const PartsException('No motorcycle found.');
      await ref.read(partsRepositoryProvider).install(
            partId: partId,
            motorcycleId: bike.id,
            date: date,
            odometerKm: odometerKm,
            position: position,
            notes: notes,
          );
    });
  }

  Future<String?> remove({
    required int installationId,
    required DateTime date,
    required int odometerKm,
  }) =>
      _run(() => ref.read(partsRepositoryProvider).remove(
            installationId: installationId,
            date: date,
            odometerKm: odometerKm,
          ));

  Future<String?> _run(Future<void> Function() body) async {
    state = const AsyncLoading();
    try {
      await body();
      state = const AsyncData(null);
      return null;
    } on UserFacingException catch (e) {
      state = const AsyncData(null);
      return e.message;
    } catch (e, st) {
      state = AsyncError(e, st);
      return 'Could not save: $e';
    }
  }
}

final partsActionsProvider =
    AsyncNotifierProvider<PartsActions, void>(PartsActions.new);
