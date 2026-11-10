import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../domain/offline_map_models.dart';
import 'mbtiles_reader.dart';

/// Result of validating a map tile source against OpenStreetMap Foundation policies.
class PolicyCheckResult {
  const PolicyCheckResult({
    required this.isAllowed,
    required this.reason,
  });

  final bool isAllowed;
  final String reason;
}

/// Service that manages offline map packages (MBTiles, PMTiles),
/// storage directories, active offline regions, and OSM policy compliance.
class OfflineMapService {
  OfflineMapService({
    Directory? storageDirOverride,
  }) : _storageDirOverride = storageDirOverride;

  final Directory? _storageDirOverride;
  final List<OfflineMapPackage> _packages = [];
  String? _activePackageId;
  MbTilesReader? _activeReader;

  List<OfflineMapPackage> get packages => List.unmodifiable(_packages);
  String? get activePackageId => _activePackageId;
  OfflineMapPackage? get activePackage {
    if (_activePackageId == null) return null;
    try {
      return _packages.firstWhere((p) => p.id == _activePackageId);
    } catch (_) {
      return null;
    }
  }

  /// Validates whether a tile download URL or source conforms to the OpenStreetMap
  /// Foundation Tile Usage Policy. Bulk downloads from public OSM servers are strictly blocked.
  PolicyCheckResult validateTileDownloadPolicy(String sourceUrl) {
    final uri = Uri.tryParse(sourceUrl.trim());
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return const PolicyCheckResult(
        isAllowed: false,
        reason: 'Invalid URL address provided.',
      );
    }

    final host = uri.host.toLowerCase();
    if (host.contains('tile.openstreetmap.org') ||
        host.contains('openstreetmap.org')) {
      return const PolicyCheckResult(
        isAllowed: false,
        reason:
            'OpenStreetMap Foundation Tile Usage Policy strictly prohibits bulk-downloading '
            'or scraping tiles from standard public tile servers. Please use an authorized '
            'offline map package, MBTiles archive, or a self-hosted tile infrastructure.',
      );
    }

