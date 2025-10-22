{ inputs, outputs, ... }:

{
  imports = [
    ./shell
    ./terminal
    ./editor
    ./browser
    ./media
    ./development
    ./productivity
    ./communication
    ./utilities
    ./keybind-viewer.nix
  ];
}