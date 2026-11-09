import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/providers.dart';
import '../../motorcycle/presentation/motorcycle_view_model.dart';
import '../domain/odometer_log.dart';

/// Odometer history (including superseded entries) for the primary motorcycle.
final odometerLogsProvider = StreamProvider<List<OdometerLog>>((ref) async* {
  final bike = await ref.watch(primaryMotorcycleProvider.future);
  if (bike == null) {
    yield const [];
    return;
  }
  yield* ref.watch(odometerRepositoryProvider).watchLogs(bike.id);
});

/// Actions for the odometer screen. Business rules live in OdometerService.
class OdometerActions extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Returns an error message, or null on success.
  Future<String?> record(
      {required int readingKm, required DateTime date, String? notes}) {
    return _run(() async {
      final bike = await ref.read(primaryMotorcycleProvider.future);
      if (bike == null) throw const OdometerException('No motorcycle found.');
      await ref.read(odometerServiceProvider).record(
          motorcycleId: bike.id,
          readingKm: readingKm,
          date: date,
          notes: notes);
    });
  }

  Future<String?> correct(
      {required int logId, required int newReadingKm, required String reason}) {
    return _run(() => ref
        .read(odometerServiceProvider)
        .correct(logId: logId, newReadingKm: newReadingKm, reason: reason));
  }

  Future<String?> _run(Future<void> Function() body) async {
    state = const AsyncLoading();
    try {
      await body();
      state = const AsyncData(null);
      return null;
    } on OdometerException catch (e) {
      state = const AsyncData(null);
      return e.message;
    } catch (e, st) {
      state = AsyncError(e, st);
      return 'Could not save: $e';
    }
  }
}

final odometerActionsProvider =
    AsyncNotifierProvider<OdometerActions, void>(OdometerActions.new);
