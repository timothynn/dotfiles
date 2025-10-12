{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    
    shellAliases = {
      # System management
      ls = "eza";
      ll = "eza -la";
      la = "eza -a";
      tree = "eza --tree";
      cat = "bat";
      
      # NixOS shortcuts
      hms = "home-manager switch --flake .";
      nrs = "sudo nixos-rebuild switch --flake .";
      
      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline";
      
      # Directory navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "....." = "cd ../../../..";
    };
    
    oh-my-zsh = {
      enable = true;
      plugins = [ 
        "sudo" 
        "git" 
        "docker" 
        "docker-compose" 
        "aliases" 
        "gh" 
        "kubectl"
      ];
      theme = "robbyrussell";
    };

    # Additional configuration
    initContent = ''
      # Custom functions
      mkcd() {
        mkdir -p "$1" && cd "$1"
      }

      # Better history
      setopt HIST_VERIFY
      setopt SHARE_HISTORY
      setopt APPEND_HISTORY
      setopt INC_APPEND_HISTORY
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_IGNORE_SPACE
    '';
  };
}