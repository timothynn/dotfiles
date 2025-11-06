#!/usr/bin/env bash

# Rofi launcher with tabs (Apps, Run, Files, Windows)
# Catppuccin Mocha Theme

# Create temporary theme with Catppuccin colors
TEMP_THEME="/tmp/rofi-launcher-catppuccin.rasi"

cat > "$TEMP_THEME" << 'EOF'
@import "~/.config/rofi/catppuccin-mocha.rasi"

configuration {
    font: "JetBrainsMono Nerd Font 8";
    show-icons: true;
    icon-theme: "Papirus-Dark";
    display-drun: "  Apps";
    display-run: " ﬿ Run";
    display-filebrowser: "  Files";
    display-window: "  Windows";
    drun-display-format: "{name}";
    disable-history: false;
    sidebar-mode: false;
}

window {
    transparency: "real";
    background-color: @bg0;
    text-color: @fg0;
    border: 2px;
    border-color: @accent;
    border-radius: 10px;
    width: 700px;
    location: center;
}

prompt {
    enabled: true;
    padding: 8px;
    background-color: @accent;
    text-color: @bg0;
    border-radius: 6px;
}

textbox-prompt-colon {
    expand: false;
    str: " ";
    background-color: @accent;
    text-color: @bg0;
    padding: 8px 12px;
    border-radius: 6px;
}

entry {
    background-color: @bg2;
    text-color: @fg0;
    placeholder-color: @fg2;
    placeholder: "Search...";
    expand: true;
    horizontal-align: 0;
    blink: true;
    padding: 8px;
    border-radius: 6px;
}

inputbar {
    children: [ textbox-prompt-colon, entry ];
    background-color: @bg1;
    text-color: @fg0;
    expand: false;
    border: 0px 0px 1px 0px;
    border-radius: 6px;
    border-color: @accent;
    margin: 0px 0px 10px 0px;
    padding: 10px;
}

listview {
    background-color: transparent;
    columns: 2;
    lines: 8;
    spacing: 4px;
    cycle: true;
    dynamic: true;
    layout: vertical;
}

mainbox {
    background-color: @bg0;
    children: [ inputbar, mode-switcher, listview ];
    spacing: 10px;
    padding: 20px;
}

element {
    background-color: @bg1;
    text-color: @fg0;
    orientation: horizontal;
    border-radius: 6px;
    padding: 8px;
}

element-icon {
    background-color: transparent;
    size: 24px;
    border: 0;
}

element-text {
    background-color: transparent;
    text-color: inherit;
    expand: true;
    horizontal-align: 0;
    vertical-align: 0.5;
    margin: 0px 10px 0px 10px;
}

element selected {
    background-color: @accent;
    text-color: @bg0;
    border-radius: 6px;
}

element-text selected {
    text-color: @bg0;
}

mode-switcher {
    background-color: @bg1;
    text-color: @fg0;
    spacing: 0;
    border: 2px;
    border-color: @accent;
    border-radius: 6px;
}

button {
    padding: 10px;
    background-color: @bg1;
    text-color: @fg0;
    vertical-align: 0.5;
    horizontal-align: 0.5;
}

button selected {
    background-color: @accent;
    text-color: @bg0;
    border-radius: 4px;
}
EOF

rofi -show drun \
    -modi "drun,run,filebrowser,window" \
    -theme "$TEMP_THEME"

