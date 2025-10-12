{ config, pkgs, ... }:

{
  # System-wide configuration that doesn't fit elsewhere
  
  # Performance optimizations
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.dirty_ratio" = 15;
    "vm.dirty_background_ratio" = 5;
  };

  # Hardware support
  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
  };

  # Power management
  services.power-profiles-daemon.enable = true;
}