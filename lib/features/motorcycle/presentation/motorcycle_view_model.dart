import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../shared/providers/providers.dart';
import '../domain/motorcycle.dart';

/// Live primary motorcycle.
final primaryMotorcycleProvider = StreamProvider<Motorcycle?>(
  (ref) => ref.watch(motorcycleRepositoryProvider).watchPrimary(),
);

/// ViewModel for editing the motorcycle profile.
class MotorcycleEditViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Saves the profile. Errors are surfaced through [state].
  Future<bool> save(Motorcycle updated) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(motorcycleRepositoryProvider).update(updated),
    );
    return !state.hasError;
  }

  /// Copies a picked photo into app storage and returns the stored path.
  Future<String> storePhoto(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final photos = Directory(p.join(dir.path, 'photos'));
    await photos.create(recursive: true);
    final dest = p.join(photos.path,
        'motorcycle_${DateTime.now().millisecondsSinceEpoch}${p.extension(sourcePath)}');
    await File(sourcePath).copy(dest);
    return dest;
  }
}

final motorcycleEditViewModelProvider =
    AsyncNotifierProvider<MotorcycleEditViewModel, void>(
        MotorcycleEditViewModel.new);
