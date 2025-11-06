# Troubleshooting Guide

## Common Issues and Solutions

### Build Failures

#### Issue: `nixpkgs` options conflict with `useGlobalPkgs`
```
Failed assertions:
- tim profile: `nixpkgs` options are disabled when `home-manager.useGlobalPkgs` is enabled.
```

**Solution:**
Remove `nixpkgs.config` from any Home Manager files. Add this to `home/tim/default.nix`:
```nix
nixpkgs.config = lib.mkForce {};
```

#### Issue: Flake syntax error
**Solution:**
```bash
nix-instantiate --parse flake.nix
```
Look for missing semicolons, brackets, or quotes.

#### Issue: Hash mismatch for fetchurl
**Solution:**
```bash
# Get new hash
nix-prefetch-url <url>

# Or use this in your config
hash = lib.fakeSha256;  # Will show actual hash in error
```

### Home Manager Issues

#### Issue: Activation fails with collision
```
error: collision between ... and ...
```

**Solution:**
```bash
# Remove conflicting files
rm ~/.config/problematic-file

# Or use backup extension
home-manager switch --flake . -b backup
```

#### Issue: Service fails to start
**Solution:**
```bash
# Check service status
systemctl --user status service-name

# Check logs
journalctl --user -xeu service-name

# Test service manually
/nix/store/xxx-service/bin/service-name
```

### Hyprland Issues

#### Issue: Hyprland won't start
**Solution:**
```bash
# Check logs
journalctl -b | grep hyprland

# Try running from TTY
Hyprland

# Check if required packages are installed
which waybar kitty
```

#### Issue: Screen tearing or stuttering
**Solution:**
Add to `hyprland.conf`:
```conf
env = WLR_NO_HARDWARE_CURSORS,1
env = WLR_DRM_NO_ATOMIC,1
```

#### Issue: Applications not appearing in rofi
**Solution:**
```bash
# Update desktop database
update-desktop-database ~/.local/share/applications

# Or rebuild home-manager
home-manager switch --flake .
```

### Display Manager Issues

#### Issue: SDDM doesn't show theme
**Solution:**
```bash
# Check theme directory
ls /run/current-system/sw/share/sddm/themes/

# Rebuild system
sudo nixos-rebuild switch --flake .

# Check SDDM config
cat /etc/sddm.conf
```

#### Issue: Can't login after rebuild
**Solution:**
1. Switch to TTY (Ctrl+Alt+F2)
2. Login as root or user
3. Check logs: `journalctl -xeu display-manager`
4. Rollback: `sudo nixos-rebuild switch --rollback`

### Network Issues

#### Issue: No internet after boot
**Solution:**
```bash
# Check NetworkManager status
systemctl status NetworkManager

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Check connections
nmcli device status
nmcli connection show
```

#### Issue: DNS not resolving
**Solution:**
```bash
# Check DNS
cat /etc/resolv.conf

# Test DNS
nslookup google.com

# Restart resolved
sudo systemctl restart systemd-resolved
```

### Audio Issues

#### Issue: No audio output
**Solution:**
```bash
# Check PipeWire status
systemctl --user status pipewire pipewire-pulse wireplumber

# Restart audio services
systemctl --user restart pipewire pipewire-pulse wireplumber

# Check sinks
wpctl status
```

#### Issue: Wrong default audio device
**Solution:**
```bash
# List devices
wpctl status

# Set default
wpctl set-default <device-id>
```

### Graphics Issues

#### Issue: NVIDIA drivers not working
**Solution:**
Add to `hosts/nixos/default.nix`:
```nix
services.xserver.videoDrivers = [ "nvidia" ];
hardware.nvidia = {
  modesetting.enable = true;
  open = false;  # Use proprietary driver
  nvidiaSettings = true;
};
```

#### Issue: Screen flickering on Intel
**Solution:**
```nix
boot.kernelParams = [ "i915.enable_psr=0" ];
```

