{ config, pkgs, ... }:

{
  # Network diagnostic tools
  home.packages = with pkgs; [
    # Network analysis
    mtr              # Network diagnostic tool
    iperf3           # Network performance
    netcat           # Network utility
    nmap             # Port scanner
    tcpdump          # Packet analyzer
    wireshark        # Network protocol analyzer
    
    # DNS tools
    dog
    # dig              # DNS lookup
    # bind             # DNS utilities (includes dig, nslookup)
    # dogdns           # Modern DNS client
    
    # HTTP tools
    curl
    wget
    httpie           # User-friendly HTTP client
    
    # Monitoring
    bandwhich        # Display network utilization by process
    nethogs          # Network bandwidth by process
    iftop            # Network bandwidth monitoring
  ];

  # SSH configuration
  programs.ssh = {
    enable = true;
    
    # SSH config
    matchBlocks = {
      "*" = {
        # Use SSH keys from keyring
        identityFile = "~/.ssh/id_ed25519";
        
        # Security settings
        extraOptions = {
          AddKeysToAgent = "yes";
          # UseKeychain = "no";
        };
      };
      
      # Example host configuration
      # "github.com" = {
      #   hostname = "github.com";
      #   user = "git";
      #   identityFile = "~/.ssh/id_ed25519_github";
      # };
    };
  };

  # Network status script
  home.file.".local/bin/network-status" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Display network status
      
      set -euo pipefail
      
      echo "🌐 Network Status"
      echo "===================="
      echo
      
      # Active connections
      echo "📡 Active Interfaces:"
      ip -br addr show | grep -v "^lo" | while read line; do
        echo "  $line"
      done
      echo
      
      # Default route
      echo "🚦 Default Route:"
      ip route show default | head -1
      echo
      
      # DNS servers
      echo "🔍 DNS Servers:"
      resolvectl status | grep "DNS Servers" | head -5
      echo
      
      # Connectivity test
      echo "🌍 Connectivity:"
      if ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1; then
        echo "  ✓ Internet: Connected"
      else
        echo "  ✗ Internet: Disconnected"
      fi
      
      if ping -c 1 -W 2 google.com >/dev/null 2>&1; then
        echo "  ✓ DNS: Working"
      else
        echo "  ✗ DNS: Not working"
      fi
      echo
      
      # Network speed (if speedtest is available)
      if command -v speedtest >/dev/null 2>&1; then
        echo "📶 Speed Test:"
        speedtest --simple 2>/dev/null || echo "  Speed test unavailable"
      fi
    '';
  };

  # Quick network restart script
  home.file.".local/bin/network-restart" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Restart network services
      
      echo "🔄 Restarting network services..."
      
      sudo systemctl restart NetworkManager
      
      # Wait for network to come back up
      sleep 3
      
      if ping -c 1 1.1.1.1 >/dev/null 2>&1; then
        echo "✓ Network is back up"
      else
        echo "✗ Network still down"
      fi
    '';
  };
}
