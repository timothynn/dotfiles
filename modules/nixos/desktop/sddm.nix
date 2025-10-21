{ config, pkgs, ... }:

let
  # Catppuccin SDDM theme
  catppuccin-sddm = pkgs.stdenv.mkDerivation {
    name = "catppuccin-sddm-mocha";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "sddm";
      rev = "4d52ea50b511ab677329c4d9d2c4db589d03b5d2";
      sha256 = "sha256-/0DV3ZDjFBpMFEP1pcbixVTHJnr+yR8fLfKfCGz/eFw=";
    };
    
    installPhase = ''
      mkdir -p $out/share/sddm/themes/catppuccin-mocha
      cp -r src/catppuccin-mocha/* $out/share/sddm/themes/catppuccin-mocha/
      
      # Customize theme.conf for your screen
      cat > $out/share/sddm/themes/catppuccin-mocha/theme.conf << EOF
[General]
Background="backgrounds/mocha.png"
Font="JetBrainsMono Nerd Font"
FontSize=10
Locale=

AccentColor=#89b4fa
BackgroundColor=#1e1e2e
ForegroundColor=#cdd6f4

CornerRadius=16

MainColor=#cdd6f4
PasswordFieldColor=#313244
UserPictureColor=#89b4fa

SessionButtonColor=#313244
PowerButtonColor=#313244

TranslateLogin=Login
TranslateLoginFailed=Login Failed
TranslatePassword=Password
TranslateSession=Session
TranslateUsernamePlaceholder=Username

ForceRightToLeft=false

EOF
    '';
  };
in
{
  # Display manager with Catppuccin theme
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
    
    theme = "catppuccin-mocha";
    
    settings = {
      Theme = {
        Current = "catppuccin-mocha";
        ThemeDir = "${catppuccin-sddm}/share/sddm/themes";
        CursorTheme = "Bibata-Modern-Classic";
        CursorSize = 20;  # Adjusted for 1366x768
        Font = "JetBrainsMono Nerd Font";
        EnableAvatars = true;
      };
      
      General = {
        InputMethod = "";
        Numlock = "on";
        HaltCommand = "/run/current-system/systemd/bin/systemctl poweroff";
        RebootCommand = "/run/current-system/systemd/bin/systemctl reboot";
      };
      
      Users = {
        MaximumUid = 60000;
        MinimumUid = 1000;
        HideUsers = "";
        HideShells = "/bin/false,/usr/bin/nologin,/sbin/nologin";
        RememberLastUser = true;
        RememberLastSession = true;
      };
      
      Wayland = {
        SessionDir = "/run/current-system/sw/share/wayland-sessions";
        CompositorCommand = "Hyprland";
      };
    };
  };

  # Required packages
  environment.systemPackages = with pkgs; [
    catppuccin-sddm
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtsvg
    kdePackages.qt6ct
    bibata-cursors
  ];
}
