# Flutter Installation Guide for Windows

## Step 1: Download Flutter

1. Go to: https://docs.flutter.dev/get-started/install/windows
2. Download the latest Flutter SDK (ZIP file)
3. Extract it to a location like `C:\src\flutter` (avoid spaces in path)

## Step 2: Add Flutter to PATH

### Option A: Using System Environment Variables (Recommended)

1. Press `Win + R`, type `sysdm.cpl`, press Enter
2. Click "Environment Variables"
3. Under "User variables", find "Path" and click "Edit"
4. Click "New" and add: `C:\src\flutter\bin` (or your Flutter installation path)
5. Click OK on all dialogs
6. **Restart your terminal/command prompt**

### Option B: Using PowerShell (Current Session Only)

```powershell
$env:PATH += ";C:\src\flutter\bin"
```

## Step 3: Verify Installation

Open a NEW terminal/command prompt and run:
```bash
flutter doctor
```

This will check your Flutter installation and show what else you need.

## Step 4: Install Android Studio (Required for APK)

1. Download Android Studio: https://developer.android.com/studio
2. Install it
3. Open Android Studio and go through the setup wizard
4. Install Android SDK (API 21 or higher)

## Step 5: Accept Android Licenses

```bash
flutter doctor --android-licenses
```

Press `y` to accept all licenses.

## Step 6: Verify Everything

```bash
flutter doctor
```

You should see green checkmarks for:
- Flutter
- Android toolchain
- Android Studio

## Step 7: Build APK

Once Flutter is installed and in PATH, run:
```bash
cd flutter
build_apk.bat
```

## Alternative: Use Flutter from Full Path

If you don't want to add to PATH, you can modify `build_apk.bat` to use the full path to Flutter.

