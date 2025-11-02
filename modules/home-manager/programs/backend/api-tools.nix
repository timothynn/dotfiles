{ config, pkgs, ... }:

let
  packages = import ../../../common/packages.nix { inherit pkgs; };
in
{
  # API Development & Testing Tools
  home.packages = packages.apiTools ++ packages.loadTesting;
}
