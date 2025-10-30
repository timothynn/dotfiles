{ inputs, outputs, config, pkgs, lib, ... }:

{
  imports = [
    # Import home manager modules
    ../../modules/home-manager
  ];

  # Basic home manager settings
  home = {
    username = "tim";
    homeDirectory = "/home/tim";
    stateVersion = "24.11";
  };

  # Session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  # Allow unfree packages since useGlobalPkgs is disabled
  nixpkgs.config.allowUnfree = true;

  # Enable home manager
  programs.home-manager.enable = true;
}
