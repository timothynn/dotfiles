{ config, pkgs, ... }:

{
  # Development tools
  environment.systemPackages = with pkgs; [
    # Development
    home-manager
    gh
    git
    
    # Languages
    nodejs
    
    # Build tools
    clang
    gcc
  ];

  # Enable development services
  programs.git.enable = true;
}