import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:sqlite3/sqlite3.dart';

import '../domain/offline_map_models.dart';

/// Reads raster and vector map tiles directly from standard offline MBTiles SQLite packages.
class MbTilesReader {
  MbTilesReader(this.file) {
    _db = sqlite3.open(file.path, mode: OpenMode.readOnly);
  }

  final File file;
  late final Database _db;
  bool _isClosed = false;

  bool get isClosed => _isClosed;

  /// Validates that the SQLite file contains required MBTiles tables and schema.
  bool isValidMbTiles() {
    if (_isClosed) return false;
    try {
      final tables = _db.select(
        "SELECT name FROM sqlite_master WHERE type IN ('table', 'view') AND name IN ('metadata', 'tiles')",
      );
      return tables.length >= 2;
    } catch (_) {
      return false;
    }
  }

  /// Retrieves metadata key-value pairs stored in the MBTiles package.
  Map<String, String> getMetadata() {
    if (_isClosed) return {};
    final map = <String, String>{};
    try {
      final rows = _db.select('SELECT name, value FROM metadata');
      for (final r in rows) {
        final key = r['name'] as String?;
        final val = r['value'] as String?;
        if (key != null && val != null) {
          map[key] = val;
        }
      }
    } catch (_) {}
    return map;
  }

  /// Retrieves the bounding box coordinates of the MBTiles package if present.
  OfflineRegionBounds? getBounds() {
    final meta = getMetadata();
    final boundsStr = meta['bounds'];
    if (boundsStr != null && boundsStr.isNotEmpty) {
      return OfflineRegionBounds.fromCsv(boundsStr);
    }
    return null;
  }

  /// Retrieves total count of stored tiles in the package.
  int getTileCount() {
    if (_isClosed) return 0;
    try {
      final rows = _db.select('SELECT COUNT(*) AS cnt FROM tiles');
      if (rows.isNotEmpty) {
        return rows.first['cnt'] as int? ?? 0;
      }
    } catch (_) {}
    return 0;
  }

  /// Retrieves minimum and maximum zoom levels supported by this package.
  ({int minZoom, int maxZoom}) getZoomRange() {
    final meta = getMetadata();
    int minZ = int.tryParse(meta['minzoom'] ?? '') ?? 0;
    int maxZ = int.tryParse(meta['maxzoom'] ?? '') ?? 18;

    if (minZ == 0 && maxZ == 18) {
      try {
        final rows = _db.select(
          'SELECT MIN(zoom_level) AS minz, MAX(zoom_level) AS maxz FROM tiles',
        );
        if (rows.isNotEmpty) {
          minZ = rows.first['minz'] as int? ?? minZ;
          maxZ = rows.first['maxz'] as int? ?? maxZ;
        }
      } catch (_) {}
    }
    return (minZoom: minZ, maxZoom: maxZ);
  }

  /// Reads raw PNG/JPEG image tile bytes for OpenStreetMap XYZ coordinates.
  /// Translates Slippy OpenStreetMap Y coordinate to TMS Y coordinate convention:
  /// `tmsY = (1 << z) - 1 - osmY`
  Uint8List? getTileBytes({
    required int z,
    required int x,
    required int y,
    bool isTms = false,
  }) {
    if (_isClosed) return null;
    final targetY = isTms ? y : ((1 << z) - 1 - y);

    try {
      final rows = _db.select(
        'SELECT tile_data FROM tiles WHERE zoom_level = ? AND tile_column = ? AND tile_row = ? LIMIT 1',
        [z, x, targetY],
      );

      if (rows.isNotEmpty) {
        final blob = rows.first['tile_data'];
        if (blob is Uint8List) {
          return blob;
        } else if (blob is List<int>) {
          return Uint8List.fromList(blob);
        }
      }
    } catch (_) {}
    return null;
  }

  void close() {
    if (!_isClosed) {
      _isClosed = true;
      _db.dispose();
    }
  }
}
