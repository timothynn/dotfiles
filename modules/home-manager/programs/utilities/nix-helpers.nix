{ config, pkgs, ... }:

let
  packages = import ../../../common/packages.nix { inherit pkgs; };
in
{
  # Nix Helper Tools
  home.packages = packages.nixHelpers;
}
