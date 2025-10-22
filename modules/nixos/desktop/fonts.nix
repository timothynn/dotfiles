{ config, pkgs, ... }:

{
  # Fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-serif
    ];
    
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" "Source Han Serif" ];
        sansSerif = [ "Noto Sans" "Source Han Sans" ];
        monospace = [ "JetbrainsMono Nerd Font" ];
      };
    };
  };
}