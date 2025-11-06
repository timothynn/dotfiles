{ config, pkgs, ... }:

{
  # Backend Development - Modularized by domain
  imports = [
    ./api-tools.nix
    ./containers.nix
    ./kubernetes.nix
    ./infrastructure.nix
    ./network-tools.nix
    ./docker-compose.nix
  ];
}
