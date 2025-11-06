{ config, pkgs, ... }:

{
  # Zellij - Modern terminal multiplexer
  programs.zellij = {
    enable = true;
    
    settings = {
      # Theme
      theme = "catppuccin-mocha";
      
      # UI settings
      pane_frames = false;
      simplified_ui = true;
      default_layout = "compact";
      
      # Behavior
      on_force_close = "quit";
      scroll_buffer_size = 10000;
      copy_on_select = true;
      
      # Mouse
      mouse_mode = true;
      
      # Keybindings - use Ctrl+Space as prefix to avoid conflicts
      keybinds = {
        normal = {
          "bind \"Ctrl g\"" = { SwitchToMode = "locked"; };
        };
      };
      
      # Themes
      themes.catppuccin-mocha = {
        fg = "#cdd6f4";
        bg = "#1e1e2e";
        black = "#45475a";
        red = "#f38ba8";
        green = "#a6e3a1";
        yellow = "#f9e2af";
        blue = "#89b4fa";
        magenta = "#cba6f7";
        cyan = "#94e2d5";
        white = "#bac2de";
        orange = "#fab387";
      };
    };
  };
}
