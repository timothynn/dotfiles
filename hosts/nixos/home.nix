{ inputs, outputs, ... }:

{
  home-manager.users.tim = {
    imports = [
      ../../home/tim
    ];
  };
}