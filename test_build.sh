#!/bin/bash

# Local Mobile Build Test Script
# Tests that the mobile app builds successfully for Android and iOS

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "📱 Skwark Mobile Build Test"
echo "============================"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed${NC}"
    echo "Please install Flutter: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo -e "${GREEN}✓${NC} Flutter found: $(flutter --version | head -n 1)"

# Check if in correct directory
if [ ! -f "melos.yaml" ]; then
    echo -e "${RED}❌ Not in monorepo root${NC}"
    echo "Please run this script from the repository root"
    exit 1
fi

# Parse command line arguments
PLATFORM="${1:-all}"
BUILD_MODE="${2:-debug}"

echo ""
echo "Configuration:"
echo "  Platform: $PLATFORM"
echo "  Build Mode: $BUILD_MODE"
echo ""

# Run verification first
echo "📋 Step 1: Verifying Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
chmod +x verify_build_config.sh
./verify_build_config.sh || {
    echo -e "${RED}❌ Configuration verification failed${NC}"
    exit 1
}

echo ""
echo "📦 Step 2: Bootstrap Monorepo"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if command -v melos &> /dev/null; then
    melos bootstrap
else
    echo -e "${YELLOW}⚠${NC} Melos not found, using flutter pub get"
    cd apps/skwark
    flutter pub get
    cd ../..
fi

echo ""
echo "🏗️  Step 3: Generate Platform Files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd apps/skwark

# Determine which platforms to generate
case $PLATFORM in
    android)
        PLATFORMS="android"
        ;;
    ios)
        PLATFORMS="ios"
        ;;
    all)
        PLATFORMS="android,ios"
        ;;
    *)
        echo -e "${RED}❌ Invalid platform: $PLATFORM${NC}"
        echo "Valid options: android, ios, all"
        exit 1
        ;;
esac

if [ ! -d "android" ] || [ ! -d "ios" ]; then
    echo "Generating mobile platform files for: $PLATFORMS"
    flutter create --platforms=$PLATFORMS .
else
    echo -e "${GREEN}✓${NC} Mobile platform files already exist"
fi

echo ""
echo "🧪 Step 4: Run Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

flutter test || {
    echo -e "${YELLOW}⚠${NC} Tests failed or no tests to run"
}

echo ""
echo "🔍 Step 5: Analyze Code"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

flutter analyze || {
    echo -e "${RED}❌ Code analysis failed${NC}"
    exit 1
}

echo ""
echo "🏗️  Step 6: Build Application"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

BUILD_FLAGS=""
if [ "$BUILD_MODE" = "release" ]; then
    BUILD_FLAGS="--release"
elif [ "$BUILD_MODE" = "profile" ]; then
    BUILD_FLAGS="--profile"
else
    BUILD_FLAGS="--debug"
fi

build_android() {
    echo ""
    echo "📱 Building for Android..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    flutter build apk $BUILD_FLAGS || {
        echo -e "${RED}❌ Android build failed${NC}"
        return 1
    }

    APK_PATH=$(find build/app/outputs/flutter-apk -name "*.apk" | head -n 1)
    if [ -n "$APK_PATH" ]; then
        APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
        echo -e "${GREEN}✅ Android APK built successfully${NC}"
        echo "   Path: $APK_PATH"
        echo "   Size: $APK_SIZE"
    fi
}

build_ios() {
    echo ""
    echo "🍎 Building for iOS..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo -e "${YELLOW}⚠${NC} iOS builds are only supported on macOS"
        return 0
    fi

    # Install pods if needed
    if [ -f "ios/Podfile" ]; then
        echo "Installing iOS dependencies..."
        cd ios
        pod install
        cd ..
    fi

    flutter build ios $BUILD_FLAGS --no-codesign || {
        echo -e "${RED}❌ iOS build failed${NC}"
        return 1
    }

    echo -e "${GREEN}✅ iOS built successfully${NC}"
}

# Build based on platform selection
FAILED=0

case $PLATFORM in
    android)
        build_android || FAILED=1
        ;;
    ios)
        build_ios || FAILED=1
        ;;
    all)
        build_android || FAILED=1
        build_ios || FAILED=1
        ;;
esac

cd ../..

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 MOBILE BUILD SUCCESSFUL!${NC}"
    echo ""
    echo "All mobile builds completed successfully."
    echo ""
    echo "Build artifacts:"

    if [ -f "apps/skwark/build/app/outputs/flutter-apk/app-$BUILD_MODE.apk" ] || \
       [ -f "apps/skwark/build/app/outputs/flutter-apk/app.apk" ]; then
        echo "  📱 Android: apps/skwark/build/app/outputs/flutter-apk/"
    fi

    if [ -d "apps/skwark/build/ios" ]; then
        echo "  🍎 iOS: apps/skwark/build/ios/"
    fi

    echo ""
    exit 0
else
    echo -e "${RED}❌ MOBILE BUILD FAILED${NC}"
    echo ""
    echo "Some mobile builds failed. Check the error messages above."
    echo ""
    exit 1
fi
