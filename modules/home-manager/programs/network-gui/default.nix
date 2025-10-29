{ config, pkgs, ... }:

{
  # Rofi-focused network management
  home.packages = with pkgs; [
    # Primary: NetworkManager with rofi interface
    networkmanager_dmenu  # Rofi interface for NetworkManager
    
    # Minimal GUI for advanced settings only
    networkmanagerapplet  # Provides nm-connection-editor for rare advanced config
  ];
  
  # NetworkManager Dmenu configuration for rofi
  home.file.".config/networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = rofi -dmenu -i
    rofi_highlight = True
    compact = True
    wifi_chars = ▂▄▆█
    wifi_icons = 󰤯󰤟󰤢󰤥󰤨
    format = {name}  {sec}  {signal}
    
    [dmenu_passphrase]
    obscure = True
    obscure_color = #1e1e2e
    
    [editor]
    terminal = kitty
    gui_if_available = False
  '';
  
  # Custom rofi network script with better styling
  home.file.".local/bin/rofi-network" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Rofi network manager with custom styling
      
      networkmanager_dmenu \
        -theme-str 'window { width: 50%; }' \
        -theme-str 'listview { lines: 12; }' \
        -p "Network" \
        "$@"
    '';
  };
  
  # Quick WiFi toggle script
  home.file.".local/bin/rofi-wifi-toggle" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Quick WiFi toggle with rofi notification
      
      STATUS=$(nmcli radio wifi)
      
      if [ "$STATUS" = "enabled" ]; then
        nmcli radio wifi off
        notify-send -i network-wireless-disabled "WiFi" "Disabled" -t 2000
      else
        nmcli radio wifi on
        notify-send -i network-wireless-enabled "WiFi" "Enabled" -t 2000
      fi
    '';
  };
  
  # Network info display
  home.file.".local/bin/rofi-network-info" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Display network info in rofi
      
      info=$(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device status | column -t -s ':')
      active=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active)
      ip=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1')
      gateway=$(ip route | grep default | awk '{print $3}')
      dns=$(nmcli -t -f IP4.DNS device show | grep -oP '\d+(\.\d+){3}' | head -2)
      
      result="=== Network Devices ===\n$info\n\n"
      result+="=== Active Connections ===\n$active\n\n"
      result+="=== IP Addresses ===\n$ip\n\n"
      result+="=== Gateway ===\n$gateway\n\n"
      result+="=== DNS Servers ===\n$dns"
      
      echo -e "$result" | rofi -dmenu -i -p "Network Info" \
        -theme-str 'window { width: 60%; }' \
        -theme-str 'listview { lines: 20; }' \
        -theme-str 'textbox { font: "JetBrainsMono Nerd Font 10"; }'
    '';
  };
}
