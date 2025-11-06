#!/usr/bin/env bash

# Rofi network manager with Catppuccin Mocha theme

TEMP_THEME="/tmp/rofi-network-catppuccin.rasi"

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
    border-radius: 6px;
    padding: 12px;
}

textbox {
    text-color: @accent;
    background-color: transparent;
    horizontal-align: 0.5;
    font: "JetBrainsMono Nerd Font Bold 11";
}

listview {
    background-color: transparent;
    columns: 1;
    lines: 10;
    spacing: 8px;
    cycle: true;
    scrollbar: true;
}

scrollbar {
    width: 4px;
    border: 0;
    handle-color: @accent;
    padding: 0;
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

# Check if NetworkManager is running
if ! systemctl is-active --quiet NetworkManager; then
    notify-send "Network Manager" "NetworkManager is not running" -u critical
    exit 1
fi

# Get WiFi status
wifi_status=$(nmcli radio wifi)
if [ "$wifi_status" = "enabled" ]; then
    wifi_icon="󰖩"
    wifi_state="ON"
else
    wifi_icon="󰖪"
    wifi_state="OFF"
fi

# Get current connection
current_connection=$(nmcli -t -f NAME connection show --active | head -n1)
if [ -n "$current_connection" ]; then
    connection_status="Connected: $current_connection"
else
    connection_status="Not Connected"
fi

# Build menu
options="󰖩  WiFi: $wifi_state\n"
options+="󰈀  Ethernet Status\n"
options+="  Scan WiFi Networks\n"
options+="  Disconnect\n"
options+="  Network Settings"

chosen=$(echo -e "$options" | rofi -dmenu -p "$connection_status" -theme "$TEMP_THEME")

case $chosen in
    "󰖩  WiFi:"*)
        if [ "$wifi_status" = "enabled" ]; then
            nmcli radio wifi off
            notify-send "WiFi" "WiFi disabled" -i network-wireless-disabled
        else
            nmcli radio wifi on
            notify-send "WiFi" "WiFi enabled" -i network-wireless-enabled
        fi
        ;;
    "󰈀  Ethernet Status")
        ethernet_status=$(nmcli device status | grep ethernet)
        notify-send "Ethernet" "$ethernet_status" -i network-wired
        ;;
    "  Scan WiFi Networks")
        # Get list of WiFi networks
        wifi_list=$(nmcli -t -f SSID,SIGNAL,SECURITY device wifi list | sort -t: -k2 -rn)
        
        if [ -z "$wifi_list" ]; then
            notify-send "WiFi" "No networks found" -u normal
            exit 0
        fi
        
        # Format for rofi
        formatted_list=""
        while IFS=: read -r ssid signal security; do
            if [ -n "$ssid" ]; then
                # Show signal strength icon
                if [ "$signal" -gt 75 ]; then
                    icon="󰤨"
                elif [ "$signal" -gt 50 ]; then
                    icon="󰤥"
                elif [ "$signal" -gt 25 ]; then
                    icon="󰤢"
                else
                    icon="󰤟"
                fi
                
                # Show lock icon if secured
                if [ -n "$security" ] && [ "$security" != "--" ]; then
                    lock="󰌾"
                else
                    lock=""
                fi
                
                formatted_list+="$icon $lock  $ssid ($signal%)\n"
            fi
        done <<< "$wifi_list"
        
        # Show network selection
        selected=$(echo -e "$formatted_list" | rofi -dmenu -p "Select Network" -theme "$TEMP_THEME")
        
        if [ -n "$selected" ]; then
            # Extract SSID from selection
            ssid=$(echo "$selected" | sed -E 's/^[^ ]+ [^ ]*  ([^(]+) \([0-9]+%\)$/\1/' | xargs)
            
            # Check if network requires password
            security=$(nmcli -t -f SSID,SECURITY device wifi list | grep "^$ssid:" | cut -d: -f2)
            
            if [ -n "$security" ] && [ "$security" != "--" ]; then
                # Ask for password
                password=$(rofi -dmenu -p "Password for $ssid" -password -theme "$TEMP_THEME")
                if [ -n "$password" ]; then
                    nmcli device wifi connect "$ssid" password "$password" && \
                        notify-send "WiFi" "Connected to $ssid" -i network-wireless || \
                        notify-send "WiFi" "Failed to connect to $ssid" -u critical
                fi
            else
                # Connect without password
                nmcli device wifi connect "$ssid" && \
                    notify-send "WiFi" "Connected to $ssid" -i network-wireless || \
                    notify-send "WiFi" "Failed to connect to $ssid" -u critical
            fi
        fi
        ;;
    "  Disconnect")
        if [ -n "$current_connection" ]; then
            nmcli connection down "$current_connection"
            notify-send "Network" "Disconnected from $current_connection" -i network-offline
        else
            notify-send "Network" "No active connection" -u normal
        fi
        ;;
    "  Network Settings")
        nm-connection-editor &
        ;;
esac
