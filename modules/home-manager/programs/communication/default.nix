{ config, pkgs, ... }:

let
  # Wrapper for mailspring that ensures keyring socket is available
  mailspring-wrapped = pkgs.writeShellScriptBin "mailspring" ''
    # Set keyring control socket path
    export GNOME_KEYRING_CONTROL="$XDG_RUNTIME_DIR/keyring"
    
    # Ensure dbus session is available
    if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
      export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
    fi
    
    # Launch mailspring with gnome-libsecret password store
    exec ${pkgs.mailspring}/bin/mailspring --password-store="gnome-libsecret" "$@"
  '';
in
{
  # Communication applications
  home.packages = with pkgs; [
    # Email (wrapped to ensure keyring access)
    mailspring-wrapped
    # Note: libsecret is provided at system level

    # Chat/Video
    vesktop          # Better Discord client
    telegram-desktop
    zoom-us
    slack
    teams-for-linux
  ];
  
  # Desktop entry for Mailspring to appear in Rofi
  home.file.".local/share/applications/mailspring.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Mailspring
    GenericName=Email Client
    Comment=Send and receive email
    Exec=mailspring %U
    Icon=mailspring
    Terminal=false
    Categories=Network;Email;Office;
    MimeType=x-scheme-handler/mailto;x-scheme-handler/mailspring;
    StartupNotify=true
    StartupWMClass=Mailspring
  '';
}