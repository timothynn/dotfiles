#!/usr/bin/env bash

# Rofi apps-as-root menu using type-2 with Catppuccin Mocha

TEMP_THEME="/tmp/rofi-root-catppuccin.rasi"

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
    border-color: @urgent;
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
    border: 1px;
    border-color: @urgent;
    border-radius: 6px;
    padding: 12px;
}

textbox {
    text-color: @urgent;
    background-color: transparent;
    horizontal-align: 0.5;
    font: "JetBrainsMono Nerd Font Bold 11";
}

listview {
    background-color: transparent;
    columns: 1;
    lines: 6;
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
    background-color: @urgent;
    text-color: @bg0;
}
EOF

# Root apps options
options="  File Manager (Thunar)\n  Terminal\n  Text Editor (Neovim)\n󰒓  System Monitor\n  Package Manager\n  Disk Usage Analyzer"

chosen=$(echo -e "$options" | rofi -dmenu -p "⚠ Run as Root" -theme "$TEMP_THEME" -mesg "⚠ WARNING: Running apps as root can be dangerous!")

case $chosen in
    "  File Manager (Thunar)")
        pkexec thunar &
        ;;
    "  Terminal")
        pkexec kitty &
        ;;
    "  Text Editor (Neovim)")
        pkexec kitty -e nvim &
        ;;
    "󰒓  System Monitor")
        pkexec kitty -e btop &
        ;;
    "  Package Manager")
        pkexec kitty -e nix-shell -p nix --run "nix-env -qaP" &
        ;;
    "  Disk Usage Analyzer")
        pkexec baobab &
        ;;
esac
