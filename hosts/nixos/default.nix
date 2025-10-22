{ inputs, outputs, config, pkgs, ... }:

{
  imports = [
    # Import the previous hardware configuration
    ../../hardware-configuration.nix
    
    # Import modular system configurations
    ../../modules/nixos
    
    # Home manager configuration for this host
    ./home.nix
  ];

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Localization
  time.timeZone = "Africa/Nairobi";
  i18n.defaultLocale = "en_US.UTF-8";

  # Users
  users.users.tim = {
    isNormalUser = true;
    description = "tim";
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "audio" 
      "video" 
      "storage" 
      "podman" 
      "adbusers" 
    ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  # Set default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "tim" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System state version
  system.stateVersion = "25.05";
}