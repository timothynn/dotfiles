{ lib
, stdenv
, fetchurl
, makeWrapper
, jdk17
, gtk3
, glib
, libXtst
, webkitgtk_4_1
}:

stdenv.mkDerivation rec {
  pname = "dbeaver-ee";
  version = "25.2.0";

  src = fetchurl {
    url = "https://dbeaver.com/files/${version}/dbeaver-ee-${version}-linux.gtk.x86_64-nojdk.tar.gz";
    sha256 = "062xaipdxlqabd91jvydv6q46b234a50rpqyxax71jg29fxvlp3k";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    jdk17
    gtk3
    glib
    libXtst
    webkitgtk_4_1
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/dbeaver
    cp -r . $out/opt/dbeaver

    mkdir -p $out/bin
    makeWrapper $out/opt/dbeaver/dbeaver $out/bin/dbeaver \
      --prefix PATH : ${lib.makeBinPath [ jdk17 ]} \
      --set JAVA_HOME ${jdk17.home} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ gtk3 glib libXtst webkitgtk_4_1 ]}

    # Create desktop entry
    mkdir -p $out/share/applications
    cat > $out/share/applications/dbeaver-ee.desktop <<EOF
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=DBeaver Enterprise
    Comment=Universal Database Manager and SQL Client
    Exec=$out/bin/dbeaver
    Icon=$out/opt/dbeaver/dbeaver.png
    Terminal=false
    Categories=Development;Database;
    Keywords=SQL;MySQL;PostgreSQL;Oracle;Database;
    StartupWMClass=DBeaver
    EOF

    # Copy icon if it exists
    if [ -f dbeaver.png ]; then
      mkdir -p $out/share/pixmaps
      cp dbeaver.png $out/share/pixmaps/dbeaver-ee.png
    fi

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://dbeaver.com/";
    description = "Universal Database Manager and SQL Client - Enterprise Edition";
    platforms = platforms.linux;
    license = licenses.unfree;
    maintainers = [ ];
  };
}
