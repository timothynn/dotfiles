{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      # Window
      confirm_os_window_close = 0;
      window_padding_width = 4;
      window_margin_width = 4;
      hide_window_decorations = "yes";
      
      # Audio
      enable_audio_bell = "no";
      
      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";
      
      # Cursor
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";
      
      # Scrollback
      scrollback_lines = 10000;
      
      # URLs
      url_style = "curly";
      open_url_with = "default";
      
      # Tab bar
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      
      # Font (will be overridden by stylix)
      font_size = 11;
      
      # Shell integration - disable auto-launch of terminal multiplexers
      shell_integration = "no-cursor";
    };
    
    keybindings = {
      "kitty_mod+c" = "copy_to_clipboard";
      "kitty_mod+v" = "paste_from_clipboard";
      "kitty_mod+t" = "new_tab";
      "kitty_mod+w" = "close_tab";
      "kitty_mod+right" = "next_tab";
      "kitty_mod+left" = "previous_tab";
      "kitty_mod+plus" = "change_font_size all +2.0";
      "kitty_mod+minus" = "change_font_size all -2.0";
      "kitty_mod+0" = "change_font_size all 0";
    };
  };
}