#!/usr/bin/env bash
# Simple terminal keybinding viewer
# Shows Hyprland keybindings in the terminal with colors

CONFIG_FILE="$HOME/.dotfiles/configs/hyprland/hyprland.conf"

if [[ ! -f "$CONFIG_FILE" ]]; then
    CONFIG_FILE="$HOME/.config/hypr/hyprland.conf"
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "❌ Hyprland config not found!"
    exit 1
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Header
echo -e "${BLUE}${BOLD}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}${BOLD}║                           HYPRLAND KEYBINDINGS                               ║${NC}"
echo -e "${BLUE}${BOLD}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
echo

# Parse keybindings
parse_keybinds() {
    local config="$1"
    local mainMod
    
    # Get mainMod value
    mainMod=$(grep '^\$mainMod[[:space:]]*=' "$config" | sed 's/^\$mainMod[[:space:]]*=[[:space:]]*\([^[:space:]#]*\).*/\1/' | head -1)
    [[ -z "$mainMod" ]] && mainMod="SUPER"
    
    echo -e "${CYAN}Main modifier: ${WHITE}$mainMod${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
    
    # Categories
    declare -A categories=(
        ["window"]="🪟 Window Management"
        ["workspace"]="🖥️  Workspace Control"
        ["app"]="🚀 Applications"
        ["media"]="🎵 Media Control"
        ["system"]="⚙️  System"
        ["pypr"]="🔧 PyprLand"
        ["other"]="📋 Other"
    )
    
    declare -A keybinds
    
    # Parse all keybindings
    while IFS= read -r line; do
        if [[ $line =~ ^bind[elm]?[[:space:]]*=[[:space:]]*([^,]+),[[:space:]]*([^,]+),[[:space:]]*(.+) ]]; then
            local modifiers="${BASH_REMATCH[1]}"
            local key="${BASH_REMATCH[2]}"
            local action="${BASH_REMATCH[3]}"
            
            # Clean up
            modifiers=$(echo "$modifiers" | sed 's/[[:space:]]*$//')
            modifiers="${modifiers//\$mainMod/$mainMod}"
            key=$(echo "$key" | sed 's/[[:space:]]*$//')
            action="${action#exec, }"
            action="${action#exec,}"
            action="${action# }"
            
            # Categorize
            local category="other"
            case "$action" in
                *workspace* | *movetoworkspace*) category="workspace" ;;
                *killactive* | *movefocus* | *movewindow* | *resizewindow* | *togglefloating* | *togglesplit* | *pseudo*) category="window" ;;
                *terminal* | *kitty* | *firefox* | *rofi* | *dolphin* | *fileManager*) category="app" ;;
                *volume* | *brightness* | *playerctl* | *mute* | *Audio*) category="media" ;;
                *pypr* | *\$pypr*) category="pypr" ;;
                *exit* | *waybar* | *dpms*) category="system" ;;
            esac
            
            # Format key combo
            if [[ -n "$modifiers" && "$modifiers" != " " ]]; then
                local keycombo="$modifiers + $key"
            else
                local keycombo="$key"
            fi
            
            keybinds["$category"]+="$keycombo|$action\n"
        fi
    done < <(grep -E '^bind[elm]?[[:space:]]*=' "$config")
    
    # Display by category
    for cat in window workspace app media system pypr other; do
        if [[ -n "${keybinds[$cat]}" ]]; then
            echo -e "${GREEN}${BOLD}${categories[$cat]}${NC}"
            echo -e "${YELLOW}────────────────────────────────────────${NC}"
            echo -e "${keybinds[$cat]}" | sort | while IFS='|' read -r keycombo action; do
                if [[ -n "$keycombo" ]]; then
                    printf "${WHITE}%-25s${NC} ${PURPLE}│${NC} %s\n" "$keycombo" "$action"
                fi
            done
            echo
        fi
    done
}

# Show keybindings with pagination
if command -v less >/dev/null 2>&1; then
    parse_keybinds "$CONFIG_FILE" | less -R
else
    parse_keybinds "$CONFIG_FILE"
fi