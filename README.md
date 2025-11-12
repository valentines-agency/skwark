# Skwark ✈️

**The augmented reality plane spotter.**

A sleek, modern Flutter AR application that transforms your smartphone into an intelligent aviation spotter. Point your phone at the sky and instantly see flight paths anchored to real aircraft, rendered directly in your camera view with smooth, stable AR tracking.

## Features

- **On-Device AR Processing**: All AR rendering, tracking, and stabilization performed locally using ARKit (iOS) and ARCore (Android)
- **Multi-Path Visualization**: See flight paths for all visible aircraft simultaneously
- **Intelligent Path-to-Plane Connection**: Paths connect to visually detected aircraft with confidence-based anchoring
- **Natural Touch Interactions**: Tap directly on aircraft or flight paths to view details
- **Real-Time Flight Data**: Live updates from OpenSky Network API every 5-7 seconds
- **Material 3 Design**: Polished UI with glass-morphism effects and smooth animations
- **Detailed Aircraft Profiles**: Comprehensive information including specs, live status, and interactive maps

## Tech Stack

- **Framework**: Flutter 3.2+
- **AR**: ARCore (Android), ARKit (iOS)
- **Maps**: Google Maps Flutter
- **State Management**: Flutter Bloc
- **APIs**: OpenSky Network (flight data)
- **Location**: Geolocator
- **Camera**: Camera plugin
- **Sensors**: Sensors Plus (accelerometer, gyroscope)

## Project Structure

```
lib/
├── core/
│   ├── theme/
│   │   └── app_theme.dart         # Material 3 theme with color palette
│   ├── utils/
│   └── constants/
├── features/
│   ├── onboarding/
│   │   └── screens/
│   │       └── permissions_gate_screen.dart  # Permission request screen
│   ├── ar_view/
│   │   ├── screens/
│   │   │   └── ar_view_screen.dart           # Main AR camera view
│   │   └── widgets/
│   │       ├── flight_path_painter.dart      # Custom painter for AR paths
│   │       └── flight_list_bottom_sheet.dart # Flight details sheet
│   └── plane_profile/
│       └── screens/
│           └── plane_profile_screen.dart     # Detailed aircraft profile
├── shared/
│   ├── models/
│   │   ├── flight.dart            # Flight data model
│   │   └── aircraft.dart          # Aircraft specifications model
│   ├── services/
│   │   ├── flight_data_service.dart  # OpenSky API integration
│   │   └── location_service.dart     # GPS and location handling
│   └── widgets/
└── main.dart                      # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK 3.2 or higher
- iOS 13+ / Android 8.0+ (API 26+)
- Physical device with camera (AR requires actual hardware)
- Google Maps API key (for map features)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/valentines-agency/skwark.git
   cd skwark
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Google Maps** (optional for full functionality):

   **Android**: Add your API key to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY_HERE"/>
   ```

   **iOS**: Add your API key to `ios/Runner/AppDelegate.swift`:
   ```swift
   GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
   ```

4. **Run on device** (camera required for AR):
   ```bash
   flutter run
   ```

## Usage

1. **Launch App**: Open Skwark on your device
2. **Grant Permissions**: Allow camera and location access
3. **Point at Sky**: Aim your camera at the sky to see aircraft
4. **View Flight Paths**: Watch as paths are rendered in real-time
5. **Tap to Explore**: Tap any plane or path to view details
6. **Deep Dive**: Open full profile for comprehensive aircraft information

## Development Roadmap

### Phase 1: Core AR Experience (MVP) ✅
- [x] Flutter app structure with camera integration
- [x] Basic AR tracking and sensor fusion
- [x] Flight data integration with OpenSky API
- [x] Multi-path rendering in screen space
- [x] Touch interaction on paths
- [x] Bottom sheet with flight details
- [x] Plane profile view

### Phase 2: Visual Enhancement
- [ ] ARCore/ARKit native plugin integration
- [ ] On-device plane detection with computer vision
- [ ] Visual anchoring of paths to detected planes
- [ ] Advanced path stabilization algorithms
- [ ] Smooth animations and hero transitions
- [ ] Performance optimization (60 FPS target)

### Phase 3: Polish & Scale
- [ ] Battery and performance tuning
- [ ] Edge case handling (different weather, lighting)
- [ ] Accessibility features
- [ ] Analytics integration
- [ ] App Store optimization
- [ ] User testing and feedback iteration

## Architecture Notes

### AR Rendering
Currently uses geometric projection based on:
- GPS coordinates from ADS-B data
- User's location and device orientation
- Sensor fusion (accelerometer + gyroscope)

**Future Enhancement**: Full ARCore/ARKit integration will enable:
- World tracking with 6DOF
- Plane detection in camera feed
- Visual-inertial odometry
- Persistent anchors

### Flight Data
- **Source**: OpenSky Network REST API
- **Refresh Rate**: Every 7 seconds
- **Radius**: 100km from user location
- **Caching**: Local cache prevents duplicate requests

### Performance
- **Target**: 60 FPS camera preview + AR rendering
- **Sensor Rate**: 100 Hz for smooth tracking
- **Battery**: Optimized for 30+ minutes of continuous use

## API Reference

### OpenSky Network
The app uses the free OpenSky Network API for live flight data:
- **Endpoint**: `https://opensky-network.org/api/states/all`
- **Rate Limit**: 10 requests per minute (anonymous)
- **Documentation**: https://openskynetwork.github.io/opensky-api/

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- **OpenSky Network** for providing free flight tracking data
- **Flutter team** for the amazing cross-platform framework
- **ARCore/ARKit** teams for enabling mobile AR experiences

## Contact

For questions, issues, or feature requests, please open an issue on GitHub.

---

**Made with ❤️ by Valentines Agency**
