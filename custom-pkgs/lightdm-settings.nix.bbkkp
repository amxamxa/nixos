{ stdenv, lib, meson, ninja, gettext, pkgconfig, glib, gtk3, lightdm, dconf }:

stdenv.mkDerivation {
  pname = "lightdm-settings";
  version = "1.0.0";  # Passe die Version an das Projekt an

  src = ./.;  # Das aktuelle Verzeichnis als Quellcode

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkgconfig
  ];

  buildInputs = [
    glib
    gtk3
    lightdm
    dconf
  ];

  meta = with lib; {
    description = "A settings manager for LightDM display manager";
    homepage = "https://github.com/linuxmint/lightdm-settings";
    license = licenses.gpl3;  # Passe die Lizenz an
    maintainers = with maintainers; [ your_name_here ];  # Trage deinen Namen ein
  };

  # Installationsprozess
  mesonFlags = [ ];
  buildPhase = "meson _build && ninja -C _build";
  installPhase = "DESTDIR=$out ninja -C _build install";
}

