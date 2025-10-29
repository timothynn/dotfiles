{ config, pkgs, ... }:

{
  # Mako notification daemon
  services.mako = {
    enable = true;
    
    # Appearance
    # backgroundColor = "#1e1e2e";
    # textColor = "#cdd6f4";
    # borderColor = "#89b4fa";
    # progressColor = "over #313244";
    
    # Dimensions
    width = 400;
    height = 150;
    margin = "10";
    padding = "15";
    borderSize = 2;
    borderRadius = 8;
    
    # Icons
    icons = true;
    maxIconSize = 48;
    iconPath = "${pkgs.catppuccin-papirus-folders}/share/icons/Papirus-Dark";
    
    # Behavior
    defaultTimeout = 5000;  # 5 seconds
    # ignoreTimeout = false;
    
    # Position (top-right)
    anchor = "top-right";
    
    # Font
    # font = "JetBrains Mono 11";
    
    # Grouping
    groupBy = "app-name";
    
    # Multiple monitors
    output = "";  # Show on focused monitor
    
    # Extra config
    extraConfig = ''
      [urgency=low]
      border-color=#94e2d5
      default-timeout=3000
      
      [urgency=normal]
      border-color=#89b4fa
      default-timeout=5000
      
      [urgency=high]
      border-color=#f38ba8
      default-timeout=0
      ignore-timeout=1
      
      [app-name="Spotify"]
      border-color=#a6e3a1
      
      [app-name="Volume"]
      border-color=#fab387
      default-timeout=2000
      
      [app-name="Brightness"]
      border-color=#f9e2af
      default-timeout=2000
    '';
  };

  # Notification testing script
  home.file.".local/bin/test-notifications" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Test notification system
      
      ${pkgs.libnotify}/bin/notify-send "Low Priority" "This is a low priority notification" -u low
      sleep 2
      ${pkgs.libnotify}/bin/notify-send "Normal Priority" "This is a normal notification" -u normal
      sleep 2
      ${pkgs.libnotify}/bin/notify-send "High Priority" "This is an urgent notification!" -u critical
      sleep 2
      ${pkgs.libnotify}/bin/notify-send "With Icon" "This notification has an icon" -i dialog-information
    '';
  };

  # Notification utilities
  home.packages = with pkgs; [
    libnotify     # notify-send command
    dunst         # Alternative notification daemon (if you want to try it)
  ];
}
