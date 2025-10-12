# NixOS + Home Manager Dotfiles

A modular NixOS configuration with home-manager for Hyprland on unstable channel.

## Structure

```
.
├── flake.nix                 # Main flake configuration
├── hosts/                   # Host-specific configurations
│   ├── default.nix          # Default host configuration
│   └── nixos/               # Main desktop configuration
├── home/                    # Home manager configurations
│   ├── default.nix          # Default home configuration
│   └── tim/                 # User-specific configurations
├── modules/                 # Reusable modules
│   ├── nixos/               # NixOS system modules
│   └── home-manager/        # Home manager modules
├── scripts/                 # Custom scripts
└── configs/                 # Configuration files
    ├── hyprland/
    ├── waybar/
    └── other configs...
```

## Usage

### Quick Commands (using Makefile)
```bash
# Check configuration validity
make check

# Build and switch system
make switch-system

# Build and switch home manager  
make switch-home

# Update all inputs
make update
```

### Script Usage
```bash
# Rebuild NixOS system
./scripts/rebuild-system.sh

# Rebuild home-manager
./scripts/rebuild-home.sh

# Update flake inputs
./scripts/update-flake.sh

# Check configuration
./scripts/check-config.sh
```

### Daily Usage (after setup)
```bash
# Rebuild NixOS system
nrs  # alias for: sudo nixos-rebuild switch --flake .

# Rebuild home-manager
hms  # alias for: home-manager switch --flake .
```

## Adding New Programs

1. Create a module in `modules/home-manager/programs/`
2. Add the module to `modules/home-manager/default.nix`
3. Enable it in your user configuration in `home/tim/`

## Features

- **Modular Design**: Easy to add/remove components
- **Multiple Hosts**: Support for different machines
- **Hyprland**: Configured for Wayland with Hyprland
- **Stylix**: Consistent theming across applications
- **Development Tools**: Comprehensive developer environment