{ config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
  ];
}