# Build Testing Guide

This document describes how to verify that the Skwark app builds correctly using both local scripts and CI/CD.

## Quick Build Verification

### Verify Configuration

```bash
./verify_build_config.sh
```

This script checks:
- ✅ Monorepo structure
- ✅ App source files
- ✅ Configuration files (pubspec.yaml, melos.yaml)
- ✅ Documentation
- ✅ Setup scripts
- ⚠️  Platform files (warns if not generated)

### Validate YAML Files

```bash
python3 validate_yaml.py
```

Validates all YAML configuration files for syntax errors.

### Test Build Locally

```bash
# Test all platforms
./test_build.sh all debug

# Test specific platform
./test_build.sh android release
./test_build.sh ios debug
./test_build.sh web release
```

**Script Arguments:**
1. Platform: `android`, `ios`, `web`, or `all`
2. Build mode: `debug`, `profile`, or `release`

## Local Build Testing

### Prerequisites

Before running build tests, ensure you have:

- Flutter SDK (3.2.0+)
- Dart SDK
- Melos (install: `dart pub global activate melos`)
- Platform-specific tools:
  - **Android**: Android Studio, Android SDK
  - **iOS**: Xcode, CocoaPods (macOS only)
  - **Web**: Chrome browser

### Step-by-Step Build Test

1. **Verify configuration**:
   ```bash
   ./verify_build_config.sh
   ```

2. **Validate YAML**:
   ```bash
   python3 validate_yaml.py
   ```

3. **Bootstrap monorepo**:
   ```bash
   melos bootstrap
   ```

4. **Generate platform files**:
   ```bash
   cd apps/skwark
   flutter create --platforms=android,ios,web .
   cd ../..
   ```

5. **Run automated build test**:
   ```bash
   ./test_build.sh all debug
   ```

### Manual Build Testing

If you prefer manual testing:

```bash
cd apps/skwark

# Analyze
flutter analyze

# Test
flutter test

# Build Android
flutter build apk --debug
flutter build apk --release

# Build iOS (macOS only)
flutter build ios --debug --no-codesign
flutter build ios --release --no-codesign

# Build Web
flutter build web --debug
flutter build web --release

cd ../..
```

## CI/CD Build Testing

The repository includes two GitHub Actions workflows:

### 1. Full Build Workflow (`.github/workflows/build.yml`)

