#!/usr/bin/env bash

# Rofi volume control using type-2 with Catppuccin Mocha

TEMP_THEME="/tmp/rofi-volume-catppuccin.rasi"

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
    width: 300px;
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
    text-color: @accent;
    background-color: transparent;
    horizontal-align: 0.5;
    font: "JetBrainsMono Nerd Font Bold 12";
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
    padding: 10px;
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

# Get current volume
current_vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o "MUTED")

if [ -n "$is_muted" ]; then
    vol_status="󰝟 Muted ($current_vol%)"
else
    vol_status="󰕾 Volume: $current_vol%"
fi

# Volume options
options="󰝝  Increase (+5%)\n󰝞  Decrease (-5%)\n󰝟  Mute/Unmute\n  Max Volume\n  50%\n  Pavucontrol"

chosen=$(echo -e "$options" | rofi -dmenu -p "$vol_status" -theme "$TEMP_THEME" -mesg "Current: $current_vol%")

case $chosen in
    "󰝝  Increase (+5%)")
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
        ;;
    "󰝞  Decrease (-5%)")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        ;;
    "󰝟  Mute/Unmute")
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    "  Max Volume")
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 100%
        ;;
    "  50%")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%
        ;;
    "  Pavucontrol")
        pavucontrol &
        ;;
esac
