# Building APK with SSG Logo

## Quick Build (Recommended)

Simply run the build script:
```bash
build_apk.bat
```

This will:
1. Clean previous builds
2. Get dependencies
3. Generate app icons from SSG logo
4. Build the release APK

## Manual Build Steps

1. **Generate Icons** (uses SSG logo):
   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons
   ```

2. **Build APK**:
   ```bash
   flutter build apk --release
   ```

## APK Location

After building, find your APK at:
```
flutter\build\app\outputs\flutter-apk\app-release.apk
```

## Installation

1. Transfer the APK to your Android phone
2. Enable "Install from Unknown Sources" in Settings
3. Tap the APK file to install
4. The app will appear with the SSG logo as the icon

## Notes

- The SSG logo is automatically used as the app icon
- Minimum Android version: 5.0 (API 21)
- The app connects to: https://gray-dotterel-737970.hostingersite.com

