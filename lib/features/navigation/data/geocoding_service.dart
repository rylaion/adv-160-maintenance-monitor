import 'dart:convert';
import 'package:http/http.dart' as http;

import '../domain/route_models.dart';

/// Geocoding service using OpenStreetMap Nominatim and offline landmark cache.
class GeocodingService {
  GeocodingService({http.Client? httpClient})
      : _client = httpClient ?? http.Client();

  final http.Client _client;

  /// Curated offline motorcycle destinations for offline routing & quick lookup.
  static const List<SearchResultLocation> offlineLandmarks = [
    SearchResultLocation(
      displayName:
          'Honda Safety Driving Center (HSDC), Parañaque, Metro Manila',
      shortName: 'Honda Safety Driving Center',
      latitude: 14.4988,
      longitude: 121.0367,
      category: 'service',
      address: 'Km 17 East Service Rd, Parañaque',
    ),
    SearchResultLocation(
      displayName: 'Marilaque Highway (Sierra Madre Viewpoint), Tanay, Rizal',
      shortName: 'Marilaque Highway Viewpoint',
      latitude: 14.6152,
      longitude: 121.3654,
      category: 'scenic',
      address: 'Marilaque Hwy, Tanay, Rizal',
    ),
    SearchResultLocation(
      displayName: 'Tanay Windmills & Daranak Falls, Tanay, Rizal',
      shortName: 'Tanay Windmills',
      latitude: 14.5028,
      longitude: 121.3533,
      category: 'scenic',
      address: 'Pililla-Tanay Wind Farm, Rizal',
    ),
    SearchResultLocation(
      displayName: 'Tagaytay Ridge & Picnic Grove, Tagaytay, Cavite',
      shortName: 'Tagaytay Ridge',
      latitude: 14.1287,
      longitude: 120.9782,
      category: 'scenic',
      address: 'Tagaytay-Calamba Rd, Tagaytay',
    ),
    SearchResultLocation(
      displayName: 'Shell Mobility Station, C-5 Pasig City',
      shortName: 'Shell Gas Station C-5',
      latitude: 14.5734,
      longitude: 121.0745,
      category: 'gas_station',
      address: 'Eulogio Rodriguez Jr. Ave, Pasig',
    ),
    SearchResultLocation(
      displayName: 'Honda Prestige Traders, Quezon City',
      shortName: 'Honda Motorcycle Service Center',
      latitude: 14.6341,
      longitude: 121.0322,
      category: 'service',
      address: 'Quezon Ave, Quezon City',
    ),
  ];

  /// Searches for addresses, cities, and landmarks.
  Future<List<SearchResultLocation>> search(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    // Check offline landmark matches first
    final lower = cleanQuery.toLowerCase();
    final offlineMatches = offlineLandmarks.where((item) {
      return item.displayName.toLowerCase().contains(lower) ||
          item.shortName.toLowerCase().contains(lower) ||
          (item.address?.toLowerCase().contains(lower) ?? false);
    }).toList();

    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(cleanQuery)}'
        '&format=json'
        '&limit=6'
        '&addressdetails=1',
      );

      final response = await _client.get(
        uri,
        headers: {
          'User-Agent':
              'ADV-MON-Motorcycle-Assistant/1.0 (contact: advmon-app)',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        final results = <SearchResultLocation>[...offlineMatches];

        for (final item in list) {
          final lat = double.tryParse(item['lat']?.toString() ?? '');
          final lon = double.tryParse(item['lon']?.toString() ?? '');
          if (lat == null || lon == null) continue;

          final displayName = item['display_name'] as String? ?? 'Location';
          final name = item['name'] as String? ?? displayName.split(',').first;
          final type = item['type'] as String? ?? 'location';

          // Avoid duplicates with offline landmarks
          if (results.any((r) =>
              (r.latitude - lat).abs() < 0.001 &&
              (r.longitude - lon).abs() < 0.001)) {
            continue;
          }

          results.add(SearchResultLocation(
            displayName: displayName,
            shortName: name,
            latitude: lat,
            longitude: lon,
            category: type,
            address: displayName,
          ));
        }

        if (results.isNotEmpty) {
          return results;
        }
      }
    } catch (_) {
      // Offline fallback: Return offline landmark matches if query matched
    }

    return offlineMatches;
  }
}
