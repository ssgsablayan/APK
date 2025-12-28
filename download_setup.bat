@echo off
echo ========================================
echo Flutter & Android Studio Download Helper
echo ========================================
echo.
echo This will open the download pages for:
echo 1. Flutter SDK
echo 2. Android Studio
echo.
echo Please download and install them, then follow the setup instructions.
echo.
pause

echo.
echo Opening Flutter download page...
start https://docs.flutter.dev/get-started/install/windows

timeout /t 3 /nobreak >nul

echo.
echo Opening Android Studio download page...
start https://developer.android.com/studio

echo.
echo ========================================
echo Download pages opened in your browser!
echo ========================================
echo.
echo After downloading:
echo.
echo 1. FLUTTER:
echo    - Extract the ZIP to C:\src\flutter
echo    - Add C:\src\flutter\bin to your PATH
echo    - Restart terminal
echo.
echo 2. ANDROID STUDIO:
echo    - Run the installer
echo    - Complete the setup wizard
echo    - Install Android SDK (API 21+)
echo.
echo 3. VERIFY:
echo    - Open new terminal
echo    - Run: flutter doctor
echo    - Accept licenses: flutter doctor --android-licenses
echo.
echo 4. BUILD APK:
echo    - Run: build_apk.bat
echo.
pause

