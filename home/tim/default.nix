{ inputs, outputs, config, pkgs, ... }:

{
  imports = [
    # Import home manager modules
    ../../modules/home-manager
  ];

  # Configure nixpkgs
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: true;
    };
  };

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

  # Enable home manager
  programs.home-manager.enable = true;
}