    return const PolicyCheckResult(
      isAllowed: true,
      reason:
          'Source is authorized for offline synchronization (Self-hosted or third-party tile server).',
    );
  }

  /// Returns the local directory where offline map packages are stored.
  Future<Directory> getStorageDirectory() async {
    final override = _storageDirOverride;
    if (override != null) {
      if (!await override.exists()) {
        await override.create(recursive: true);
      }
      return override;
    }

    final appDocDir = await getApplicationDocumentsDirectory();
    final offlineDir = Directory(p.join(appDocDir.path, 'offline_maps'));
    if (!await offlineDir.exists()) {
      await offlineDir.create(recursive: true);
    }
    return offlineDir;
  }

  /// Initializes the service and loads all locally stored offline packages.
  Future<void> initialize() async {
    _packages.clear();
    final dir = await getStorageDirectory();
    final manifestFile = File(p.join(dir.path, 'manifest.json'));

    if (await manifestFile.exists()) {
      try {
        final content = await manifestFile.readAsString();
        final list = jsonDecode(content) as List<dynamic>;
        for (final item in list) {
          final map = item as Map<String, dynamic>;
          final pkgFile = File(map['filePath'] as String);
          if (await pkgFile.exists()) {
            _packages.add(
              OfflineMapPackage(
                id: map['id'] as String,
                name: map['name'] as String,
                description: map['description'] as String,
                format: OfflineMapFormat.values.firstWhere(
                  (f) => f.name == map['format'],
                  orElse: () => OfflineMapFormat.mbTiles,
                ),
                filePath: pkgFile.path,
                sizeBytes: await pkgFile.length(),
                minZoom: map['minZoom'] as int? ?? 10,
                maxZoom: map['maxZoom'] as int? ?? 16,
                bounds: OfflineRegionBounds.fromCsv(
                  map['bounds'] as String? ?? '0,0,0,0',
                ),
                isActive: map['isActive'] as bool? ?? false,
                importedAt:
                    DateTime.tryParse(map['importedAt'] as String? ?? '') ??
                        DateTime.now(),
                tileCount: map['tileCount'] as int?,
                attribution: map['attribution'] as String? ??
                    '© OpenStreetMap contributors',
              ),
            );
          }
        }
      } catch (_) {}
    }

    // Set first active package if any
    final active = _packages.where((p) => p.isActive).firstOrNull;
    if (active != null) {
      await setActivePackage(active.id);
    }
  }

  /// Imports an external .mbtiles file into the local offline storage directory.
  Future<OfflineMapPackage> importMbTilesFile(
    File sourceFile, {
    String? customName,
    String? customDescription,
  }) async {
    if (!await sourceFile.exists()) {
      throw Exception('Source file does not exist: ${sourceFile.path}');
    }

    final reader = MbTilesReader(sourceFile);
    if (!reader.isValidMbTiles()) {
      reader.close();
      throw Exception(
        'The selected file is not a valid MBTiles SQLite package.',
      );
    }

    final meta = reader.getMetadata();
    final bounds = reader.getBounds() ??
        const OfflineRegionBounds(
          minLatitude: 12.0,
          maxLatitude: 18.0,
          minLongitude: 119.0,
          maxLongitude: 124.0,
        );
    final zoomRange = reader.getZoomRange();
    final tileCount = reader.getTileCount();
    final attribution = meta['attribution'] ?? '© OpenStreetMap contributors';
    final pkgName = customName ??
        meta['name'] ??
        p.basenameWithoutExtension(sourceFile.path);
    final pkgDesc = customDescription ??
        meta['description'] ??
        'Offline motorcycle map package';

    reader.close();

    final dir = await getStorageDirectory();
    final id = 'mbtiles_${DateTime.now().millisecondsSinceEpoch}';
    final targetPath = p.join(dir.path, '$id.mbtiles');

    // Copy to app offline storage
    await sourceFile.copy(targetPath);
    final targetFile = File(targetPath);
    final size = await targetFile.length();

    final pkg = OfflineMapPackage(
      id: id,
      name: pkgName,
      description: pkgDesc,
      format: OfflineMapFormat.mbTiles,
      filePath: targetPath,
      sizeBytes: size,
      minZoom: zoomRange.minZoom,
      maxZoom: zoomRange.maxZoom,
      bounds: bounds,
      isActive: _packages.isEmpty, // activate by default if first package
      importedAt: DateTime.now(),
      tileCount: tileCount,
      attribution: attribution,
    );

    _packages.add(pkg);
    await _saveManifest();

    if (pkg.isActive) {
      await setActivePackage(pkg.id);
    }

    return pkg;
  }

  /// Sets the active offline map package for map rendering.
  Future<void> setActivePackage(String? id) async {
    _activePackageId = id;
    _activeReader?.close();
    _activeReader = null;

    for (int i = 0; i < _packages.length; i++) {
      _packages[i] = _packages[i].copyWith(isActive: _packages[i].id == id);
    }

    if (id != null) {
      final pkg = activePackage;
      if (pkg != null && pkg.format == OfflineMapFormat.mbTiles) {
        final f = File(pkg.filePath);
        if (await f.exists()) {
          _activeReader = MbTilesReader(f);
        }
      }
    }

    await _saveManifest();
  }

  /// Retrieves raw PNG tile image bytes for coordinates from the active offline package.
  Uint8List? getTileBytes(int z, int x, int y) {
    if (_activeReader == null || _activeReader!.isClosed) return null;
    return _activeReader!.getTileBytes(z: z, x: x, y: y);
  }

  /// Deletes an offline map package from disk and updates the manifest.
  Future<void> deletePackage(String id) async {
    if (_activePackageId == id) {
      await setActivePackage(null);
    }

    final idx = _packages.indexWhere((p) => p.id == id);
    if (idx != -1) {
      final pkg = _packages.removeAt(idx);
      final file = File(pkg.filePath);
      if (await file.exists()) {
        try {
          await file.delete();
        } catch (_) {}
      }
      await _saveManifest();
    }
  }

  /// Computes combined disk storage consumed by all installed offline map packages.
  int getTotalStorageBytes() {
    return _packages.fold(0, (sum, p) => sum + p.sizeBytes);
  }

  Future<void> _saveManifest() async {
    final dir = await getStorageDirectory();
    final manifestFile = File(p.join(dir.path, 'manifest.json'));
    final list = _packages.map((p) {
      return {
        'id': p.id,
        'name': p.name,
        'description': p.description,
        'format': p.format.name,
        'filePath': p.filePath,
        'minZoom': p.minZoom,
        'maxZoom': p.maxZoom,
        'bounds':
            '${p.bounds.minLongitude},${p.bounds.minLatitude},${p.bounds.maxLongitude},${p.bounds.maxLatitude}',
        'isActive': p.isActive,
        'importedAt': p.importedAt.toIso8601String(),
        'tileCount': p.tileCount,
        'attribution': p.attribution,
      };
    }).toList();

    await manifestFile.writeAsString(jsonEncode(list));
  }

  void dispose() {
    _activeReader?.close();
    _activeReader = null;
  }
}
