 { config, pkgs, lib, ... }:
#let
  # Import the custom package
#  lightdm-settings = import /etc/nixos/custom-pkgs/lightdm-settings.nix { inherit pkgs; };#
#in
{
 environment.systemPackages = with pkgs; [

  # System/Basis-Tools
  dmidecode # Info about your hardware according to SMBIOS/DMI
  efibootmgr # EFI boot manager utility
  v4l-utils # V4L utils and libv4l, provide common image formats regardless of the v4l device
  kbd # Linux keyboard tools and keyboard maps
  libxkbcommon # Library to handle keyboard descriptions
  gettext # Well integrated localization tool
  coreutils # Core utilities expected on every OS
  logrotate # Rotate and compress system logs
  tree # Display directories as trees
  inxi # System information tool
  lshw # Detailed hardware information
  toybox # Minimalist utilities (bblkid, blockdev, etc.)
  # unrar #unfree
  file # Specifies that a series of tests are performed on the file

  # System-Monitore und -Diagnose
  btop # Resource monitor (modern htop alternative)
  htop # Interactive process viewer
  duf # Disk usage/free utility
  baobab # Graphical application to analyse disk usage in any GNOME environment
  ncdu # Disk usage analyzer with an ncurses interface
  bottom # Modern system monitor (alternative to btop/htop)
  vnstat # Console-based network traffic monitor
  libgtop # Library for multicore sys monitor

  # Bootloader und Recovery
  grub2 # Bootloader
  memtest86-efi # Memory testing tool
  os-prober # Detect other OSes for GRUB
  nixos-grub2-theme # NixOS GRUB theme
  # refind # alt boot mgr
  testdisk # Powerful tool for partition recovery and fixing boot problems
  extundelete # Tool for recovering deleted files on ext3/ext4 file systems.
  gparted # Partition editor

  # Backup und Synchronisation
  deja-dup # Simple and secure backup tool with a graphical interface.
  duplicity # Encrypted backup across various protocols with incremental backups.
  warpinator # Share files across the LAN
  dedup # Deduplicating backup program
  timeshift # System restore utility

  # Netzwerk und Konnektivität
  gvfs # Virtual Filesystem support library
  avahi # mDNS/DNS-SD implementation
  blueman # GTK-based Bluetooth Manager
  wirelesstools # ifrename iwconfig iwevent iwgetid iwlist iwpriv iwspy
  hidapi # Library for communicating with USB and Bluetooth HID devices
  curl # Transfer data from or to a server
  wget # Non-interactive network downloader
  openssl # SSL/TLS toolkit
  inetutils # Essential network utilities (ftp, telnet, ifconfig, etc.)
  dog # DNS lookup tool (dig alternative)
  gping # Ping with graph
  trippy # Network diagnostic tool (modern traceroute)
  mtr # Network diagnostic tool combining ping and traceroute
  bandwhich # Network utilization by process
  ntfs3g # FUSE-based NTFS driver with full write support

   # Android-Tools und MTP
  android-tools # Android SDK platform tools (adb, fastboot)
  libmtp # Implementation of Microsoft's Media Transfer Protocol
  jmtpfs # Mounts MTP devices as a fuse filesystem (~/android-mount)
  scrcpy # Display and control Android devices over USB or TCP/IP
  # genymotion # Fast and easy Android emulation

 # Shell und Kommandozeilen-Tools
  age # Modern encryption tool (alternative to GPG)
  direnv # Automatic environment variables per directory
  just # Command runner (Makefile alternative)
  thefuck # Corrects previous console commands
  ripgrep # Fast search tool (grep alternative)
  fd # Find in go (find 2.0)
  procs # Modern ps replacement
  dust # More intuitive du alternative
  sd # Intuitive sed alternative
  tokei # Count code lines and statistics
  hyperfine # Command-line benchmarking tool
  shellcheck # Shell script analysis tool
  shunit2 # xUnit based unit test framework for bash scripts
  jq # Lightweight and flexible command-line JSON processor
  bar # cli progress bar
  unzip # List, test and extract compressed files
  zip # Package and compress files
  zlib # Compression library
  gnupg # GNU Privacy Guard (encryption and signing)
  libglvnd # The GL Vendor-Neutral Dispatch library
  libGL # Stub bindings using libglvnd

  # Nix-Spezifische Tools
  nix-index # Quickly locate nix packages
  nvd # Nix/NixOS package version diff tool
  nix-tree # Interactively browse Nix store paths
  nix-info # System information for Nix
  # nix-diff # Compare Nix derivations
  # nix-output-monitor # Process output of Nix commands
  nix-prefetch-github # Prefetch sources from github
  nixfmt-classic # An opinionated formatter for Nix
  nixfmt-tree # Official Nix formatter zero-setup starter using treefmt
  statix # Lints and suggestions for the nix programming language
  deadnix # Find and remove unused code in .nix source files
  nixos-icons # Icons of the Nix logo, in Freedesktop Icon Directory Layout

  # Terminal- und Shell-Erweiterungen (Zsh/Kitty)
  zsh # Shell
  zsh-autosuggestions # Command line suggestions
  zsh-autocomplete # Autocomplete for Zsh
  zsh-syntax-highlighting # Syntax highlighting
  starship # Minimal, blazing-fast, and infinitely customizable prompt
  zsh-nix-shell # Use Zsh in nix-shell
  navi # Cheat sheet tool
  fzf # Command-line fuzzy finder
  fzf-zsh # Fzf integration for Zsh
  fzf-git-sh # Git utilities powered by fzf
  zsh-forgit # Git utility tool
  kitty # Terminal emulator
  lsd # Modern ls command (ls alternative)
  eza # Improved ls replacement
  bat # Cat clone with wings (syntax highlighting)
  zoxide # Smarter cd command
  broot # Better way to navigate directories
  # tmux # Terminal multiplexer
  # mcfly # An upgraded ctrl-r where history results make sense
  # mcfly-fzf # Integrate Mcfly with fzf

  # Terminal-Visualisierung und -Farben
  colordiff # Colored diff tool
  lscolors # Colorize paths using LS_COLORS
  lcms # Color management engine
  terminal-colors # Display terminal colors
  colorpanes # Terminal pane colors
  sanctity # Terminal color combinations
  vivid # LS_COLORS generator
  colord-gtk4 # Color Manager
  colorized-logs # Tools for logs with ANSI color
  colorz # Color scheme generator ($ colorz image -n 12)
  colorless # Colorise cmd output and pipe it to less
  # dumm: colorstorm # cmd line tool to generate color themes for editors/terminals
  # rich-cli # toolbox for fancy output in the terminal
  chafa # Tool for generating colored ASCII art
  notcurses # C compile, TUIs and character graphics

  # Terminal-Spaß und MOTD
  fancy-motd # Colorful MOTD written in bash
  rust-motd # Useful MOTD generation with zero runtime dependencies
  terminal-parrot # Shows colorful, animated party parrot in your terminial
  banner # Text banner tool
  toilet # Text banner tool (alternative to banner)
  tealdeer # Simplified man pages
  neo-cowsay # ASCII art tool
  xcowsay # Customize cowsay with images
  fortune # Display random quotes
  lolcat # Colorize output
  blahaj # Fun terminal tool
  dotacat # Like lolcat, but fast
  theme-sh # Theme management
  neofetch # System information display
  hyfetch # Fork of neofetch
 # ASCII/Bild-Tools
  asciiquarium-transparent # Aquarium/sea animation in ASCII art
  ascii-image-converter # Convert images into ASCII art on the console
  pablodraw # Ansi/Ascii text and RIPscrip vector editor/viewer
  ascii-draw # Drawing tool
  uni2ascii # UTF-8 to ASCII conversion
  jp2a # Utility that converts JPG images to ASCII
  artem # Small CLI program to convert images to ASCII art
  gifsicle # CLI tool for GIF images
  gif-for-cli # Render gifs as ASCII art in your cli

 # Multimedia und Video-Tools
  asciinema # Record terminal sessions
  asciinema-scenario # Create asciinema videos from a text file
  asciinema-agg # Generate animated GIF files from asciicast v2 files
  agg # High quality rendering engine for C++
  obs-studio # Free and open source software for video recording and live streaming
  losslesscut-bin # Lossless video/audio editor
  mp3splt # Utility to split mp3, ogg vorbis and FLAC files without decoding
  spotdl # Downl---oad your Spotify playlists and songs

  # Grafik und Visualisierung
  libsixel # Console graphics library
  libpng # PNG library
  libavif # AVIF image library
  webp-pixbuf-loader # WebP image loader
  jpegoptim # JPEG optimizer
  jpeginfo # JPEG integrity checker
  libva # Video Acceleration API
  libva-utils # VA-API utilities
  glxinfo # OpenGL information
  glmark2 # OpenGL benchmarking
  clinfo # OpenCL information
  gcolor3 # Color chooser written in GTK3
  graphviz # Graph visualization tools
  imagemagick # Image manipulation tool
  drawing # Basic image editor

  # Dokumenten- und Text-Verarbeitung
  pdfarranger # Rearrange pages in PDF files
  pandoc # Convert markup formats (Markdown, HTML, LaTeX, etc.)
  wmctrl # CLI tool to interact with EWMH/NetWM compatible X Window Managers
  # jupyter # Webbasierte interaktive Entwicklungsumgebung (z.B. für Python)

  # Text-Editoren und Notizen
  # IDEs
  # emacs # Powerful text editor
  sublime # Text editor for code, markup, and prose
  gnome-text-editor # Simple text editor for GNOME
  cherrytree # Hierarchical note-taking application
  obsidian # Note-taking app for networked thoughts
  typora # Markdown editor
  micro # Terminal-based text editor
  # vscode-with-extensions # Open source source code editor developed by Microsoft

 # Programmier- und Entwicklungstools
  # Python Development # (siehe python.nix)
  # Version Control
  gitFull # Distributed version control system
  gitnr # Create `.gitignore` files using templates
  git-doc # Git documentation
  gitstats # Generate statistics from Git repositories
  gitleaks # Scan git repos for secrets
  gitlint # Linting for git commit messages
  delta # Better git diff viewer with syntax highlighting
  # git-hub # Interface to GitHub from the command line
  # github-desktop # GUI for managing Git and GitHub
  # gitlab # GitLab Community Edition
  go # Go Programming language
  nodejs # JavaScript runtime
  nodePackages.npm # Node.js package manager
  # yarn # Alternative package manager for Node.js
  # deno # Secure runtime for JavaScript and TypeScript
  sass # CSS preprocessor
  # postcss # Tool for transforming CSS with JavaScript
  ruby # Object-oriented language
  vagrant # Virtual machine manager
  qemu # Emulator and virtualizer
  OVMFFull # Sample UEFI firmware for QEMU and KVM
  qtemu # Qt-based front-end for QEMU emulator

  # Text Processing Utilities (alternatives/ergänzungen)
  choose # Human-friendly alternative to cut/awk
  dasel # Query and modify JSON, YAML, TOML, XML, CSV
  fx # Terminal JSON viewer (JSON processor)
  gron # Make JSON greppable
  xcp # cp 2.0

  # Testing und Utility-Tools
  shellspec # BDD unit testing framework
  hackertyper # Simulate hacking
  presenterm # Terminal-based presentation creator
  # BROKEN: pingu # Ping command implementation in Go but with colorful output and pingu ascii art

  # GNOME/Desktop Utilities
  gnome-online-accounts # Single sign-on framework for GNOME
  gnome-logs # Logs viewer
  gnome-keyring # Component to store secrets, passwords, keys, certificates
  dconf-editor # Configuration editor
  gnome-firmware # Firmware updater
  gnome-disk-utility # Disk utility
  fwup # Configurable embedded Linux firmware update creator
  fwupd # Firmware update daemon
  fwupd-efi # EFI component for fwupd
  # ausweisapp # Official authentication app for German ID card and residence permit

  # Cinnamon Utilities
  nemo # File manager
  nemo-qml-plugin-dbus # D-Bus integration for Nemo
  nemo-emblems # Emblems for Nemo
  folder-color-switcher # Folder color switcher
  nemo-fileroller # File roller integration
  nemo-python # Python extensions for Nemo

  # X11 Utilities
  xorg.xwininfo # Display information about a window
  xorg.libXrandr # X Resize and Rotate Extension library
  xorg.xhost # Access control for the X server
  xclip # X11 clipboard manipulation
  emacsPackages.pbcopy # Clipboard integration for Emacs

   # Multimedia/Desktop-Anwendungen
  libreoffice # Office suite
  shotwell # Photo organizer
  evince # Document viewer
  flameshot # Powerful yet simple to use screenshot software
  # UNFREE vivaldi # customizable and feature-rich web browser
  firefox # Web browser
  w3m # Terminal web browser
  tuxpaint # Open Source Drawing Software for Children
  gcompris # Educational software suite for Children
  superTuxKart # Tux Kart (Kart racing game)
  # steam # Game platform

   # Theming und Icons
  lightdm-slick-greeter # Slick-looking LightDM greeter
  whitesur-gtk-theme # MacOS Big Sur theme for GNOME
  numix-cursor-theme # Cursor theme
  # pop-gtk-theme # Pop!_OS GTK theme
  theme-vertex # Theme for GTK 3, GTK 2, Gnome-Shell, and Cinnamon
  pantheon.elementary-wallpapers # Collection of wallpapers for elementary
  adapta-backgrounds # Wallpaper collection for adapta-project
  deepin.deepin-wallpapers # Wallpapers provides wallpapers of dde
  faba-mono-icons # Mono icons
  # flat-remix-icon-theme # Flat remix icon theme
  # eww #ElKowars wacky widgets
  linearicons-free # linearicons.com/free
  icon-library # Symbolic icons for your apps
  pantheon.elementary-iconbrowser # Browse and find system icons
  xfce.xfce4-icon-theme # Icons for Xfce
  material-design-icons # 7000+ Material Design Icons from the Community
  material-black-colors # Material Black Colors icons
  sweet-folders # Folders icons for Sweet GTK theme
  candy-icons # Icon theme colored with sweet gradients
  arc-icon-theme # Arc icon theme
  whitesur-icon-theme # MacOS Big Sur icons
  vimix-icon-theme # Vimix icon theme
  kanagawa-icon-theme # Kanagawa icon theme
  tela-icon-theme # Tela icon theme
  nordzy-icon-theme # Nordzy icon theme
  kora-icon-theme # Kora icon theme
  qogir-icon-theme # Qogir icon theme
  rose-pine-icon-theme # Rose Pine icon theme
  papirus-icon-theme # Papirus icon theme
  andromeda-gtk-theme # Elegant dark theme for gnome, mate, budgie, cinnamon, xfce

  # Aus unstable Channel
  # unstable.hugo # Static site generator
  unstable.yt-dlp # Downloader for YouTube and other sites
 # Fonts and Typography  > fonts.nix
];




/* 
######### Packages die im Standartd der jeweiligen WM inkludiert sind, abwählen, per:
 environment.packageOverrides = pkgs: {
	removePackages = pkgs.lib.removeDerivations [ 
		pkgs.onboard 
 		pkgs.cinnamon.mint-x-icons pkgs.cinnamon.mint-l-theme pkgs.cinnamon.mint-l-icons
	   	pkgs.cinnamon.xreader
 			];
		}; 
environment.xfce.excludePackages = [	            pkgs.xfce.mousepad 	 pkgs.xfce.parole
	            pkgs.xfce.ristretto	 pkgs.xfce.thunar ]; 
environment.gnome.excludePackages = [
	   		pkgs.gnome.gnome-backgrounds pkgs.gnome.gnome-characters
	   		pkgs.gnome.geary  pkgs.gnome.gnome-music
	   		pkgs.gnome-photos pkgs.gnome.nautilus
	   		pkgs.gnome.totem  pkgs.gnome.yelp
	   		pkgs.gnome.cheese     	 ];
	   		*/
}



