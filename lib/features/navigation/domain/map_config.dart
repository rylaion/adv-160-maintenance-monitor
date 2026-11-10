import 'package:flutter/foundation.dart';

/// Supported OpenStreetMap-compatible tile provider types.
enum MapTileProviderType {
  openStreetMap,
  cartoDbDarkMatter,
  cartoDbVoyager,
  openTopoMap,
  customSelfHosted,
  offlineMbTiles,
}

/// Configuration for OpenStreetMap and compatible tile servers.
/// Respects OpenStreetMap Foundation Tile Usage Policy:
/// - Distinctive and valid HTTP User-Agent
/// - Proper copyright and contributor attribution
/// - Configurable caching and tile servers
@immutable
class MapTileConfig {
  const MapTileConfig({
    required this.type,
    required this.name,
    required this.urlTemplate,
    required this.attribution,
    this.subdomains = const ['a', 'b', 'c'],
    this.userAgentPackageName = 'com.advmon.adv_mon',
    this.minZoom = 2.0,
    this.maxZoom = 19.0,
    this.isDarkThemed = false,
  });

  final MapTileProviderType type;
  final String name;
  final String urlTemplate;
  final String attribution;
  final List<String> subdomains;
  final String userAgentPackageName;
  final double minZoom;
  final double maxZoom;
  final bool isDarkThemed;

  /// Standard OpenStreetMap public tile server.
  factory MapTileConfig.osmStandard() {
    return const MapTileConfig(
      type: MapTileProviderType.openStreetMap,
      name: 'OpenStreetMap Standard',
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      attribution: '© OpenStreetMap contributors',
      subdomains: [],
      userAgentPackageName: 'com.advmon.adv_mon (ADV-MON Motorcycle Assistant)',
      minZoom: 1.0,
      maxZoom: 19.0,
      isDarkThemed: false,
    );
  }

  /// CartoDB Dark Matter — optimized for night riding and OLED displays.
  factory MapTileConfig.nightMode() {
    return const MapTileConfig(
      type: MapTileProviderType.cartoDbDarkMatter,
      name: 'Night Ride (Dark Matter)',
      urlTemplate:
          'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
      attribution: '© OpenStreetMap contributors, © CARTO',
      subdomains: ['a', 'b', 'c', 'd'],
      userAgentPackageName: 'com.advmon.adv_mon',
      minZoom: 1.0,
      maxZoom: 20.0,
      isDarkThemed: true,
    );
  }

  /// CartoDB Voyager — high readability daytime raster style.
  factory MapTileConfig.dayVoyager() {
    return const MapTileConfig(
      type: MapTileProviderType.cartoDbVoyager,
      name: 'Daylight (Voyager)',
      urlTemplate:
          'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
      attribution: '© OpenStreetMap contributors, © CARTO',
      subdomains: ['a', 'b', 'c', 'd'],
      userAgentPackageName: 'com.advmon.adv_mon',
      minZoom: 1.0,
      maxZoom: 19.0,
      isDarkThemed: false,
    );
  }

  /// OpenTopoMap — elevation contours and topographic terrain for adventure touring.
  factory MapTileConfig.openTopo() {
    return const MapTileConfig(
      type: MapTileProviderType.openTopoMap,
      name: 'Topographic Touring (OpenTopoMap)',
      urlTemplate: 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
      attribution: '© OpenStreetMap contributors, SRTM | © OpenTopoMap',
      subdomains: ['a', 'b', 'c'],
      userAgentPackageName: 'com.advmon.adv_mon',
      minZoom: 1.0,
      maxZoom: 17.0,
      isDarkThemed: false,
    );
  }

  /// Custom self-hosted or proxy tile server (e.g. Docker OSM or local cache).
  factory MapTileConfig.custom({
    required String name,
    required String urlTemplate,
    String attribution = '© OpenStreetMap contributors',
    List<String> subdomains = const [],
    double minZoom = 1.0,
    double maxZoom = 19.0,
    bool isDarkThemed = false,
  }) {
    return MapTileConfig(
      type: MapTileProviderType.customSelfHosted,
      name: name,
      urlTemplate: urlTemplate,
      attribution: attribution,
      subdomains: subdomains,
      userAgentPackageName: 'com.advmon.adv_mon',
      minZoom: minZoom,
      maxZoom: maxZoom,
      isDarkThemed: isDarkThemed,
    );
  }

  /// Offline MBTiles package provider.
  factory MapTileConfig.offlinePackage({
    required String name,
    required String filePath,
    String attribution = '© OpenStreetMap contributors',
    double minZoom = 10.0,
    double maxZoom = 16.0,
  }) {
    return MapTileConfig(
      type: MapTileProviderType.offlineMbTiles,
      name: name,
      urlTemplate: 'file://$filePath/{z}/{x}/{y}.png',
      attribution: attribution,
      subdomains: const [],
      minZoom: minZoom,
      maxZoom: maxZoom,
    );
  }

  MapTileConfig copyWith({
    MapTileProviderType? type,
    String? name,
    String? urlTemplate,
    String? attribution,
    List<String>? subdomains,
    String? userAgentPackageName,
    double? minZoom,
    double? maxZoom,
    bool? isDarkThemed,
  }) {
    return MapTileConfig(
      type: type ?? this.type,
      name: name ?? this.name,
      urlTemplate: urlTemplate ?? this.urlTemplate,
      attribution: attribution ?? this.attribution,
      subdomains: subdomains ?? this.subdomains,
      userAgentPackageName: userAgentPackageName ?? this.userAgentPackageName,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      isDarkThemed: isDarkThemed ?? this.isDarkThemed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapTileConfig &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          urlTemplate == other.urlTemplate;

  @override
  int get hashCode => type.hashCode ^ urlTemplate.hashCode;
}
