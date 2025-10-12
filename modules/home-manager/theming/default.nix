{ config, pkgs, ... }:

{
  # Stylix theming configuration
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    image = pkgs.fetchurl {
      url = "https://www.pixelstalk.net/wp-content/uploads/2025/05/A-dense-forest-with-towering-evergreens-and-a-glowing-mist-rising-from-the-ground.webp";
      hash = "sha256-e8RDn46vsP4b/kLAmYXKgBL12soOXJxAqpRvSruqbXA=";
    };
    
    polarity = "dark";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
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
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      
      sizes = {
        applications = 11;
        desktop = 11;
        popups = 11;
        terminal = 11;
      };
    };

    targets = {
      gtk.enable = true;
      kitty.enable = true;
      btop.enable = true;
      bat.enable = true;
      fzf.enable = true;
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
    qt6ct
    plasma5Packages.qtstyleplugin-kvantum
  ];
}