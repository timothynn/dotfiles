{ config, pkgs, ... }:

{

  imports = [
    ./backup.nix
  ];
  # Home manager services
  services = {
    # Keyring
    gnome-keyring = {
      enable = true;
      components = [ "secrets" "ssh" "pkcs11" ];
    };
    
    # Auto mounting
    udiskie.enable = true;
    
    # Notification daemon
    mako = {
      enable = true;
      settings = {
        default-timeout = 5000;
        ignore-timeout = true;
      };
    };
  };
}
