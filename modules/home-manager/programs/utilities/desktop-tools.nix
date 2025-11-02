{ config, pkgs, ... }:

let
  packages = import ../../../common/packages.nix { inherit pkgs; };
in
{
  # Desktop Tools - Clipboard, Screenshots, Color Picker
  home.packages = packages.desktop;
}
