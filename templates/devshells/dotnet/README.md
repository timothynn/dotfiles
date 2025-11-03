# .NET Development Environment Template

A Nix flake template for .NET development projects with all necessary tools and dependencies.

## Features

- .NET 8 SDK
- OmniSharp (C# language server for LSP support)
- Isolated NuGet package cache
- Local dotnet tools directory
- Telemetry disabled by default
- No first-time experience prompts

## Quick Start

### 1. Initialize a new .NET project

```bash
# Copy the template to your project
mkdir my-dotnet-project
cd my-dotnet-project
cp -r ~/.dotfiles/templates/devshells/dotnet/flake.nix .

# Or use nix flake init with a custom template path
nix flake init -t ~/.dotfiles#dotnet
```

### 2. Enter the development environment

```bash
nix develop
```

### 3. Create your .NET project

Inside the dev shell:

```bash
# Console application
dotnet new console -n MyApp

# Web API
dotnet new webapi -n MyApi

# Blazor app
dotnet new blazor -n MyBlazorApp

# Class library
dotnet new classlib -n MyLibrary

# xUnit test project
dotnet new xunit -n MyTests
```

### 4. Build and run

```bash
cd MyApp
dotnet build
dotnet run
```

## Common Commands

```bash
# Restore dependencies
dotnet restore

# Build project
dotnet build

# Run project
dotnet run

# Run with hot reload
dotnet watch run

# Run tests
dotnet test

# Add a package
dotnet add package Newtonsoft.Json

# Install a global tool locally
dotnet tool install --tool-path .dotnet/tools <tool-name>

# Publish for production
dotnet publish -c Release -o ./publish
```

## Project Structure Example

```
my-dotnet-project/
├── flake.nix              # Nix development environment
├── .envrc                 # direnv configuration (optional)
├── MyApp/
│   ├── MyApp.csproj
│   ├── Program.cs
│   └── ...
├── MyApp.Tests/
│   ├── MyApp.Tests.csproj
│   └── ...
└── .nuget/                # Local NuGet cache (auto-created)
    └── packages/
```

## Using with direnv

Create a `.envrc` file in your project root:

```bash
use flake
```

Then run:

```bash
direnv allow
```

The development environment will automatically activate when you enter the directory.

## Customization

### Change .NET version

Edit `flake.nix` and replace `dotnet-sdk_8` with your desired version:

```nix
# .NET 9
dotnet-sdk_9

# .NET 7
dotnet-sdk_7
```

### Add database support

Uncomment database tools in the `buildInputs` section:

```nix
buildInputs = with pkgs; [
  dotnet-sdk_8
  
  # Database tools
  postgresql
  sqlite
  sqlitebrowser
  
  # ...
];
```

### Add additional tools

Add any packages you need:

```nix
buildInputs = with pkgs; [
  dotnet-sdk_8
  omnisharp-roslyn
  
  # Add your tools
  azure-cli
  docker
  git
];
```

## Troubleshooting

### "Read-only file system" error

This happens when trying to use `dotnet workload` commands. In NixOS, workloads should be managed through the Nix configuration, not at runtime.

**Solution**: Use project-specific development shells (like this template) instead of global workload installation.

### NuGet restore fails

Make sure you're inside the nix development shell where `NUGET_PACKAGES` is set correctly.

### OmniSharp not working in VS Code

Make sure you have the C# extension installed and restart VS Code after entering the nix shell.

## Examples

### Web API with Entity Framework

```bash
nix develop
dotnet new webapi -n MyApi
cd MyApi
dotnet add package Microsoft.EntityFrameworkCore
dotnet add package Microsoft.EntityFrameworkCore.Sqlite
dotnet run
```

### Console app with unit tests

```bash
nix develop
dotnet new console -n MyApp
dotnet new xunit -n MyApp.Tests
dotnet add MyApp.Tests/MyApp.Tests.csproj reference MyApp/MyApp.csproj
dotnet test
```

## See Also

- [.NET Documentation](https://docs.microsoft.com/dotnet/)
- [NixOS Wiki - DotNet](https://nixos.wiki/wiki/DotNet)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
