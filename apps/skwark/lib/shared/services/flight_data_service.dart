import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flight.dart';

class FlightDataService {
  static const String _baseUrl = 'https://opensky-network.org/api';
  static const Duration _cacheDuration = Duration(seconds: 7);

  List<Flight>? _cachedFlights;
  DateTime? _lastFetchTime;
  Timer? _autoRefreshTimer;

  // Get flights within a bounding box
  Future<List<Flight>> getFlightsInArea({
    required double minLat,
    required double maxLat,
    required double minLon,
    required double maxLon,
  }) async {
    // Return cached data if still fresh
    if (_cachedFlights != null &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
      return _cachedFlights!;
    }

    try {
      final url = Uri.parse(
        '$_baseUrl/states/all?lamin=$minLat&lomin=$minLon&lamax=$maxLat&lomax=$maxLon',
      );

      final response = await http.get(url).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final states = data['states'] as List<dynamic>?;

        if (states == null || states.isEmpty) {
          _cachedFlights = [];
          _lastFetchTime = DateTime.now();
          return [];
        }

        final flights = states
            .map((state) {
              try {
                return Flight.fromOpenSkyJson(state as List<dynamic>);
              } catch (e) {
                print('Error parsing flight: $e');
                return null;
              }
            })
            .whereType<Flight>()
            .where((flight) => !flight.onGround && flight.hasValidPosition)
            .toList();

        _cachedFlights = flights;
        _lastFetchTime = DateTime.now();

        return flights;
      } else if (response.statusCode == 429) {
        // Rate limited - return cached data or empty list
        print('OpenSky API rate limit exceeded');
        return _cachedFlights ?? [];
      } else {
        throw Exception('Failed to load flights: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching flights: $e');
      return _cachedFlights ?? [];
    }
  }

  // Get flights visible from a specific location
  // Uses approximate 100km radius converted to degrees
  Future<List<Flight>> getFlightsNearLocation({
    required double latitude,
    required double longitude,
    double radiusKm = 100.0,
  }) async {
    // Convert radius to approximate lat/lon degrees
    // 1 degree latitude ≈ 111 km
    // 1 degree longitude ≈ 111 km * cos(latitude)
    final latDelta = radiusKm / 111.0;
    final lonDelta = radiusKm / (111.0 * (latitude * 0.0174533).abs());

    return getFlightsInArea(
      minLat: latitude - latDelta,
      maxLat: latitude + latDelta,
      minLon: longitude - lonDelta,
      maxLon: longitude + lonDelta,
    );
  }

  // Start auto-refresh of flight data
  void startAutoRefresh({
    required double latitude,
    required double longitude,
    required Function(List<Flight>) onUpdate,
    double radiusKm = 100.0,
  }) {
    _autoRefreshTimer?.cancel();

    // Immediate first fetch
    getFlightsNearLocation(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    ).then((flights) => onUpdate(flights));

    // Then refresh every 7 seconds
    _autoRefreshTimer = Timer.periodic(_cacheDuration, (_) {
      getFlightsNearLocation(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
      ).then((flights) => onUpdate(flights));
    });
  }

  // Stop auto-refresh
  void stopAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  // Clear cache
  void clearCache() {
    _cachedFlights = null;
    _lastFetchTime = null;
  }

  void dispose() {
    stopAutoRefresh();
    clearCache();
  }
}
