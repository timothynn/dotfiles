# .NET MAUI Development Environment

A Nix flake template for .NET MAUI development with Android support and workload installation capabilities.

## Features

- FHS environment allowing workload installation
- .NET 8 SDK
- Android SDK integration
- Java 17 (required for Android)
- Support for Blazor Hybrid apps

## Prerequisites

You need to manually install Android SDK command-line tools (Google's licensing prevents us from packaging them directly):

### 1. Download Android cmdline-tools

Visit: https://developer.android.com/studio#command-tools

Download the Linux command-line tools zip file.

### 2. Extract to the correct location

```bash
mkdir -p ~/.android/sdk/cmdline-tools
unzip commandlinetools-linux-*.zip -d ~/.android/sdk/cmdline-tools
mv ~/.android/sdk/cmdline-tools/cmdline-tools ~/.android/sdk/cmdline-tools/latest
```

### 3. Enter the development environment

```bash
cd your-maui-project
cp -r ~/.dotfiles/templates/devshells/dotnet-maui/flake.nix .
nix develop
```

### 4. Install MAUI workloads (inside the dev shell)

```bash
# Install MAUI Android workload
dotnet workload install maui-android

# Install WebAssembly tools (for Blazor)
dotnet workload install wasm-tools

# Verify workloads
dotnet workload list
```

### 5. Accept Android licenses

```bash
sdkmanager --licenses
```

## Creating a MAUI Blazor App

```bash
# Create new MAUI Blazor app
dotnet new maui-blazor -n MyMauiApp
cd MyMauiApp

# Build the app
dotnet build

# Run on Android emulator
dotnet build -t:Run -f net8.0-android
```

## Running on Android

### Option 1: Android Emulator

Create an emulator through Android Studio or:

```bash
# List available system images
sdkmanager --list | grep system-images

# Install a system image (example: Android 34)
sdkmanager "system-images;android-34;google_apis;x86_64"

# Create AVD
avdmanager create avd -n MyEmulator -k "system-images;android-34;google_apis;x86_64"

# Start emulator
emulator -avd MyEmulator
```

Then in another terminal:

```bash
dotnet build -t:Run -f net8.0-android
```

### Option 2: Physical Android Device

1. Enable Developer Options on your Android device
2. Enable USB Debugging
3. Connect device via USB
4. Verify connection:

```bash
adb devices
```

5. Run app:

```bash
dotnet build -t:Run -f net8.0-android
```

## Project Structure

```
my-maui-app/
├── flake.nix              # Nix development environment
├── .envrc                 # direnv configuration (optional)
├── MyMauiApp/
│   ├── MyMauiApp.csproj
│   ├── App.xaml
│   ├── AppShell.xaml
│   ├── MainPage.xaml
│   ├── MauiProgram.cs
│   └── ...
└── Platforms/
    ├── Android/
    ├── iOS/
    ├── MacCatalyst/
    └── Windows/
```

## Common Commands

```bash
# List installed workloads
dotnet workload list

# Update workloads
dotnet workload update

# Create new MAUI app
dotnet new maui -n MyApp

# Create new MAUI Blazor app
dotnet new maui-blazor -n MyApp

# Build for specific platform
dotnet build -f net8.0-android

# Run on Android
dotnet build -t:Run -f net8.0-android

# Clean build
dotnet clean
```

## Troubleshooting

### Workload installation fails

Make sure you're inside the FHS environment (`nix develop`). The FHS wrapper allows mutable installations.

### Android SDK not found

Verify your Android SDK installation:

```bash
echo $ANDROID_HOME
ls -la ~/.android/sdk/cmdline-tools/latest
```

### Emulator doesn't start

You may need to enable hardware virtualization and install additional Android components:

```bash
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

### Build fails with "android" workload error

Install the workload:

```bash
dotnet workload install maui-android
```

### Java not found

The template includes Java 17. Verify with:

```bash
echo $JAVA_HOME
java -version
```

## Target Frameworks

- `net8.0-android` - Android
- `net8.0-ios` - iOS (macOS only)
- `net8.0-maccatalyst` - macOS Catalyst (macOS only)
- `net8.0-windows` - Windows (Windows only)

On NixOS/Linux, you can primarily target Android.

## Using with direnv

Create `.envrc`:

```bash
use flake
```

Then:

```bash
direnv allow
```

## Limitations on NixOS

- iOS and macOS Catalyst development requires macOS
- Windows development requires Windows
- Android is the primary target platform on Linux

## See Also

- [.NET MAUI Documentation](https://learn.microsoft.com/dotnet/maui/)
- [Android Developer Guide](https://developer.android.com/studio/command-line)
- [NixOS Android Development](https://nixos.wiki/wiki/Android)
