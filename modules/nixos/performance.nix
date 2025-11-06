{ config, pkgs, lib, ... }:

{
  # Performance optimizations for Intel i5-6300U laptop with 7.4GB RAM

  # Boot optimization
  boot = {
    # Use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;
    
    # Kernel modules
    kernelModules = [ "tcp_bbr" ];
    
    # Kernel sysctl parameters - Conservative for laptop
    kernel.sysctl = {
      # Memory management - optimized for 7.4GB RAM
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
      "vm.dirty_writeback_centisecs" = 1500;
      
      # Network optimization
      "net.core.netdev_max_backlog" = 8192;
      "net.core.somaxconn" = 4096;
      "net.core.rmem_default" = 262144;
      "net.core.rmem_max" = 4194304;
      "net.core.wmem_default" = 262144;
      "net.core.wmem_max" = 4194304;
      "net.ipv4.tcp_rmem" = "4096 87380 4194304";
      "net.ipv4.tcp_wmem" = "4096 65536 4194304";
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_mtu_probing" = 1;
      "net.ipv4.tcp_max_syn_backlog" = 4096;
      "net.ipv4.tcp_slow_start_after_idle" = 0;
      
      # File system
      "fs.file-max" = 1048576;
      "fs.inotify.max_user_watches" = 524288;
      "fs.inotify.max_user_instances" = 256;
      
      # Kernel
      "kernel.sched_autogroup_enabled" = 1;
    };
    
    # Faster initrd
    initrd.systemd.enable = true;
  };

  # Systemd optimization
  systemd = {
    services = {
      systemd-udev-settle.enable = false;
      NetworkManager-wait-online.enable = false;
    };
    
    extraConfig = ''
      DefaultTimeoutStopSec=10s
      DefaultLimitNOFILE=524288
    '';
    
    user.extraConfig = ''
      DefaultLimitNOFILE=524288
    '';
  };

  # Nix optimization
  nix = {
    settings = {
      # Use 2 cores for builds (save battery)
      cores = 2;
      max-jobs = 2;
      
      # Binary caches
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];
      
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
      
      keep-build-log = true;
      keep-derivations = true;
      keep-outputs = true;
      warn-dirty = false;
    };
    
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    
    # Optimize store
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  # Power management for laptop
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";  # Laptop mode
  };
  
  # TLP for advanced laptop power management
  services.tlp = {
    enable = true;
    settings = {
      # CPU settings
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60;
      
      # CPU boost
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      
      # Platform profile
      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      
      # Disk settings
      DISK_DEVICES = "sda";
      DISK_APM_LEVEL_ON_AC = "254 254";
      DISK_APM_LEVEL_ON_BAT = "128 128";
      
      # SATA link power management
      SATA_LINKPWR_ON_AC = "med_power_with_dipm";
      SATA_LINKPWR_ON_BAT = "min_power";
      
      # WiFi power saving
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      
      # Runtime PM
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";
      
      # USB autosuspend
      USB_AUTOSUSPEND = 1;
      
      # Sound power saving
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
    };
  };

  # Hardware acceleration for Intel HD Graphics 520
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver    # VAAPI driver for Skylake+
        intel-compute-runtime # OpenCL
        vaapiIntel           # Legacy VAAPI
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
    
    # Intel CPU microcode
    cpu.intel.updateMicrocode = true;
    
    # Bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = false;  # Save power, enable manually
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
  };

  # Audio optimization with Pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
    # Optimized for laptop
    extraConfig.pipewire = {
      "10-clock-rate" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 2048;  # Higher for battery
          "default.clock.min-quantum" = 512;
          "default.clock.max-quantum" = 4096;
        };
      };
    };
  };

  # Zram for better memory management (4GB compressed swap)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;  # 3.7GB Zram from 7.4GB RAM
  };

  # Tmpfs for faster temporary files
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "2G";  # Conservative for your RAM
  };

  # Earlyoom to prevent system freezes on low memory
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
    enableNotifications = true;
  };

  # irqbalance for better interrupt handling
  services.irqbalance.enable = true;

  # Thermald for Intel thermal management
  services.thermald.enable = true;

  # Disable unused services to save resources
  services = {
    # Disable if not using printing
    printing.enable = false;
    
    # Disable CUPS browsing
    avahi.enable = false;
  };
}
