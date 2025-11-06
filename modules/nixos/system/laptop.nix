{ config, pkgs, lib, ... }:

{
  # Laptop-specific configurations
  
  # Disable power-profiles-daemon to avoid conflicts with auto-cpufreq
  services.power-profiles-daemon.enable = lib.mkForce false;
  
  # Auto CPU frequency scaling
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        scaling_min_freq = 800000;
        scaling_max_freq = 2400000;
        turbo = "never";
        enable_thresholds = true;
        start_threshold = 20;
        stop_threshold = 80;
      };
      
      charger = {
        governor = "performance";
        scaling_min_freq = 1000000;
        scaling_max_freq = 3500000;
        turbo = "auto";
        enable_thresholds = false;
      };
    };
  };
  
  # TLP conflicts with auto-cpufreq, so disable it
  services.tlp.enable = lib.mkForce false;
  
  # Battery optimization
  services.upower = {
    enable = true;
    percentageLow = 20;
    percentageCritical = 10;
    percentageAction = 5;
    criticalPowerAction = "Hibernate";
  };
  
  # Thermald for Intel CPUs
  services.thermald.enable = true;
  
  # Laptop mode tools
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
}
