#!/usr/bin/env bash

# Quick WiFi toggle script

# Check if NetworkManager is running
if ! systemctl is-active --quiet NetworkManager; then
    notify-send "WiFi Toggle" "NetworkManager is not running" -u critical
    exit 1
fi

# Get current WiFi status
wifi_status=$(nmcli radio wifi)

# Toggle WiFi
if [ "$wifi_status" = "enabled" ]; then
    nmcli radio wifi off
    notify-send "WiFi" "WiFi Disabled" -i network-wireless-disabled
else
    nmcli radio wifi on
    notify-send "WiFi" "WiFi Enabled" -i network-wireless-enabled
fi