### Performance Issues

#### Issue: System is slow
**Solution:**
```bash
# Check what's using resources
btop

# Check disk I/O
iotop

# Check journal size
journalctl --disk-usage

# Clean up if needed
sudo journalctl --vacuum-size=100M
```

#### Issue: Nix store taking too much space
**Solution:**
```bash
# Check store size
du -sh /nix/store

# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Delete old generations
sudo nix-collect-garbage -d

# Optimize store
nix-store --optimise
```

### Backup and Recovery

#### Issue: Need to rollback system
**Solution:**
```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Switch to specific generation
sudo nixos-rebuild switch --rollback

# Or boot into previous generation from GRUB/systemd-boot menu
```

#### Issue: Configuration lost
**Solution:**
```bash
# If dotfiles are backed up
cd ~/.dotfiles
git log  # Find good commit
git checkout <commit-hash>
make switch-system
make switch-home

# If using backup service
~/.local/bin/backup-restore
```

### Package Issues

#### Issue: Package not found
**Solution:**
```bash
# Search for package
nix search nixpkgs <package-name>

# Update flake
nix flake update

# Check if in unstable
nix search nixpkgs#<package-name>
```

#### Issue: Package fails to build
**Solution:**
```bash
# Try with more details
nixos-rebuild switch --flake . --show-trace

# Check if package is broken
nix eval nixpkgs#<package>.meta.broken

# Try different version/channel
```

### Hyprlock Issues

#### Issue: Hyprlock won't unlock
**Solution:**
- Ensure PAM is configured correctly
- Switch to TTY (Ctrl+Alt+F2) and kill hyprlock
- Check logs: `journalctl --user -xeu hyprlock`

### Git Issues

#### Issue: Git credentials not saved
**Solution:**
```bash
# Check keyring
secret-tool lookup protocol git

# Start keyring daemon
eval $(gnome-keyring-daemon --start)

# Configure git credential helper
git config --global credential.helper libsecret
```

## Debugging Commands

### System Information
```bash
# NixOS version
nixos-version

# Check flake inputs
nix flake metadata

# Show configuration
nixos-option <option.path>

# Evaluate config value
nix eval .#nixosConfigurations.nixos.config.<option>
```

### Log Analysis
```bash
# System logs
journalctl -b           # Current boot
journalctl -b -1        # Previous boot
journalctl -f           # Follow logs
journalctl -p err       # Errors only
journalctl -u <unit>    # Specific unit

# User logs
journalctl --user -f
```

### Service Management
```bash
# System services
systemctl status <service>
systemctl restart <service>
systemctl enable <service>

# User services
systemctl --user status <service>
systemctl --user restart <service>
```

### Network Debugging
```bash
# Test connectivity
ping 1.1.1.1
ping google.com

# Check routes
ip route

# Check DNS
resolvectl status

# Monitor network
nethogs
iftop
```

## Recovery Mode

If system is completely broken:

1. Boot from NixOS installer USB
2. Mount your system:
```bash
mount /dev/sdXY /mnt
mount /dev/sdXZ /mnt/boot
```
3. Chroot:
```bash
nixos-enter
```
4. Rollback:
```bash
nix-env --list-generations --profile /nix/var/nix/profiles/system
nix-env --switch-generation <number> --profile /nix/var/nix/profiles/system
/nix/var/nix/profiles/system/bin/switch-to-configuration boot
```

## Getting Help

1. **Check logs first**: `journalctl -xef`
2. **Search NixOS options**: https://search.nixos.org
3. **NixOS Wiki**: https://nixos.wiki
4. **Discourse**: https://discourse.nixos.org
5. **GitHub Issues**: Check relevant package issues
6. **IRC/Matrix**: #nixos on libera.chat

## Prevention

- Always test before switching: `nixos-rebuild test`
- Keep backups of working configurations
- Use git for dotfiles
- Keep at least 3-4 old generations
- Test major changes in VM first
