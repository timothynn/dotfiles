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
      spacing = 4;
      margin-top = 8;
      margin-left = 8;
      margin-right = 8;
      modules-left = ["hyprland/workspaces" "hyprland/mode"];
      modules-center = ["clock"];
      modules-right = ["pulseaudio" "network" "cpu" "memory" "battery" "tray"];

      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          "6" = "";
          "7" = "";
          "8" = "";
          "9" = "";
          "10" = "";
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
        format = "  {usage}%";
        tooltip = false;
        interval = 2;
      };

      memory = {
        format = "  {}%";
        tooltip = false;
        interval = 2;
      };

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon}  {capacity}%";
        format-charging = "  {capacity}%";
        format-plugged = "  {capacity}%";
        format-alt = "{time} {icon}";
        format-icons = ["" "" "" "" ""];
      };

      network = {
        format-wifi = "  {signalStrength}%";
        format-ethernet = "  Connected";
        format-linked = "  (No IP)";
        format-disconnected = "  Disconnected";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        tooltip-format = "{essid} via {gwaddr}";
      };

      pulseaudio = {
        format = "{icon}  {volume}%";
        format-bluetooth = "{icon}  {volume}%";
        format-bluetooth-muted = " {icon}";
        format-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
        scroll-step = 5;
      };

      tray = {
        spacing = 10;
      };
    }];
  };
}