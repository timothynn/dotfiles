{ inputs, outputs, ... }:

{
  imports = [
    ./programs
    ./services
    ./desktop
    ./theming
  ];

  # Import centralized aliases at the home-manager level
  programs.zsh.shellAliases = import ../common/aliases.nix { };
}
