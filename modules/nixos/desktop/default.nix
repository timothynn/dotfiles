{ inputs, outputs, config, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./sddm.nix
    ./fonts.nix
  ];

  # Enable sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Graphics
  hardware.graphics.enable = true;

  # XDG portals
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Environment variables for wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Configure keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}