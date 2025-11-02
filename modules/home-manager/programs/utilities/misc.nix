{ config, pkgs, ... }:

{
  # Miscellaneous Utilities
  home.packages = with pkgs; [
    protonvpn-gui # VPN client
    qbittorrent # Torrent client
    libnotify # For notify-send command
  ];
}
