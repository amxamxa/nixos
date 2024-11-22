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
    # $ nix-prefetch-url --unpack https://github.com/linuxmint/lightdm-settings/archive/master.tar.gz
    sha256 = "0ib80zhg36ypr4ashqwf3150cyg7jfx6244bc2s5v1n4j9pl7zlm";
  };

  nativeBuildInputs = [ pkgs.python3 pkgs.makeWrapper ];

  buildInputs = [
    pkgs.lightdm
     pkgs.lightdm-slick-greeter
     pkgs.gtk3
    pkgs.gobject-introspection
    pkgs.libgee
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin
  '';
# meta = with pkgs.stdenv.lib; {
  meta = with lib; {
    description = "A configuration tool for the LightDM display manager";
    homepage = "https://github.com/linuxmint/lightdm-settings";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };
}

