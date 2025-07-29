# python.nix
{ config, pkgs, ... }:

let
  # Definieren einer einzigen, benutzerdefinierten Python-Umgebung
  # mit allen notwendigen Paketen.
  python-env = (pkgs.python312.withPackages (ps: with ps; [
    # Werkzeuge für Paketmanagement und Builds
    pip                           # PyPA recommended tool for installing packages
    setuptools                    # Build system foundation
    wheel                         # For building wheels [cite: 3]
    virtualenv                    # create isolated Python environments
    # API- und Web-Bibliotheken
    openai                        # Access to OpenAI API
    feedparser                    # Universal feed parser [cite: 5]
    beautifulsoup4                # HTML/XML Parsing
    # Audio- und Sprachverarbeitung
    pydub                         # Audio manipulation toolkit [cite: 4]
    speechrecognition             # API for voice recognition
    librosa                       # Audioanalyse, FFT, Tonhöhe, Beat-Detection [cite: 6]
    soundfile                     # Lesen/Schreiben von Audiodateien [cite: 6]
    # Bildverarbeitung und ASCII-Art
    pillow                        # (PIL Fork) - Für Bildverarbeitung [cite: 9]
    numpy                         # Für effiziente Pixelmanipulation [cite: 9]
    ascii-magic                   # Converts images to ASCII
    art                           # ASCII Art generation
    # CLI- und Terminal-Werkzeuge
    rich                          # Farbenfrohe Terminalausgabe [cite: 7]
    typer                         # CLI-Tools mit Typanmerkungen [cite: 7]
    prompt-toolkit                # shell-artige Tools, Autovervollständigung
    # Entwicklung und Testen
    pytest                        # Erweiterter Test-Runner [cite: 8]
    black                         # Code Formatter [cite: 8]
    # Sonstige Werkzeuge
    pygments                      # Syntax highlighting for code
    markdown2                     # Markdown parser in Python [cite: 6]
    pdfminer                      # PDF zu Text [cite: 9]
    keyrings-alt                  # Alternative keyring backends
  ]));

in
{
  # Installieren Sie NUR die oben definierte, angepasste Python-Umgebung.
  environment.systemPackages = with pkgs; [
    python-env # Diese Umgebung enthält Python 3.12 und alle Pakete
    jetbrains.pycharm-community-bin # py IDE.
    nix-ld # Run unpatched dynamic binaries on NixOS
  ];


# Enable nix-ld, a compatibility tool that allows executing
  # dynamically linked ELF binaries that were built outside of Nix/Nixpkgs.
  # It provides a fallback dynamic linker and library path for such binaries.
  programs.nix-ld.enable = true;
 
  # Define the shared libraries that nix-ld should make available
  # to foreign dynamically linked binaries. This is crucial for running
  # precompiled Linux software (e.g., from GitHub, vendor tarballs)
  # that depends on common libraries not available in the Nix store path.
  programs.nix-ld.libraries = with pkgs; [

    # Core system libraries used by most programs
    stdenv.cc.cc.lib   # Contains libstdc++, libgcc_s — essential C/C++ runtime libraries
    zlib               # Compression library used for gzipped data
    openssl            # Provides libssl and libcrypto for TLS, HTTPS, etc.
    curl               # Useful for binaries requiring HTTP(S) communication

    # Common Linux compatibility libraries
    nss                # Network Security Services (used by Firefox, etc.)
    nspr               # Netscape Portable Runtime (dependency of nss)
    libxml2            # XML parsing library (used by many C/C++ apps)
    libunwind          # Stack unwinding (used in backtraces, crash handling)
    icu                # International Components for Unicode (Unicode/locale support)
    libuuid            # Universally Unique Identifier library
    libapparmor        # AppArmor support (if binary uses AppArmor confinement)
    alsa-lib           # Advanced Linux Sound Architecture (audio)
    expat              # Fast XML parser used in many low-level tools
    dbus               # D-Bus IPC (for apps needing interprocess communication)
    systemd            # Provides libsystemd, e.g. for journal/logging APIs

    # GUI libraries (uncomment as needed for GUI binaries)
    # xorg.libX11       # X11 windowing system support
    # gtk3              # GTK 3 toolkit for graphical UIs
  ];
 }
