{ inputs, outputs, ... }:

{
  imports = [
    ./shell
    ./terminal
    ./editor
    ./browser
    ./media
    ./development
    ./data-science
    ./backend
    ./productivity
    ./communication
    ./utilities
    ./keybind-viewer.nix
  ];
}
