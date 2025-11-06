{ config, pkgs, ... }:

{
  # Automatic garbage collection and optimization
  nix = {
    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    
    # Store optimization
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    
    # Additional settings
    settings = {
      auto-optimise-store = true;
      
      # Clean up build artifacts
      min-free = "${toString (5 * 1024 * 1024 * 1024)}"; # 5GB
      max-free = "${toString (10 * 1024 * 1024 * 1024)}"; # 10GB
    };
  };
  
  # Systemd tmpfiles cleanup
  systemd.tmpfiles.rules = [
    "d /tmp 1777 root root 10d"
    "d /var/tmp 1777 root root 30d"
  ];
}
