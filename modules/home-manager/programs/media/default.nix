{ config, pkgs, ... }:

{
  # Media applications
  home.packages = with pkgs; [
    # Video/Audio players
    mpv
    vlc
    
    # Image viewers
    imv
    
    # Audio visualization
    cava
    
    # Music
    spotify
    
    # Document viewers
    zathura
  ];

  # Audio visualization
  programs.cava.enable = true;
}