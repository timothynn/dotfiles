#!/usr/bin/env bash
# Hyprland Keybindings viewer using rofi
# This script parses your Hyprland config and shows keybindings in rofi

CONFIG_FILE="$HOME/.dotfiles/configs/hyprland/hyprland.conf"

if [[ ! -f "$CONFIG_FILE" ]]; then
    CONFIG_FILE="$HOME/.config/hypr/hyprland.conf"
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
    rofi -e "Hyprland config not found!"
    exit 1
fi

# Parse keybindings from config
parse_keybinds() {
    local config="$1"
    local mainMod
    
    # Get mainMod value - fix the regex to handle comments
    mainMod=$(grep '^\$mainMod[[:space:]]*=' "$config" | sed 's/^\$mainMod[[:space:]]*=[[:space:]]*\([^[:space:]#]*\).*/\1/' | head -1)
    [[ -z "$mainMod" ]] && mainMod="SUPER"
    
    # Parse bind statements and format them
    {
        # Regular binds
        grep -E '^bind[elm]?[[:space:]]*=' "$config" | while IFS= read -r line; do
            # Extract components: bind = modifiers, key, action
            if [[ $line =~ ^bind[elm]?[[:space:]]*=[[:space:]]*([^,]+),[[:space:]]*([^,]+),[[:space:]]*(.+) ]]; then
                local modifiers="${BASH_REMATCH[1]}"
                local key="${BASH_REMATCH[2]}"
                local action="${BASH_REMATCH[3]}"
                
                # Clean modifiers and replace $mainMod
                modifiers=$(echo "$modifiers" | sed 's/[[:space:]]*$//')
                modifiers="${modifiers//\$mainMod/$mainMod}"
                
                # Clean up action
                action="${action#exec, }"
                action="${action#exec,}"
                action="${action# }"
                
                # Clean key
                key=$(echo "$key" | sed 's/[[:space:]]*$//')
                
                # Format key combination
                if [[ -n "$modifiers" && "$modifiers" != " " ]]; then
                    printf "%-25s │ %s\n" "$modifiers + $key" "$action"
                else
                    printf "%-25s │ %s\n" "$key" "$action"
                fi
            fi
        done
    } | sort
}

# Create the keybinding list
KEYBINDS=$(parse_keybinds "$CONFIG_FILE")

if [[ -z "$KEYBINDS" ]]; then
    rofi -e "No keybindings found in config!"
    exit 1
fi

# Show in rofi with custom theme
echo "$KEYBINDS" | rofi -dmenu \
    -i \
    -p "Keybindings" \
    -theme-str 'window { width: 80%; }' \
    -theme-str 'listview { lines: 20; }' \
    -theme-str 'element-text { font: "JetBrains Mono 10"; }' \
    -no-custom \
    -kb-accept-entry "" \
    -kb-row-up "Up,Control+k,ISO_Left_Tab" \
    -kb-row-down "Down,Control+j,Tab"