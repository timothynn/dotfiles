{ config, pkgs, ... }:

let
  packages = import ../../../common/packages.nix { inherit pkgs; };
in
{
  # Kubernetes Tools
  home.packages = packages.kubernetes;
}
