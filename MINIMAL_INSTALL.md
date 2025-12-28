# Minimal Installation Guide - Smaller Downloads

## Option 1: Flutter SDK + Android SDK Command Line Tools (SMALLEST)

### Flutter SDK (Required - ~1.5 GB)
- **Can't reduce this** - it's the core framework
- Download: https://docs.flutter.dev/get-started/install/windows
- Size: ~1.5 GB (ZIP file)

### Android SDK Command Line Tools (Instead of Full Android Studio)
- **Much smaller than Android Studio!**
- Download: https://developer.android.com/tools#command-tools
- Direct link: https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip
- Size: ~150 MB (vs 1 GB for Android Studio)

**Total: ~1.65 GB instead of ~2.5 GB**

## Option 2: What You Actually Need

### Minimum Required:
1. **Flutter SDK** (~1.5 GB) - Required
2. **Android SDK Platform Tools** (~50 MB) - Required
3. **Android SDK Build Tools** (~50 MB) - Required
4. **Android Platform (API 21+)** (~100 MB) - Required

**Total Minimum: ~1.7 GB**

### Optional (Not needed for building APK):
- ❌ Android Studio IDE (1 GB) - NOT NEEDED if using command line
- ❌ Android Emulator (~500 MB) - NOT NEEDED (use real device)
- ❌ Android Studio plugins - NOT NEEDED

## Recommended Minimal Setup

### 1. Flutter SDK (Required)
- Download full Flutter SDK
- Extract to `C:\src\flutter`
- Add to PATH

### 2. Android SDK Command Line Tools (Small Alternative)
Instead of full Android Studio, use command line tools:
- Download: https://developer.android.com/tools#command-tools
- Extract to `C:\Android\cmdline-tools`
- Install only what you need via command line

### 3. Install Only Required Android Components
```bash
# After installing command line tools
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

## Comparison

| Component | Full Install | Minimal Install | Savings |
|-----------|-------------|-----------------|---------|
| Flutter SDK | 1.5 GB | 1.5 GB | 0 GB |
| Android Studio | 1.0 GB | 0 GB | 1.0 GB |
| Android SDK (CLI) | 0 GB | 0.15 GB | -0.15 GB |
| **Total** | **2.5 GB** | **1.65 GB** | **0.85 GB** |

## Step-by-Step Minimal Installation

### Step 1: Download Flutter SDK
- Size: 1.5 GB
- Required: Yes
- Can't reduce: No

### Step 2: Download Android Command Line Tools
- Size: 150 MB
- Link: https://developer.android.com/tools#command-tools
- Alternative to: Full Android Studio (1 GB)

### Step 3: Setup Android SDK
```bash
# Extract command line tools to C:\Android\cmdline-tools
# Add to PATH: C:\Android\cmdline-tools\bin

# Install only what you need
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

### Step 4: Verify
```bash
flutter doctor
```

## What Each Component Does

### Flutter SDK (Required - 1.5 GB)
- Core Flutter framework
- Dart compiler
- Flutter tools
- **Cannot be reduced**

### Android Studio (Optional - 1 GB)
- Full IDE with GUI
- Code editor
- Visual designer
- **NOT NEEDED** - Can use VS Code or any editor

### Android SDK Command Line Tools (Required - 150 MB)
- Command line tools for Android
- SDK manager
- Build tools
- **Minimal alternative to Android Studio**

## Recommendation

**Use Flutter SDK + Android Command Line Tools:**
- ✅ Smaller download (1.65 GB vs 2.5 GB)
- ✅ All features needed for building APK
- ✅ No unnecessary IDE components
- ✅ Faster installation

You can always install Android Studio later if you want the full IDE experience.


