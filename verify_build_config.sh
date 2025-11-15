#!/bin/bash

# Build Configuration Verification Script
# Verifies that all necessary files and configurations are in place for building

set -e

echo "🔍 Skwark Build Configuration Verification"
echo "=========================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Function to check file existence
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} Found: $1"
        return 0
    else
        echo -e "${RED}✗${NC} Missing: $1"
        ((ERRORS++))
        return 1
    fi
}

# Function to check directory existence
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} Found: $1"
        return 0
    else
        echo -e "${YELLOW}⚠${NC} Missing: $1"
        ((WARNINGS++))
        return 1
    fi
}

# Function to check file contains string
check_contains() {
    if grep -q "$2" "$1" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $1 contains: $2"
        return 0
    else
        echo -e "${RED}✗${NC} $1 missing: $2"
        ((ERRORS++))
        return 1
    fi
}

echo "📋 Checking Monorepo Structure"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

check_file "melos.yaml"
check_file "pubspec.yaml"
check_dir "apps"
check_dir "apps/skwark"
check_dir "packages"

echo ""
echo "📱 Checking App Structure"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd apps/skwark

check_file "pubspec.yaml"
check_file "analysis_options.yaml"
check_file ".metadata"
check_dir "lib"
check_dir "test"

echo ""
echo "📦 Checking Core Source Files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

check_file "lib/main.dart"
check_file "lib/core/theme/app_theme.dart"
check_file "lib/features/ar_view/screens/ar_view_screen.dart"
check_file "lib/features/onboarding/screens/permissions_gate_screen.dart"
check_file "lib/features/plane_profile/screens/plane_profile_screen.dart"
check_file "lib/shared/models/flight.dart"
check_file "lib/shared/models/aircraft.dart"
check_file "lib/shared/services/flight_data_service.dart"
check_file "lib/shared/services/location_service.dart"

echo ""
echo "🧪 Checking Test Files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

check_file "test/widget_test.dart"

echo ""
echo "⚙️  Validating pubspec.yaml"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "pubspec.yaml" ]; then
    # Check for required fields
    check_contains "pubspec.yaml" "name: skwark"
    check_contains "pubspec.yaml" "flutter:"
    check_contains "pubspec.yaml" "sdk: flutter"

    # Check for key dependencies
    check_contains "pubspec.yaml" "camera:"
    check_contains "pubspec.yaml" "geolocator:"
    check_contains "pubspec.yaml" "flutter_bloc:"
    check_contains "pubspec.yaml" "google_maps_flutter:"

    # Verify no invalid asset references
    if grep -q "assets:" pubspec.yaml | grep -v "#"; then
        if ! grep -q "# assets:" pubspec.yaml; then
            echo -e "${YELLOW}⚠${NC} Active asset references found - ensure asset directories exist"
            ((WARNINGS++))
        fi
    fi
fi

echo ""
echo "🔧 Checking Platform Files (Optional)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if check_dir "android"; then
    check_file "android/build.gradle"
    check_file "android/app/build.gradle"
    check_file "android/app/src/main/AndroidManifest.xml"
    check_file "android/settings.gradle"
else
    echo -e "${BLUE}ℹ${NC} Platform files not generated yet"
    echo -e "${BLUE}ℹ${NC} Run: flutter create --platforms=android,ios,web ."
fi

if check_dir "ios"; then
    check_file "ios/Podfile"
    check_file "ios/Runner/Info.plist"
    check_dir "ios/Runner.xcodeproj"
fi

if ! [ -d "android" ] && ! [ -d "ios" ]; then
    echo ""
    echo -e "${YELLOW}⚠${NC} No platform files found"
    echo -e "${BLUE}ℹ${NC} Generate them with: flutter create --platforms=android,ios,web ."
fi

cd ../..

echo ""
echo "📄 Checking Documentation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

check_file "README.md"
check_file "SETUP.md"
check_file "BUILD.md"
check_file "apps/skwark/README.md"
check_file "apps/skwark/CHECKLIST.md"

echo ""
echo "🚀 Checking Setup Scripts"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

check_file "setup.sh"
check_file "apps/skwark/setup_platforms.sh"

# Check if scripts are executable
if [ -x "setup.sh" ]; then
    echo -e "${GREEN}✓${NC} setup.sh is executable"
else
    echo -e "${YELLOW}⚠${NC} setup.sh is not executable (run: chmod +x setup.sh)"
    ((WARNINGS++))
fi

if [ -x "apps/skwark/setup_platforms.sh" ]; then
    echo -e "${GREEN}✓${NC} setup_platforms.sh is executable"
else
    echo -e "${YELLOW}⚠${NC} setup_platforms.sh is not executable"
    ((WARNINGS++))
fi

echo ""
echo "📊 Validation Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ Perfect! All checks passed.${NC}"
    echo ""
    echo "Your build configuration is ready!"
    echo ""
    echo "Next steps:"
    echo "  1. Generate platform files: cd apps/skwark && flutter create --platforms=android,ios,web ."
    echo "  2. Build for Android: flutter build apk"
    echo "  3. Build for iOS: flutter build ios"
    echo "  4. Build for Web: flutter build web"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Warnings: $WARNINGS${NC}"
    echo -e "${GREEN}✓ Errors: $ERRORS${NC}"
    echo ""
    echo "Build configuration is mostly ready, but some optional items are missing."
    echo "Review warnings above and generate platform files if needed."
    exit 0
else
    echo -e "${RED}✗ Errors: $ERRORS${NC}"
    echo -e "${YELLOW}⚠ Warnings: $WARNINGS${NC}"
    echo ""
    echo "Build configuration has errors. Please fix the issues above."
    exit 1
fi
