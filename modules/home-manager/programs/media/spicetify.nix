{ config, pkgs, inputs, lib, ... }:

{
  # Spicetify - Spotify customization
  programs.spicetify = 
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      
      # Catppuccin Mocha theme - override Stylix
      theme = lib.mkForce spicePkgs.themes.catppuccin;
      colorScheme = lib.mkForce "mocha";

      # Enable extensions
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
        keyboardShortcut
        fullAppDisplay
        betterGenres
      ];
    };
}
