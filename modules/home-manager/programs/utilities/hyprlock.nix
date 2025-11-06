{ config, pkgs, lib, ... }:

{
  # Disable Stylix for hyprlock to avoid conflicts
  stylix.targets.hyprlock.enable = false;
  
  # Hyprlock - Screen locker for Hyprland
  programs.hyprlock = {
    enable = true;
    
    settings = {
      general = {
        disable_loading_bar = false;
        hide_cursor = true;
        grace = 0;
        no_fade_in = false;
        no_fade_out = false;
      };
      
      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 7;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];
      
      input-field = [
        {
          size = "300, 60";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(205, 214, 244)";
          inner_color = "rgb(30, 30, 46)";
          outer_color = "rgb(137, 180, 250)";
          outline_thickness = 2;
          placeholder_text = "<span foreground='##cdd6f4'>Password...</span>";
          shadow_passes = 2;
        }
      ];
      
      label = [
        # Time
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%H:%M\")\"";
          color = "rgb(205, 214, 244)";
          font_size = 90;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        # Date
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%A, %B %d\")\"";
          color = "rgb(205, 214, 244)";
          font_size = 25;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
        # User
        {
          monitor = "";
          text = "  $USER";
          color = "rgb(205, 214, 244)";
          font_size = 18;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 20";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
