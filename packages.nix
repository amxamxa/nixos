 { config, pkgs, lib, ... }:
#let
  # Import the custom package
#  lightdm-settings = import /etc/nixos/custom-pkgs/lightdm-settings.nix { inherit pkgs; };#
#in
{
environment.systemPackages = with pkgs; [

# aus unstable Channel:
 	unstable.hugo
 	unstable.yt-dlp
#+############################ 	
 	
 	
 	linearicons-free # linearicons.com/free	
 	icon-library # Symbolic icons for your apps
 	pantheon.elementary-icon-theme  # Named, vector icons for elementary OS
 	pantheon.elementary-iconbrowser # Browse and find system icons
 	xfce.xfce4-icon-theme # Icons for Xfce
 	material-design-icons # 7000+ Material Design Icons from the Community
 	material-black-colors # Material Black Colors icons
 	sweet-folders # Folders icons for Sweet GTK theme
 	candy-icons # Icon theme colored with sweet gradients
 	
#### Python Development
# siehe python.nix
fontpreview
efibootmgr
### Video prod
  asciinema # Record terminal sessions
  asciinema-scenario # Create asciinema videos from a text file
  asciinema-scenario #  Create asciinema videos from a text file
  asciinema-agg # Command-line tool for generating animated GIF files from asciicast v2 files produced by asciinema terminal recorder
  agg # : High quality rendering engine for C++
  obs-studio # : Free and open source software for video recording and live streaming  
    gettext # Well integrated
######################################################
agg #  High quality rendering engine for C++
android-tools #  Android SDK platform tools
    libmtp #    Implementation of Microsoft's Media Transfer Protocol
jmtpfs # Erstellt ein mountbares Laufwerk (~/android-mount)

baobab #  Graphical application to analyse disk usage in any GNOME environment

ncdu #  Disk usage analyzer with an ncurses interface
    v4l-utils # V4L utils and libv4l, provide common image formats regardless of the v4l device
pdfarranger
wmctrl # CLI tool to interact with EWMH/NetWM compatible X Window Managers
# ausweisapp # Official authentication app for German ID card and residence permit

# Infinite-world block sandbox game
minetestserver
minetest-mapserver
minetest
minetestclient

libreoffice  

android-tools # Android SDK platform tools

baobab # Graphical application to analyse disk usage in any GNOME environment
mp3splt # Utility to split mp3, ogg vorbis and FLAC files without decoding
gvfs # Virtual Filesystem support library
avahi # mDNS/DNS-SD implementation
dmidecode # Tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard
scrcpy # Display and control Android devices over USB or TCP/IP
shellcheck # Shell script analysis tool

chafa # tool for generating colored ASCII art 
     deja-dup # Simple and secure backup tool with a graphical interface.
     duplicity # Encrypted backup across various protocols with incremental backups.
     extundelete # Tool for recovering deleted files on ext3/ext4 file systems.
     marker # tool for highlighting text in terminal output.
     presenterm # terminal-based presentation creator.
     testdisk # Powerful tool for partition recovery and fixing boot problems.
# UNFREE     vivaldi # customizable and feature-rich web browser.
     vnstat # console-based network traffic monitor.
     whisper # speech-to-text system (utilizes OpenAI's Whisper model).
     
gnome-online-accounts # Single sign-on framework for GNOME

# Theming and Appearance
	lightdm-slick-greeter # slick-looking LightDM greeter
	  whitesur-gtk-theme # MacOS Big Sur theme for GNOME
	  numix-cursor-theme # Cursor theme
	  pop-icon-theme # Pop!_OS icon theme
	 #  pop-gtk-theme # Pop!_OS GTK theme
	 theme-vertex # theme for GTK 3, GTK 2, Gnome-Shell, and Cinnamon
	 andromeda-gtk-theme # elegant dark theme for gnome, mate, budgie, cinnamon, xfce
pantheon.elementary-wallpapers # collection of wallpapers for elementary
 	adapta-backgrounds # wallpaper collection for adapta-project
 	deepin.deepin-wallpapers # wallpapers provides wallpapers of dde
	
warpinator # share files across the LAN

losslesscut-bin # Lossless video/audio editor
hidapi # Library for communicating with USB and Bluetooth HID devices
   libxkbcommon # library to handle keyboard descriptions
   nixos-icons # icons of the Nix logo, in Freedesktop Icon Directory Layout
#   rich-cli # toolbox for fancy output in the terminal
     vivid
  #   steam
xorg.xwininfo 
  xorg.libXrandr
  xorg.xhost # fuer docker
  libglvnd #The GL Vendor-Neutral Dispatch library
libGL # Stub bindings using libglvnd
tuxpaint # open Source Drawing Software for Children
gcompris # educational software suite  for Children
superTuxKart # Tux Kart
  fancy-motd 	# colorful MOTD written in bash. Server status at a glance
  rust-motd 	# useful   MOTD generation with zero runtime dependencies
	grub2 # Bootloader
	memtest86-efi # Memory testing tool
	os-prober # Detect other OSes for GRUB
	nixos-grub2-theme
	# refind # alt boot mgr
# nix-stuff ---------------------	
	nix-index # Quickly locate nix packages
	nvd #Nix/NixOS package version diff tool
	nix-tree # Interactively browse Nix store paths
	nix-info # System information for Nix
#	nix-diff # Compare Nix derivations
#	nix-output-monitor # Process output of Nix commands
	nix-prefetch-github #Prefetch sources from github seppeljordan/nix-prefetch-github
# ------------------------------------------------------	
	# faba-icon-theme #  modern icon theme with Tango influences
	faba-mono-icons
       # flat-remix-icon-theme # Flat remix is a pretty simple icon theme inspired on material design
        blueman # GTK-based Bluetooth Manager
        wirelesstools # ifrename iwconfig iwevent iwgetid iwlist iwpriv iwspy
	meld	# visual diff and merge tool
# __________________________________________
	# genymotion # Fast and easy Android emulation

	# eww #ElKowars wacky widgets
	fwup fwupd fwupd-efi #    Configurable embedded Linux firmware update creator and runner
# Backup and Recovery
	  dedup # Deduplicating backup program
	  timeshift # System restore utility
	  gparted # Partition editor

	#BROKEN: pingu # Ping command implementation in Go but with colorful output and pingu ascii art
# IDEs
	 # emacs # Powerful text editor
	   sublime 	# Text editor for code, markup, and prose
   # txt editors
	  gnome-text-editor # Simple text editor for GNOME
	  cherrytree 	# Hierarchical note-taking application
	  obsidian 	# Note-taking app for networked thoughts
	  typora 	# Markdown editor
	  micro 	# Terminal-based text editor
	  marker 	# Markdown editor

 # GNOME Utilities
	  gnome-logs # Logs viewer
	  gnome-keyring  # set of components in GNOME that store secrets, passwords, keys, certificates and make them available 
	  dconf-editor # Configuration editor
	  gnome-firmware # Firmware updater
	  gnome-disk-utility # Disk utility
	  gnome-text-editor # Simple text editor
# Multimedia, ohne audioxwininfo
	imagemagick # Image manipulation tool
	  shotwell # Photo organizer
	  evince # Document viewer
	  drawing # Basic image editor
	  pandoc # Convert markup formats

	  # Clipboard and Text Utilities
	  xclip # X11 clipboard manipulation
	  emacsPackages.pbcopy # Clipboard integration for Emacs
	flameshot # Powerful yet simple to use screenshot software
	ruby # object-oriented language 
	ntfs3g # FUSE-based NTFS driver with full write support
 # Web Browsers
	  firefox # Web browser
	  w3m # Terminal web browser
# Graphics and Visualization
	  libsixel # Console graphics library
	  libpng # PNG library
	  libavif # AVIF image library
	  jpegoptim # JPEG optimizer
	  jpeginfo # JPEG integrity checker
	  webp-pixbuf-loader # WebP image loader
	  libavif # C implementation of the AV1 Image File Format
	  libva # Video Acceleration API
	  libva-utils # VA-API utilities
	  glxinfo # OpenGL information
	  glmark2 # OpenGL benchmarking
	  clinfo # OpenCL information
	#  mangohud # OpenGL overlay for monitoring
	  gcolor3 # color chooser written in GTK3
	  libgtop # library for multicore sys monitor 

  # Cinnamon Utilities
	  nemo # File manager
	  nemo-qml-plugin-dbus # D-Bus integration for Nemo
	  nemo-emblems # Emblems for Nemo
	  folder-color-switcher # Folder color switcher
	  nemo-fileroller # File roller integration
	  nemo-python # Python extensions for Nemo
  # Testing and Development
	  shellspec # BDD unit testing framework
	  hackertyper # Simulate hacking

	  vagrant # Virtual machine manager
	qemu
OVMFFull # Sample UEFI firmware for QEMU and KVM
qtemu # Qt-based front-end for QEMU emulator
# vscode-with-extensions # Open source source code editor developed by Microsoft for Windows, Linux and macOS 
# Web Development
        go # G o Programming language
	nodejs # JavaScript runtime
	nodePackages.npm # Node.js package manager
	#  yarn # Alternative package manager for Node.js
	#  deno # Secure runtime for JavaScript and TypeScript
	#  react # JavaScript library for building user interfaces
	#  vue-cli # Command-line interface for Vue.js
	#  angular-cli # Command-line interface for Angular
	 sass # CSS preprocessor
	# postcss # Tool for transforming CSS with JavaScript
# Databases
	#  postgresql # Relational database system
	#  mysql # Relational database system
	#  sqlite # Lightweight database
	#  redis # In-memory data structure store
	#  mongodb # NoSQL database
 
 # Fonts and Typography ---> fonts.nix

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



