{
  description = ".NET development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # .NET SDK (choose version as needed)
            dotnet-sdk_8
            
            # ASP.NET Core runtime (if needed separately)
            # dotnet-aspnetcore_8
            
            # Development tools
            omnisharp-roslyn  # C# language server
            
            # Database tools (uncomment as needed)
            # postgresql
            # sqlite
            # sqlitebrowser
            
            # Additional utilities
            unzip
            curl
            wget
          ];
          
          shellHook = ''
            echo "🔷 .NET Development Environment"
            echo ".NET version: $(dotnet --version)"
            echo ""
            echo "Available commands:"
            echo "  dotnet new              - Create new project from template"
            echo "  dotnet build            - Build project"
            echo "  dotnet run              - Run project"
            echo "  dotnet test             - Run tests"
            echo "  dotnet publish          - Publish application"
            echo ""
            echo "Common project templates:"
            echo "  dotnet new console      - Console application"
            echo "  dotnet new webapi       - ASP.NET Core Web API"
            echo "  dotnet new mvc          - ASP.NET Core MVC"
            echo "  dotnet new blazor       - Blazor app"
            echo "  dotnet new classlib     - Class library"
            echo "  dotnet new xunit        - xUnit test project"
            echo ""
            
            # Set .NET environment variables
            export DOTNET_ROOT="${pkgs.dotnet-sdk_8}"
            export DOTNET_CLI_TELEMETRY_OPTOUT=1
            export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
            
            # Create local NuGet cache directory
            export NUGET_PACKAGES="$PWD/.nuget/packages"
            mkdir -p "$NUGET_PACKAGES"
            
            # Set up local tools path
            export PATH="$PWD/.dotnet/tools:$PATH"
            export DOTNET_TOOLS_PATH="$PWD/.dotnet/tools"
            mkdir -p "$DOTNET_TOOLS_PATH"
            
            echo "NuGet packages: $NUGET_PACKAGES"
            echo "Local tools: $DOTNET_TOOLS_PATH"
            echo ""
          '';
        };
      }
    );
}
