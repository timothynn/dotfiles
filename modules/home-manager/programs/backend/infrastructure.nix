{ config, pkgs, ... }:

let
  packages = import ../../../common/packages.nix { inherit pkgs; };
in
{
  # Infrastructure as Code Tools
  home.packages = packages.iac;
}
