{ config, pkgs, ... }:

{
  # Utility applications
  home.packages = with pkgs; [
    # System monitoring
    btop
    bottom
    
    # Network
    protonvpn-gui
    
    # File management
    yazi             # Terminal file manager
    xfce.thunar     # GUI file manager
    
    # Archive tools
    peazip
    p7zip
    unzip
    zstd
    
    # Nix utilities
    nix-tree
    nix-du
    nh              # Nix helper
    
    # System info
    fastfetch
    
    # Clipboard
    wl-clipboard
    cliphist
    
    # Screenshots
    grimblast
    hyprpicker      # Color picker
    
    # Audio control
    pavucontrol
    pwvucontrol
    
    # System control
    wlogout
    
    # Hyprland utilities
    pyprland
    hyprsunset
    hyprlock
    hypridle
    hyprpaper
    
    # Other utilities
    qbittorrent
    tradingview
    rofi
  ];
}
