# /etc/nixos/modules/packages.nix
{ config, pkgs, lib, ... }: 
{

# System-wide application packages
#--------------------------------
# Organization:
# - Packages specific to shells (zsh, bash) are in their respective modules
# - Packages specific to desktop environments are in their respective modules
# - This file contains general system utilities and applications
# Note: Check for duplicates before adding packages here


  # to install from unstable-channel, siehe packages.nix
  nixpkgs.config = {
    allowUnfreePredicate = pkg:
    ##allow unfree
      builtins.elem (lib.getName pkg) [
        "vivaldi"              "vagrant"
        "memtest86-efi"        "sublimetext"
        "obsidian"             "typora"
        "decent-sampler"        "vst2-sdk"
        "kiro"
      ];
    allowUnfree = false;

    packageOverrides = pkgs: {
      unstable = import (fetchTarball
        "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") { };
    };

  };

  #  Allow InsecurePackages
  nixpkgs.config.permittedInsecurePackages = [
    #"openssl-1.1.1w" 	    #"gradle-6.9.4" 
    # "electron-25.9.0"     # "dotnet-sdk-7.0.410"
    # "dotnet-runtime-7.0.20"
  ];


  # ====================================
  # SYSTEM PACKAGES
    environment.systemPackages = with pkgs; [
kiro-fhs # Wrapped variant of kiro which launches in a FHS compatible environment, should allow for easy usage of extensions without nix-specific modifications
  webfont-bundler # Create @font-face kits easily
font-manager # Simple font management for GTK desktop environments
texlivePackages.missaali # A late medieval OpenType textura font
dinish # Modern computer font inspired by DIN 1451
texlivePackages.yfonts-otf # OpenType version of the Old German fonts

    # ──────────────────────────────────────────────
    # WAYLAND & COMPOSITOR TOOLS
       wlr-which-key              # Keymap manager for wlroots compositors
    ydotool                    # Generic automation tool for Wayland
    # ───────────────────────────────────────────
    # CORE SYSTEM UTILITIES
        
    # System Information & Diagnostics
    dmidecode                  # Hardware info via SMBIOS/DMI
    efibootmgr                 # EFI boot manager utility
    kbd                        # Keyboard tools and keymaps
    libxkbcommon              # Keyboard description library
    gettext                    # Internationalization framework
    toybox                     # Minimalist Unix utilities
    file                       # File type identification
    inxi                       # Comprehensive system info tool
    lshw                       # Detailed hardware lister
    
    # Process & Resource Monitoring
    btop                       # Modern resource monitor (htop replacement)
    htop                       # Interactive process viewer
    bottom                     # Alternative system monitor
    procs                      # Modern ps replacement
    libgtop                    # Multi-core system monitor library
    
    # Disk Usage Analysis
    duf                        # Modern df with better output
    dust                       # More intuitive du
    baobab                     # Graphical disk usage analyzer (GNOME)
    # Note: ncdu is in zsh.nix as it's primarily a CLI tool
    
    # Logging & System Management
    logrotate                  # Log rotation utility
    coreutils                  # GNU core utilities
    tree                       # Directory tree display

    # ──────────────────────────────────────────
    # BOOTLOADER & RECOVERY
    
    grub2                      # GRUB bootloader
    memtest86-efi             # Memory testing tool
    os-prober                  # Detect other operating systems
    nixos-grub2-theme         # NixOS GRUB theme
    # testdisk                   # Partition recovery tool
    # extundelete               # ext3/ext4 file recovery
    gparted                    # Partition editor

    # ─────────────────────────
    # BACKUP & SYNCHRONIZATION
    # ─────────────────────────
    deja-dup                   # Simple backup tool with GUI
    duplicity                  # Encrypted incremental backups
    warpinator                 # LAN file sharing
    dedup                      # Deduplicating backup
    timeshift                  # System restore utility

    # ─────────────────────────
    # NETWORKING & CONNECTIVITY
    # ─────────────────────────
        # Virtual Filesystem & Device Management
    gvfs                       # Virtual filesystem support
    avahi                      # mDNS/DNS-SD (network discovery)
    blueman                    # Bluetooth manager (GTK)
    wirelesstools             # Wireless interface tools (iwconfig, etc.)
    hidapi                     # USB/Bluetooth HID device library
    ntfs3g                     # FUSE-based NTFS driver
    
    # Network Tools
    curl                       # Data transfer tool
    wget                       # Network downloader
    openssl                    # SSL/TLS toolkit
    inetutils                  # Network utilities (ftp, telnet, etc.)
    dog                        # DNS lookup (dig alternative)
    gping                      # Ping with graph
    trippy                     # Network diagnostic (modern traceroute)
    mtr                        # Network diagnostic tool
    bandwhich                  # Network utilization by process
    vnstat                     # Network traffic monitor

    # ─────────────────────────
    # ANDROID TOOLS & MTP
    # ─────────────────────────
    android-tools              # adb, fastboot
    libmtp                     # Media Transfer Protocol
    jmtpfs                     # Mount MTP devices as FUSE filesystem
    scrcpy                     # Display/control Android devices

    # ─────────────────────────
    # MODERN CLI REPLACEMENTS
    # Note: Shell-specific tools (fzf, bat, zoxide) are in zsh.nix
    # ─────────────────────────
    # Modern Alternatives
    age                        # Modern encryption (GPG alternative)
    direnv                     # Per-directory environment variables
    just                       # Command runner (Makefile alternative)
    # Note: ripgrep, fd in zsh.nix (shell tools)
    sd                         # Intuitive sed alternative
    tokei                      # Code line counter
    hyperfine                  # Command-line benchmarking
    
    # Shell & Script Tools
    shellcheck                 # Shell script analyzer
    shunit2                    # Bash unit testing framework
    jq                         # JSON processor
    bar                        # CLI progress bars
    # ─────────────────────────
    # Archive & Compression
    # ─────────────────────────
    unzip     zip     zlib    gnupg
    # Graphics Libraries (for CLI tools that need them)
    libglvnd                   # GL Vendor-Neutral Dispatch
    libGL                      # GL stub bindings

    # ─────────────────────────
    # NIX-SPECIFIC TOOLS
    # ─────────────────────────
    nix-index                  # Locate Nix packages
    nvd                        # Package version diff tool
    nix-tree                   # Browse Nix store interactively
    nix-info                   # System information for Nix
    nix-prefetch-github       # Prefetch GitHub sources
    nixfmt-tree               # Nix formatter with treefmt
    statix                     # Nix linter
    deadnix                    # Find unused Nix code
    nixos-icons               # NixOS logo icons

    # ─────────────────────────
    # TERMINAL VISUALIZATION & COLORS
    # ─────────────────────────   
    # Color Tools
    colordiff                  # Colored diff
    lscolors                   # Colorize ls output
    lcms                       # Color management engine
    terminal-colors           # Display terminal colors
    colorpanes                 # Terminal pane colors
    sanctity                   # Terminal color combinations
    vivid                      # LS_COLORS generator
    colord-gtk4               # Color manager
    colorized-logs            # Colorize log output
    colorz                     # Color scheme generator
    colorless                 # Colorize output and pipe to less
    chafa                      # Colored ASCII art generator
    notcurses                  # TUI and character graphics
    # Terminal Fun
    terminal-parrot           # Animated party parrot
    # Note: banner, toilet, neofetch in zsh.nix

    # ─────────────────────────
    # ASCII ART & IMAGE TOOLS
    # ─────────────────────────
    asciiquarium-transparent  # ASCII aquarium animation
    ascii-image-converter     # Images to ASCII
    pablodraw                  # ANSI/ASCII editor
    ascii-draw                 # ASCII drawing tool
    uni2ascii                  # UTF-8 to ASCII conversion
    jp2a                       # JPG to ASCII
    artem                      # Images to ASCII art
    gifsicle                   # GIF manipulation
    gif-for-cli               # Render GIFs as ASCII

    # ─────────────────────────
    # MULTIMEDIA & VIDEO TOOLS
    # ─────────────────────────
    asciinema                  # Record terminal sessions
    asciinema-scenario        # Create asciinema from text
    asciinema-agg             # Generate GIFs from asciinema
    agg                        # Rendering engine
    losslesscut-bin           # Lossless video/audio editor

    # ─────────────────────────
    # GRAPHICS & VISUALIZATION
    # ─────────────────────────
    libsixel                   # Console graphics library
    libpng                     # PNG library
    libavif                    # AVIF image library
    webp-pixbuf-loader        # WebP loader
    jpegoptim                  # JPEG optimizer
    jpeginfo                   # JPEG integrity checker
    libva                      # Video Acceleration API
    libva-utils               # VA-API utilities
    mesa-demos                 # OpenGL info (glxinfo)
    glmark2                    # OpenGL benchmarking
    clinfo                     # OpenCL information
    gcolor3                    # GTK color picker
    graphviz                   # Graph visualization
    imagemagick               # Image manipulation
    drawing                    # Basic image editor

    # ─────────────────────────
    # DOCUMENT PROCESSING
    pdfarranger               # Rearrange PDF pages
    pandoc                     # Document format converter
    v4l-utils                  # Video4Linux utilities

    # ─────────────────────────
    # TEXT EDITORS & NOTE-TAKING
    gnome-text-editor         # Simple GNOME text editor
    cherrytree                 # Hierarchical note-taking
    obsidian                   # Networked thought notes
    typora                     # Markdown editor
    # Note: micro is in zsh.nix as a shell tool

    # ─────────────────────────
    # VERSION CONTROL (GIT)
    # All git-related tools consolidated here
    gitFull                    # Full git with all features
    git-doc                    # Git documentation
    gitstats                   # Repository statistics
    gitleaks                   # Scan for secrets
    gitlint                    # Commit message linting
    delta                      # Better git diff with syntax highlighting
    gitnr                      # .gitignore generator
    # ─────────────────────────
    # TEXT PROCESSING
    dasel                      # Query JSON/YAML/TOML/XML/CSV
    fx                         # Terminal JSON viewer
    gron                       # Make JSON greppable
    xcp                        # Extended cp
    # ─────────────────────────
    # DEVELOPMENT & TESTING
    shellspec                  # BDD testing for shell scripts
    hackertyper               # Simulate hacking
    presenterm                 # Terminal presentations
    # ─────────────────────────
    # DESKTOP UTILITIES
    # GNOME Tools
    gnome-online-accounts     # Single sign-on
    # gnome-logs                 # Log viewer
    gnome-keyring             # Keyring/secrets manager
    dconf-editor              # Configuration editor
    gnome-firmware            # Firmware updater
    gnome-disk-utility        # Disk manager
    # Firmware Management
    fwup                       # Firmware update creator
    fwupd                      # Firmware update daemon
    fwupd-efi                  # EFI component for fwupd
    # ─────────────────────────
    # FILE MANAGERS & INTEGRATION
    nemo                      # Cinnamon file manager
    nemo-qml-plugin-dbus      # D-Bus integration
    nemo-emblems              # File emblems
    folder-color-switcher     # Change folder colors
    nemo-fileroller           # Archive integration

    # ─────────────────────────
    # DESKTOP APPLICATIONS
    # Office & Productivity
    libreoffice               # Office suite
    # Media
    lolcat
    pixd # a tool for visualizing binary data
    pix
    # shotwell                   # Photo organizer
    evince                     # Document viewer
    flameshot                  # Screenshot tool
    vlc                        # Media player (from audio.nix functionality)
    
    # Web Browsers
    firefox                    # Web browser
    w3m                        # Terminal browser
    
    # Educational
    tuxpaint                   # Drawing software for children
    gcompris                   # Educational software
    superTuxKart              # Kart racing game

    # ─────────────────────────
    # VIRTUALIZATION
    # ─────────────────────────
    vagrant                    # VM manager
    qemu                       # Emulator/virtualizer
    OVMFFull                  # UEFI firmware for QEMU
    qtemu                      # Qt frontend for QEMU

    # ─────────────────────────
    # THEMING & APPEARANCE
    # ─────────────────────────
    themechanger              # Theme switching utility
    pay-respects              # Command correction (thefuck alternative)
    calligraphy               # ASCII banners from text
    
    # Wallpapers
    adapta-backgrounds        # Wallpaper collection

    # Icons (selected, not comprehensive)
    linearicons-free          # Free linearicons
    icon-library              # Symbolic icons
    pantheon.elementary-iconbrowser  # Icon browser
    kora-icon-theme           # Kora icons
    brose-pine-icon-theme      # Rose Pine icons
    papirus-icon-theme        # Papirus icons
    andromeda-gtk-theme       # Dark theme

    # ─────────────────────────
    # SYSTEM-SPECIFIC UTILITIES
    # ─────────────────────────
    zenity                     # Display dialogs from CLI
    libnotify                  # Desktop notifications
    file-roller               # Archive manager

    # Miscellaneous
    linux-firmware            # Firmware files
    pay-respects              # Command correction utility
     
    #dev
    codex # Lightweight coding agent that runs in your terminal
    #helix # Post-modern modal text editor
    #helix-gpt # Code completion LSP for Helix with support for Copilot + OpenAI
    # ─────────────────────────
    # UNSTABLE CHANNEL PACKAGES
    # Packages from nixos-unstable for newer versions
    # ─────────────────────────
    unstable.yt-dlp           # YouTube downloader
  ];

  # ============================================================================
  # PACKAGE NOTES
  # ============================================================================
  # 
  # REMOVED (moved to zsh.nix):
  # - All zsh-* packages
  # - Shell tools: fzf, bat, zoxide, eza, lsd
  # - CLI tools: ripgrep, fd, ncdu
  # - Prompts: starship, powerlevel10k
  # - Terminal: kitty
  # - Shell utilities: banner, toilet, neofetch, hyfetch, fortune, lolcat, etc.
  #
  # REMOVED (moved to cosmic.nix):
  # - COSMIC desktop components
  #
  # REMOVED (moved to audio.nix):
  # - Audio/JACK/PipeWire packages
  #
  # REMOVED (moved to python.nix):
  # - Python packages and development tools
  #
  # REMOVED (already in other modules or redundant):
  # - Duplicate git tools (consolidated here)
  # - Development language runtimes (go, nodejs, ruby)
  # - Database systems (postgresql, mysql, etc.)
  # - Web development frameworks

    ## tshoot: /run/current-system/sw/share/icons
    

/*----------........ .__  ......... .___  ------- ___
  ____ ___  ___ ____ |  |  __ __  __| _/____   __| _/
_/ __ \\  \/  // ___\|  | |  |  \/ __ |/ __ \ / __ | 
\  ___/ >    <\  \___|  |_|  |  / /_/ \  ___// /_/ | 
 \___  >__/\_ \\___  >____/____/\____ |\___  >____ | 
------\/ ---- \/ ----\/-------------- \/ -- \/ ---\/ 
            .oPYo. 8  .o  .oPYo. .oPYo. 
            8    8 8oP'   8    8 Yb..   
EXCLUDED    8    8 8 `b.  8    8   'Yb. 
PACKAGES    8YooP' 8  `o. `YooP8 `YooP' 
:::.........8 ....:..::......8 :.....::.....:::::::::
 ::.........8 ::::::::::: :ooP'.::::::::::...::::::: */
# Remove unwanted packages that come with desktop environments
## Packages die im Standartd der jeweiligen WM inkludiert sind, abwählen, per:
  environment.cinnamon.excludePackages = [
    pkgs.onboard
    pkgs.cinnamon.mint-x-icons
    pkgs.cinnamon.mint-l-theme
    pkgs.cinnamon.mint-l-icons
    pkgs.cinnamon.xreader
  ];
  environment.xfce.excludePackages = [
    pkgs.xfce.mousepad
    pkgs.xfce.parole
    pkgs.xfce.ristretto
    pkgs.xfce.thunar
  ];
  environment.gnome.excludePackages = [
    pkgs.gnome.gnome-backgrounds
    pkgs.gnome.gnome-characters
    pkgs.gnome.geary
    pkgs.gnome.gnome-music
    pkgs.gnome-photos
    pkgs.gnome.nautilus
    pkgs.gnome.totem
    pkgs.gnome.yelp
    pkgs.gnome.cheese
  ];
# environment.cosmic.excludePackages = with pkgs; --> cosmic.nix
 
}

