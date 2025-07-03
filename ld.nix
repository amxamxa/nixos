 { config, pkgs, ... }:

{
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
