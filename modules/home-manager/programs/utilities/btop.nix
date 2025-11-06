{ config, pkgs, lib, ... }:

{
  # Btop - Beautiful system monitor
  programs.btop = {
    enable = true;
    
    settings = {
      # Theme - override Stylix
      color_theme = lib.mkForce "catppuccin_mocha";
      theme_background = false;
      
      # Behavior
      vim_keys = true;
      rounded_corners = true;
      
      # Update rate
      update_ms = 1000;
      
      # Processes
      proc_sorting = "cpu lazy";
      proc_tree = true;
      proc_gradient = true;
      proc_colors = true;
      
      # CPU
      cpu_graph_upper = "total";
      cpu_graph_lower = "total";
      cpu_single_graph = false;
      
      # Memory
      mem_graphs = true;
      mem_below_net = false;
      
      # Network
      net_auto = true;
      net_sync = true;
      net_iface = "";
      
      # Disks
      show_disks = true;
      disk_free_priv = true;
      
      # Show battery
      show_battery = true;
    };
  };
}
