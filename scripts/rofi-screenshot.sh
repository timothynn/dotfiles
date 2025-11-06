#!/usr/bin/env bash

# Rofi screenshot menu using type-2 with Catppuccin Mocha

TEMP_THEME="/tmp/rofi-screenshot-catppuccin.rasi"
SCREENSHOT_DIR="${HOME}/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

cat > "$TEMP_THEME" << 'EOF'
@import "~/.config/rofi/catppuccin-mocha.rasi"

configuration {
    font: "JetBrainsMono Nerd Font 11";
}

window {
    transparency: "real";
    background-color: @bg0;
    text-color: @fg0;
    border: 2px;
    border-color: @accent;
    border-radius: 10px;
    width: 350px;
    location: center;
}

mainbox {
    background-color: @bg0;
    children: [ message, listview ];
    spacing: 15px;
    padding: 20px;
}

message {
    background-color: @bg1;
    border-radius: 6px;
    padding: 12px;
}

textbox {
    text-color: @fg0;
    background-color: transparent;
    horizontal-align: 0.5;
}

listview {
    background-color: transparent;
    columns: 1;
    lines: 4;
    spacing: 8px;
    cycle: true;
}

element {
    background-color: @bg1;
    text-color: @fg0;
    border-radius: 6px;
    padding: 12px;
}

element-text {
    background-color: transparent;
    text-color: inherit;
    horizontal-align: 0;
}

element selected {
    background-color: @accent;
    text-color: @bg0;
}
EOF

# Screenshot options
options="󰹑  Fullscreen\n  Selection\n  Window\n  Delay 3s"

chosen=$(echo -e "$options" | rofi -dmenu -p "Screenshot" -theme "$TEMP_THEME")

filename="${SCREENSHOT_DIR}/screenshot_$(date +%Y%m%d_%H%M%S).png"

case $chosen in
    "󰹑  Fullscreen")
        grim "$filename"
        notify-send "Screenshot" "Fullscreen saved to $filename" -i "$filename"
        ;;
    "  Selection")
        grim -g "$(slurp)" "$filename"
        notify-send "Screenshot" "Selection saved to $filename" -i "$filename"
        ;;
    "  Window")
        grim -g "$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" "$filename"
        notify-send "Screenshot" "Window saved to $filename" -i "$filename"
        ;;
    "  Delay 3s")
        sleep 3
        grim "$filename"
        notify-send "Screenshot" "Delayed screenshot saved to $filename" -i "$filename"
        ;;
esac

# Copy to clipboard
if [ -f "$filename" ]; then
    wl-copy < "$filename"
fi
