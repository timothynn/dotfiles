{ config, pkgs, ... }:

{
  # Utility Applications - Modularized by domain
  imports = [
    ./system-monitoring.nix
    ./file-management.nix
    ./nix-helpers.nix
    ./desktop-tools.nix
    ./audio-video.nix
    ./hyprland-extras.nix
    ./misc.nix
  ];
}
