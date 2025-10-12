{ inputs, config, pkgs, ... }:

{
  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    
    # Source the existing config file
    extraConfig = builtins.readFile ../../../configs/hyprland/hyprland.conf;
  };

  # Copy pyprland config
  home.file.".config/pypr/pyprland.toml".source = ../../../configs/pyprland.toml;
  
  # XDG configuration
  xdg = {
    enable = true;
    
    # Set default applications
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "google-chrome.desktop";
        "x-scheme-handler/http" = "google-chrome.desktop";
        "x-scheme-handler/https" = "google-chrome.desktop";
        "x-scheme-handler/about" = "google-chrome.desktop";
        "x-scheme-handler/unknown" = "google-chrome.desktop";
        "application/pdf" = "zathura.desktop";
        "image/*" = "imv.desktop";
        "video/*" = "mpv.desktop";
        "audio/*" = "mpv.desktop";
      };
    };
  };
}