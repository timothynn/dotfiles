# Rofi Adi1090x Themes - Keybindings Reference

## 🎨 **Theme Configuration**

All themes use **Catppuccin Mocha** color scheme with the following adi1090x styles:

- **Launcher**: Type-1 Style-6
- **Apps as Root**: Type-2
- **Power Menu**: Type-2 Style-2
- **Screenshot**: Type-2
- **Volume**: Type-2

---

## ⌨️ **Keybindings**

### **Main Launcher**
- `Super + D` - Open application launcher (Type-1 Style-6)
- `Super + R` - Alternative launcher (original rofi)
s
### **Screenshot**
- `Super + S` - Screenshot menu
- `Print` - Screenshot menu (alternative)

**Screenshot Options:**
- 󰹑 Fullscreen
- 🖱 Selection (click and drag)
- 🪟 Window (active window)
- ⏲ Delay 3s (3-second delay)

Screenshots saved to: `~/Pictures/Screenshots/`
Auto-copied to clipboard with `wl-clipboard`

### **Volume Control**
- `Super + Ctrl + V` - Volume control menu
- `XF86AudioRaiseVolume` - Increase volume (hardware key)
- `XF86AudioLowerVolume` - Decrease volume (hardware key)
- `XF86AudioMute` - Toggle mute (hardware key)

**Volume Menu Options:**
- 󰝝 Increase (+5%)
- 󰝞 Decrease (-5%)
- 󰝟 Mute/Unmute
- 🔊 Max Volume (100%)
- 🔉 50%
- 🎛 Pavucontrol (GUI mixer)

### **Apps as Root** ⚠️
- `Super + Shift + A` - Run applications as root (USE WITH CAUTION)

**Root Apps Available:**
- 📁 File Manager (Thunar)
- 💻 Terminal
- 📝 Text Editor (Neovim)
- 󰒓 System Monitor (btop)
- 📦 Package Manager
- 💾 Disk Usage Analyzer

### **Power Menu**
- `Super + Shift + P` - Power menu
- `Super + X` - Power menu (alternative)

**Power Options:**
- ⏻ Shutdown
- 🔄 Reboot
- 💤 Suspend
- 🛏 Hibernate
- 󰒲 Logout
- 🔒 Lock

### **Network** (Existing)
- `Super + N` - Network menu
- `Super + Shift + N` - WiFi toggle

### **Window Management** (Existing - No Conflicts)
- `Super + Q` - Terminal
- `Super + Shift + Q` - Kill active window
- `Super + M` - Exit Hyprland
- `Super + E` - File manager
- `Super + V` - Toggle floating
- `Super + T` - Toggle split
- `Super + W` - Toggle Waybar

---

## 🎯 **No Keybinding Conflicts**

All new keybindings have been carefully chosen to avoid conflicts with existing ones:

**Existing bindings preserved:**
- `Super + [1-9,0]` - Workspaces
- `Super + Arrow Keys` - Workspace navigation
- `Super + Vim keys` - Window focus  
- `Super + Shift + [1-9,0]` - Move to workspace
- `Super + A` - Pypr toggle term
- `Super + Shift + V` - Pypr toggle volume
- `Super + Ctrl + V` - **NEW** Rofi volume menu
- `Super + Shift + M` - Pypr toggle stb
- `Super + F1` - Keybind viewer
- `Super + Shift + F1` - Keybinds rofi

**New bindings added:**
- `Super + D` - Rofi launcher ✨
- `Super + S` / `Print` - Screenshot ✨
- `Super + Ctrl + V` - Volume menu ✨
- `Super + Shift + A` - Root apps ✨
- `Super + Shift + P` / `Super + X` - Power menu ✨

---

## 📦 **Dependencies Installed**

- `grim` - Screenshot utility for Wayland
- `slurp` - Region selector for screenshots
- `wl-clipboard` - Clipboard manager for Wayland
- `jq` - JSON processor
- `rofi-themes-adi1090x` - Theme collection

---

## 🎨 **Color Scheme**

All menus use Catppuccin Mocha colors:
- **Background**: #1e1e2e, #313244
- **Foreground**: #cdd6f4
- **Accent (Blue)**: #89b4fa
- **Urgent (Red)**: #f38ba8
- **Green**: #a6e3a1
- **Yellow**: #f9e2af

---

## 📁 **Script Locations**

All scripts are located in `~/.dotfiles/scripts/`:
- `rofi-launcher.sh`
- `rofi-powermenu.sh`
- `rofi-screenshot.sh`
- `rofi-volume.sh`
- `rofi-root-apps.sh`

Configuration file: `~/.config/rofi/catppuccin-mocha.rasi`

---

## 🔧 **Customization**

To modify themes, edit the respective script in `~/.dotfiles/scripts/` and adjust the RASI theme code.

To add more options to menus, edit the `options` variable in each script.

---

**Created**: November 6, 2025
**Theme**: Catppuccin Mocha
**Style**: adi1090x Type-1 & Type-2
