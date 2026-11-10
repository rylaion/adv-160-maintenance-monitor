import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

/// Supported offline map storage formats.
enum OfflineMapFormat {
  mbTiles('MBTiles (SQLite)', '.mbtiles'),
  pmTiles('PMTiles (Single-file Archive)', '.pmtiles'),
  directoryArchive('Extracted Tile Directory', '.zip');

  const OfflineMapFormat(this.label, this.extension);
  final String label;
  final String extension;
}

/// Geographic bounding box defining the coverage area of an offline map region.
@immutable
class OfflineRegionBounds {
  const OfflineRegionBounds({
    required this.minLatitude,
    required this.maxLatitude,
    required this.minLongitude,
    required this.maxLongitude,
  });

  final double minLatitude;
  final double maxLatitude;
  final double minLongitude;
  final double maxLongitude;

  bool contains(LatLng point) {
    return point.latitude >= minLatitude &&
        point.latitude <= maxLatitude &&
        point.longitude >= minLongitude &&
        point.longitude <= maxLongitude;
  }

  LatLng get center => LatLng(
        (minLatitude + maxLatitude) / 2.0,
        (minLongitude + maxLongitude) / 2.0,
      );

  factory OfflineRegionBounds.fromCsv(String csv) {
    final parts =
        csv.split(',').map((s) => double.tryParse(s.trim()) ?? 0.0).toList();
    if (parts.length >= 4) {
      // Standard MBTiles bounds order: minLon, minLat, maxLon, maxLat
      return OfflineRegionBounds(
        minLongitude: parts[0],
        minLatitude: parts[1],
        maxLongitude: parts[2],
        maxLatitude: parts[3],
      );
    }
    return const OfflineRegionBounds(
      minLatitude: 0,
      maxLatitude: 0,
      minLongitude: 0,
      maxLongitude: 0,
    );
  }
}

/// A stored offline map package (e.g., imported MBTiles file).
@immutable
class OfflineMapPackage {
  const OfflineMapPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.format,
    required this.filePath,
    required this.sizeBytes,
    required this.minZoom,
    required this.maxZoom,
    required this.bounds,
    this.isActive = false,
    required this.importedAt,
    this.tileCount,
    this.attribution = '© OpenStreetMap contributors',
    this.version = '1.0.0',
  });

  final String id;
  final String name;
  final String description;
  final OfflineMapFormat format;
  final String filePath;
  final int sizeBytes;
  final int minZoom;
  final int maxZoom;
  final OfflineRegionBounds bounds;
  final bool isActive;
  final DateTime importedAt;
  final int? tileCount;
  final String attribution;
  final String version;

  String get formattedSize {
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  OfflineMapPackage copyWith({
    String? id,
    String? name,
    String? description,
    OfflineMapFormat? format,
    String? filePath,
    int? sizeBytes,
    int? minZoom,
    int? maxZoom,
    OfflineRegionBounds? bounds,
    bool? isActive,
    DateTime? importedAt,
    int? tileCount,
    String? attribution,
    String? version,
  }) {
    return OfflineMapPackage(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      format: format ?? this.format,
      filePath: filePath ?? this.filePath,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      bounds: bounds ?? this.bounds,
      isActive: isActive ?? this.isActive,
      importedAt: importedAt ?? this.importedAt,
      tileCount: tileCount ?? this.tileCount,
      attribution: attribution ?? this.attribution,
      version: version ?? this.version,
    );
  }
}

/// Popular motorcycle touring zones in the Philippines with pre-configured coordinates.
class PredefinedMotorcycleZone {
  const PredefinedMotorcycleZone({
    required this.id,
    required this.name,
    required this.description,
    required this.bounds,
    required this.recommendedMinZoom,
    required this.recommendedMaxZoom,
    required this.estimatedSizeMb,
  });

  final String id;
  final String name;
  final String description;
  final OfflineRegionBounds bounds;
  final int recommendedMinZoom;
  final int recommendedMaxZoom;
  final double estimatedSizeMb;

  static const List<PredefinedMotorcycleZone> curatedZones = [
    PredefinedMotorcycleZone(
      id: 'marilaque_sierra_madre',
      name: 'Marilaque & Sierra Madre Highway',
      description:
          'Marikina-Infanta Highway, Tanay Sierra Madre twisties, and Quezon mountain pass.',
      bounds: OfflineRegionBounds(
        minLatitude: 14.50,
        maxLatitude: 14.85,
        minLongitude: 121.15,
        maxLongitude: 121.65,
      ),
      recommendedMinZoom: 10,
      recommendedMaxZoom: 16,
      estimatedSizeMb: 45.0,
    ),
    PredefinedMotorcycleZone(
      id: 'tagaytay_batangas_loop',
      name: 'Tagaytay Ridge & Batangas Loop',
      description:
          'Tagaytay-Calamba-Nasugbu motorcycle touring loop and Taal caldera viewpoints.',
      bounds: OfflineRegionBounds(
        minLatitude: 13.90,
        maxLatitude: 14.25,
        minLongitude: 120.75,
        maxLongitude: 121.20,
      ),
      recommendedMinZoom: 10,
      recommendedMaxZoom: 16,
      estimatedSizeMb: 52.0,
    ),
    PredefinedMotorcycleZone(
      id: 'baguio_benguet_cordillera',
      name: 'Baguio & Benguet Cordillera',
      description:
          'Halsema Highway, Ambuklao Dam run, and high-altitude mountain routes.',
      bounds: OfflineRegionBounds(
        minLatitude: 16.30,
        maxLatitude: 16.65,
        minLongitude: 120.45,
        maxLongitude: 120.85,
      ),
      recommendedMinZoom: 10,
      recommendedMaxZoom: 16,
      estimatedSizeMb: 60.0,
    ),
    PredefinedMotorcycleZone(
      id: 'metro_manila_urban',
      name: 'Metro Manila Urban Riding Belt',
      description:
          'Non-expressway arterial routes, service roads, and secondary motorcycle corridors.',
      bounds: OfflineRegionBounds(
        minLatitude: 14.40,
        maxLatitude: 14.75,
        minLongitude: 120.90,
        maxLongitude: 121.15,
      ),
      recommendedMinZoom: 11,
      recommendedMaxZoom: 17,
      estimatedSizeMb: 68.0,
    ),
  ];
}
