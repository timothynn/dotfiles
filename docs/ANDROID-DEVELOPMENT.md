# Android & Mobile Development Setup

## Overview

Your NixOS configuration now includes comprehensive tools for .NET, Java, and Android development.

## Installed Packages

### System-Level (NixOS)

- **Android SDK**: Full Android SDK with platform tools, build tools, and emulator
  - Platform versions: 34, 33, 31
  - Build tools: 34.0.0, 33.0.0
  - NDK included for native development
  - System images for emulator (Google Play Store variants)
  - ABI support: x86_64, arm64-v8a
- **ADB (Android Debug Bridge)**: Enabled system-wide

### User-Level (Home Manager)

- **dotnet-sdk**: .NET SDK for C# development
- **dotnet-aspnetcore**: ASP.NET Core runtime
- **jdk**: Java Development Kit (for Android & general Java development)
- **android-tools**: Android platform tools (adb, fastboot, etc.)
- **android-studio**: Full Android Studio IDE
- **qemu**: Emulation support
- **Development utilities**: curl, unzip, which, file

## Environment Variables

The following environment variables are automatically set:

```bash
ANDROID_HOME=/nix/store/.../libexec/android-sdk
ANDROID_SDK_ROOT=/nix/store/.../libexec/android-sdk
```

## User Permissions

Your user (`tim`) has been added to the `adbusers` group, allowing you to:

- Use ADB without root
- Debug Android devices via USB
- Access Android emulators

## Getting Started

### Android Studio

Launch Android Studio:

```bash
android-studio
```

On first launch, Android Studio will:

1. Detect the pre-installed Android SDK
2. Offer to download additional components
3. Set up the Android Virtual Device (AVD) Manager

### Using ADB

Check connected devices:

```bash
adb devices
```

Install an APK:

```bash
adb install app.apk
```

Access device shell:

```bash
adb shell
```

### Android Emulator

List available system images:

```bash
${ANDROID_HOME}/emulator/emulator -list-avds
```

Create a new AVD (through Android Studio or command line):

```bash
# Through Android Studio
Tools > Device Manager > Create Device

# Or via command line
avdmanager create avd -n "Pixel_API_34" -k "system-images;android-34;google_apis_playstore;x86_64"
```

Start emulator:

```bash
${ANDROID_HOME}/emulator/emulator -avd Pixel_API_34
```

### .NET Development

Check .NET version:

```bash
dotnet --version
```

Create a new console app:

```bash
dotnet new console -n MyApp
cd MyApp
dotnet run
```

Create an ASP.NET Core web app:

```bash
dotnet new webapp -n MyWebApp
cd MyWebApp
dotnet run
```

### Java Development

Check Java version:

```bash
java -version
javac -version
```

Compile and run Java:

```bash
javac HelloWorld.java
java HelloWorld
```

## Connecting Physical Android Devices

### Enable USB Debugging on Android Device

1. Go to **Settings** > **About Phone**
2. Tap **Build Number** 7 times to enable Developer Options
3. Go to **Settings** > **Developer Options**
4. Enable **USB Debugging**

### Connect Device

1. Connect device via USB
2. On the device, authorize the computer when prompted
3. Verify connection:

```bash
adb devices
```

You should see your device listed.

## Troubleshooting

### ADB not finding device

```bash
# Restart adb server
adb kill-server
adb start-server

# Check USB permissions
lsusb
```

### Emulator won't start

```bash
# Check KVM access (required for fast emulation)
ls -la /dev/kvm

# Your user should have access via the kvm group
# If not, you may need to add yourself to the kvm group
```

### Android Studio SDK issues

If Android Studio doesn't detect the SDK:

1. Open Android Studio
2. Go to **File** > **Settings** > **Appearance & Behavior** > **System Settings** > **Android SDK**
3. Set SDK Location to: `$ANDROID_HOME`

### .NET SSL Certificate Issues

If you encounter SSL/HTTPS issues:

```bash
# Trust the .NET development certificate
dotnet dev-certs https --trust
```

## Updating the Configuration

### Add More Android Platform Versions

Edit `/home/tim/.dotfiles/modules/nixos/programs/development.nix`:

```nix
platformVersions = [ "34" "33" "31" "30" ];  # Add version 30
```

### Change .NET Version

Edit `/home/tim/.dotfiles/modules/home-manager/programs/development/default.nix`:

```nix
dotnet-sdk_9  # Use .NET 9 instead of default (8)
```

### Add More System Images

Edit the `systemImageTypes` in `development.nix`:

```nix
systemImageTypes = [ "google_apis_playstore" "google_apis" "default" ];
```

## Building Your Configuration

After making changes:

```bash
cd /home/tim/.dotfiles

# For system-level changes (Android SDK, ADB)
sudo nixos-rebuild switch --flake .#nixos

# For user-level changes (.NET, Android Studio)
home-manager switch --flake .#tim@nixos
```

## Resources

- [Android Developers](https://developer.android.com/)
- [.NET Documentation](https://docs.microsoft.com/dotnet/)
- [NixOS Android Development](https://nixos.wiki/wiki/Android)
- [Android Studio User Guide](https://developer.android.com/studio/intro)

## Known Limitations

1. **Android SDK Updates**: Android SDK components are managed by Nix. Use `nix flake update` to get newer versions.
2. **Emulator Performance**: For best performance, ensure KVM is enabled and your user is in the `kvm` group.
3. **Google Play Services**: Some features may require additional setup for development builds.

## Example Projects

### React Native with Expo

```bash
# Install Expo CLI
npm install -g expo-cli

# Create new project
npx create-expo-app my-app
cd my-app

# Start development server
npx expo start
```

### Flutter

Flutter requires additional setup. See the Flutter template in `/home/tim/.dotfiles/templates/` (if available) or install separately.

### Xamarin/.NET MAUI

```bash
# Install MAUI workload
dotnet workload install maui

# Create MAUI app
dotnet new maui -n MyMauiApp
cd MyMauiApp
dotnet build
```

## Next Steps

1. **Launch Android Studio**: Set up your first project
2. **Create an AVD**: Set up an emulator for testing
3. **Connect a device**: Test with a physical Android device
4. **Build a sample app**: Try the "Hello World" tutorials
5. **Explore templates**: Check `/home/tim/.dotfiles/templates/` for development shells
