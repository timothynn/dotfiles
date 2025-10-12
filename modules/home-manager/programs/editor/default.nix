{ config, pkgs, ... }:

{
  imports = [
    ./nixvim.nix
  ];

  # Additional editors
  home.packages = with pkgs; [
    helix
    emacs
    vscode
  ];
}