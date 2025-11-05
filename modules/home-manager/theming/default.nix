{ config, pkgs, ... }:

{
  # Stylix theming configuration
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/orangci/walls-catppuccin-mocha/master/voxel-city.jpg";
      hash = "sha256-KChwMrsiX2XkPcq/Gsav7HDTFvaQ83kPpitONM64hL0=";
    };
    
    polarity = "dark";

    cursor = {
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "catppuccin-mocha-dark-cursors";
      size = 18;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetbrainsMono Nerd Font";
      };
      
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      
      sizes = {
        applications = 10;
        desktop = 10;
        popups = 10;
        terminal = 10;
      };
    };

    targets = {
      gtk.enable = true;
      kitty.enable = true;
      btop.enable = true;
      bat.enable = true;
      fzf.enable = true;
      rofi.enable = false;
      cava.enable = true;
    };
  };

  # GTK configuration
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "blue";
      };
    };
  };

  # Qt configuration
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  # Additional theming packages
  home.packages = with pkgs; [
    # Themes
    catppuccin-gtk
    catppuccin-kvantum
    
    # Theme tools
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    plasma5Packages.qtstyleplugin-kvantum
  ];
}
