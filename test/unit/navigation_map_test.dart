import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:adv_mon/features/navigation/data/live_location_service.dart';
import 'package:adv_mon/features/navigation/domain/map_config.dart';
import 'package:adv_mon/features/navigation/domain/navigation_models.dart';
import 'package:adv_mon/features/navigation/presentation/map_view_model.dart';

void main() {
  group('Phase A: Basic Interactive OpenStreetMap Integration', () {
    test(
        'Standard OpenStreetMap tile configuration adheres to OSM usage policy',
        () {
      final osm = MapTileConfig.osmStandard();

      expect(osm.type, MapTileProviderType.openStreetMap);
      expect(osm.urlTemplate, 'https://tile.openstreetmap.org/{z}/{x}/{y}.png');
      expect(osm.attribution, contains('OpenStreetMap contributors'));
      expect(osm.userAgentPackageName, contains('com.advmon.adv_mon'));
      expect(osm.isDarkThemed, isFalse);
      expect(osm.minZoom, 1.0);
      expect(osm.maxZoom, 19.0);
    });

    test('Night Ride (Dark Matter) preset is dark themed for night riding', () {
      final night = MapTileConfig.nightMode();

      expect(night.type, MapTileProviderType.cartoDbDarkMatter);
      expect(night.isDarkThemed, isTrue);
      expect(night.urlTemplate, contains('cartocdn.com/dark_all'));
      expect(night.attribution, contains('CARTO'));
      expect(night.subdomains, contains('a'));
    });

    test('OpenTopoMap and Voyager presets are properly configured', () {
      final topo = MapTileConfig.openTopo();
      expect(topo.type, MapTileProviderType.openTopoMap);
      expect(topo.urlTemplate, contains('opentopomap.org'));
      expect(topo.attribution, contains('OpenTopoMap'));

      final voyager = MapTileConfig.dayVoyager();
      expect(voyager.type, MapTileProviderType.cartoDbVoyager);
      expect(voyager.urlTemplate, contains('voyager'));
    });

    test(
        'Custom self-hosted tile server configuration allows arbitrary endpoints',
        () {
      final custom = MapTileConfig.custom(
        name: 'Private ADV Tile Server',
        urlTemplate: 'http://192.168.1.100:8080/tiles/{z}/{x}/{y}.png',
        attribution: '© Local OSM Mirror',
      );

      expect(custom.type, MapTileProviderType.customSelfHosted);
      expect(custom.name, 'Private ADV Tile Server');
      expect(custom.urlTemplate,
          'http://192.168.1.100:8080/tiles/{z}/{x}/{y}.png');
      expect(custom.attribution, '© Local OSM Mirror');
    });

    test(
        'MapViewModel initial state defaults to OpenStreetMap and Manila coordinates',
        () {
      final vm = MapViewModel();
      expect(vm.state.activeConfig.type, MapTileProviderType.openStreetMap);
      expect(vm.state.center.latitude, closeTo(14.5995, 0.001));
      expect(vm.state.center.longitude, closeTo(120.9842, 0.001));
      expect(vm.state.zoom, 15.0);
      expect(vm.state.rotation, 0.0);
      expect(vm.state.isFollowLocationEnabled, isTrue);
    });

    test('MapViewModel toggles night mode between Standard and Dark Matter',
        () {
      final vm = MapViewModel();
      expect(vm.state.activeConfig.isDarkThemed, isFalse);

      vm.toggleNightMode();
      expect(vm.state.activeConfig.type, MapTileProviderType.cartoDbDarkMatter);
      expect(vm.state.activeConfig.isDarkThemed, isTrue);
      expect(vm.state.isNightModeForced, isTrue);

      vm.toggleNightMode();
      expect(vm.state.activeConfig.type, MapTileProviderType.openStreetMap);
      expect(vm.state.activeConfig.isDarkThemed, isFalse);
    });

    test('MapViewModel updates camera and bearing correctly', () {
      final vm = MapViewModel();
      const newCenter = LatLng(14.5547, 121.0244); // Makati

      vm.updateCamera(
        center: newCenter,
        zoom: 16.0,
        rotation: 45.0,
      );

      expect(vm.state.center, newCenter);
      expect(vm.state.zoom, 16.0);
      expect(vm.state.rotation, 45.0);

      vm.resetNorth();
      expect(vm.state.rotation, 0.0);
      expect(vm.state.center, newCenter);
    });

    test('MapViewModel allows registering custom self-hosted tile servers', () {
      final vm = MapViewModel();
      final initialCount = vm.state.availableConfigs.length;

      final custom = MapTileConfig.custom(
        name: 'Workshop Offline Mirror',
        urlTemplate: 'http://localhost:8000/{z}/{x}/{y}.png',
      );

      vm.registerCustomTileServer(custom);

      expect(vm.state.availableConfigs.length, initialCount + 1);
      expect(vm.state.activeConfig, custom);
      expect(vm.state.availableConfigs.last.name, 'Workshop Offline Mirror');
    });

    test('MapViewModel follow location toggle works as expected', () {
      final vm = MapViewModel();
      expect(vm.state.isFollowLocationEnabled, isTrue);

      vm.toggleFollowLocation();
      expect(vm.state.isFollowLocationEnabled, isFalse);

      vm.setFollowLocation(true);
      expect(vm.state.isFollowLocationEnabled, isTrue);
    });
  });

  group('Phase B: Current GPS Location and Live Position Tracking', () {
    test('MotorcycleGpsPosition classifies signal precision accurately', () {
      final now = DateTime.now();

      final good = MotorcycleGpsPosition(
        latitude: 14.5995,
        longitude: 120.9842,
        speedKmh: 45.0,
        heading: 180.0,
        accuracyMeters: 4.5,
        timestamp: now,
      );
      expect(good.signalQuality, GpsSignalQuality.good);
      expect(good.latLng.latitude, 14.5995);

      final fair = good.copyWith(accuracyMeters: 18.0);
      expect(fair.signalQuality, GpsSignalQuality.fair);

      final poor = good.copyWith(accuracyMeters: 42.0);
      expect(poor.signalQuality, GpsSignalQuality.poor);

      final searching = good.copyWith(accuracyMeters: 0.0);
      expect(searching.signalQuality, GpsSignalQuality.searching);
    });

    test(
        'LiveLocationService emits position updates and updates lastKnownPosition',
        () async {
      final service = LiveLocationService();
      final now = DateTime.now();

      final testPos = MotorcycleGpsPosition(
        latitude: 14.5500,
        longitude: 121.0300,
        speedKmh: 52.0,
        heading: 90.0,
        accuracyMeters: 6.0,
        timestamp: now,
      );

      final futurePos = service.positionStream.first;
      service.emitPosition(testPos);

      final received = await futurePos;
      expect(received.latitude, 14.5500);
      expect(received.speedKmh, 52.0);
      expect(received.heading, 90.0);
      expect(service.lastKnownPosition?.latitude, 14.5500);

      service.dispose();
    });

    test(
        'MapViewModel onLocationUpdated follows motorcycle when follow mode is on',
        () {
      final vm = MapViewModel();
      expect(vm.state.isFollowLocationEnabled, isTrue);

      final pos1 = MotorcycleGpsPosition(
        latitude: 14.5800,
        longitude: 121.0500,
        speedKmh: 40.0,
        heading: 120.0,
        accuracyMeters: 5.0,
        timestamp: DateTime.now(),
      );

      vm.onLocationUpdated(pos1);
      expect(vm.state.currentPosition, pos1);
      expect(vm.state.center.latitude, 14.5800);
      expect(vm.state.center.longitude, 121.0500);
    });

    test('MapViewModel decouples follow mode when user manually gestures map',
        () {
      final vm = MapViewModel();
      expect(vm.state.isFollowLocationEnabled, isTrue);

      // User drags map to a new location
      vm.updateCamera(
        center: const LatLng(14.6000, 121.0000),
        zoom: 15.0,
        fromUserGesture: true,
      );

      expect(vm.state.isFollowLocationEnabled, isFalse);

      // New GPS update arrives while user is exploring elsewhere
      final pos2 = MotorcycleGpsPosition(
        latitude: 14.5000,
        longitude: 121.0800,
        speedKmh: 35.0,
        heading: 90.0,
        accuracyMeters: 4.0,
        timestamp: DateTime.now(),
      );
      vm.onLocationUpdated(pos2);

      // Camera center should NOT jump because follow mode is disengaged
      expect(vm.state.center.latitude, 14.6000);
      expect(vm.state.currentPosition, pos2);

      // Tapping Recenter snaps back to motorcycle and re-engages follow mode
      vm.recenterOnMotorcycle();
      expect(vm.state.isFollowLocationEnabled, isTrue);
      expect(vm.state.center.latitude, 14.5000);
    });

    test('Heading-Up mode rotates map to match motorcycle heading while riding',
        () {
      final vm = MapViewModel();
      expect(vm.state.isHeadingUpMode, isFalse);
      expect(vm.state.rotation, 0.0);

      vm.toggleHeadingUpMode();
      expect(vm.state.isHeadingUpMode, isTrue);

      final ridePos = MotorcycleGpsPosition(
        latitude: 14.5200,
        longitude: 121.0100,
        speedKmh: 45.0, // Moving speed
        heading: 270.0, // Heading West
        accuracyMeters: 3.5,
        timestamp: DateTime.now(),
      );

      vm.onLocationUpdated(ridePos);
      expect(vm.state.rotation, 270.0);

      // Toggle back to North-Up
      vm.toggleHeadingUpMode();
      expect(vm.state.isHeadingUpMode, isFalse);
      expect(vm.state.rotation, 0.0);
    });
  });
}
