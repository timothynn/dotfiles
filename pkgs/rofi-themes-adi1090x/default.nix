{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "rofi-themes-adi1090x";
  version = "2024-11-06";

  src = fetchFromGitHub {
    owner = "adi1090x";
    repo = "rofi";
    rev = "093c1a79f58daab358199c4246de50357e5bf462";
    hash = "sha256-iUX0Quae06tGd7gDgXZo1B3KYgPHU+ADPBrowHlv02A=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rofi/themes
    cp -r files/* $out/share/rofi/themes/

    runHook postInstall
  '';

  meta = with lib; {
    description = "A huge collection of Rofi based custom Applets, Launchers & Powermenus";
    homepage = "https://github.com/adi1090x/rofi";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
