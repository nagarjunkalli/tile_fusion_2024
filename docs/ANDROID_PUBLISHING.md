# Android Publishing Guide for Tile Fusion 2048

This guide provides comprehensive instructions for building and publishing the Tile Fusion 2048 Flutter app to the Google Play Store.

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.0 or later) - [Installation Guide](https://flutter.dev/docs/get-started/install)
- **Android Studio** with Android SDK
- **Java JDK** (8 or later)
- **Git** for version control

### Verify Your Setup

Run the following command to check your Flutter installation:

```bash
flutter doctor
```

All checkmarks should be green for Android development.

## 🔧 Initial Setup

### 1. Clone and Setup the Project

```bash
git clone https://github.com/nagarjunkalli/tile_fusion_2024.git
cd tile_fusion_2024
flutter pub get
```

### 2. Generate App Icons

```bash
flutter pub run flutter_launcher_icons:main
```

## 🔑 Signing Configuration

### Generate Signing Keys

For publishing to Google Play Store, you need to sign your app with a release key:

```bash
./scripts/setup_signing.sh
```

This script will:
- Generate a keystore file (`android/upload-keystore.jks`)
- Create a `key.properties` file with your signing configuration
- Guide you through the certificate information setup

**⚠️ Important Security Notes:**
- Keep your keystore file safe and backed up securely
- Never commit `key.properties` or keystore files to version control
- Store passwords in a secure password manager
- If you lose your keystore, you cannot update your app on Play Store

### Manual Signing Setup (Alternative)

If you prefer to set up signing manually:

1. Generate a keystore:
```bash
keytool -genkey -v -keystore android/upload-keystore.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000
```

2. Copy the template and fill in your details:
```bash
cp android/key.properties.template android/key.properties
# Edit android/key.properties with your keystore information
```

## 🏗️ Building the App

### Option 1: Use the Build Script (Recommended)

```bash
./scripts/build_android.sh
```

This script will:
- Clean previous builds
- Get dependencies
- Generate app icons
- Build both APK and App Bundle
- Show output file locations

### Option 2: Manual Build Commands

For APK (testing and sideloading):
```bash
flutter clean
flutter pub get
flutter build apk --release
```

For App Bundle (Google Play Store):
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

## 📁 Output Files

After building, you'll find:
- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **App Bundle**: `build/app/outputs/bundle/release/app-release.aab`

## 📱 Testing

### Install APK on Device

```bash
# Enable USB debugging on your Android device
flutter install
# or manually install the APK
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Test Release Build

```bash
flutter run --release
```

## 🚀 Publishing to Google Play Store

### 1. Google Play Console Setup

1. Create a [Google Play Console](https://play.google.com/console) account
2. Pay the one-time $25 registration fee
3. Create a new application

### 2. Prepare Store Listing

You'll need:
- App title: "Tile Fusion 2048"
- Short description (80 characters max)
- Full description (4000 characters max)
- Screenshots (phone, tablet, etc.)
- Feature graphic (1024 x 500 pixels)
- App icon (512 x 512 pixels)
- Privacy policy URL (if applicable)

### 3. Upload App Bundle

1. Go to "Release" → "Production" in Play Console
2. Click "Create new release"
3. Upload the `app-release.aab` file
4. Fill in release notes
5. Review and roll out

### 4. Review Process

- Google typically reviews apps within 1-3 days
- Ensure your app complies with [Play Policies](https://play.google.com/about/developer-content-policy/)

## 🤖 Automated Builds with GitHub Actions

This project includes a GitHub Actions workflow that automatically builds the app when you push to the main branch.

### Setup GitHub Secrets

To enable automatic building and deployment, add these secrets to your GitHub repository:

1. **KEYSTORE_BASE64**: Base64 encoded keystore file
   ```bash
   base64 -i android/upload-keystore.jks | pbcopy
   ```

2. **KEY_PROPERTIES**: Contents of your key.properties file
   ```
   storePassword=your_keystore_password
   keyPassword=your_key_password
   keyAlias=upload
   storeFile=../upload-keystore.jks
   ```

3. **GOOGLE_PLAY_SERVICE_ACCOUNT_JSON**: (Optional) For automatic Play Store deployment

### Workflow Features

- Builds APK for pull requests
- Builds signed App Bundle for main branch and tags
- Runs tests and code analysis
- Creates GitHub releases for tagged versions
- Optional automatic deployment to Play Store

## 🐛 Troubleshooting

### Common Issues

1. **"Keystore not found"**
   - Ensure `android/key.properties` exists and points to the correct keystore path
   - Verify the keystore file exists at the specified location

2. **"Flutter command not found"**
   - Add Flutter to your PATH: `export PATH="$PATH:[PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin"`

3. **"Android SDK not found"**
   - Install Android Studio and accept SDK licenses: `flutter doctor --android-licenses`

4. **Build failures**
   - Clean and rebuild: `flutter clean && flutter pub get`
   - Check `flutter doctor` for issues

### Version Management

Update version numbers in `pubspec.yaml`:
```yaml
version: 1.0.1+2  # 1.0.1 is the version name, 2 is the build number
```

## 📚 Additional Resources

- [Flutter Deployment Guide](https://flutter.dev/docs/deployment/android)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [Play Store Review Guidelines](https://developer.android.com/guide/playcore/in-app-review)

## 🏷️ App Configuration

Current configuration:
- **Package Name**: `com.tilefusion.game2048`
- **App Name**: "Tile Fusion 2048"
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: Latest stable

## 📄 License and Distribution

This app is configured for distribution through:
- Google Play Store (primary)
- Direct APK distribution (testing)
- GitHub Releases (backup)

---

For questions or issues, please create an issue in the GitHub repository.