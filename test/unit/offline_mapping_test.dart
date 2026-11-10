import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:sqlite3/sqlite3.dart';

import 'package:adv_mon/features/navigation/data/mbtiles_reader.dart';
import 'package:adv_mon/features/navigation/data/offline_map_service.dart';
import 'package:adv_mon/features/navigation/domain/offline_map_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase G: Offline Mapping and Tile Storage', () {
    late Directory tempDir;
    late File sampleMbTilesFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('adv_mon_offline_test_');

      // Create a valid mock MBTiles SQLite database
      sampleMbTilesFile = File('${tempDir.path}/marilaque_sample.mbtiles');
      final db = sqlite3.open(sampleMbTilesFile.path);

      db.execute('''
        CREATE TABLE metadata (name TEXT, value TEXT);
        CREATE TABLE tiles (zoom_level INTEGER, tile_column INTEGER, tile_row INTEGER, tile_data BLOB);
      ''');

      db.execute('''
        INSERT INTO metadata (name, value) VALUES
          ('name', 'Marilaque Mountain Pass'),
          ('description', 'Offline map of Marilaque Highway'),
          ('format', 'png'),
          ('minzoom', '10'),
          ('maxzoom', '16'),
          ('bounds', '121.15,14.50,121.65,14.85'),
          ('attribution', '© OpenStreetMap contributors');
      ''');

      // Insert mock tile: z=12, x=3345, Slippy y=1875 -> TMS y = (1<<12) - 1 - 1875 = 2220
      final dummyPngBytes =
          Uint8List.fromList([137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0]);
      db.execute(
        'INSERT INTO tiles (zoom_level, tile_column, tile_row, tile_data) VALUES (?, ?, ?, ?)',
        [12, 3345, 2220, dummyPngBytes],
      );

      db.dispose();
    });

    tearDown(() async {
      try {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      } catch (_) {}
    });

    test(
        'OfflineRegionBounds correctly detects coordinates within geographic bounding box',
        () {
      const bounds = OfflineRegionBounds(
        minLatitude: 14.50,
        maxLatitude: 14.85,
        minLongitude: 121.15,
        maxLongitude: 121.65,
      );

      // Center of Marilaque
      expect(bounds.contains(const LatLng(14.65, 121.35)), isTrue);

      // Manila Bay (outside west)
      expect(bounds.contains(const LatLng(14.58, 120.95)), isFalse);

      // Northern Luzon (outside north)
      expect(bounds.contains(const LatLng(16.40, 121.35)), isFalse);

      expect(bounds.center.latitude, closeTo(14.675, 0.001));
      expect(bounds.center.longitude, closeTo(121.400, 0.001));
    });

    test(
        'PredefinedMotorcycleZone catalogs essential Philippine motorcycle regions',
        () {
      const zones = PredefinedMotorcycleZone.curatedZones;

      expect(zones.length, greaterThanOrEqualTo(4));
      expect(zones.any((z) => z.id == 'marilaque_sierra_madre'), isTrue);
      expect(zones.any((z) => z.id == 'tagaytay_batangas_loop'), isTrue);
      expect(zones.any((z) => z.id == 'baguio_benguet_cordillera'), isTrue);

      for (final z in zones) {
        expect(z.recommendedMinZoom, lessThan(z.recommendedMaxZoom));
        expect(z.estimatedSizeMb, greaterThan(10.0));
      }
    });

    test('OfflineMapService strictly enforces OpenStreetMap Tile Usage Policy',
        () {
      final service = OfflineMapService(storageDirOverride: tempDir);

      // Public OSM tile URLs are strictly blocked from bulk download
      final blocked1 = service.validateTileDownloadPolicy(
        'https://tile.openstreetmap.org/12/3345/1875.png',
      );
      expect(blocked1.isAllowed, isFalse);
      expect(blocked1.reason, contains('strictly prohibits bulk-downloading'));

      final blocked2 = service.validateTileDownloadPolicy(
        'https://a.tile.openstreetmap.org/10/500/500.png',
      );
      expect(blocked2.isAllowed, isFalse);

      // Authorized self-hosted or local tile server is permitted
      final allowed = service.validateTileDownloadPolicy(
        'https://tiles.my-motorcycle-server.local/v1/osm/12/3345/1875.png',
      );
      expect(allowed.isAllowed, isTrue);

      // Invalid URL handled safely
      final invalid = service.validateTileDownloadPolicy('invalid-not-a-url');
      expect(invalid.isAllowed, isFalse);

      service.dispose();
    });

    test(
        'MbTilesReader validates schema, parses metadata, and converts TMS tile coordinates',
        () {
      final reader = MbTilesReader(sampleMbTilesFile);

      expect(reader.isValidMbTiles(), isTrue);

      final meta = reader.getMetadata();
      expect(meta['name'], 'Marilaque Mountain Pass');
      expect(meta['format'], 'png');

      final zoomRange = reader.getZoomRange();
      expect(zoomRange.minZoom, 10);
      expect(zoomRange.maxZoom, 16);

      final bounds = reader.getBounds();
      expect(bounds, isNotNull);
      expect(bounds!.minLongitude, 121.15);
      expect(bounds.minLatitude, 14.50);

      expect(reader.getTileCount(), 1);

      // Query tile with Slippy XYZ (z=12, x=3345, y=1875) -> reader translates to TMS y=2220
      final tileBytes = reader.getTileBytes(z: 12, x: 3345, y: 1875);
      expect(tileBytes, isNotNull);
      expect(tileBytes!.length, 11);
      expect(tileBytes[0], 137); // PNG magic header byte

      // Query non-existent tile
      final missingTile = reader.getTileBytes(z: 12, x: 9999, y: 9999);
      expect(missingTile, isNull);

      reader.close();
      expect(reader.isClosed, isTrue);
    });

    test(
        'OfflineMapService imports, activates, serves tiles, and deletes MBTiles package',
        () async {
      final storageDir = Directory('${tempDir.path}/app_storage');
      final service = OfflineMapService(storageDirOverride: storageDir);

      await service.initialize();
      expect(service.packages, isEmpty);
      expect(service.getTotalStorageBytes(), 0);

      // Import sample MBTiles package
      final importedPkg = await service.importMbTilesFile(
        sampleMbTilesFile,
        customName: 'Sierra Madre Test Pack',
      );

      expect(importedPkg.name, 'Sierra Madre Test Pack');
      expect(importedPkg.format, OfflineMapFormat.mbTiles);
      expect(importedPkg.isActive, isTrue);
      expect(service.packages.length, 1);
      expect(service.getTotalStorageBytes(), greaterThan(0));

      // Active package serves tile bytes
      final tileBytes = service.getTileBytes(12, 3345, 1875);
      expect(tileBytes, isNotNull);
      expect(tileBytes!.first, 137);

      // Deactivate
      await service.setActivePackage(null);
      expect(service.activePackageId, isNull);
      expect(service.getTileBytes(12, 3345, 1875), isNull);

      // Reactivate
      await service.setActivePackage(importedPkg.id);
      expect(service.activePackageId, importedPkg.id);
      expect(service.getTileBytes(12, 3345, 1875), isNotNull);

      // Delete package
      await service.deletePackage(importedPkg.id);
      expect(service.packages, isEmpty);
      expect(service.activePackageId, isNull);
      expect(service.getTotalStorageBytes(), 0);

      service.dispose();
    });
  });
}
