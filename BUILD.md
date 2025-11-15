# Skwark Build Guide

Comprehensive instructions for building the Skwark app on all platforms.

## Prerequisites

Before building, ensure you have completed the setup in [SETUP.md](SETUP.md):

- ✅ Monorepo bootstrapped (`melos bootstrap`)
- ✅ Platform files generated (`flutter create --platforms=android,ios,web .`)
- ✅ Dependencies installed

## Quick Build Commands

```bash
# From monorepo root
melos run build:app

# From apps/skwark directory
flutter build <platform>
```

## Platform-Specific Build Instructions

### Android

#### Debug Build (APK)

```bash
cd apps/skwark
flutter build apk --debug
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

#### Release Build (APK)

```bash
cd apps/skwark
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

#### Release Build (App Bundle for Play Store)

```bash
cd apps/skwark
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

#### Build Variants

```bash
# Build for specific ABI
flutter build apk --target-platform android-arm64

# Build split APKs per ABI (smaller file size)
flutter build apk --split-per-abi

# Build with obfuscation
flutter build apk --obfuscate --split-debug-info=build/app/outputs/symbols
```

#### Signing for Release

1. Create keystore:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias upload
   ```

2. Create `apps/skwark/android/key.properties`:
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=/path/to/upload-keystore.jks
   ```

3. Update `apps/skwark/android/app/build.gradle`:
   ```gradle
   def keystoreProperties = new Properties()
   def keystorePropertiesFile = rootProject.file('key.properties')
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   }

   android {
       ...
       signingConfigs {
           release {
               keyAlias keystoreProperties['keyAlias']
               keyPassword keystoreProperties['keyPassword']
               storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
               storePassword keystoreProperties['storePassword']
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
           }
       }
   }
   ```

4. Build signed release:
   ```bash
   flutter build appbundle --release
   ```

### iOS

#### Debug Build

```bash
cd apps/skwark
flutter build ios --debug
```

#### Release Build

```bash
cd apps/skwark
flutter build ios --release
```

#### Build for specific configuration

```bash
# Build without code signing (simulator)
flutter build ios --debug --no-codesign

# Build for specific simulator
flutter build ios --simulator

# Build with specific build number
flutter build ios --build-number=42
```

#### App Store Build

1. **Open in Xcode**:
   ```bash
   open apps/skwark/ios/Runner.xcworkspace
   ```

2. **Configure signing**:
   - Select Runner in project navigator
   - Go to Signing & Capabilities
   - Select your development team
   - Ensure provisioning profile is configured

3. **Archive**:
   - Product → Archive
   - Wait for archive to complete
   - Organizer will open automatically

4. **Upload to App Store**:
   - Click "Distribute App"
   - Follow the wizard
   - Upload to App Store Connect

#### TestFlight Build

```bash
# Create IPA for TestFlight
flutter build ipa

# Output will be at:
# build/ios/archive/Runner.xcarchive
```

Upload the IPA via Xcode or Transporter app.

### Web

#### Debug Build

```bash
cd apps/skwark
flutter build web --debug
```

Output: `build/web/`

#### Release Build

```bash
cd apps/skwark
flutter build web --release
```

#### Build with specific renderer

```bash
# Auto (default)
flutter build web --web-renderer auto

# HTML renderer (better compatibility)
flutter build web --web-renderer html

# CanvasKit renderer (better performance)
flutter build web --web-renderer canvaskit
```

#### Deploy to hosting

The `build/web/` directory can be deployed to any static hosting:

```bash
# Firebase Hosting
firebase deploy

# Netlify
netlify deploy --dir=build/web --prod

# GitHub Pages
# Copy build/web/* to your gh-pages branch

# Vercel
vercel --prod
```

### Linux (Desktop)

#### Build

```bash
cd apps/skwark
flutter build linux --release
```

Output: `build/linux/x64/release/bundle/`

The bundle directory contains all files needed to run the app.

### macOS (Desktop)

#### Build

```bash
cd apps/skwark
flutter build macos --release
```

Output: `build/macos/Build/Products/Release/skwark.app`

#### Create DMG for distribution

```bash
# Install create-dmg
brew install create-dmg

