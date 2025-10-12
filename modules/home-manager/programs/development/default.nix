{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
  ];

  # Development tools
  home.packages = with pkgs; [
    # Version control
    gh
    lazygit
    
    # Development environments
    devenv
    direnv
    
    # Languages
    (python3.withPackages (ps: with ps; [ tkinter ]))
    nodejs
    
    # Tools
    postman
    lazydocker
    
    # AI tools
    github-copilot-cli
    ollama
    gollama
    jan
    
    # Terminals
    warp-terminal
  ];

  # Enable direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}