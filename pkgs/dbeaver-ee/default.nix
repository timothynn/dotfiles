{ lib
, stdenv
, fetchurl
, buildFHSEnv
, makeDesktopItem
, copyDesktopItems
, jdk
, gtk3
, glib
, libXtst
, webkitgtk_4_1
, libsecret
, gsettings-desktop-schemas
, wrapGAppsHook3
}:

let
  pname = "dbeaver-ee";
  version = "25.2.0";

  dbeaver-ee-unwrapped = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://dbeaver.com/files/${version}/dbeaver-ee-${version}-linux.gtk.x86_64-nojdk.tar.gz";
      sha256 = "Sqi8un3FU680vhscTEw+zxdy0DdBKNYDL+vWxbRhnhk=";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/opt/dbeaver
      cp -r . $out/opt/dbeaver

      # Copy icon
      mkdir -p $out/share/pixmaps
      cp dbeaver.png $out/share/pixmaps/dbeaver-ee.png

      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://dbeaver.com/";
      description = "Universal Database Manager and SQL Client - Enterprise Edition";
      platforms = platforms.linux;
      license = licenses.unfree;
    };
  };

in buildFHSEnv {
  name = "dbeaver";

  targetPkgs = pkgs: with pkgs; [
    dbeaver-ee-unwrapped
    jdk
    gtk3
    glib
    libXtst
    webkitgtk_4_1
    libsecret
    gsettings-desktop-schemas
    
    # Additional dependencies that might be needed
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXtst
    xorg.libXrender
    fontconfig
    freetype
    zlib
  ];

  runScript = "${dbeaver-ee-unwrapped}/opt/dbeaver/dbeaver";

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cat > $out/share/applications/dbeaver-ee.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=DBeaver Enterprise
Comment=Universal Database Manager and SQL Client
Exec=$out/bin/dbeaver
Icon=${dbeaver-ee-unwrapped}/share/pixmaps/dbeaver-ee.png
Terminal=false
Categories=Development;Database;
Keywords=SQL;MySQL;PostgreSQL;Oracle;Database;
StartupWMClass=DBeaver
EOF

    mkdir -p $out/share/pixmaps
    ln -s ${dbeaver-ee-unwrapped}/share/pixmaps/dbeaver-ee.png $out/share/pixmaps/
  '';

  meta = dbeaver-ee-unwrapped.meta;
}
