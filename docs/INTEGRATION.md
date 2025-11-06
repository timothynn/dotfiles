# Integration Guide for New Enhancements

This guide shows you how to integrate all the new enhancement files into your existing dotfiles.

## Step-by-Step Integration

### 1. Add System Modules

Edit `modules/nixos/system/default.nix`:
```nix
{ config, pkgs, ... }:

{
  imports = [
    ./security.nix      # NEW
    ./maintenance.nix   # NEW
  ];

  # ... rest of existing config
}
```

### 2. Add Home Manager Service Modules

Edit `modules/home-manager/services/default.nix`:
```nix
{ config, pkgs, ... }:

{
  imports = [
    ./backup.nix        # NEW
  ];

  # Home manager services
  services = {
    # ... existing services
  };
}
```

### 3. Add Desktop Modules

Edit `modules/home-manager/desktop/default.nix`:
```nix
{ config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./notifications.nix   # NEW
  ];
}
```

### 4. Add Network Module

Edit `modules/home-manager/programs/default.nix`:
```nix
{ inputs, outputs, ... }:

{
  imports = [
    ./shell
    ./terminal
    ./editor
    ./browser
    ./media
    ./development
    ./productivity
    ./communication
    ./utilities
    ./keybind-viewer.nix
    ./network            # NEW
  ];
}
```

### 5. Update Hyprland Configuration

Edit `configs/hyprland/hyprland.conf` and add at the end:
```conf
# Source additional configurations
source = ~/.dotfiles/configs/hyprland/hyprland-additions.conf
```

### 6. Make Scripts Executable

```bash
cd ~/.dotfiles
chmod +x scripts/system-monitor.sh
chmod +x scripts/power-menu.sh
chmod +x scripts/rollback.sh
```

### 7. Add Scripts to PATH

The scripts should be automatically available through home-manager, but you can also add to `.local/bin`:

```bash
ln -sf ~/.dotfiles/scripts/system-monitor.sh ~/.local/bin/system-monitor
ln -sf ~/.dotfiles/scripts/power-menu.sh ~/.local/bin/power-menu
ln -sf ~/.dotfiles/scripts/rollback.sh ~/.local/bin/rollback
```

### 8. Configure Backups (Optional)

Edit `modules/home-manager/services/backup.nix` and uncomment the restic configuration:
```nix
services.restic.backups = {
  homeBackup = {
    # ... configure your backup destination
    repository = "/mnt/backup/restic";  # Change this!
    passwordFile = "/home/tim/.config/restic/password";
  };
};
```

Create password file:
```bash
mkdir -p ~/.config/restic
echo "your-secure-password" > ~/.config/restic/password
chmod 600 ~/.config/restic/password
```

### 9. Update Makefile (Optional)

Add new commands to your `Makefile`:
```makefile
# System health check
health:
	@./scripts/system-monitor.sh

# Rollback commands
rollback-system:
	@./scripts/rollback.sh system --list

rollback-home:
	@./scripts/rollback.sh home --list
```

### 10. Test Configuration

```bash
cd ~/.dotfiles
make check-fast
```

### 11. Apply Changes

```bash
# Apply system changes
make switch-system

# Apply home-manager changes  
make switch-home
```

## New Features Available

After integration, you'll have:

### System-Level
- ✅ Firewall enabled with sensible defaults
- ✅ Fail2ban for SSH protection
- ✅ AppArmor security profiles
- ✅ Automatic garbage collection (weekly)
- ✅ SMART disk monitoring
- ✅ Automatic SSD TRIM

### User-Level
- ✅ Mako notifications with Catppuccin theme
- ✅ Backup scripts (manual and automated)
- ✅ Syncthing for file synchronization
- ✅ Network diagnostic tools
- ✅ SSH configuration management

### Hyprland Enhancements
- ✅ Screenshot keybinds (`Super+Shift+S` for area)
- ✅ Window rules for common applications
- ✅ Workspace assignments
- ✅ Clipboard manager integration
- ✅ Color picker (`Super+Shift+C`)
- ✅ Vim-like window navigation
- ✅ Resize mode
- ✅ Lock screen (`Super+L`)

### Development Tools
- ✅ Python development shell template
- ✅ Node.js development shell template
- ✅ Rust development shell template
- ✅ System monitoring script
- ✅ Power menu script
- ✅ Rollback script

### Scripts
- ✅ `system-monitor` - Check system health
- ✅ `power-menu` - Power options menu
- ✅ `rollback` - Rollback system or home-manager
- ✅ `network-status` - Show network information
- ✅ `network-restart` - Restart network services
- ✅ `backup-now` - Manual backup
- ✅ `test-notifications` - Test notification system

## Testing New Features

### Test Notifications
```bash
test-notifications
```

### Test System Monitor
```bash
system-monitor
```

### Test Power Menu
```bash
power-menu
```

### Test Rollback
```bash
rollback system --list
rollback home --list
```

### Test Network Tools
```bash
network-status
```

### Test Screenshots (Hyprland)
- `Super+Shift+S` - Select area
- `Super+Print` - Current output
- `Print` - Full screen

### Test Color Picker (Hyprland)
- `Super+Shift+C` - Pick color

### Test Development Shells
```bash
cd ~/dev/my-python-project
cp -r ~/.dotfiles/templates/devshells/python/* .
nix develop
```

## Customization

### Firewall Ports
Edit `modules/nixos/system/security.nix`:
```nix
allowedTCPPorts = [ 5432 80 443 ];  # Add your ports
```

### Garbage Collection Frequency
Edit `modules/nixos/system/maintenance.nix`:
```nix
nix.gc.dates = "daily";  # or "weekly", "monthly"
```

### Notification Timeout
Edit `modules/home-manager/desktop/notifications.nix`:
```nix
defaultTimeout = 3000;  # milliseconds
```

### Backup Paths
Edit `modules/home-manager/services/backup.nix`:
```nix
paths = [
  "/home/tim/Documents"
  "/home/tim/Pictures"
  # Add more paths
];
```

## Troubleshooting

If you encounter issues:

1. Check syntax: `make check-fast`
2. View detailed errors: `make check`
3. Test build without switching: `make build-system` or `make build-home`
4. View the troubleshooting guide: `docs/TROUBLESHOOTING.md`

## Rollback if Needed

If something breaks:
```bash
# System rollback
sudo nixos-rebuild switch --rollback

# Home-manager rollback
./scripts/rollback.sh home
```

## Next Steps

1. **Configure Backups**: Set up automated backups with restic
2. **Customize Window Rules**: Add your applications to Hyprland window rules
3. **Create Dev Shells**: Set up development shells for your projects
4. **Fine-tune Security**: Review and adjust firewall and fail2ban settings
5. **Set Up Monitoring**: Review system health regularly with `system-monitor`

## Questions?

- Check `docs/TROUBLESHOOTING.md`
- Review NixOS options: https://search.nixos.org
- Ask on NixOS Discourse: https://discourse.nixos.org
