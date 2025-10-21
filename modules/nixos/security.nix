{ config, pkgs, lib, ... }:

{
  # Security hardening module

  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowPing = false;
    logRefusedConnections = false;  # Save resources on laptop
  };

  # Security services
  services = {
    # Fail2ban for brute force protection
    fail2ban = {
      enable = true;
      maxretry = 5;
      ignoreIP = [
        "127.0.0.0/8"
        "10.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"
      ];
      
      jails.sshd = ''
        enabled = true
        port = ssh
        filter = sshd
        maxretry = 3
      '';
    };
    
    # AppArmor
    apparmor = {
      enable = true;
      killUnconfinedConfinables = false;  # Less strict for development
    };
  };

  # Security settings
  security = {
    # Sudo configuration
    sudo = {
      enable = true;
      execWheelOnly = true;
      extraConfig = ''
        Defaults lecture = never
        Defaults timestamp_timeout = 30
      '';
    };
    
    # Disable coredumps
    pam.loginLimits = [
      { domain = "*"; type = "hard"; item = "core"; value = "0"; }
      { domain = "*"; type = "soft"; item = "nofile"; value = "524288"; }
      { domain = "*"; type = "hard"; item = "nofile"; value = "1048576"; }
    ];
  };

  # Boot security
  boot = {
    # Kernel security parameters (balanced for development)
    kernelParams = [
      "page_alloc.shuffle=1"
      "pti=on"
    ];
    
    # Blacklist uncommon filesystems
    blacklistedKernelModules = [
      "cramfs"
      "freevxfs"
      "jffs2"
      "hfs"
      "hfsplus"
      "udf"
      "dccp"
      "sctp"
      "rds"
      "tipc"
    ];
    
    # Kernel hardening
    kernel.sysctl = {
      # Network security
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.default.accept_source_route" = 0;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.default.accept_source_route" = 0;
      
      # Kernel security
      "kernel.dmesg_restrict" = 1;
      "kernel.kptr_restrict" = 2;
      "kernel.unprivileged_bpf_disabled" = 1;
      "kernel.yama.ptrace_scope" = 1;
      
      # File system
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;
      "fs.suid_dumpable" = 0;
    };
  };

  # Secure system packages
  environment.systemPackages = with pkgs; [
    # Security tools
    cryptsetup
    gnupg
    openssl
    age
    sops
    
    # Password management
    keepassxc
  ];
}
