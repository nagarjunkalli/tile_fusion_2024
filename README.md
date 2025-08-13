# Tile Fusion 2048

A modern and engaging 2048 puzzle game built with Flutter, featuring smooth animations and beautiful design.

## 🎮 About

Tile Fusion 2048 is a sleek implementation of the classic 2048 puzzle game. Challenge yourself to reach the 2048 tile by combining matching numbers in this addictive puzzle game.

## ✨ Features

- **Smooth Animations**: Fluid tile movements and transitions
- **Beautiful Design**: Modern UI with polished graphics
- **Local Storage**: Your high scores are saved locally
- **Cross Platform**: Runs on Android, iOS, Web, and Desktop
- **Responsive**: Adapts to different screen sizes

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.0 or later)
- [Android Studio](https://developer.android.com/studio) (for Android development)
- [Xcode](https://developer.apple.com/xcode/) (for iOS development, macOS only)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/nagarjunkalli/tile_fusion_2024.git
cd tile_fusion_2024
```

2. Get dependencies:
```bash
flutter pub get
```

3. Generate app icons:
```bash
flutter pub run flutter_launcher_icons:main
```

4. Run the app:
```bash
flutter run
```

## 📱 Publishing

### Android

For detailed instructions on building and publishing the Android app to Google Play Store, see our comprehensive guide:

**[📖 Android Publishing Guide](docs/ANDROID_PUBLISHING.md)**

#### Quick Start

1. **Setup signing keys:**
   ```bash
   ./scripts/setup_signing.sh
   ```

2. **Build the app:**
   ```bash
   ./scripts/build_android.sh
   ```

3. **Upload to Play Store:**
   - Upload the generated `app-release.aab` file to Google Play Console
   - Follow the store listing guidelines in our documentation

#### Automated Builds

This project includes GitHub Actions for automated building:
- Builds APK for pull requests
- Creates signed App Bundle for releases
- Automatic deployment to Play Store (with proper secrets configured)

### iOS

For iOS publishing (coming soon):
- App Store deployment configuration
- TestFlight distribution setup
- iOS-specific build scripts

## 🛠️ Development

### Project Structure

```
lib/
├── main.dart              # App entry point
├── models/               # Data models
├── screens/              # App screens
├── widgets/              # Reusable UI components
└── utils/                # Utility functions

android/
├── app/
│   ├── build.gradle      # Android build configuration
│   └── src/main/         # Android-specific code
└── key.properties        # Signing configuration (not in repo)

scripts/
├── build_android.sh      # Android build script
└── setup_signing.sh      # Signing setup script
```

### Running Tests

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

## 🏗️ Building for Production

### Android APK (for testing)
```bash
flutter build apk --release
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### iOS (macOS only)
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 📦 Dependencies

- `flutter`: SDK
- `cupertino_icons`: iOS-style icons
- `shared_preferences`: Local storage
- `url_launcher`: External URL handling
- `flutter_launcher_icons`: App icon generation

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 Roadmap

- [ ] iOS App Store deployment
- [ ] Web deployment to GitHub Pages
- [ ] Multiple difficulty levels
- [ ] Online leaderboards
- [ ] Custom themes
- [ ] Sound effects and music
- [ ] Multiplayer mode

## 📞 Support

If you encounter any issues or have questions:
- Create an [Issue](https://github.com/nagarjunkalli/tile_fusion_2024/issues)
- Check our [Android Publishing Guide](docs/ANDROID_PUBLISHING.md)
- Review the [Flutter Documentation](https://flutter.dev/docs)

---

**Happy Gaming! 🎮**
