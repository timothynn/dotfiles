{ config, pkgs, ... }:

{
  imports = [
    ./database.nix
  ];

  # Essential services
  services = {
    # File services
    gvfs.enable = true;
    udisks2.enable = true;
    
    # Thumbnails
    tumbler.enable = true;
  };
}