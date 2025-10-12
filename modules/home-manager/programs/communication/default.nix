{ config, pkgs, ... }:

{
  # Communication applications
  home.packages = with pkgs; [
    # Chat/Video
    vesktop          # Better Discord client
    telegram-desktop
    zoom-us
    slack
    teams-for-linux
  ];
}