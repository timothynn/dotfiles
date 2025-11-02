{ config, pkgs, ... }:

let
  packages = import ../../../common/packages.nix { inherit pkgs; };
in
{
  # Network & Security Tools
  home.packages =
    packages.network
    ++ packages.security
    ++ packages.protobuf
    ++ (with pkgs; [
      nginx # Reverse proxy
    ]);
}
