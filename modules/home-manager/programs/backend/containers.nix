{ config, pkgs, ... }:

let
  packages = import ../../../common/packages.nix { inherit pkgs; };
in
{
  # Container Development Tools
  home.packages = packages.containers;
}
