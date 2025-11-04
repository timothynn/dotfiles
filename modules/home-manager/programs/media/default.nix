{ config, pkgs, ... }:

{
  # Media applications
  home.packages = with pkgs; [
    # Video/Audio players
    mpv
    vlc
    
    # Image viewers
    imv
    feh
        
    # Music
    spotify
    
    
    # Document viewers
    zathura

    # Markdown Viewers
    glow
    mdcat

  ];

  # Audio visualization
  programs.cava.enable = true;
  
}