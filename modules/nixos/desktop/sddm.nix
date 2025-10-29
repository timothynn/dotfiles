{ config, pkgs, ... }:

let
  # Sugar Dark SDDM theme - modern, minimal, beautiful
  sugar-dark-sddm = pkgs.stdenv.mkDerivation {
    name = "sddm-sugar-dark-theme";
    src = pkgs.fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "v1.2";
      sha256 = "sha256-p2d7W6AB/vzH5p5GPJH8RobBh0wCgpJE3pRW3xhANFk=";
    };
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -r $src $out/share/sddm/themes/sugar-dark
    '';
  };
in
{
  # Display manager
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
    
    # Use Sugar Dark theme
    theme = "sugar-dark";
    
    settings = {
      Theme = {
        Current = "sugar-dark";
        ThemeDir = "/run/current-system/sw/share/sddm/themes";
        CursorTheme = "Bibata-Modern-Classic";
      };
      
      General = {
        # Display settings
        DisplayServer = "wayland";
        GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
        
        # User settings
        InputMethod = "";
      };
      
      Users = {
        MaximumUid = 60000;
        MinimumUid = 1000;
        HideUsers = "";
        HideShells = "/bin/false,/usr/bin/nologin";
      };
      
      Wayland = {
        CompositorCommand = "kwin_wayland --no-global-shortcuts --no-kactivities --no-lockscreen --locale1";
      };
    };
  };

  # SDDM dependencies
  environment.systemPackages = with pkgs; [
    # Qt graphics
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtsvg
    libsForQt5.qt5.qtquickcontrols2
    
    # Theme
    sugar-dark-sddm
    
    # Alternative modern themes (comment out sugar-dark above and uncomment one below)
    # Catppuccin (your current theme)
    (catppuccin-sddm.override {
      flavor = "mocha";
      font = "JetbrainsMono Nerd Font";
      fontSize = "10";
      loginBackground = true;
      background = "${pkgs.fetchurl {
        url = "https://www.pixelstalk.net/wp-content/uploads/2025/05/A-dense-forest-with-towering-evergreens-and-a-glowing-mist-rising-from-the-ground.webp";
        hash = "sha256-e8RDn46vsP4b/kLAmYXKgBL12soOXJxAqpRvSruqbXA=";
      }}";
    })
  ];
  
  # Cursor theme for SDDM
  environment.variables = {
    # Set cursor theme
    XCURSOR_THEME = "Bibata-Modern-Classic";
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
