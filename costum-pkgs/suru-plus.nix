{ pkgs ? import <nixpkgs> {} }:
# nix-build -E 'with import <nixpkgs> {}; zsh-autosuggestions'



# Bauen des Projekts: Nachdem Sie die Nix-Expression erstellt haben, können Sie das Projekt mit dem Befehl nix-build bauen. Dieser Befehl liest die Nix-Expression und führt die Build-Anweisungen aus.
pkgs.stdenv.mkDerivation rec {
  pname = "suru-plus";
  version = "9bd895f324051ed9ba26e5981dd995376e5e572a";

  src = pkgs.fetchFromGitHub {
    owner = "gusbemacbe";
    repo = "suru-plus";
    rev = "9bd895f324051ed9ba26e5981dd995376e5e572a";
    sha256 = "0pdcxm7i2yagbqf7pqjvrqpkdbb8irb6bdqfz1w66ln42xsqp53d";
    };
    # $ nix-prefetch-url --unpack https://github.com/gusbemacbe/suru-plus/archive/master.tar.gz
  buildInputs = [ pkgs.makeWrapper ];
# Verzeichnis $out/share/icons erstellt wird und die Dateien dorthin kopiert werden. makeWrapper wird als buildInput hinzugefügt, um sicherzustellen, dass alle notwendigen Werkzeuge zur Verfügung stehen
# Ansonsten: Verzeichnis /usr/share/icons zu schreiben, was in der Sandbox vonNix nicht erlaubt ist. Stattdessen sollte das Paket in das temporäre Verzeichnis $out installiert werden, welches von Nix bereitgestellt wird.
  installPhase = ''
    mkdir -p $out/share/icons
    cp -r * $out/share/icons/
  '';
}
