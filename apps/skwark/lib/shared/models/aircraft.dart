import 'package:equatable/equatable.dart';

class Aircraft extends Equatable {
  final String manufacturer;
  final String model;
  final String? variant;
  final String? registration;
  final int? firstFlightYear;
  final int? age;

  // Specifications
  final double? wingspan; // in feet
  final double? length; // in feet
  final double? height; // in feet
  final int? maxRange; // in nautical miles
  final int? cruiseSpeed; // in mph
  final int? maxPassengers;
  final int? crewSize;

  // Fun fact
  final String? funFact;

  // Media
  final String? imageUrl;

  const Aircraft({
    required this.manufacturer,
    required this.model,
    this.variant,
    this.registration,
    this.firstFlightYear,
    this.age,
    this.wingspan,
    this.length,
    this.height,
    this.maxRange,
    this.cruiseSpeed,
    this.maxPassengers,
    this.crewSize,
    this.funFact,
    this.imageUrl,
  });

  String get fullName {
    final base = '$manufacturer $model';
    return variant != null ? '$base $variant' : base;
  }

  factory Aircraft.fromJson(Map<String, dynamic> json) {
    return Aircraft(
      manufacturer: json['manufacturer'] as String,
      model: json['model'] as String,
      variant: json['variant'] as String?,
      registration: json['registration'] as String?,
      firstFlightYear: json['firstFlightYear'] as int?,
      age: json['age'] as int?,
      wingspan: json['wingspan'] as double?,
      length: json['length'] as double?,
      height: json['height'] as double?,
      maxRange: json['maxRange'] as int?,
      cruiseSpeed: json['cruiseSpeed'] as int?,
      maxPassengers: json['maxPassengers'] as int?,
      crewSize: json['crewSize'] as int?,
      funFact: json['funFact'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'manufacturer': manufacturer,
      'model': model,
      'variant': variant,
      'registration': registration,
      'firstFlightYear': firstFlightYear,
      'age': age,
      'wingspan': wingspan,
      'length': length,
      'height': height,
      'maxRange': maxRange,
      'cruiseSpeed': cruiseSpeed,
      'maxPassengers': maxPassengers,
      'crewSize': crewSize,
      'funFact': funFact,
      'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [
        manufacturer,
        model,
        variant,
        registration,
        firstFlightYear,
        age,
        wingspan,
        length,
        height,
        maxRange,
        cruiseSpeed,
        maxPassengers,
        crewSize,
        funFact,
        imageUrl,
      ];
}

// Static aircraft database for common types
class AircraftDatabase {
  static final Map<String, Aircraft> _database = {
    'B788': const Aircraft(
      manufacturer: 'Boeing',
      model: '787',
      variant: 'Dreamliner',
      firstFlightYear: 2009,
      wingspan: 197,
      length: 186,
      height: 56,
      maxRange: 7635,
      cruiseSpeed: 560,
      maxPassengers: 242,
      crewSize: 2,
      funFact: "The 787's wings can flex up to 26 feet during flight, enabled by carbon fiber composite materials.",
    ),
    'B789': const Aircraft(
      manufacturer: 'Boeing',
      model: '787-9',
      variant: 'Dreamliner',
      firstFlightYear: 2013,
      wingspan: 197,
      length: 206,
      height: 56,
      maxRange: 7635,
      cruiseSpeed: 560,
      maxPassengers: 296,
      crewSize: 2,
      funFact: "The 787's windows are 30% larger than traditional aircraft windows and feature electronic dimming instead of shades.",
    ),
    'A320': const Aircraft(
      manufacturer: 'Airbus',
      model: 'A320',
      firstFlightYear: 1987,
      wingspan: 117.5,
      length: 123.3,
      height: 38.6,
      maxRange: 3300,
      cruiseSpeed: 511,
      maxPassengers: 180,
      crewSize: 2,
      funFact: "The A320 was the first commercial aircraft to introduce a digital fly-by-wire flight control system.",
    ),
    'A321': const Aircraft(
      manufacturer: 'Airbus',
      model: 'A321',
      firstFlightYear: 1993,
      wingspan: 117.5,
      length: 146,
      height: 38.6,
      maxRange: 3700,
      cruiseSpeed: 511,
      maxPassengers: 220,
      crewSize: 2,
      funFact: "The A321 is the longest single-aisle, narrow-body airliner produced by Airbus.",
    ),
    'B77W': const Aircraft(
      manufacturer: 'Boeing',
      model: '777-300ER',
      firstFlightYear: 2003,
      wingspan: 212,
      length: 242,
      height: 61,
      maxRange: 7370,
      cruiseSpeed: 560,
      maxPassengers: 396,
      crewSize: 2,
      funFact: "The 777-300ER has the longest range of any twin-engine airliner and can fly over 7,370 nautical miles non-stop.",
    ),
    'B737': const Aircraft(
      manufacturer: 'Boeing',
      model: '737',
      firstFlightYear: 1967,
      wingspan: 117.5,
      length: 129.5,
      height: 41.2,
      maxRange: 3500,
      cruiseSpeed: 515,
      maxPassengers: 189,
      crewSize: 2,
      funFact: "The Boeing 737 is the best-selling commercial jetliner in history, with over 10,000 aircraft delivered since 1967.",
    ),
    'A359': const Aircraft(
      manufacturer: 'Airbus',
      model: 'A350-900',
      firstFlightYear: 2013,
      wingspan: 212,
      length: 219,
      height: 56,
      maxRange: 8100,
      cruiseSpeed: 561,
      maxPassengers: 325,
      crewSize: 2,
      funFact: "The A350's fuselage is made of 53% composite materials, making it lighter and more fuel-efficient.",
    ),
  };

  static Aircraft? getAircraft(String icaoCode) {
    return _database[icaoCode];
  }

  static Aircraft getAircraftWithFallback(String icaoCode, String defaultName) {
    return _database[icaoCode] ??
        Aircraft(
          manufacturer: 'Unknown',
          model: defaultName,
          funFact: 'This aircraft type is not in our database yet.',
        );
  }
}
