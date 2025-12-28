# Quick Start: Build APK

## If Flutter is NOT Installed

### Quick Installation Steps:

1. **Download Flutter SDK**
   - Visit: https://docs.flutter.dev/get-started/install/windows
   - Download the ZIP file
   - Extract to `C:\src\flutter` (create folder if needed)

2. **Add Flutter to PATH**
   - Press `Win + X` and select "System"
   - Click "Advanced system settings"
   - Click "Environment Variables"
   - Under "User variables", select "Path" and click "Edit"
   - Click "New" and add: `C:\src\flutter\bin`
   - Click OK on all dialogs
   - **Close and reopen your terminal/command prompt**

3. **Install Android Studio** (Required for building APK)
   - Download: https://developer.android.com/studio
   - Install and run setup wizard
   - Install Android SDK (API 21+)

4. **Verify Installation**
   ```bash
   flutter doctor
   ```
   Accept Android licenses if prompted:
   ```bash
   flutter doctor --android-licenses
   ```

5. **Build APK**
   ```bash
   cd flutter
   build_apk.bat
   ```

## If Flutter IS Already Installed

Just make sure it's in your PATH, then run:
```bash
cd flutter
build_apk.bat
```

## Alternative: Use Flutter from Specific Location

If Flutter is installed but not in PATH, you can modify `build_apk.bat` to use the full path:
- Find where Flutter is installed (e.g., `C:\src\flutter`)
- Replace `flutter` commands with full path: `C:\src\flutter\bin\flutter`

## Troubleshooting

**"flutter is not recognized"**
- Flutter is not in PATH
- Restart terminal after adding to PATH
- Or use full path to Flutter executable

**"Android SDK not found"**
- Install Android Studio
- Run `flutter doctor` to see what's missing

**Build fails**
- Run `flutter doctor` to check setup
- Make sure Android licenses are accepted
- Check internet connection (needs to download dependencies)

