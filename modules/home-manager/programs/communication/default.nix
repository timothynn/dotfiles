{ config, pkgs, ... }:

{
  # Communication applications
  home.packages = with pkgs; [
    # Email (uses libsecret from system for password storage)
    mailspring
    libsecret

    # Chat/Video
    vesktop          # Better Discord client
    telegram-desktop
    zoom-us
    slack
    teams-for-linux
  ];
}