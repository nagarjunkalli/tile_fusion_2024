#!/bin/bash

# Build script for Android APK and App Bundle
# This script builds both debug and release versions of the app

set -e

echo "🚀 Starting Tile Fusion 2048 Android build process..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter from https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check if Android SDK is properly configured
if ! flutter doctor --android-licenses > /dev/null 2>&1; then
    echo "⚠️  Android SDK not properly configured"
    echo "Run 'flutter doctor' to check your setup"
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Generate icons
echo "🎨 Generating app icons..."
flutter pub run flutter_launcher_icons:main

# Build APK (for testing and sideloading)
echo "📱 Building APK for testing..."
flutter build apk --release

# Build App Bundle (for Play Store)
echo "📦 Building App Bundle for Play Store..."
flutter build appbundle --release

echo ""
echo "✅ Build completed successfully!"
echo ""
echo "📁 Output files:"
echo "   APK: build/app/outputs/flutter-apk/app-release.apk"
echo "   App Bundle: build/app/outputs/bundle/release/app-release.aab"
echo ""
echo "💡 Next steps:"
echo "   1. Test the APK on your device"
echo "   2. Upload the App Bundle (.aab) to Google Play Console"
echo ""