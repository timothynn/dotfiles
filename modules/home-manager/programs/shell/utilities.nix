{ config, pkgs, ... }:

{
  # Shell utilities
  programs = {
    # Better ls
    eza = {
      enable = true;
      icons = "auto";
      git = true;
      enableZshIntegration = true;
    };

    # Better cat
    bat = {
      enable = true;
      config = {
        style = "numbers,changes,header";
      };
    };

    # Fuzzy finder
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # Directory jumper
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # Command history
    atuin = {
      enable = true;
      enableZshIntegration = true;
    };

    # Alternative grep
    ripgrep.enable = true;
    
    # Alternative find
    fd.enable = true;
  };

  # Additional utilities as packages
  home.packages = with pkgs; [
    tldr        # Better man pages
    bottom      # Better top
    du-dust     # Better du
    procs       # Better ps
    choose      # Better cut/awk
    sd          # Better sed
    hyperfine   # Benchmarking tool
    tokei       # Code statistics
    gitui       # Git TUI
    lazygit     # Another Git TUI
  ];
}