{ inputs, config, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  # Required packages for Hyprland
  environment.systemPackages = with pkgs; [
    waybar
    wofi
    kitty
    brightnessctl
    playerctl
    wl-clipboard
    grimblast
    hyprlock
    hypridle
    hyprpaper
    hyprpicker
    pavucontrol
    pwvucontrol
    wlogout
    cliphist
  ];

  # Enable dconf for GTK applications
  programs.dconf.enable = true;

  # Security
  security.polkit.enable = true;
}