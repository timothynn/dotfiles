# Installation Guide

## Prerequisites

Make sure you have NixOS installed with flakes enabled. If not, add this to your `/etc/nixos/configuration.nix`:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

## Installation Steps

### 1. Clone the Repository

```bash
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
```

### 2. Update User Information

Edit the following files to match your setup:

- `modules/home-manager/programs/development/git.nix` - Update git username and email
- `hosts/nixos/default.nix` - Update username if different from "tim"
- `home/tim/default.nix` - Update username and home directory

### 3. Hardware Configuration

Copy your existing hardware configuration:

```bash
sudo cp /etc/nixos/hardware-configuration.nix ~/.dotfiles/
```

### 4. Initial System Build

For the first time setup, you might need to build step by step:

```bash
# Test the configuration first
sudo nixos-rebuild test --flake .#nixos

# If successful, switch to it
sudo nixos-rebuild switch --flake .#nixos
```

### 5. Home Manager Setup

```bash
# Build home manager configuration
home-manager switch --flake .#tim@nixos
```

### 6. Reboot

Reboot to ensure everything is working properly:

```bash
sudo reboot
```

## Daily Usage

After initial setup, use these commands:

```bash
# Rebuild system
./scripts/rebuild-system.sh

# Rebuild home manager
./scripts/rebuild-home.sh

# Update flake inputs
./scripts/update-flake.sh

# Or use the aliases (after home manager is active)
nrs  # Rebuild system
hms  # Rebuild home manager
```

## Customization

### Adding New Programs

1. Create a new module in `modules/home-manager/programs/`
2. Add it to the imports in the appropriate default.nix
3. Enable it in your user configuration

### Modifying Hyprland

Edit `configs/hyprland/hyprland.conf` directly. Changes will be applied on the next home manager rebuild.

### Changing Themes

Modify the stylix configuration in `modules/home-manager/theming/default.nix`.

## Troubleshooting

### Build Failures

1. Check syntax: `nix-instantiate --parse flake.nix`
2. Use `--show-trace` for detailed error information
3. Test individual modules by commenting out imports

### Permission Issues

Make sure your user is in the `wheel` group and has sudo access.

### Home Manager Issues

If home manager fails, try:
```bash
home-manager switch --flake .#tim@nixos --show-trace
```