{ config, pkgs, ... }:

# let
#   # Sugar Dark SDDM theme - modern, minimal, beautiful
#   sugar-dark-sddm = pkgs.stdenv.mkDerivation {
#     name = "sddm-sugar-dark-theme";
#     src = pkgs.fetchFromGitHub {
#       owner = "MarianArlt";
#       repo = "sddm-sugar-dark";
#       rev = "v1.2";
#       sha256 = "sha256-C3qB9hFUeuT5+Dos2zFj5SyQegnghpoFV9wHvE9VoD8=";
#     };
#     installPhase = ''
#       mkdir -p $out/share/sddm/themes
#       cp -r $src $out/share/sddm/themes/sugar-dark
#     '';
#   };
# in
{
  # Display manager
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
    
    # Use Catppuccin theme (theme name includes accent color)
    theme = "catppuccin-mocha-blue";
    
    # settings = {
    #   Theme = {
    #     Current = "sugar-dark";
    #     ThemeDir = "/run/current-system/sw/share/sddm/themes";
    #     CursorTheme = "Bibata-Modern-Classic";
    #   };
    #   
    #   General = {
    #     # Display settings
    #     DisplayServer = "wayland";
    #     GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
    #     
    #     # User settings
    #     InputMethod = "";
    #   };
    #   
    #   Users = {
    #     MaximumUid = 60000;
    #     MinimumUid = 1000;
    #     HideUsers = "";
    #     HideShells = "/bin/false,/usr/bin/nologin";
    #   };
    #   
    #   Wayland = {
    #     CompositorCommand = "kwin_wayland --no-global-shortcuts --no-kactivities --no-lockscreen --locale1";
    #   };
    # };
  };

  # SDDM dependencies
  environment.systemPackages = with pkgs; [
    # Qt graphics
    libsForQt5.qt5.qtgraphicaleffects
    # libsForQt5.qt5.qtsvg
    # libsForQt5.qt5.qtquickcontrols2
    
    # Current theme
    # sugar-dark-sddm
    # sddm-sugar-dark
    
    # Alternative Catppuccin theme
    (catppuccin-sddm.override {
      flavor = "mocha";
      accent = "blue";  # This sets the accent color in the theme name
      font = "JetbrainsMono Nerd Font";
      fontSize = "11";
      background = "${pkgs.fetchurl {
        url = "https://www.pixelstalk.net/wp-content/uploads/2025/05/A-dense-forest-with-towering-evergreens-and-a-glowing-mist-rising-from-the-ground.webp";
        hash = "sha256-e8RDn46vsP4b/kLAmYXKgBL12soOXJxAqpRvSruqbXA=";
      }}";
      loginBackground = true;
    })
  ];
  
  # Cursor theme for SDDM
  environment.variables = {
    # Set cursor theme
    XCURSOR_THEME = "Catppuccin-Mocha-Blue";
    XCURSOR_SIZE = "18";
  };
}

# Alternative themes to try:
# 1. Sugar Dark (minimal, modern) - Currently configured
# 2. Catppuccin (colorful, comfortable) - Available above
# 3. Chili (elegant, simple):
#    chili-sddm = pkgs.fetchFromGitHub {
#      owner = "MarianArlt";
#      repo = "sddm-chili";
#      rev = "0.1.5";
#      sha256 = "sha256-wxWsdRGC59YzDcSopDRzxg8TfjjmA3LHrdWjepTuzgw=";
#    };
