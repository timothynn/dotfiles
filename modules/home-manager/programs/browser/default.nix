{ config, pkgs, ... }:

{
  # Browsers
  home.packages = with pkgs; [
    google-chrome
    firefox
  ];
}