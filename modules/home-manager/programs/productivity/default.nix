{ config, pkgs, ... }:

{
  # Productivity applications
  home.packages = with pkgs; [
    # Office suite
    libreoffice-fresh
    
    # Note taking
    notion-app-enhanced
    
    # Email
    thunderbird
    # mailspring moved to communication/default.nix with keyring wrapper
    aerc
    
    # Password manager
    bitwarden-desktop
  ];
}
