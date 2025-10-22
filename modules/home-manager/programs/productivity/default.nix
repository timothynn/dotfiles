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
    mailspring
    aerc
    
    # Password manager
    bitwarden-desktop
  ];
}