#!/bin/bash

# Setup script for Android signing keys
# This script helps generate the signing keys needed for publishing to Google Play Store

set -e

echo "🔑 Android App Signing Setup for Tile Fusion 2048"
echo "================================================="
echo ""

# Check if keytool is available
if ! command -v keytool &> /dev/null; then
    echo "❌ keytool is not installed or not in PATH"
    echo "keytool comes with Java JDK. Please install Java JDK first."
    exit 1
fi

KEYSTORE_PATH="android/upload-keystore.jks"
KEY_PROPERTIES_PATH="android/key.properties"

# Check if keystore already exists
if [[ -f "$KEYSTORE_PATH" ]]; then
    echo "⚠️  Keystore already exists at $KEYSTORE_PATH"
    read -p "Do you want to create a new keystore? This will overwrite the existing one. (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

echo "Creating upload keystore for Google Play Store..."
echo ""

# Prompt for keystore details
echo "Please provide the following information for your keystore:"
read -p "Key alias (default: upload): " KEY_ALIAS
KEY_ALIAS=${KEY_ALIAS:-upload}

read -s -p "Keystore password: " STORE_PASSWORD
echo
read -s -p "Confirm keystore password: " STORE_PASSWORD_CONFIRM
echo

if [[ "$STORE_PASSWORD" != "$STORE_PASSWORD_CONFIRM" ]]; then
    echo "❌ Passwords do not match!"
    exit 1
fi

read -s -p "Key password (can be same as keystore password): " KEY_PASSWORD
echo

echo ""
echo "Certificate information:"
read -p "First and last name: " CN
read -p "Organizational unit: " OU
read -p "Organization: " O
read -p "City or locality: " L
read -p "State or province: " ST
read -p "Country code (2 letters): " C

# Generate the keystore
echo ""
echo "🔧 Generating keystore..."

keytool -genkey \
    -v \
    -keystore "$KEYSTORE_PATH" \
    -alias "$KEY_ALIAS" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -storepass "$STORE_PASSWORD" \
    -keypass "$KEY_PASSWORD" \
    -dname "CN=$CN, OU=$OU, O=$O, L=$L, ST=$ST, C=$C"

# Create key.properties file
echo ""
echo "📝 Creating key.properties file..."

cat > "$KEY_PROPERTIES_PATH" << EOF
storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=../upload-keystore.jks
EOF

echo ""
echo "✅ Setup completed successfully!"
echo ""
echo "📁 Created files:"
echo "   Keystore: $KEYSTORE_PATH"
echo "   Properties: $KEY_PROPERTIES_PATH"
echo ""
echo "⚠️  IMPORTANT SECURITY NOTES:"
echo "   1. Keep your keystore file safe and backed up securely"
echo "   2. Never commit key.properties or keystore files to version control"
echo "   3. Store passwords in a secure password manager"
echo "   4. If you lose your keystore, you cannot update your app on Play Store"
echo ""
echo "💡 Next steps:"
echo "   1. Run './scripts/build_android.sh' to build your app"
echo "   2. Upload the generated .aab file to Google Play Console"
echo ""