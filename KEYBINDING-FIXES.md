# Keybinding Collision Fixes - Applied on November 2, 2025

## Summary
Fixed 7 keybinding collisions in Hyprland configuration files.

---

## Changes Applied

### 1. **$mainMod + C** - Moved from killactive to clipboard
- **Before**: `killactive`
- **After**: Clipboard manager (cliphist)
- **Note**: Kill window moved to `$mainMod + SHIFT + Q` (more intentional)

### 2. **$mainMod + SHIFT + Q** - New keybinding for killactive
- **Before**: Not assigned
- **After**: `killactive` (close window)
- **Reason**: More intentional than just C

### 3. **$mainMod + V** - Resolved triple collision
- **Kept**: `togglefloating` (most common use)
- **Moved pypr volume**: To `$mainMod + SHIFT + V`
- **Moved clipboard**: To `$mainMod + C`

### 4. **$mainMod + SHIFT + S** - Kept for screenshots
- **Kept**: `grimblast copy area` (screenshots)
- **Moved scratchpad**: To `$mainMod + minus` and `$mainMod + SHIFT + minus`

### 5. **$mainMod + J** - Resolved double collision
- **Before**: `togglesplit` AND `$pypr change_workspace -1`
- **After**: Only vim-style focus down (`movefocus, d`)
- **togglesplit moved to**: `$mainMod + T`
- **pypr workspace navigation moved to**: `$mainMod + bracketleft`

### 6. **$mainMod + K** - Resolved collision
- **Before**: `$pypr change_workspace +1` conflicted with vim nav
- **After**: Only vim-style focus up (`movefocus, u`)
- **pypr workspace navigation moved to**: `$mainMod + bracketright`

### 7. **$mainMod + L** - Resolved triple collision
- **Before**: `$pypr toggle_dpms`, `hyprlock`, and vim focus right
- **After**: Only vim-style focus right (`movefocus, r`)
- **hyprlock moved to**: `$mainMod + Escape`
- **toggle_dpms removed**: Duplicate of `$mainMod + ALT + P`

### 8. **Arrow Keys** - Repurposed for workspace navigation
- **Before**: `movefocus` (duplicated vim keys)
- **After**: `workspace, e-1` and `workspace, e+1` for left/right
- **Reason**: Vim keys (h/j/k/l) handle focus movement

### 9. **Color Picker** - Moved to avoid future conflicts
- **Before**: `$mainMod + SHIFT + C`
- **After**: `$mainMod + ALT + C`
- **Reason**: SHIFT+C might be needed for other functions

### 10. **$mainMod + T** - New binding for togglesplit
- **Before**: Not assigned
- **After**: `togglesplit` (dwindle layout)
- **Reason**: Moved from J to avoid vim navigation conflict

### 11. **$mainMod + [ and ]** - New pypr workspace navigation
- **Before**: Not assigned
- **After**: `$pypr change_workspace -1` (prev) and `+1` (next)
- **Reason**: Intuitive bracket keys for workspace switching

### 12. **$mainMod + ALT + B** - Moved pypr expose
- **Before**: `$mainMod + B`
- **After**: `$mainMod + ALT + B`
- **Reason**: Reserved B for potential browser shortcut

---

## Quick Reference - Updated Keybindings

### Window Management
| Key | Action |
|-----|--------|
| `$mainMod + h/j/k/l` | Focus window (vim-style) |
| `$mainMod + SHIFT + h/j/k/l` | Move window (vim-style) |
| `$mainMod + I` | Enter resize mode |
| `$mainMod + V` | Toggle floating |
| `$mainMod + SHIFT + Q` | Kill window |
| `$mainMod + T` | Toggle split (dwindle) |
| `$mainMod + F` | Fullscreen |
| `$mainMod + SHIFT + F` | Maximize |
| `$mainMod + SHIFT + P` | Pin window |
| `$mainMod + G` | Toggle group (tabbed) |

### Workspaces
| Key | Action |
|-----|--------|
| `$mainMod + 0-9` | Switch to workspace |
| `$mainMod + SHIFT + 0-9` | Move window to workspace |
| `$mainMod + [ / ]` | Previous/Next workspace (pypr) |
| `$mainMod + left/right` | Previous/Next workspace (scroll) |
| `$mainMod + minus` | Toggle scratchpad |
| `$mainMod + SHIFT + minus` | Move to scratchpad |

### Applications
| Key | Action |
|-----|--------|
| `$mainMod + Q` | Terminal |
| `$mainMod + E` | File manager |
| `$mainMod + R` | App launcher (wofi) |
| `$mainMod + A` | Toggle pypr terminal |

### Utilities
| Key | Action |
|-----|--------|
| `$mainMod + C` | Clipboard history |
| `$mainMod + SHIFT + V` | Volume control (pypr) |
| `$mainMod + N` | Network menu |
| `$mainMod + SHIFT + N` | WiFi toggle |
| `$mainMod + CTRL + N` | Network info |
| `$mainMod + W` | Toggle waybar |

### Screenshots
| Key | Action |
|-----|--------|
| `$mainMod + SHIFT + S` | Screenshot area |
| `$mainMod + Print` | Screenshot output |
| `Print` | Screenshot screen |
| `$mainMod + CTRL + S` | Save screenshot to file |
| `$mainMod + ALT + S` | Screenshot area (frozen) |

### System
| Key | Action |
|-----|--------|
| `$mainMod + Escape` | Lock screen |
| `$mainMod + SHIFT + E` | Logout menu (wlogout) |
| `$mainMod + M` | Exit Hyprland |
| `$mainMod + ALT + C` | Color picker |

### Pypr Specific
| Key | Action |
|-----|--------|
| `$mainMod + SHIFT + Z` | Zoom |
| `$mainMod + ALT + P` | Toggle DPMS |
| `$mainMod + SHIFT + O` | Shift monitors |
| `$mainMod + ALT + B` | Expose windows |
| `$mainMod + SHIFT + M` | Toggle stb logs |

### Keybinding Viewers
| Key | Action |
|-----|--------|
| `$mainMod + F1` | GUI keybind viewer |
| `$mainMod + SHIFT + F1` | Rofi keybind viewer |
| `$mainMod + CTRL + F1` | Terminal keybind viewer |

---

## Files Modified
1. `/home/tim/.dotfiles/configs/hyprland/hyprland.conf`
2. `/home/tim/.dotfiles/configs/hyprland/hyprland-additions.nix`

## Next Steps
1. Reload Hyprland configuration: `hyprctl reload` or `$mainMod + SHIFT + R` (if configured)
2. Test all keybindings to ensure they work as expected
3. Update any personal documentation or cheat sheets

## Rollback
If you need to revert these changes, use git:
```bash
cd /home/tim/.dotfiles
git diff configs/hyprland/
git checkout configs/hyprland/hyprland.conf configs/hyprland/hyprland-additions.nix
```
