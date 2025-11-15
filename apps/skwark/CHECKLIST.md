# Pre-Build Checklist

Use this checklist to verify your Skwark app setup before building.

## ✅ Initial Setup

- [ ] Flutter SDK installed (version 3.2.0 or higher)
  ```bash
  flutter --version
  ```

- [ ] Dart SDK available
  ```bash
  dart --version
  ```

- [ ] Melos installed globally
  ```bash
  melos --version
  ```

- [ ] Repository cloned
  ```bash
  git clone https://github.com/valentines-agency/skwark.git
  cd skwark
  ```

## ✅ Monorepo Configuration

- [ ] Monorepo bootstrapped
  ```bash
  melos bootstrap
  ```

- [ ] All packages linked correctly
  ```bash
  melos list
  ```

## ✅ Platform Files Generated

- [ ] Platform files created
  ```bash
  cd apps/skwark
  flutter create --platforms=android,ios,web .
  ```

- [ ] Verify platform directories exist:
  - [ ] `android/` directory exists
  - [ ] `ios/` directory exists
  - [ ] `web/` directory exists

## ✅ Dependencies

- [ ] Dependencies installed
  ```bash
  cd apps/skwark
  flutter pub get
  ```

- [ ] No dependency conflicts
  ```bash
  flutter pub get
  # Should complete without errors
  ```

- [ ] Check for outdated packages (optional)
  ```bash
  flutter pub outdated
  ```

## ✅ Code Quality

- [ ] No analysis errors
  ```bash
  flutter analyze
  # Should return: No issues found!
  ```

- [ ] Code formatted correctly
  ```bash
  flutter format lib/
  ```

## ✅ Android Setup (for Android builds)

- [ ] Android Studio installed
- [ ] Android SDK installed (API level 26+)
- [ ] Android emulator or physical device available
- [ ] Gradle files present:
  - [ ] `android/build.gradle`
  - [ ] `android/app/build.gradle`
  - [ ] `android/settings.gradle`

- [ ] Gradle sync successful
  ```bash
  cd android
  ./gradlew tasks
  cd ..
  ```

### Android Permissions Configured

- [ ] Camera permission in AndroidManifest.xml
- [ ] Location permission in AndroidManifest.xml
- [ ] ARCore feature in AndroidManifest.xml

### Android API Keys (Optional)

- [ ] Google Maps API key added to AndroidManifest.xml

## ✅ iOS Setup (for iOS builds, macOS only)

- [ ] Xcode installed (latest stable version)
- [ ] Xcode command line tools installed
  ```bash
  xcode-select --install
  ```

- [ ] CocoaPods installed
  ```bash
  pod --version
  ```

- [ ] iOS dependencies installed
  ```bash
  cd ios
  pod install
  cd ..
  ```

- [ ] Xcode workspace present: `ios/Runner.xcworkspace`

### iOS Permissions Configured

- [ ] Camera usage description in Info.plist
- [ ] Location usage description in Info.plist

### iOS API Keys (Optional)

- [ ] Google Maps API key added to AppDelegate.swift

### iOS Signing

- [ ] Development team selected in Xcode
- [ ] Provisioning profile configured
- [ ] Bundle identifier updated (if needed)

## ✅ Build Verification

### Android Build Test

- [ ] Debug APK builds successfully
  ```bash
  flutter build apk --debug
  ```

- [ ] Release APK builds successfully (optional)
  ```bash
  flutter build apk --release
  ```

### iOS Build Test (macOS only)

- [ ] Debug build succeeds
  ```bash
  flutter build ios --debug --no-codesign
  ```

- [ ] Simulator build succeeds
  ```bash
  flutter build ios --simulator
  ```

### Web Build Test

- [ ] Web build succeeds
  ```bash
  flutter build web
  ```

## ✅ Run Verification

- [ ] App runs on Android device/emulator
  ```bash
  flutter run
  # Select Android device
  ```

- [ ] App runs on iOS simulator/device (macOS only)
  ```bash
  flutter run
  # Select iOS device
  ```

- [ ] App runs in web browser
  ```bash
  flutter run -d chrome
  ```

## ✅ Testing

- [ ] Unit tests pass
  ```bash
  flutter test
  ```

- [ ] No test errors or warnings

## ✅ Final Checks

- [ ] App launches without crashes
- [ ] Permissions screen appears on first launch
- [ ] Camera access works
- [ ] Location access works
- [ ] AR view renders correctly
- [ ] Flight data loads

## Troubleshooting

If any checks fail, refer to:

- [SETUP.md](../../SETUP.md) - Complete setup instructions
- [BUILD.md](../../BUILD.md) - Detailed build guide
- [README.md](README.md) - App-specific documentation

### Common Issues

**"Flutter command not found"**
- Install Flutter: https://docs.flutter.dev/get-started/install

**"Platform directories missing"**
- Run: `flutter create --platforms=android,ios,web .`

**"Dependency errors"**
- Run: `flutter clean && flutter pub get`

**"Gradle sync failed"**
- Open `android/` in Android Studio and sync manually

**"Pod install failed"**
- Run: `cd ios && pod deintegrate && pod install && cd ..`

**"Build failed with errors"**
- Run: `flutter clean && flutter pub get && flutter build <platform>`

---

## Ready to Build?

Once all checks pass, you're ready to build:

```bash
# Android
flutter build apk --release

# iOS (macOS only)
flutter build ios --release

# Web
flutter build web --release
```

See [BUILD.md](../../BUILD.md) for advanced build options and deployment.
