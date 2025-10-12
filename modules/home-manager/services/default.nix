{ config, pkgs, ... }:

{
  # Home manager services
  services = {
    # Keyring
    gnome-keyring = {
      enable = true;
      components = [ "secrets" "ssh" "pkcs11" ];
    };
    
    # Auto mounting
    udiskie.enable = true;
  };
}