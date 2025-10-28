{ config, pkgs, ... }:

{
  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Optimize nix store
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # Automatic system updates (optional - be careful with this)
  # system.autoUpgrade = {
  #   enable = true;
  #   flake = "/home/tim/.dotfiles";
  #   flags = [
  #     "--update-input"
  #     "nixpkgs"
  #     "-L"  # print build logs
  #   ];
  #   dates = "weekly";
  #   allowReboot = false;
  # };

  # SMART monitoring for disk health
  services.smartd = {
    enable = true;
    autodetect = true;
    notifications = {
      wall.enable = true;
      # Uncomment and configure if you want email notifications
      # mail = {
      #   enable = true;
      #   sender = "root@localhost";
      #   recipient = "tim@localhost";
      # };
    };
  };

  # Periodic SSD TRIM
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # System monitoring tools
  environment.systemPackages = with pkgs; [
    smartmontools  # Disk health
    lm_sensors     # Temperature sensors
    pciutils       # lspci
    usbutils       # lsusb
    hdparm         # Disk info
    iotop          # I/O monitoring
    nethogs        # Network per-process monitoring
  ];

  # Temperature and fan monitoring
  services.thermald.enable = true;  # Intel only

  # Logging configuration
  services.journald.extraConfig = ''
    SystemMaxUse=500M
    MaxRetentionSec=7day
  '';
}
