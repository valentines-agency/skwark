#!/bin/bash

# Skwark Monorepo Quick Setup Script
# This script automates the entire setup process

set -e

echo "✈️  Skwark Monorepo Setup"
echo "========================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Flutter is installed
echo "Checking prerequisites..."
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
    echo ""
    echo "Please install Flutter first:"
    echo "  https://docs.flutter.dev/get-started/install"
    echo ""
    exit 1
fi
echo -e "${GREEN}✓${NC} Flutter found: $(flutter --version | head -n 1)"

# Check if Dart is installed (comes with Flutter)
if ! command -v dart &> /dev/null; then
    echo -e "${RED}❌ Dart is not installed or not in PATH${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC} Dart found: $(dart --version 2>&1 | head -n 1)"

# Check if Melos is installed
if ! command -v melos &> /dev/null; then
    echo -e "${YELLOW}⚠${NC}  Melos not found. Installing..."
    dart pub global activate melos
    export PATH="$PATH":"$HOME/.pub-cache/bin"

    if ! command -v melos &> /dev/null; then
        echo -e "${YELLOW}⚠${NC}  Melos installed but not in PATH"
        echo "Please add Dart's global bin to your PATH:"
        echo "  export PATH=\"\$PATH\":\"\$HOME/.pub-cache/bin\""
        echo ""
        echo "Or add to your shell profile (~/.bashrc, ~/.zshrc):"
        echo "  echo 'export PATH=\"\$PATH\":\"\$HOME/.pub-cache/bin\"' >> ~/.bashrc"
        echo ""
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
else
    echo -e "${GREEN}✓${NC} Melos found: $(melos --version)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Step 1: Bootstrap the monorepo
echo "📦 Step 1: Bootstrap monorepo"
echo "This will install dependencies and link packages..."
echo ""
melos bootstrap

echo ""
echo -e "${GREEN}✓${NC} Monorepo bootstrapped successfully"
echo ""

# Step 2: Generate platform files
echo "📱 Step 2: Generate platform files"
echo "This will create Android, iOS, and Web platform files..."
echo ""

cd apps/skwark

# Check if platforms already exist
if [ -d "android" ] && [ -d "ios" ]; then
    echo -e "${YELLOW}⚠${NC}  Platform directories already exist"
    read -p "Regenerate? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping platform generation"
        cd ../..
    else
        flutter create --platforms=android,ios,web .
        cd ../..
        echo ""
        echo -e "${GREEN}✓${NC} Platform files regenerated"
    fi
else
    flutter create --platforms=android,ios,web .
    cd ../..
    echo ""
    echo -e "${GREEN}✓${NC} Platform files generated"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${GREEN}🎉 Setup complete!${NC}"
echo ""
echo "Next steps:"
echo ""
echo "  1. Configure Google Maps API keys (optional)"
echo "     See: apps/skwark/README.md"
echo ""
echo "  2. Run the app:"
echo "     ${YELLOW}melos run run:app${NC}"
echo "     or"
echo "     ${YELLOW}cd apps/skwark && flutter run${NC}"
echo ""
echo "  3. Open in IDE:"
echo "     - Android Studio: Open apps/skwark/android"
echo "     - Xcode: Open apps/skwark/ios/Runner.xcworkspace"
echo "     - VS Code: Open the root directory"
echo ""
echo "For more details, see: ${YELLOW}SETUP.md${NC}"
echo ""
