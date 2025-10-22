{ config, pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;  # Disable auto-launch when opening terminal
  };

  # Zellij is a terminal multiplexer (like tmux but more modern)
  home.packages = with pkgs; [
    zellij
  ];
}