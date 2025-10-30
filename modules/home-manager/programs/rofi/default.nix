{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    
    plugins = with pkgs; [
      rofi-calc          # Calculator plugin
      rofi-emoji         # Emoji picker
      rofi-file-browser  # File browser
      rofi-power-menu    # Power menu
    ];
    
    terminal = "${pkgs.kitty}/bin/kitty";
    
    extraConfig = {
      modi = "drun,run,filebrowser,window,calc,emoji";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      display-drun = "  Apps";
      display-run = "  Run";
      display-filebrowser = "  Files";
      display-window = "  Windows";
      display-calc = " 󰃬 Calc";
      display-emoji = " 󰞅 Emoji";
      drun-display-format = "{name}";
      window-format = "{w} · {c} · {t}";
      
      # Behavior
      matching = "fuzzy";
      sort = true;
      sorting-method = "fzf";
      scroll-method = 0;
      disable-history = false;
      
      # Layout
      width = 35;
      lines = 10;
      columns = 1;
      location = 0;
      xoffset = 0;
      yoffset = 0;
      font = "JetBrainsMono Nerd Font 11";
      
      # Keys
      kb-cancel = "Escape,Control+c";
      kb-mode-next = "Shift+Right,Control+Tab";
      kb-mode-previous = "Shift+Left,Control+ISO_Left_Tab";
      kb-row-up = "Up,Control+k";
      kb-row-down = "Down,Control+j";
    };
    
    theme = let 
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg0 = mkLiteral "#1e1e2e";
        bg1 = mkLiteral "#313244";
        bg2 = mkLiteral "#45475a";
        fg0 = mkLiteral "#cdd6f4";
        fg1 = mkLiteral "#bac2de";
        accent = mkLiteral "#89b4fa";
        urgent = mkLiteral "#f38ba8";
        
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg0";
        
        margin = 0;
        padding = 0;
        spacing = 0;
      };
      
      window = {
        location = mkLiteral "center";
        width = 640;
        background-color = mkLiteral "@bg0";
        border = mkLiteral "2px";
        border-color = mkLiteral "@accent";
        border-radius = mkLiteral "8px";
      };
      
      inputbar = {
        padding = mkLiteral "12px";
        spacing = mkLiteral "12px";
        children = map mkLiteral [ "prompt" "entry" ];
        background-color = mkLiteral "@bg1";
        border-radius = mkLiteral "8px 8px 0 0";
      };
      
      prompt = {
        text-color = mkLiteral "@accent";
        font = "JetBrainsMono Nerd Font Bold 12";
      };
      
      entry = {
        placeholder = "Search...";
        placeholder-color = mkLiteral "@bg2";
        cursor = mkLiteral "pointer";
      };
      
      message = {
        margin = mkLiteral "12px 0 0";
        border-radius = mkLiteral "8px";
        border-color = mkLiteral "@accent";
        background-color = mkLiteral "@bg1";
      };
      
      textbox = {
        padding = mkLiteral "8px 12px";
        background-color = mkLiteral "@bg1";
      };
      
      listview = {
        background-color = mkLiteral "transparent";
        margin = mkLiteral "12px 0 0";
        lines = 8;
        columns = 1;
        fixed-height = false;
        scrollbar = true;
      };
      
      scrollbar = {
        width = mkLiteral "4px";
        border = 0;
        handle-color = mkLiteral "@accent";
        handle-width = mkLiteral "4px";
        padding = 0;
        margin = mkLiteral "0 0 0 8px";
      };
      
      element = {
        padding = mkLiteral "8px 12px";
        spacing = mkLiteral "12px";
        border-radius = mkLiteral "6px";
      };
      
      "element normal normal" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg0";
      };
      
      "element normal urgent" = {
        background-color = mkLiteral "@urgent";
        text-color = mkLiteral "@bg0";
      };
      
      "element normal active" = {
        background-color = mkLiteral "@accent";
        text-color = mkLiteral "@bg0";
      };
      
      "element selected normal" = {
        background-color = mkLiteral "@bg2";
        text-color = mkLiteral "@accent";
      };
      
      "element selected urgent" = {
        background-color = mkLiteral "@urgent";
        text-color = mkLiteral "@bg0";
      };
      
      "element selected active" = {
        background-color = mkLiteral "@accent";
        text-color = mkLiteral "@bg0";
      };
      
      "element-icon" = {
        size = mkLiteral "1.2em";
        vertical-align = mkLiteral "0.5";
      };
      
      "element-text" = {
        text-color = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
      };
    };
  };
  
  # Additional rofi utilities
  home.packages = with pkgs; [
    # Rofi scripts
    rofimoji        # Better emoji picker
  ];
  
  # Rofi keybindings in Hyprland config
  # Add to your hyprland.conf:
  # bind = $mainMod, R, exec, rofi -show drun
  # bind = $mainMod, period, exec, rofi -show emoji
  # bind = $mainMod SHIFT, R, exec, rofi -show run
  # bind = $mainMod, E, exec, rofi -show filebrowser
  # bind = $mainMod, C, exec, rofi -show calc -no-show-match -no-sort
}
