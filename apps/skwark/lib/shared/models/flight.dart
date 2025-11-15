import 'package:equatable/equatable.dart';

class Flight extends Equatable {
  final String icao24;
  final String? callsign;
  final String? originCountry;
  final double? latitude;
  final double? longitude;
  final double? altitude; // in meters
  final double? velocity; // in m/s
  final double? heading; // in degrees
  final double? verticalRate; // in m/s
  final int? timePosition;
  final int? lastContact;
  final bool onGround;

  // Extended data (may need additional API calls)
  final String? flightNumber;
  final String? airline;
  final String? aircraftType;
  final String? registration;
  final String? origin;
  final String? destination;

  const Flight({
    required this.icao24,
    this.callsign,
    this.originCountry,
    this.latitude,
    this.longitude,
    this.altitude,
    this.velocity,
    this.heading,
    this.verticalRate,
    this.timePosition,
    this.lastContact,
    this.onGround = false,
    this.flightNumber,
    this.airline,
    this.aircraftType,
    this.registration,
    this.origin,
    this.destination,
  });

  factory Flight.fromOpenSkyJson(List<dynamic> json) {
    return Flight(
      icao24: json[0] as String,
      callsign: json[1] as String?,
      originCountry: json[2] as String?,
      timePosition: json[3] as int?,
      lastContact: json[4] as int?,
      longitude: json[5] as double?,
      latitude: json[6] as double?,
      altitude: json[7] as double?,
      onGround: json[8] as bool? ?? false,
      velocity: json[9] as double?,
      heading: json[10] as double?,
      verticalRate: json[11] as double?,
    );
  }

  // Convert altitude from meters to feet
  double? get altitudeInFeet => altitude != null ? altitude! * 3.28084 : null;

  // Convert velocity from m/s to mph
  double? get velocityInMph => velocity != null ? velocity! * 2.23694 : null;

  // Convert velocity from m/s to knots
  double? get velocityInKnots => velocity != null ? velocity! * 1.94384 : null;

  // Get heading as cardinal direction
  String? get headingCardinal {
    if (heading == null) return null;
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((heading! + 22.5) / 45).floor() % 8;
    return directions[index];
  }

  // Check if flight has valid position data
  bool get hasValidPosition =>
      latitude != null && longitude != null && altitude != null;

  Flight copyWith({
    String? icao24,
    String? callsign,
    String? originCountry,
    double? latitude,
    double? longitude,
    double? altitude,
    double? velocity,
    double? heading,
    double? verticalRate,
    int? timePosition,
    int? lastContact,
    bool? onGround,
    String? flightNumber,
    String? airline,
    String? aircraftType,
    String? registration,
    String? origin,
    String? destination,
  }) {
    return Flight(
      icao24: icao24 ?? this.icao24,
      callsign: callsign ?? this.callsign,
      originCountry: originCountry ?? this.originCountry,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      velocity: velocity ?? this.velocity,
      heading: heading ?? this.heading,
      verticalRate: verticalRate ?? this.verticalRate,
      timePosition: timePosition ?? this.timePosition,
      lastContact: lastContact ?? this.lastContact,
      onGround: onGround ?? this.onGround,
      flightNumber: flightNumber ?? this.flightNumber,
      airline: airline ?? this.airline,
      aircraftType: aircraftType ?? this.aircraftType,
      registration: registration ?? this.registration,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
    );
  }

  @override
  List<Object?> get props => [
        icao24,
        callsign,
        originCountry,
        latitude,
        longitude,
        altitude,
        velocity,
        heading,
        verticalRate,
        timePosition,
        lastContact,
        onGround,
        flightNumber,
        airline,
        aircraftType,
        registration,
        origin,
        destination,
      ];
}
