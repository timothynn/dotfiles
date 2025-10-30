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

  # CRITICAL FIX: Disable nixpkgs config when useGlobalPkgs is enabled
  nixpkgs.config = lib.mkForce {};

  # Enable home manager
  programs.home-manager.enable = true;
}
