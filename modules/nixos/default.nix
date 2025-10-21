{ inputs, outputs, ... }:

{
  imports = [
    ./desktop
    ./programs
    ./services
    ./system
    ./security.nix
    ./performance.nix
  ];
}
