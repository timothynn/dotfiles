# Customization Guide

## Personal Information

Update these files with your personal information:

### Git Configuration
Edit `modules/home-manager/programs/development/git.nix`:
```nix
userName = "Your Name";
userEmail = "your.email@example.com";
```

### User Configuration  
Edit `hosts/nixos/default.nix` if your username is different:
```nix
users.users.yourname = {
  # ... user configuration
};
```

Also update `home/yourname/default.nix`:
```nix
home = {
  username = "yourname";
  homeDirectory = "/home/yourname";
};
```

## Enabling/Disabling Programs

### System Level (NixOS)
Edit modules in `modules/nixos/programs/` to add system-wide packages.

### User Level (Home Manager)
Edit modules in `modules/home-manager/programs/` to add user-specific programs.

### Quick Enable/Disable
Comment out imports in the respective `default.nix` files:

```nix
{
  imports = [
    ./shell
    ./terminal
    # ./editor  # Disabled
    ./browser
  ];
}
```

## Theming

### Change Wallpaper
Edit `modules/home-manager/theming/default.nix`:
```nix
image = pkgs.fetchurl {
  url = "your-wallpaper-url";
  hash = "sha256-your-hash";
};
```

### Change Color Scheme
```nix
base16Scheme = "${pkgs.base16-schemes}/share/themes/your-theme.yaml";
```

Popular themes:
- `catppuccin-mocha.yaml` (dark)
- `catppuccin-latte.yaml` (light)
- `dracula.yaml`
- `nord.yaml`

### Change Fonts
```nix
fonts = {
  monospace = {
    package = pkgs.nerd-fonts.your-font;
    name = "Your Font Name";
  };
};
```

## Adding New Hosts

1. Create `hosts/newhostname/` directory
2. Copy `hardware-configuration.nix` for the new machine
3. Create host-specific configuration
4. Add to flake.nix:

```nix
nixosConfigurations = {
  nixos = mkSystem [ ./hosts/nixos ];
  newhostname = mkSystem [ ./hosts/newhostname ];
};
```

## Adding New Users

1. Create `home/newuser/` directory
2. Create user configuration
3. Add to flake.nix:

```nix
homeConfigurations = {
  "tim@nixos" = mkHome [ ./home/tim ];
  "newuser@nixos" = mkHome [ ./home/newuser ];
};
```

## Module Structure

### Creating New Programs Module

1. Create file: `modules/home-manager/programs/yourprogram/default.nix`
2. Add configuration:

```nix
{ config, pkgs, ... }:
{
  # Program configuration
  programs.yourprogram = {
    enable = true;
    # ... configuration options
  };
  
  # Or just install packages
  home.packages = with pkgs; [
    your-package
  ];
}
```

3. Add to imports in `modules/home-manager/programs/default.nix`:

```nix
imports = [
  # ... existing imports
  ./yourprogram
];
```

### Creating System Services Module

Similar process in `modules/nixos/services/`.

## Configuration Files

### Direct File Management
Place config files in `configs/` directory and reference them:

```nix
home.file.".config/app/config.conf".source = ../../../configs/app/config.conf;
```

### Templated Configuration
Use Nix to generate configuration:

```nix
home.file.".config/app/config.conf".text = ''
  setting1=${config.stylix.base16Scheme.base00}
  setting2=value
'';
```

## Performance Tips

1. Use `--show-trace` for better error messages
2. Build configurations before switching: `make build-system`
3. Test configurations: `sudo nixos-rebuild test --flake .#nixos`
4. Regular cleanup: `make clean`

## Debugging

### Check logs:
```bash
journalctl -xeu home-manager-youruser.service
```

### Validate specific modules:
```bash
nix-instantiate --eval -E 'with import <nixpkgs> {}; (import ./modules/your-module.nix { inherit config pkgs; })'
```