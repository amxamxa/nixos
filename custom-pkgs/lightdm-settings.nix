{ pkgs ? import <nixpkgs> {} }:

let
  lib = pkgs.lib;
in

pkgs.stdenv.mkDerivation rec {
  pname = "lightdm-settings";
  version = "latest";

  src = pkgs.fetchFromGitHub {
    owner = "linuxmint";
    repo = "lightdm-settings";
    rev = "master";
    sha256 = "0ib80zhg36ypr4ashqwf3150cyg7jfx6244bc2s5v1n4j9pl7zlm";
  };

  # Build- und Laufzeit-Abhängigkeiten
  nativeBuildInputs = [
    pkgs.gnumake        # Für die Build-Phase
    pkgs.python3        # Benötigt während der Build-Phase
    pkgs.gettext        # Für msgfmt
    pkgs.wrapGAppsHook  # GTK-spezifische Wrapper
  ];

  buildInputs = [
    pkgs.python3
    pkgs.libgcc         # Laufzeit-C-Bibliothek
    pkgs.glibc          # C-Standardbibliothek
    pkgs.libunistring   # UTF-8 Unterstützung
    pkgs.libidn2        # IDN-Unterstützung
    pkgs.bash           # Bash als Shell
    pkgs.lightdm        # LightDM selbst
    pkgs.lightdm-slick-greeter # Slick-Greeter
    pkgs.gtk3           # GTK-Bibliothek
    pkgs.gobject-introspection # GI-Bindings
    pkgs.libgee         # GObject-Collection-Bibliothek
  ];

  # Übersetzung und Build
  buildPhase = ''
    echo "Building translations and compiling..."
    make
  '';

  # Installation und Wrapper-Erstellung
  installPhase = ''
    # Verzeichnisse erstellen
    mkdir -p $out/{bin,share}
    mkdir -p $out/share/{applications,polkit-1/actions}
    mkdir -p $out/lib/lightdm-settings

    # Dateien kopieren
    if [ -d usr/lib/lightdm-settings ]; then
      cp -r usr/lib/lightdm-settings/* $out/lib/lightdm-settings/
    fi
    cp -r usr/share/locale $out/share/
    cp usr/share/applications/lightdm-settings.desktop $out/share/applications/
    cp usr/share/polkit-1/actions/org.x.lightdm-settings.policy $out/share/polkit-1/actions/

    # Wrapper-Skript erstellen
    cat > $out/bin/lightdm-settings << EOF
    #!/bin/sh
    exec ${pkgs.python3}/bin/python3 $out/lib/lightdm-settings/lightdm-settings.py
    EOF
    chmod +x $out/bin/lightdm-settings

    # Pfade korrigieren
    substituteInPlace $out/lib/lightdm-settings/lightdm-settings.py \
      --replace "/usr/lib/lightdm-settings" "$out/lib/lightdm-settings"
  '';

  # GTK-Wrapping
  postFixup = ''
    wrapProgram $out/bin/lightdm-settings \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/lib/lightdm-settings" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix XDG_DATA_DIRS : "$out/share:$XDG_DATA_DIRS"
  '';

  # Meta-Informationen
  meta = with lib; {
    description = "A configuration tool for the LightDM display manager";
    homepage = "https://github.com/linuxmint/lightdm-settings";
    license = licenses.gpl3;
  };
}



