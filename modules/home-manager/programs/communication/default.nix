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
    
    # Launch mailspring with keyring available
    exec ${pkgs.mailspring}/bin/mailspring "$@"
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
}