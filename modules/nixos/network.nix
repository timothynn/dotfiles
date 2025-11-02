{ config, pkgs, ... }:

{
  # Networking configuration
  networking = {
    # Firewall settings are configured in modules/nixos/system/security.nix
    # Additional firewall ports for email services
    firewall.allowedTCPPorts = [
      # SMTP
      25    # SMTP
      587   # SMTP with STARTTLS
      465   # SMTPS
      
      # IMAP
      143   # IMAP
      993   # IMAPS
      
      # POP3
      110   # POP3
      995   # POP3S
    ];
    
    # DNS configuration - helps with email fetching
    nameservers = [ 
      "1.1.1.1"  # Cloudflare
      "8.8.8.8"  # Google
    ];
    
    # Enable systemd-resolved for better DNS handling
    # Comment out if you prefer networkmanager's DNS
    # networkmanager.dns = "systemd-resolved";
  };
  
  # Enable systemd-resolved
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    extraConfig = ''
      DNS=1.1.1.1 8.8.8.8
      FallbackDNS=1.0.0.1 8.8.4.4
    '';
  };
}
