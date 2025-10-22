{ config, pkgs, ... }:

{
  # Install the keybind viewer scripts
  home.file.".local/bin/keybind-viewer" = {
    source = ../../../scripts/keybind-viewer.py;
    executable = true;
  };
  
  home.file.".local/bin/keybinds-rofi" = {
    source = ../../../scripts/keybinds-rofi.sh;
    executable = true;
  };
  
  home.file.".local/bin/keybinds-show" = {
    source = ../../../scripts/keybinds-show.sh;
    executable = true;
  };

  # Create desktop entry for the GUI app
  xdg.desktopEntries.keybind-viewer = {
    name = "Hyprland Keybindings";
    comment = "View Hyprland keybindings in a GUI";
    exec = "/home/tim/.local/bin/keybind-viewer";
    icon = "preferences-desktop-keyboard-shortcuts";
    categories = [ "System" "Utility" ];
    terminal = false;
  };
}