# Create DMG
create-dmg \
  --volname "Skwark" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --icon "skwark.app" 200 190 \
  --hide-extension "skwark.app" \
  --app-drop-link 600 185 \
  "Skwark.dmg" \
  "build/macos/Build/Products/Release/skwark.app"
```

### Windows (Desktop)

#### Build

```bash
cd apps/skwark
flutter build windows --release
```

Output: `build/windows/runner/Release/`

## Build Configuration

### Version Management

Update version in `apps/skwark/pubspec.yaml`:

```yaml
version: 1.2.3+45
#        │ │ │  │
#        │ │ │  └─ Build number
#        │ │ └──── Patch version
#        │ └────── Minor version
#        └──────── Major version
```

Or use command line:

```bash
# Set version
flutter build apk --build-name=1.2.3 --build-number=45
```

### Build Modes

Flutter has three build modes:

1. **Debug**:
   - Assertions enabled
   - Service extensions enabled
   - Debugging enabled
   - Compiler optimizations disabled
   - Command: `flutter build <platform> --debug`

2. **Profile**:
   - Some service extensions enabled
   - Tracing enabled
   - Minimal compiler optimizations
   - Command: `flutter build <platform> --profile`

3. **Release**:
   - Assertions disabled
   - Debugging disabled
   - Compiler optimizations enabled
   - Command: `flutter build <platform> --release`

### Build Optimization

#### Reduce App Size

```bash
# Build with --split-per-abi (Android)
flutter build apk --split-per-abi

# Build with obfuscation
flutter build apk --obfuscate --split-debug-info=build/symbols

# Use --tree-shake-icons (removes unused icons)
flutter build apk --tree-shake-icons
```

#### Improve Performance

```bash
# Profile mode for performance testing
flutter build apk --profile

# Release mode with performance tracing
flutter build apk --release --dart-define=PERFORMANCE_OVERLAY=true
```

## Build Troubleshooting

### Common Issues

#### "Gradle build failed"

```bash
cd apps/skwark/android
./gradlew clean
cd ../../..
flutter clean
flutter pub get
flutter build apk
```

#### "CocoaPods error"

```bash
cd apps/skwark/ios
pod deintegrate
pod install
cd ../..
flutter clean
flutter build ios
```

#### "Out of memory"

```bash
# Increase Gradle memory (Android)
# Edit apps/skwark/android/gradle.properties
org.gradle.jvmargs=-Xmx4096m
```

#### "Version conflict"

```bash
flutter clean
flutter pub get
flutter pub upgrade
flutter build apk
```

### Build Validation

Before releasing, validate your build:

```bash
# Analyze code
flutter analyze

# Run tests
flutter test

# Check for outdated packages
flutter pub outdated

# Validate Android build
cd apps/skwark/android
./gradlew check
cd ../../..

# Validate iOS build (macOS only)
cd apps/skwark/ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release build
cd ../..
```

## CI/CD Integration

### GitHub Actions Example

Create `.github/workflows/build.yml`:

```yaml
name: Build

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
      - run: flutter pub get
        working-directory: apps/skwark
      - run: flutter build apk
        working-directory: apps/skwark

  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
      - run: flutter pub get
        working-directory: apps/skwark
      - run: flutter build ios --no-codesign
        working-directory: apps/skwark
```

### Fastlane Integration

For automated iOS/Android builds and deployment:

```bash
# Install fastlane
sudo gem install fastlane

# Initialize in android directory
cd apps/skwark/android
fastlane init

# Initialize in ios directory
cd ../ios
fastlane init
```

## Additional Resources

- [Flutter Build Docs](https://docs.flutter.dev/deployment)
- [Android Build Configuration](https://docs.flutter.dev/deployment/android)
- [iOS Build Configuration](https://docs.flutter.dev/deployment/ios)
- [Web Build Configuration](https://docs.flutter.dev/deployment/web)
- [Desktop Build Configuration](https://docs.flutter.dev/platform-integration/desktop)

---

For setup instructions, see [SETUP.md](SETUP.md)
For development workflow, see [README.md](README.md)
