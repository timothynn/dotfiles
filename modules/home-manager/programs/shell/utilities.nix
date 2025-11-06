{ config, pkgs, ... }:

let
  packages = import ../../../common/packages.nix { inherit pkgs; };
in
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

  # Use centralized package lists
  home.packages = packages.monitoring ++ packages.shellUtils;
}
