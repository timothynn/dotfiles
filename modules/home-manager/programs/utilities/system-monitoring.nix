{ config, pkgs, ... }:

let
  packages = import ../../../common/packages.nix { inherit pkgs; };
in
{
  # System Monitoring Tools
  home.packages =
    packages.monitoring
    ++ (with pkgs; [
      fastfetch # System info
    ]);
}
