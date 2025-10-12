{ config, pkgs, ... }:

{
  # Display manager
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
    theme = "catppuccin-mocha";
    # Ensure themes directory exists
    settings = {
      Theme = {
        Current = "catppuccin-mocha";
        ThemeDir = "/run/current-system/sw/share/sddm/themes";
      };
    };
  };

  # SDDM theme
  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtgraphicaleffects
    (catppuccin-sddm.override {
      flavor = "mocha";
      font = "JetbrainsMono Nerd Font";
      fontSize = "10";
      loginBackground = true;
    })
  ];
}