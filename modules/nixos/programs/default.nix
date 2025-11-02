{ config, pkgs, ... }:

{
  imports = [
    ./development.nix
    ./containers.nix
  ];

  # Core system packages (system-critical only)
  environment.systemPackages = with pkgs; [
    # System essentials
    neovim # System editor
    wget # System downloader

    # Security (system-level)
    polkit
    polkit_gnome
    libsecret
    gnome-keyring
    seahorse
  ];
}
