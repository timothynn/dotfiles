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

  # Disable nixpkgs config since useGlobalPkgs is enabled
  # The system-level config will be used instead
  # nixpkgs.config = lib.mkForce {};

  # Enable home manager
  programs.home-manager.enable = true;
}
