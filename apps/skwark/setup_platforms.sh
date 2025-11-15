#!/bin/bash

# Skwark Platform Setup Script
# This script generates platform-specific files for Android, iOS, and other platforms

set -e

echo "🚀 Skwark Platform Setup"
echo "========================"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo ""
    echo "Please install Flutter first:"
    echo "  https://docs.flutter.dev/get-started/install"
    echo ""
    exit 1
fi

echo "✓ Flutter found: $(flutter --version | head -n 1)"
echo ""

# Check if we're in the correct directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ pubspec.yaml not found"
    echo "Please run this script from the apps/skwark directory"
    exit 1
fi

if [ ! -d "lib" ]; then
    echo "❌ lib directory not found"
    echo "Please run this script from the apps/skwark directory"
    exit 1
fi

echo "✓ Correct directory detected"
echo ""

# Generate platform files
echo "📱 Generating platform files..."
echo ""
echo "This will create:"
echo "  - android/    (Android Studio project)"
echo "  - ios/        (Xcode project)"
echo "  - web/        (Web platform)"
echo "  - linux/      (Linux platform)"
echo "  - macos/      (macOS platform)"
echo "  - windows/    (Windows platform)"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

flutter create --platforms=android,ios,web,linux,macos,windows .

echo ""
echo "✅ Platform files generated successfully!"
echo ""

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Configure Android: Open android/ in Android Studio"
echo "  2. Configure iOS: Open ios/Runner.xcworkspace in Xcode"
echo "  3. Add Google Maps API keys (see README.md)"
echo "  4. Run: flutter run"
echo ""
