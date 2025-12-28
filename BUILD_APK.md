# Building APK for Student Governance App

## Prerequisites

1. **Install Flutter**: Make sure Flutter is installed and configured
   ```bash
   flutter doctor
   ```

2. **Install Android Studio**: Required for Android SDK and build tools

3. **Accept Android Licenses**:
   ```bash
   flutter doctor --android-licenses
   ```

## Build Commands

### Option 1: Build Debug APK (for testing)
```bash
cd flutter
flutter build apk --debug
```

The APK will be located at:
`flutter/build/app/outputs/flutter-apk/app-debug.apk`

### Option 2: Build Release APK (for production)
```bash
cd flutter
flutter build apk --release
```

The APK will be located at:
`flutter/build/app/outputs/flutter-apk/app-release.apk`

### Option 3: Build Split APKs (smaller file size)
```bash
cd flutter
flutter build apk --split-per-abi
```

This creates separate APKs for different architectures:
- `app-armeabi-v7a-release.apk` (32-bit)
- `app-arm64-v8a-release.apk` (64-bit)
- `app-x86_64-release.apk` (x86_64)

## Installation Steps

1. **Transfer APK to your phone**:
   - Connect phone via USB
   - Copy APK to phone storage
   - OR use `adb install app-release.apk`

2. **Enable Unknown Sources** (if needed):
   - Go to Settings > Security
   - Enable "Install from Unknown Sources"

3. **Install APK**:
   - Open file manager on phone
   - Navigate to APK location
   - Tap to install

## Quick Build Script

Create a file `build_apk.bat` (Windows) or `build_apk.sh` (Linux/Mac):

**Windows (build_apk.bat):**
```batch
@echo off
cd flutter
flutter clean
flutter pub get
flutter build apk --release
echo APK built successfully!
echo Location: flutter\build\app\outputs\flutter-apk\app-release.apk
pause
```

**Linux/Mac (build_apk.sh):**
```bash
#!/bin/bash
cd flutter
flutter clean
flutter pub get
flutter build apk --release
echo "APK built successfully!"
echo "Location: flutter/build/app/outputs/flutter-apk/app-release.apk"
```

## Troubleshooting

### If build fails:
1. Run `flutter clean`
2. Run `flutter pub get`
3. Check `flutter doctor` for issues
4. Ensure Android SDK is properly installed

### If app crashes on startup:
- Check API base URL in `lib/services/api_service.dart`
- Ensure backend is accessible
- Check network permissions in AndroidManifest.xml

## Notes

- The release APK is signed with a debug key (for testing)
- For production, you'll need to create a signing key
- Minimum Android version: 5.0 (API 21)
- Target Android version: 14 (API 34)

