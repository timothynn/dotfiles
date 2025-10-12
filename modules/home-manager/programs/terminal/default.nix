{ config, pkgs, ... }:

{
  imports = [
    ./kitty.nix
    ./zellij.nix
  ];
}