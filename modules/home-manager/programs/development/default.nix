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
    (python3.withPackages (ps: with ps; [ 
      tkinter 
      jupyter
      notebook
      jupyterlab
    ]))
    nodejs
    
    # Tools
    postman
    lazydocker
    
    # AI tools
    github-copilot-cli
    # gemini  # Package not found in nixpkgs
    ollama
    gollama
    lmstudio
    
    # Terminals
    # warp-terminal  # Temporarily disabled - takes very long to build

    # Database
    dolt

    # Office
    brave-bin
  ];

  # Enable direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
