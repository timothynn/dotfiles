{ config, pkgs, ... }:

{
  # OpenSnitch - Application firewall GUI
  services.opensnitch = {
    enable = true;
    
    settings = {
      DefaultAction = "allow"; # Can be "allow" or "deny"
      DefaultDuration = "until restart";
      
      Firewall = "iptables";
      
      LogLevel = 1; # 0=error, 1=warning, 2=info, 3=debug
      
      ProcMonitorMethod = "ebpf"; # or "proc" for older kernels
      
      Stats = {
        MaxEvents = 1000;
        MaxStats = 1000;
      };
      
      UI = {
        Theme = "dark";
      };
    };
  };
  
  # GUI package
  environment.systemPackages = with pkgs; [
    opensnitch-ui
  ];
}
