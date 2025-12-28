@echo off
echo ========================================
echo Student Governance APK Builder
echo ========================================
echo.

REM Check if Flutter is installed
where flutter >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Flutter is not installed or not in PATH!
    echo.
    echo Please do one of the following:
    echo.
    echo Option 1: Install Flutter
    echo   1. Download from: https://docs.flutter.dev/get-started/install/windows
    echo   2. Extract to C:\src\flutter (or another location)
    echo   3. Add Flutter\bin to your PATH environment variable
    echo   4. Restart this terminal and try again
    echo.
    echo Option 2: If Flutter is already installed, add it to PATH:
    echo   1. Press Win+R, type: sysdm.cpl
    echo   2. Click "Environment Variables"
    echo   3. Edit "Path" under User variables
    echo   4. Add: C:\src\flutter\bin (or your Flutter path)
    echo   5. Restart terminal
    echo.
    echo For detailed instructions, see: INSTALL_FLUTTER.md
    echo.
    pause
    exit /b 1
)

echo Flutter found! Starting build process...
echo.

echo Step 1: Cleaning previous builds...
call flutter clean
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Flutter clean failed!
    pause
    exit /b 1
)

echo.
echo Step 2: Getting dependencies...
call flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to get dependencies!
    pause
    exit /b 1
)

echo.
echo Step 3: Generating app icons from SSG logo...
call flutter pub run flutter_launcher_icons
if %ERRORLEVEL% NEQ 0 (
    echo WARNING: Icon generation failed, continuing anyway...
)

echo.
echo Step 4: Building release APK...
call flutter build apk --release
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: APK build failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo APK built successfully!
echo ========================================
echo.
echo APK Location:
echo %CD%\build\app\outputs\flutter-apk\app-release.apk
echo.
echo You can now transfer this APK to your phone and install it.
echo.
pause
