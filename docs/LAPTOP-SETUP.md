# Laptop-Specific Configuration Guide

## 🖥️ Your Hardware

- **CPU**: Intel Core i5-6300U (6th Gen Skylake, 2 cores/4 threads)
- **RAM**: 7.4GB
- **Graphics**: Intel HD Graphics 520 (integrated)
- **Display**: 1366x768 @ 60Hz (eDP-1)
- **Boot**: UEFI mode
- **Disk**: /dev/sda (238.5GB)
  - sda1: 1GB (/boot)
  - sda2: 228.7GB (/)
  - sda3: 8.8GB (swap)

## ⚙️ Optimizations Applied

### Power Management
✅ **TLP enabled** for battery optimization
- Performance mode on AC power
- Powersave mode on battery
- CPU boost disabled on battery
- WiFi power saving on battery
- USB autosuspend enabled

### Memory Management
✅ **Zram**: 3.7GB compressed swap (50% of RAM)
✅ **Tmpfs**: 2GB for /tmp
✅ **Earlyoom**: Prevents system freezes on low memory
✅ **Swappiness**: 10 (prefer RAM over swap)

### CPU Settings
✅ **Governor**: powersave on battery, performance on AC
✅ **Intel microcode**: Updates enabled
✅ **Thermal management**: thermald enabled
✅ **Build jobs**: Limited to 2 (save battery during builds)

### Graphics
✅ **Intel HD 520 drivers**: Full VA-API support
✅ **Hardware acceleration**: Enabled for video playback
✅ **Framebuffer compression**: Enabled
✅ **Panel self-refresh**: Enabled (saves power)

### Display
✅ **Resolution**: 1366x768 configured everywhere
✅ **GRUB**: Sized for your screen
✅ **SDDM**: Optimized cursor and font sizes
✅ **Font sizes**: Reduced for laptop screen

## 🔋 Battery Tips

### Check Battery Status
```bash
# Battery info
cat /sys/class/power_supply/BAT0/capacity
cat /sys/class/power_supply/BAT0/status

# Power consumption
sudo powertop

# TLP status
sudo tlp-stat
```

### Extend Battery Life
```bash
# Enable power saving mode
sudo tlp bat

# Disable bluetooth when not needed
sudo systemctl stop bluetooth

# Reduce screen brightness
brightnessctl set 30%

# Check what's draining battery
sudo powertop --auto-tune
```

## 💾 Resource Management

### Database Services
Start only what you need:
```bash
# Start PostgreSQL
sudo systemctl start postgresql

# Start Redis
sudo systemctl start redis

# Start MongoDB
sudo systemctl start mongodb

# Stop when not needed
sudo systemctl stop postgresql redis mongodb
```

### Monitor Resources
```bash
# System resources
btop

# Memory usage
free -h

# Disk usage
df -h

# Process list
htop
```

### Clean Up Space
```bash
# Clean Nix store
sudo nix-collect-garbage -d
home-manager expire-generations "-7 days"

# Optimize Nix store
nix-store --optimise

# Clean package caches
sudo pacman -Sc  # If coming from Arch
```

## 🎯 Performance vs Battery Trade-offs

### For Maximum Battery Life
```bash
# Edit modules/nixos/performance.nix
powerManagement.cpuFreqGovernor = "powersave";

# Reduce brightness
brightnessctl set 40%

# Disable unused services
sudo systemctl disable bluetooth
sudo systemctl disable cups  # If not printing
```

### For Maximum Performance (AC Power)
```bash
# Edit modules/nixos/performance.nix
powerManagement.cpuFreqGovernor = "performance";

# Ensure TLP uses performance profile
services.tlp.settings.CPU_SCALING_GOVERNOR_ON_AC = "performance";
```

## 🐛 Common Issues & Solutions

### Issue: System feels slow
**Solutions:**
1. Check if databases are running: `ps aux | grep postgres`
2. Check memory: `free -h`
3. Close heavy applications
4. Run `btop` to see resource usage
5. Consider disabling some services in `modules/nixos/services/`

### Issue: High CPU usage
**Solutions:**
1. Check with `htop` what's using CPU
2. Limit Nix build jobs in `performance.nix`
3. Close browser tabs (Chromium/Firefox can be heavy)

### Issue: Running out of memory
**Solutions:**
1. Check Zram: `zramctl`
2. Close heavy IDEs (VSCode, RStudio)
3. Stop unused databases
4. Increase Zram percentage in `performance.nix` (currently 50%)

### Issue: Battery drains quickly
**Solutions:**
1. Check TLP status: `sudo tlp-stat`
2. Reduce screen brightness
3. Close unused applications
4. Check power consumption: `sudo powertop`
5. Disable bluetooth: `sudo systemctl stop bluetooth`

### Issue: Overheating
**Solutions:**
1. Check thermals: `sensors`
2. Clean laptop vents
3. Use cooling pad
4. Reduce CPU frequency temporarily:
   ```bash
   sudo cpupower frequency-set --max 1.5GHz
   ```

## 📊 Recommended Workflow

### For Data Science Work
```bash
# Start only PostgreSQL and Redis
sudo systemctl start postgresql redis

# Launch Jupyter Lab
jlab

# Use lightweight data tools
duck  # DuckDB for SQL
```

### For Backend Development
```bash
# Use Docker Compose for services
cd ~/.config/docker-compose
docker-compose -f dev-stack.yml up -d

# This keeps databases in containers (easier to stop)
```

### For General Development
```bash
# Use direnv for project environments
# It automatically loads .envrc when you cd into project

# Example .envrc
echo "use flake" > .envrc
direnv allow
```

## 🔧 Customization for Your Laptop

### Change Display Scaling (if text too small)
Edit `modules/home-manager/theming/default.nix`:
```nix
fonts.sizes = {
  applications = 11;  # Increase from 10
  terminal = 12;      # Increase from 11
};
```

### Adjust Zram Size
Edit `modules/nixos/performance.nix`:
```nix
zramSwap = {
  memoryPercent = 60;  # Increase from 50% if needed
};
```

### Change CPU Governor
Edit `modules/nixos/performance.nix`:
```nix
# For always performance:
powerManagement.cpuFreqGovernor = "performance";

# For always powersave:
powerManagement.cpuFreqGovernor = "powersave";

# For automatic (recommended):
powerManagement.cpuFreqGovernor = "schedutil";
```

## 📱 Laptop-Specific Keybindings

Already configured in Hyprland:
- **Brightness**: Fn + F5/F6 (or brightness keys)
- **Volume**: Fn + F10/F11/F12
- **Media**: Fn + Play/Pause/Next/Prev

## 🎓 Learning Resources

- **TLP Documentation**: https://linrunner.de/tlp/
- **Intel Graphics**: https://wiki.archlinux.org/title/Intel_graphics
- **Power Management**: https://wiki.archlinux.org/title/Power_management

## ✅ Final Checklist

- [ ] TLP enabled and configured
- [ ] Zram configured (50% of RAM)
- [ ] Database services set to manual start
- [ ] Intel microcode updates enabled
- [ ] Graphics drivers configured
- [ ] Display resolution correct (1366x768)
- [ ] Font sizes comfortable for your screen
- [ ] Power button action configured in SDDM

Your laptop is now optimized for data engineering, development, and daily driving! 🚀
