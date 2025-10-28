#!/usr/bin/env bash
# Power menu using rofi

set -euo pipefail

# Options
shutdown="⏻ Shutdown"
reboot="⟳ Reboot"
logout="⎆ Logout"
lock="🔒 Lock"
suspend="⏾ Suspend"
hibernate="⏼ Hibernate"

# Show menu
chosen=$(echo -e "$lock\n$logout\n$suspend\n$hibernate\n$reboot\n$shutdown" | \
    rofi -dmenu \
    -i \
    -p "Power Menu" \
    -theme-str 'window { width: 300px; }' \
    -theme-str 'listview { lines: 6; }')

case "$chosen" in
    "$shutdown")
        systemctl poweroff
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$logout")
        # For Hyprland
        hyprctl dispatch exit
        ;;
    "$lock")
        hyprlock
        ;;
    "$suspend")
        systemctl suspend
        ;;
    "$hibernate")
        systemctl hibernate
        ;;
    *)
        # Do nothing if cancelled
        ;;
esac
