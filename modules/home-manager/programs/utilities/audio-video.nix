{ config, pkgs, ... }:

let
  packages = import ../../../common/packages.nix { inherit pkgs; };
in
{
  # Audio/Video Control Tools
  home.packages = packages.audioVideo;
}
