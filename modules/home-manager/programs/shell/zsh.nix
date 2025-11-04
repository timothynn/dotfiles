{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    # Fix cache directory permissions
    dotDir = "${config.xdg.configHome}/zsh";

    shellAliases = {
      # System management
      ls = "eza";
      ll = "eza -la";
      la = "eza -a";
      tree = "eza --tree";
      cat = "bat";

      # NixOS shortcuts
      hms = "home-manager switch --flake ~/.dotfiles";
      nrs = "sudo nixos-rebuild switch --flake ~/.dotfiles";

      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline";

      # Additional aliases are in modules/common/aliases.nix
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
      # Fix cache permissions
      custom = "${config.xdg.configHome}/zsh/oh-my-zsh-custom";
    };

    # Additional configuration
    initContent = ''
      # Fix Oh-My-Zsh cache directory
      export ZSH_CACHE_DIR="$HOME/.cache/oh-my-zsh"
      mkdir -p "$ZSH_CACHE_DIR/completions"

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

      # Fix permissions on completions directory
      if [[ -d "$HOME/.cache/oh-my-zsh/completions" ]]; then
        chmod -R u+w "$HOME/.cache/oh-my-zsh/completions" 2>/dev/null || true
      fi
    '';

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };
  };

  # Ensure cache directories exist with correct permissions
  home.activation.fixZshCache = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.cache/oh-my-zsh/completions
    chmod -R u+w $HOME/.cache/oh-my-zsh 2>/dev/null || true
  '';
}
