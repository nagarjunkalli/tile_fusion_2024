#!/bin/bash

# Verification script to check if the Android publishing setup is correct
# Run this script to verify all configuration files are in place

set -e

echo "🔍 Verifying Android Publishing Setup for Tile Fusion 2048"
echo "=========================================================="
echo ""

# Check if we're in the right directory
if [[ ! -f "pubspec.yaml" ]]; then
    echo "❌ pubspec.yaml not found. Please run this script from the project root."
    exit 1
fi

echo "✅ Project root directory confirmed"

# Check Flutter project files
echo ""
echo "📋 Checking Flutter configuration..."

if [[ -f "pubspec.yaml" ]]; then
    echo "✅ pubspec.yaml found"
    
    # Check app name and version
    APP_NAME=$(grep "^name:" pubspec.yaml | cut -d' ' -f2)
    VERSION=$(grep "^version:" pubspec.yaml | cut -d' ' -f2)
    echo "   App name: $APP_NAME"
    echo "   Version: $VERSION"
else
    echo "❌ pubspec.yaml not found"
fi

# Check Android configuration
echo ""
echo "🤖 Checking Android configuration..."

if [[ -f "android/app/build.gradle" ]]; then
    echo "✅ android/app/build.gradle found"
    
    # Check application ID
    APP_ID=$(grep "applicationId" android/app/build.gradle | cut -d'"' -f2)
    echo "   Application ID: $APP_ID"
    
    # Check if signing configuration is present
    if grep -q "signingConfigs" android/app/build.gradle; then
        echo "✅ Signing configuration found in build.gradle"
    else
        echo "❌ Signing configuration not found in build.gradle"
    fi
else
    echo "❌ android/app/build.gradle not found"
fi

if [[ -f "android/app/src/main/AndroidManifest.xml" ]]; then
    echo "✅ AndroidManifest.xml found"
else
    echo "❌ AndroidManifest.xml not found"
fi

if [[ -f "android/app/proguard-rules.pro" ]]; then
    echo "✅ ProGuard rules found"
else
    echo "❌ ProGuard rules not found"
fi

# Check signing setup
echo ""
echo "🔑 Checking signing configuration..."

if [[ -f "android/key.properties.template" ]]; then
    echo "✅ key.properties template found"
else
    echo "❌ key.properties template not found"
fi

if [[ -f "android/key.properties" ]]; then
    echo "✅ key.properties found (ready for release builds)"
else
    echo "⚠️  key.properties not found (run ./scripts/setup_signing.sh to create)"
fi

if [[ -f "android/upload-keystore.jks" ]]; then
    echo "✅ Keystore file found"
else
    echo "⚠️  Keystore file not found (run ./scripts/setup_signing.sh to create)"
fi

# Check scripts
echo ""
echo "📜 Checking build scripts..."

if [[ -f "scripts/build_android.sh" ]] && [[ -x "scripts/build_android.sh" ]]; then
    echo "✅ Android build script found and executable"
else
    echo "❌ Android build script not found or not executable"
fi

if [[ -f "scripts/setup_signing.sh" ]] && [[ -x "scripts/setup_signing.sh" ]]; then
    echo "✅ Signing setup script found and executable"
else
    echo "❌ Signing setup script not found or not executable"
fi

# Check GitHub Actions
echo ""
echo "🤖 Checking CI/CD configuration..."

if [[ -f ".github/workflows/android-build.yml" ]]; then
    echo "✅ GitHub Actions workflow found"
else
    echo "❌ GitHub Actions workflow not found"
fi

# Check documentation
echo ""
echo "📚 Checking documentation..."

if [[ -f "docs/ANDROID_PUBLISHING.md" ]]; then
    echo "✅ Android publishing documentation found"
else
    echo "❌ Android publishing documentation not found"
fi

if [[ -f "README.md" ]]; then
    echo "✅ README.md found"
else
    echo "❌ README.md not found"
fi

# Check .gitignore
echo ""
echo "🙈 Checking .gitignore configuration..."

if [[ -f ".gitignore" ]]; then
    if grep -q "key.properties" .gitignore; then
        echo "✅ key.properties is properly ignored"
    else
        echo "❌ key.properties should be added to .gitignore"
    fi
    
    if grep -q "upload-keystore.jks" .gitignore; then
        echo "✅ Keystore files are properly ignored"
    else
        echo "❌ Keystore files should be added to .gitignore"
    fi
else
    echo "❌ .gitignore not found"
fi

# Summary
echo ""
echo "📋 Setup Summary"
echo "================"

READY_FOR_DEVELOPMENT=true
READY_FOR_RELEASE=true

if [[ ! -f "pubspec.yaml" ]] || [[ ! -f "android/app/build.gradle" ]]; then
    READY_FOR_DEVELOPMENT=false
fi

if [[ ! -f "android/key.properties" ]] || [[ ! -f "android/upload-keystore.jks" ]]; then
    READY_FOR_RELEASE=false
fi

if [[ "$READY_FOR_DEVELOPMENT" == true ]]; then
    echo "✅ Ready for development and testing"
else
    echo "❌ Not ready for development - missing core files"
fi

if [[ "$READY_FOR_RELEASE" == true ]]; then
    echo "✅ Ready for release builds and publishing"
else
    echo "⚠️  Not ready for release - missing signing configuration"
    echo "   Run: ./scripts/setup_signing.sh"
fi

echo ""
echo "💡 Next steps:"
if [[ "$READY_FOR_RELEASE" == false ]]; then
    echo "   1. Run './scripts/setup_signing.sh' to set up signing"
    echo "   2. Run './scripts/build_android.sh' to build the app"
else
    echo "   1. Run './scripts/build_android.sh' to build the app"
    echo "   2. Upload the .aab file to Google Play Console"
fi

echo "   3. See docs/ANDROID_PUBLISHING.md for detailed instructions"
echo ""