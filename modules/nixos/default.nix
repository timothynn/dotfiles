{ inputs, outputs, ... }:

{
  imports = [
    ./desktop
    ./programs
    ./services
    ./system
  ];
}