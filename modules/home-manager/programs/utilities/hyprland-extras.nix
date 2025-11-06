{ config, pkgs, ... }:

let
  packages = import ../../../common/packages.nix { inherit pkgs; };
in
{
  # Hyprland-specific Utilities
  home.packages =
    packages.hyprland
    ++ (with pkgs; [
      wlogout # Logout menu
      grim    # Screenshot tool for Wayland
      slurp   # Select region for screenshots
      wl-clipboard # Clipboard utilities for Wayland
      jq      # JSON processor (for window selection)
    ]);
}
