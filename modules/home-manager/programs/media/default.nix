{ config, pkgs, ... }:

{
  imports = [
    ./spicetify.nix
  ];
  
  # Media applications
  home.packages = with pkgs; [
    # Video/Audio players
    mpv
    vlc
    
    # Image viewers
    imv
    feh
        
    # Music - Spotify is provided by spicetify
    # spotify  # REMOVED - conflicts with spicetify
    
    
    # Document viewers
    zathura

    # Markdown Viewers
    glow
    mdcat

  ];

  # Audio visualization with Catppuccin theme
  programs.cava = {
    enable = true;
    settings = {
      general = {
        mode = "normal";
        framerate = 60;
        bars = 0;
        bar_width = 2;
        bar_spacing = 1;
      };
      
      input = {
        method = "pulse";
        source = "auto";
      };
      
      output = {
        method = "noncurses";
      };
      
      color = {
        gradient = 1;
        gradient_count = 6;
        gradient_color_1 = "'#94e2d5'"; # Teal
        gradient_color_2 = "'#89b4fa'"; # Blue
        gradient_color_3 = "'#cba6f7'"; # Mauve
        gradient_color_4 = "'#f38ba8'"; # Red
        gradient_color_5 = "'#fab387'"; # Peach
        gradient_color_6 = "'#f9e2af'"; # Yellow
      };
      
      smoothing = {
        monstercat = 1;
        waves = 0;
        gravity = 100;
        ignore = 0;
      };
    };
  };
  
}