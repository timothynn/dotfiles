{ inputs, outputs, config, pkgs, ... }:

{
  imports = [
    # Import the hardware configuration
    ../../hardware-configuration.nix
    
    # Import modular system configurations
    ../../modules/nixos
    
    # Home manager configuration for this host
    ./home.nix
  ];

  # Bootloader - GRUB with Catppuccin theme for UEFI
  boot.loader = {
    # Disable systemd-boot
    systemd-boot.enable = false;
    
    # Enable GRUB for UEFI
    grub = {
      enable = true;
      device = "nodev";  # UEFI mode
      efiSupport = true;
      efiInstallAsRemovable = false;
      useOSProber = true;  # Detect other OS
      
      # Catppuccin Mocha theme
      theme = pkgs.stdenv.mkDerivation {
        name = "catppuccin-grub-mocha";
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "grub";
          rev = "803c5df0e83aba61668777bb96d90ab8f6847106";
          sha256 = "sha256-/bSolCta8GCZ4lP0u5NVqYQ9Y3ZooYCNdTwORNvR7M0=";
        };
        installPhase = ''
          mkdir -p $out
          cp -r src/catppuccin-mocha-grub-theme/* $out/
        '';
      };
      
      timeout = 5;
      default = 0;
      gfxmodeEfi = "1366x768";  # Your laptop resolution
      memtest86.enable = true;
    };
    
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  # Plymouth for smooth boot
  boot.plymouth = {
    enable = true;
    theme = "catppuccin-mocha";
    themePackages = [
      (pkgs.catppuccin-plymouth.override {
        variant = "mocha";
      })
    ];
  };

  # Kernel parameters optimized for your laptop
  boot.kernelParams = [
    "quiet"
    "splash"
    "i915.enable_fbc=1"       # Intel framebuffer compression
    "i915.enable_psr=2"       # Panel self refresh for battery
    "i915.fastboot=1"         # Faster boot
  ];

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.powersave = true;  # WiFi power saving
    };
    
    # Firewall with development ports
    firewall = {
      enable = true;
      allowedTCPPorts = [ 
        22    # SSH
        80    # HTTP
        443   # HTTPS
        3000  # Dev server
        5432  # PostgreSQL
        6379  # Redis
        8080  # Alt HTTP
        9090  # Prometheus
      ];
    };
  };

  # Localization
  time.timeZone = "Africa/Nairobi";
  i18n.defaultLocale = "en_US.UTF-8";

  # Console configuration
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Users
  users.users.tim = {
    isNormalUser = true;
    description = "Tim - Data Engineer & Software Developer";
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "audio" 
      "video" 
      "storage" 
      "podman"
      "docker"
      "adbusers"
      "libvirtd"
    ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  # Set default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Security
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
    };
    
    polkit.enable = true;
    rtkit.enable = true;
    
    # PAM
    pam.services = {
      login.enableGnomeKeyring = true;
      sddm.enableGnomeKeyring = true;
    };
  };

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "tim" ];
    auto-optimise-store = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Virtualization
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Enable OpenSSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Essential system packages
  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    wget
    curl
    htop
    tree
    unzip
    gparted
    ntfs3g
    exfat
  ];

  # System state version
  system.stateVersion = "25.05";
}
