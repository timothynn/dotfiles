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
    ]);
}
