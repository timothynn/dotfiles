{ config, pkgs, ... }:

{
  # Container management
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Container tools
  environment.systemPackages = with pkgs; [
    podman-compose
    podman-desktop
    podman-tui
    kubectl
    kind
    dive
    skopeo
    buildah
  ];
}