# Automatic Download Instructions

I cannot directly download files to your computer, but I've created a helper script that will open the download pages for you.

## Quick Setup

1. **Run the download helper:**
   ```bash
   download_setup.bat
   ```
   This will open both download pages in your browser.

2. **Download Flutter:**
   - Click the download link on the Flutter page
   - Save the ZIP file (about 1.5 GB)
   - Extract to `C:\src\flutter`

3. **Download Android Studio:**
   - Click the download button on Android Studio page
   - Run the installer (about 1 GB)
   - Follow the installation wizard

## Manual Download Links

If the script doesn't work, use these direct links:

### Flutter SDK
- **Direct Download:** https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.5-stable.zip
- **Or visit:** https://docs.flutter.dev/get-started/install/windows

### Android Studio
- **Direct Download:** https://redirector.gvt1.com/edgedl/android/studio/install/2023.3.1.20/android-studio-2023.3.1.20-windows.exe
- **Or visit:** https://developer.android.com/studio

## After Downloading

### Install Flutter:
1. Extract the ZIP to `C:\src\flutter`
2. Add to PATH:
   - Win+X → System → Advanced system settings
   - Environment Variables → Edit Path
   - Add: `C:\src\flutter\bin`
3. Restart terminal

### Install Android Studio:
1. Run the installer
2. Complete setup wizard
3. Install Android SDK (API 21+)

### Verify:
```bash
flutter doctor
flutter doctor --android-licenses
```

### Build APK:
```bash
build_apk.bat
```

