# Skwark Monorepo Setup Guide

Complete setup instructions for the Skwark AR Aviation Spotting monorepo.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.2.0 or higher)
  - Installation: https://docs.flutter.dev/get-started/install
- **Dart SDK** (comes with Flutter)
- **Melos** (for monorepo management)
  ```bash
  dart pub global activate melos
  ```
- **Android Studio** (for Android development)
  - Download: https://developer.android.com/studio
- **Xcode** (for iOS development, macOS only)
  - Download from App Store
- **Git**

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/valentines-agency/skwark.git
cd skwark
```

### 2. Bootstrap the Monorepo

This command will install all dependencies and link packages:

```bash
melos bootstrap
```

### 3. Generate Platform Files

The Flutter app needs platform-specific files (Android, iOS, etc.). Generate them:

```bash
cd apps/skwark
flutter create --platforms=android,ios,web .
cd ../..
```

Or use the provided setup script:

```bash
cd apps/skwark
chmod +x setup_platforms.sh
./setup_platforms.sh
cd ../..
```

### 4. Configure API Keys (Optional)

For full functionality, add Google Maps API keys:

**Android** (`apps/skwark/android/app/src/main/AndroidManifest.xml`):
```xml
<manifest ...>
    <application ...>
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_API_KEY_HERE"/>
    </application>
</manifest>
```

**iOS** (`apps/skwark/ios/Runner/AppDelegate.swift`):
```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### 5. Run the App

```bash
# Using Melos (from root)
melos run run:app

# Or directly with Flutter
cd apps/skwark
flutter run
```

## Detailed Setup Instructions

### Android Studio Setup

1. **Open Android Project**:
   - Open Android Studio
   - Click "Open an Existing Project"
   - Navigate to `skwark/apps/skwark/android`
   - Let Gradle sync complete

2. **Configure SDK**:
   - Go to Tools → SDK Manager
   - Ensure Android SDK Platform 26 (or higher) is installed
   - Install Android SDK Build-Tools

3. **Set up Emulator** (optional):
   - Tools → AVD Manager
   - Create a new virtual device
   - Choose a device with Play Store (for ARCore)
   - Download a system image (API 26+)

4. **Run from Android Studio**:
   - Open `skwark/apps/skwark` as a Flutter project
   - Click the Run button
   - Select your device/emulator

### iOS Setup (macOS only)

1. **Install CocoaPods**:
   ```bash
   sudo gem install cocoapods
   ```

2. **Install iOS Dependencies**:
   ```bash
   cd apps/skwark/ios
   pod install
   cd ../../..
   ```

3. **Open in Xcode**:
   - Open `apps/skwark/ios/Runner.xcworkspace` (NOT .xcodeproj)
   - Select your development team in Signing & Capabilities
   - Choose a simulator or connected device

4. **Run from Xcode**:
   - Click the Play button
   - Or use: `flutter run`

### Web Setup

Web platform has limited AR functionality but can display flight data:

```bash
cd apps/skwark
flutter run -d chrome
```

## Project Structure

```
skwark/                             # Monorepo root
├── apps/
│   └── skwark/                     # Main Flutter app
│       ├── lib/                    # Dart source code
│       ├── android/                # Android project (generated)
│       ├── ios/                    # iOS project (generated)
│       ├── web/                    # Web platform (generated)
│       ├── test/                   # Tests
│       ├── pubspec.yaml            # App dependencies
│       ├── setup_platforms.sh      # Platform setup script
│       └── README.md               # App-specific docs
├── packages/                       # Shared packages (future)
├── melos.yaml                      # Monorepo configuration
├── pubspec.yaml                    # Workspace dependencies
├── README.md                       # Main documentation
└── SETUP.md                        # This file
```

## Common Commands

### Monorepo Commands

```bash
# Bootstrap after cloning or adding packages
melos bootstrap

# Run the main app
melos run run:app

# Build the app
melos run build:app

# Analyze all packages
melos run analyze

# Format all code
melos run format

# Run tests
melos run test

# Clean all packages
melos run clean

# List all packages
melos list
```

### Flutter Commands (from apps/skwark)

```bash
# Run on connected device
flutter run

# Run on specific device
flutter devices                    # List devices
flutter run -d <device-id>

# Build APK (Android)
flutter build apk

# Build App Bundle (Android)
flutter build appbundle

# Build iOS
flutter build ios

# Run tests
flutter test

# Analyze code
flutter analyze

# Clean build artifacts
flutter clean
```

## Development Workflow

### Making Changes

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes in the appropriate package/app

3. Run tests and linting:
   ```bash
   melos run analyze
   melos run test
   ```

4. Commit and push:
   ```bash
   git add .
   git commit -m "Description of changes"
   git push origin feature/your-feature-name
   ```

### Adding a New Package

1. Create package in `packages/`:
   ```bash
   cd packages
   flutter create --template=package your_package_name
   cd ..
   ```

2. Bootstrap to link it:
   ```bash
   melos bootstrap
   ```

3. Add to app's `pubspec.yaml`:
   ```yaml
   dependencies:
     your_package_name:
       path: ../../packages/your_package_name
   ```

## Troubleshooting

### "Melos command not found"

```bash
# Install Melos globally
dart pub global activate melos

# Add Dart's global bin to PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### "Flutter command not found"

Install Flutter SDK: https://docs.flutter.dev/get-started/install

### Android Gradle Errors

```bash
cd apps/skwark/android
./gradlew clean
cd ../../..
melos bootstrap
```

### iOS Pod Errors

```bash
cd apps/skwark/ios
pod deintegrate
pod install
cd ../../..
```

### "No platforms found"

```bash
cd apps/skwark
flutter create --platforms=android,ios,web .
cd ../..
```

### Permission Errors on Device

Ensure you've added the necessary permissions to:
- `android/app/src/main/AndroidManifest.xml` (Android)
- `ios/Runner/Info.plist` (iOS)

See the app's README.md for details.

## Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Melos Documentation](https://melos.invertase.dev/)
- [Flutter Monorepo Guide](https://docs.flutter.dev/development/tools/pubspec#dependencies)
- [ARCore Documentation](https://developers.google.com/ar)
- [ARKit Documentation](https://developer.apple.com/arkit/)
- [OpenSky Network API](https://openskynetwork.github.io/opensky-api/)

## Getting Help

- Check the [main README](README.md) for project overview
- Check [app README](apps/skwark/README.md) for app-specific details
- Open an issue on GitHub for bugs or feature requests
- Review Flutter's [troubleshooting guide](https://docs.flutter.dev/get-started/install/troubleshooting)

---

**Happy Coding! ✈️**
