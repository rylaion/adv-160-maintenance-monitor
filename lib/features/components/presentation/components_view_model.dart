import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/exceptions/user_facing_exception.dart';
import '../../../shared/providers/providers.dart';
import '../domain/component_models.dart';

/// Streams measurements for a given itemId (or all if null).
final componentMeasurementsProvider =
    StreamProvider.family<List<ComponentMeasurement>, int?>((ref, itemId) {
  return ref
      .watch(componentsRepositoryProvider)
      .watchMeasurements(itemId: itemId);
});

class ComponentsActions extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> addMeasurement(NewComponentMeasurement m) =>
      _run(() => ref.read(componentsRepositoryProvider).addMeasurement(m));

  Future<String?> addMeasurements(List<NewComponentMeasurement> list) =>
      _run(() => ref.read(componentsRepositoryProvider).addMeasurements(list));

  Future<String?> voidMeasurement(int id) =>
      _run(() => ref.read(componentsRepositoryProvider).voidMeasurement(id));

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

final componentsActionsProvider =
    AsyncNotifierProvider<ComponentsActions, void>(ComponentsActions.new);
