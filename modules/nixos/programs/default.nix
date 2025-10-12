{ config, pkgs, ... }:

{
  imports = [
    ./development.nix
    ./containers.nix
  ];

  # Core system packages
  environment.systemPackages = with pkgs; [
    # System tools
    neovim
    git
    wget
    curl
    
    # File managers
    kdePackages.dolphin
    xfce.thunar
    xfce.thunar-volman
    
    # Security
    polkit
    polkit_gnome
    libsecret
    gnome-keyring
    seahorse
  ];
}