{
  description = ".NET MAUI development environment with workload support";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # FHS environment for .NET MAUI with workload support
        dotnet-maui-fhs = pkgs.buildFHSUserEnv {
          name = "dotnet-maui";
          targetPkgs = pkgs: (with pkgs; [
            # .NET SDK
            dotnet-sdk_8
            
            # Android SDK components
            android-tools
            jdk17
            
            # Required libraries for Android
            glibc
            zlib
            libz
            openssl
            icu
            
            # Build tools
            git
            curl
            wget
            unzip
            
            # GUI libraries (for Android emulator)
            xorg.libX11
            xorg.libXext
            xorg.libXrender
            xorg.libXtst
            xorg.libXi
            libGL
            
            # Additional dependencies
            stdenv.cc.cc.lib
            krb5
            lttng-ust
          ]);
          
          profile = ''
            export DOTNET_ROOT="${pkgs.dotnet-sdk_8}"
            export DOTNET_CLI_TELEMETRY_OPTOUT=1
            export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
            
            # Android SDK paths
            export ANDROID_HOME="$HOME/.android/sdk"
            export ANDROID_SDK_ROOT="$ANDROID_HOME"
            export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
            
            # Java for Android
            export JAVA_HOME="${pkgs.jdk17}"
            
            # Allow workload installation in user directory
            export DOTNET_CLI_HOME="$HOME/.dotnet"
            mkdir -p "$DOTNET_CLI_HOME"
          '';
          
          runScript = "zsh";
        };
        
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [ dotnet-maui-fhs ];
          
          shellHook = ''
            echo "🔷 .NET MAUI Development Environment (FHS)"
            echo ""
            echo "Entering FHS environment with workload support..."
            echo ""
            echo "First time setup:"
            echo "  1. Install Android SDK cmdline-tools:"
            echo "     mkdir -p ~/.android/sdk/cmdline-tools"
            echo "     Download from: https://developer.android.com/studio#command-tools"
            echo "     Extract to: ~/.android/sdk/cmdline-tools/latest"
            echo ""
            echo "  2. Install MAUI workloads:"
            echo "     dotnet workload install maui-android"
            echo "     dotnet workload install wasm-tools"
            echo ""
            echo "  3. Accept Android licenses:"
            echo "     sdkmanager --licenses"
            echo ""
            echo "Common commands:"
            echo "  dotnet new maui-blazor -n MyApp    - Create MAUI Blazor app"
            echo "  dotnet build -t:Run -f net8.0-android  - Run on Android"
            echo ""
            exec dotnet-maui
          '';
        };
      }
    );
}
