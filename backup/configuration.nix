# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Nairobi";
  system.stateVersion = "25.05";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  nix.settings.trusted-users = [ "root" "tim" ];
   
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.root.shell = pkgs.zsh;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tim = {
    isNormalUser = true;
    description = "tim";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "storage" "podman" "adbusers" ];
    packages = with pkgs; [];
    ignoreShellProgramCheck = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # nixpkgs.config.experimental-features = [ "nix-command" "flakes"];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
kitty
waybar
firefoxpwa
kdePackages.dolphin
wofi
brightnessctl
playerctl
neovim
home-manager
wget
git
polkit
polkit_gnome
libsecret
gnome-keyring
seahorse
# docker-compose
podman-compose
podman-desktop
podman-tui
kubectl
kind
dive                # Explore container layers
    skopeo              # Work with container images
    buildah
    libsForQt5.qt5.qtgraphicaleffects
    (catppuccin-sddm.override {
	flavor = "mocha";
	font = "JetbrainsMono Nerd Font";
	fontSize = "10";
	loginBackground = true;
    })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.hyprland = {
	enable = true;
	portalPackage = pkgs.xdg-desktop-portal-hyprland;
	xwayland.enable = true;
  };
  programs.dconf.enable = true;
  services.displayManager.sddm = {
	enable = true;
	package = pkgs.kdePackages.sddm;
	wayland.enable = true;
	theme = "catppuccin-mocha";
  };
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  security.polkit.enable = true;
services.postgresql = {
  enable = true;
  package = pkgs.postgresql_16;
  enableTCPIP = true;
  authentication = pkgs.lib.mkOverride 10 ''
    local all all trust
    host all all 127.0.0.1/32 trust
  '';
};
}
