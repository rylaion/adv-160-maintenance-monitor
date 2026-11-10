import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/offline_map_service.dart';
import '../domain/offline_map_models.dart';

final offlineMapServiceProvider = Provider<OfflineMapService>((ref) {
  final service = OfflineMapService();
  service.initialize();
  ref.onDispose(service.dispose);
  return service;
});

class OfflineMapsState {
  const OfflineMapsState({
    this.packages = const [],
    this.activePackageId,
    this.isLoading = false,
    this.totalStorageBytes = 0,
    this.errorMessage,
    this.successMessage,
  });

  final List<OfflineMapPackage> packages;
  final String? activePackageId;
  final bool isLoading;
  final int totalStorageBytes;
  final String? errorMessage;
  final String? successMessage;

  String get formattedTotalStorage {
    if (totalStorageBytes < 1024 * 1024) {
      return '${(totalStorageBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(totalStorageBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  OfflineMapsState copyWith({
    List<OfflineMapPackage>? packages,
    String? activePackageId,
    bool? isLoading,
    int? totalStorageBytes,
    String? errorMessage,
    String? successMessage,
  }) {
    return OfflineMapsState(
      packages: packages ?? this.packages,
      activePackageId: activePackageId ?? this.activePackageId,
      isLoading: isLoading ?? this.isLoading,
      totalStorageBytes: totalStorageBytes ?? this.totalStorageBytes,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class OfflineMapsViewModel extends StateNotifier<OfflineMapsState> {
  OfflineMapsViewModel(this._service) : super(const OfflineMapsState()) {
    refresh();
  }

  final OfflineMapService _service;

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _service.initialize();
    state = state.copyWith(
      packages: _service.packages,
      activePackageId: _service.activePackageId,
      totalStorageBytes: _service.getTotalStorageBytes(),
      isLoading: false,
    );
  }

  Future<void> setActivePackage(String? id) async {
    await _service.setActivePackage(id);
    state = state.copyWith(
      packages: _service.packages,
      activePackageId: _service.activePackageId,
      successMessage: id != null
          ? 'Offline map package activated.'
          : 'Offline map deactivated.',
    );
  }

  Future<void> importFromFilePicker() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mbtiles', 'pmtiles', 'sqlite'],
      );

      if (result != null && result.files.single.path != null) {
        state = state.copyWith(isLoading: true);
        final file = File(result.files.single.path!);
        final pkg = await _service.importMbTilesFile(file);
        await refresh();
        state = state.copyWith(
          successMessage:
              'Imported offline map: ${pkg.name} (${pkg.formattedSize})',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Import failed: $e',
      );
    }
  }

  Future<void> deletePackage(String id) async {
    state = state.copyWith(isLoading: true);
    await _service.deletePackage(id);
    await refresh();
    state = state.copyWith(
      successMessage: 'Offline map package removed.',
    );
  }
}

final offlineMapsViewModelProvider =
    StateNotifierProvider<OfflineMapsViewModel, OfflineMapsState>((ref) {
  final service = ref.watch(offlineMapServiceProvider);
  return OfflineMapsViewModel(service);
});
