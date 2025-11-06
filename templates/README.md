# Development Shell Templates

Quick start development environments for various languages and frameworks.

## Available Templates

### Python (`python/`)
Python development environment with common tools and libraries.

**Usage:**
```bash
cd your-project
cp -r ~/.dotfiles/templates/devshells/python/* .
nix develop
```

**Includes:**
- Python 3.11 with pip, setuptools, wheel
- Black, flake8, mypy, pytest
- Poetry for dependency management
- Automatic virtual environment setup

### Node.js (`nodejs/`)
Modern JavaScript/TypeScript development environment.

**Usage:**
```bash
cd your-project
cp -r ~/.dotfiles/templates/devshells/nodejs/* .
nix develop
```

**Includes:**
- Node.js 20 LTS
- npm, pnpm, yarn
- TypeScript, ESLint, Prettier
- Vite, Webpack

### Rust (`rust/`)
Rust development environment with cargo tools.

**Usage:**
```bash
cd your-project
cp -r ~/.dotfiles/templates/devshells/rust/* .
nix develop
```

**Includes:**
- Latest stable Rust toolchain
- rust-analyzer, rust-src
- cargo-watch, cargo-edit, cargo-audit
- Common system dependencies

### .NET (`dotnet/`)
.NET development environment for C#, F#, and ASP.NET Core projects.

**Usage:**
```bash
cd your-project
cp -r ~/.dotfiles/templates/devshells/dotnet/* .
nix develop
```

**Includes:**
- .NET 8 SDK
- OmniSharp (C# language server)
- Isolated NuGet package cache
- Local dotnet tools directory
- Telemetry disabled by default

### .NET MAUI (`dotnet-maui/`)
.NET MAUI development environment with Android support and workload installation.

**Usage:**
```bash
cd your-project
cp -r ~/.dotfiles/templates/devshells/dotnet-maui/* .
nix develop
# Then install workloads:
dotnet workload install maui-android
```

**Includes:**
- .NET 8 SDK in FHS environment (allows workload installation)
- Android SDK integration
- Java 17 for Android development
- Support for Blazor Hybrid apps
- MAUI workload support

## Creating Custom Templates

1. Copy an existing template as a base
2. Modify the `buildInputs` section in `flake.nix`
3. Update the `shellHook` for custom setup
4. Add any required system dependencies

## Using with direnv

Add `.envrc` to your project:
```bash
use flake
```

Then run:
```bash
direnv allow
```

The shell will automatically activate when you enter the directory!

## Tips

- Use `nix flake update` to update dependencies
- Use `nix develop --command zsh` to enter the shell with your preferred shell
- Combine multiple templates by merging their `buildInputs`
- Use `nix-shell -p <package>` for quick one-off package access
