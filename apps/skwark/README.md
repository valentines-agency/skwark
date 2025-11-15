# Skwark Mobile App

This is the main Skwark AR Aviation Spotting mobile application for Android and iOS.

## Setup Instructions

Since this app was restructured as part of a monorepo, you'll need to generate the mobile platform-specific files (Android and iOS) using Flutter.

### Initial Platform Setup

Run this command from the **monorepo root** directory:

```bash
# From the root of the repository
cd apps/skwark

# Generate mobile platform files (Android and iOS only)
flutter create --platforms=android,ios .

# This will create:
# - android/      (Android Studio project for phones & tablets)
# - ios/          (Xcode project for iPhone & iPad)
```

**Important:** The `flutter create .` command will NOT overwrite your existing `lib/`, `pubspec.yaml`, or `analysis_options.yaml` files. It only adds missing platform directories.

### After Running Flutter Create

1. **Configure Android**:
   - Open `android/` folder in Android Studio
   - The project should automatically sync
   - Add Google Maps API key to `android/app/src/main/AndroidManifest.xml`

2. **Configure iOS**:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Configure signing & capabilities
   - Add Google Maps API key to `ios/Runner/AppDelegate.swift`

3. **Set up AR permissions**:

   **Android** (`android/app/src/main/AndroidManifest.xml`):
   ```xml
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
   <uses-feature android:name="android.hardware.camera" android:required="true" />
   <uses-feature android:name="android.hardware.camera.ar" android:required="true" />
   ```

   **iOS** (`ios/Runner/Info.plist`):
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>Camera access is required for AR plane spotting</string>
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>Location access is required to find nearby aircraft</string>
   <key>NSLocationAlwaysUsageDescription</key>
   <string>Location access is required to find nearby aircraft</string>
   ```

### Alternative: Using the Setup Script

You can also use the provided setup script:

```bash
cd apps/skwark
chmod +x setup_platforms.sh
./setup_platforms.sh
```

## Project Structure

```
skwark/
├── lib/
│   ├── core/               # Core app-wide functionality
│   ├── features/           # Feature modules
│   └── shared/             # Shared models and services
├── android/                # Android Studio project (generated)
├── ios/                    # Xcode project (generated)
├── web/                    # Web platform (generated)
├── test/                   # Unit and widget tests
├── pubspec.yaml            # Dependencies
└── analysis_options.yaml   # Linting rules
```

## Development

### Run the app

```bash
# From apps/skwark directory
flutter run

# Or from monorepo root
melos run run:app
```

### Build the app

```bash
# Android
flutter build apk           # Debug APK
flutter build appbundle     # Release bundle for Play Store

# iOS
flutter build ios           # iOS build

# From monorepo root
melos run build:app
```

### Testing

```bash
flutter test

# Or from monorepo root
melos run test
```

## Platform-Specific Notes

### Android

- **Minimum SDK**: API 26 (Android 8.0)
- **Target SDK**: Latest stable
- **Required**: ARCore support (most modern Android devices)
- **Gradle**: Uses Gradle 7.x or higher

### iOS

- **Minimum Version**: iOS 13.0
- **Required**: ARKit support (iPhone 6S and newer)
- **Architecture**: arm64

### Web

- Limited AR functionality (no native ARCore/ARKit support)
- Camera access available via WebRTC
- Suitable for flight data viewing without AR features

## Troubleshooting

### "No android/ directory found"

Run `flutter create --platforms=android,ios,web .` from the `apps/skwark` directory.

### "flutter command not found"

Install Flutter SDK: https://docs.flutter.dev/get-started/install

### Android Gradle errors

1. Open `android/` in Android Studio
2. Let it sync and download dependencies
3. Update Gradle if prompted

### iOS build errors

1. Run `pod install` in the `ios/` directory
2. Open `ios/Runner.xcworkspace` in Xcode
3. Configure signing in Xcode

## Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [ARCore Plugin](https://pub.dev/packages/arcore_flutter_plugin)
- [ARKit Plugin](https://pub.dev/packages/arkit_plugin)
- [OpenSky Network API](https://openskynetwork.github.io/opensky-api/)
