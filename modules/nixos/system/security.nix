{ config, pkgs, ... }:

{
  # Firewall configuration
  networking.firewall = {
    enable = true;
    
    # Allow specific ports
    allowedTCPPorts = [
      5432  # PostgreSQL
      22    # SSH (if needed)
      80    # HTTP (if needed)
      443   # HTTPS (if needed)
    ];
    
    allowedUDPPorts = [
      53  # DNS
    ];
    
    # Trusted interfaces (if using VPN)
    trustedInterfaces = [ "lo" ];
    
    # Log refused connections
    logRefusedConnections = true;
    logRefusedPackets = false;  # Can be noisy
  };

  # Fail2ban for brute force protection
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "10m";
    bantime-increment = {
      enable = true;
      maxtime = "168h";  # 1 week
      factor = "4";
    };
  };

  # USB Guard (optional - uncomment if you want USB device control)
  # services.usbguard = {
  #   enable = true;
  #   rules = ''
  #     # Allow all USB devices by default (customize as needed)
  #     allow with-interface equals { 08:*:* }  # Mass storage
  #     allow with-interface equals { 03:*:* }  # HID devices
  #   '';
  # };

  # Security enhancements
  security = {
    # Sudo timeout
    sudo.extraConfig = ''
      Defaults timestamp_timeout=30
    '';
    
    # Polkit already enabled in desktop module
    
    # Additional security options
    protectKernelImage = true;
  };

  # AppArmor profiles (optional but recommended)
  security.apparmor = {
    enable = true;
    packages = [ pkgs.apparmor-profiles ];
  };

  # System audit
  security.auditd.enable = true;
  security.audit = {
    enable = true;
    rules = [
      "-a exit,always -F arch=b64 -S execve"
    ];
  };
}
