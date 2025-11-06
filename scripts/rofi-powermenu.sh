#!/usr/bin/env bash

# Rofi powermenu using adi1090x type-2 style-2 with Catppuccin Mocha

TEMP_THEME="/tmp/rofi-powermenu-catppuccin.rasi"

cat > "$TEMP_THEME" << 'EOF'
@import "~/.config/rofi/catppuccin-mocha.rasi"

configuration {
    font: "JetBrainsMono Nerd Font 12";
}

window {
    transparency: "real";
    background-color: @bg0;
    text-color: @fg0;
    border: 2px;
    border-color: @accent;
    border-radius: 10px;
    width: 400px;
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
    border: 0px;
    border-color: @accent;
    border-radius: 6px;
    padding: 15px;
}

textbox {
    text-color: @fg0;
    background-color: transparent;
    horizontal-align: 0.5;
}

listview {
    background-color: transparent;
    columns: 3;
    lines: 2;
    spacing: 10px;
    cycle: true;
    dynamic: true;
    layout: vertical;
}

element {
    background-color: @bg1;
    text-color: @fg0;
    orientation: vertical;
    border-radius: 8px;
    padding: 20px 0px;
}

element-text {
    background-color: transparent;
    text-color: inherit;
    font: "feather 32";
    horizontal-align: 0.5;
    vertical-align: 0.5;
}

element selected {
    background-color: @accent;
    text-color: @bg0;
}
EOF

# Power menu options
chosen=$(echo -e "⏻\n\n\n\n󰒲\n" | rofi -dmenu -p "Power Menu" -theme "$TEMP_THEME")

case $chosen in
    "⏻")
        systemctl poweroff
        ;;
    "")
        systemctl reboot
        ;;
    "")
        systemctl suspend
        ;;
    "")
        systemctl hibernate
        ;;
    "󰒲")
        hyprctl dispatch exit
        ;;
    "")
        swaylock
        ;;
esac