Runs on: `push` to main/develop/claude/*, and pull requests

**Jobs:**
- **verify-config**: Runs configuration verification
- **analyze**: Code analysis, formatting, and tests
- **build-android**: Builds Android APK (debug and release)
- **build-ios**: Builds iOS (no codesign)
- **build-web**: Builds for web
- **build-summary**: Summarizes all build results

**Artifacts:**
- Android APKs (debug and release)
- iOS build
- Web build

### 2. Quick Check Workflow (`.github/workflows/quick-check.yml`)

Runs on: All pushes and pull requests

**Quick checks:**
- Configuration verification
- Code analysis
- Formatting check
- Tests
- Android debug build

### Viewing CI/CD Results

1. **GitHub Actions Tab**:
   - Go to repository → Actions tab
   - View workflow runs and results

2. **Pull Request Checks**:
   - All workflows show as checks on PRs
   - Must pass before merging

3. **Build Artifacts**:
   - Download from workflow run page
   - Artifacts retained for 7 days

### Triggering CI/CD Builds

**Automatic triggers:**
```bash
# Push to main/develop
git push origin main

# Create pull request
gh pr create --base main

# Push to feature branch (runs quick-check)
git push origin feature/my-feature
```

**Manual trigger:**
- Go to Actions → Build and Test → Run workflow

## Build Verification Checklist

Before considering a build "verified":

- [ ] Configuration verification passes
  ```bash
  ./verify_build_config.sh
  ```

- [ ] YAML validation passes
  ```bash
  python3 validate_yaml.py
  ```

- [ ] Code analysis passes
  ```bash
  cd apps/skwark && flutter analyze && cd ../..
  ```

- [ ] All tests pass
  ```bash
  cd apps/skwark && flutter test && cd ../..
  ```

- [ ] Android build succeeds
  ```bash
  cd apps/skwark && flutter build apk && cd ../..
  ```

- [ ] iOS build succeeds (macOS only)
  ```bash
  cd apps/skwark && flutter build ios --no-codesign && cd ../..
  ```

- [ ] Web build succeeds
  ```bash
  cd apps/skwark && flutter build web && cd ../..
  ```

- [ ] CI/CD workflow passes
  - Check GitHub Actions results

## Troubleshooting Build Issues

### Configuration Errors

If `verify_build_config.sh` fails:

1. Check error messages for missing files
2. Ensure you're in the repository root
3. Verify all source files exist in `apps/skwark/lib/`
4. Generate platform files if warned

### YAML Syntax Errors

If `validate_yaml.py` fails:

1. Check the specific file mentioned
2. Look for indentation issues
3. Verify no tabs are used (use spaces)
4. Check for unclosed strings or missing colons

### Build Failures

**"Platform files not found":**
```bash
cd apps/skwark
flutter create --platforms=android,ios,web .
cd ../..
```

**"Dependency errors":**
```bash
melos clean
melos bootstrap
```

**"Gradle sync failed"** (Android):
```bash
cd apps/skwark/android
./gradlew clean
cd ../../..
flutter clean
flutter pub get
```

**"Pod install failed"** (iOS):
```bash
cd apps/skwark/ios
pod deintegrate
pod install
cd ../../..
```

**"Test failures":**
- Review test output
- Fix failing tests
- Ensure all dependencies are installed

### CI/CD Failures

1. **Check workflow logs**:
   - Go to Actions tab
   - Click on failed workflow
   - View log output

2. **Common CI issues**:
   - Timeout: Job took too long
   - Out of space: Build artifacts too large
   - Dependency conflict: Update pubspec.yaml

3. **Reproduce locally**:
   ```bash
   ./test_build.sh all release
   ```

## Build Performance

### Build Times (Approximate)

| Platform | Debug Build | Release Build |
|----------|-------------|---------------|
| Android  | 2-5 min     | 5-10 min      |
| iOS      | 3-6 min     | 6-12 min      |
| Web      | 1-3 min     | 3-6 min       |

*Times vary based on hardware and cached dependencies*

### Optimizing Build Performance

**Local builds:**
```bash
# Use cached builds
flutter build apk --release

# Skip build number increment
flutter build apk --release --build-number=1

# Use split ABIs (smaller APKs)
flutter build apk --split-per-abi
```

**CI/CD optimization:**
- Uses caching for Flutter SDK and dependencies
- Parallel jobs for different platforms
- Artifact retention set to 7 days

## Continuous Integration Best Practices

1. **Always run locally first**:
   ```bash
   ./test_build.sh all release
   ```

2. **Keep builds fast**:
   - Quick check workflow runs on every push
   - Full build only on main/develop

3. **Monitor CI/CD usage**:
   - Check Actions usage in repository settings
   - Optimize if approaching limits

4. **Review build artifacts**:
   - Download and test APKs locally
   - Verify app functionality

## Additional Resources

- [BUILD.md](BUILD.md) - Detailed build instructions
- [SETUP.md](SETUP.md) - Initial setup guide
- [CHECKLIST.md](apps/skwark/CHECKLIST.md) - Pre-build checklist
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter Build Documentation](https://docs.flutter.dev/deployment)

---

## Quick Reference

```bash
# Verify everything is ready
./verify_build_config.sh && python3 validate_yaml.py

# Test full build pipeline
./test_build.sh all release

# Test specific platform
./test_build.sh android debug
./test_build.sh ios release
./test_build.sh web debug

# Run what CI runs
melos bootstrap
cd apps/skwark
flutter create --platforms=android .
flutter analyze
flutter test
flutter build apk --debug
```
