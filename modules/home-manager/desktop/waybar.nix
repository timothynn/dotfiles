{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
    
    # Use the config files from the configs directory
    style = builtins.readFile ../../../configs/waybar/style.css;
    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      spacing = 3;
      margin-top = 5;
      margin-left = 8;
      margin-right = 8;
      modules-left = ["hyprland/workspaces" "hyprland/mode"];
      modules-center = ["clock"];
      modules-right = ["pulseaudio" "network" "cpu" "memory" "temperature" "battery" "uptime" "tray"];

      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
    "1" = "";
    "2" = "";
    "3" = "";
    "4" = "";
    "5" = "";
    "6" = "";
    "7" = "";
    "8" = "";
    "9" = "";
    "10" = "";
  };
  persistent-workspaces = {
    "*" = 10;
  };
  on-click = "activate";
};


      "hyprland/mode" = {
        format = "<span style=\"italic\">{}</span>";
      };

      clock = {
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format = "{:%H:%M}";
        format-alt = "{:%Y-%m-%d}";
      };

      cpu = {
        format = "󰻠 {usage}%";
        tooltip = true;
        interval = 2;
      };

      memory = {
        format = "󰍛 {percentage}%";
        tooltip = true;
        interval = 2;
      };

      temperature = {
        format = "󰔄 {temperatureC}°C";
        critical-threshold = 80;
        tooltip = true;
      };

      battery = {
        format = "{icon} {capacity}%";
        format-icons = ["󱃍" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀"];
        tooltip = true;
      };

      network = {
        format-wifi = "󰖩 {signalStrength}%";
        format-ethernet = "󰈀";
        format-disconnected = "󰖪";
        tooltip = true;
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 muted";
        format-icons = {
          default = "󰕾";
        };
        on-click = "pavucontrol";
        scroll-step = 5;
        tooltip = true;
      };

      uptime = {
        format = "󰤷";
        tooltip = true;
      };

      tray = {
        spacing = 10;
      };
    }];
  };
}