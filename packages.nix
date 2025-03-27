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
 	

######################################################

  losslesscut-bin # Lossless video/audio editor
vivaldi
gnome-online-accounts # Single sign-on framework for GNOME
gvfs # Virtual Filesystem support library
theme-vertex # theme for GTK 3, GTK 2, Gnome-Shell, and Cinnamon

andromeda-gtk-theme # elegant dark theme for gnome, mate, budgie, cinnamon, xfce
tor
dwarf-fortress-packages.themes.autoreiv # theme to use for the lightdm-slick-greeter
avahi # mDNS/DNS-SD implementation
warpinator # share files across the LAN

pydf
 affine
copyq

#python3.12-markdown2
#python3.12-pip
sublime4

texliveTeTeX # TeX Live environment
dedup # data deduplication program
 

#   lightdm-settings
hidapi # Library for communicating with USB and Bluetooth HID devices
tecla # keyboard layout viewer.
   libxkbcommon # library to handle keyboard descriptions
   nixos-icons # icons of the Nix logo, in Freedesktop Icon Directory Layout
#   rich-cli # toolbox for fancy output in the terminal
     vivid
  #   steam
  xorg.libXrandr
  libglvnd #The GL Vendor-Neutral Dispatch library
libGL #Stub bindings using libglvnd
tuxpaint # open Source Drawing Software for Children
gcompris # educational software suite  for Children
superTuxKart # Tux Kart
  fancy-motd 	# colorful MOTD written in bash. Server status at a glance
  rust-motd 	# useful   MOTD generation with zero runtime dependencies
	grub2 # Bootloader
	memtest86-efi # Memory testing tool
	os-prober # Detect other OSes for GRUB
	nixos-grub2-theme

 	flameshot # Powerful yet simple to use screenshot software


	ruby # object-oriented language 
	shunit2 # xUnit based unit test framework for bash scripts
	# genymotion # Fast and easy Android emulation
	# refind
  	pantheon.elementary-wallpapers # collection of wallpapers for elementary
 	adapta-backgrounds # wallpaper collection for adapta-project
 	deepin.deepin-wallpapers # wallpapers provides wallpapers of dde
	lightdm-slick-greeter # slick-looking LightDM greeter
	# eww #ElKowars wacky widgets
	fwup fwupd fwupd-efi #    Configurable embedded Linux firmware update creator and runner
	jp2a   #jpt 2 ascii
	# faba-icon-theme #  modern icon theme with Tango influences
	faba-mono-icons
       # flat-remix-icon-theme # Flat remix is a pretty simple icon theme inspired on material design
        blueman # GTK-based Bluetooth Manager
        wirelesstools # ifrename iwconfig iwevent iwgetid iwlist iwpriv iwspy
	meld	# visual diff and merge tool
# __________________________________________
	xcp	# cp 2.0
	jp2a # small utility that converts JPG images to ASCII
	colorized-logs # Tools for logs with ANSI color
	colorz # color scheme generator. $ colorz image -n 12
	colorless # colorise cmd output and pipe it to less $ eval "$(colorless -as)"
# dumm:	colorstorm # cmd line tool to generate color themes for editors (Vim, VSCode, Sublime, Atom) and terminal emulators (iTerm2, Hyper).
	colord-gtk4 # Color Manager
	gcolor3 #color picker
	fd # find in go = find 2.0
	ntfs3g # FUSE-based NTFS driver with full write support
	curl wget openssl inetutils
	gnupg
	unzip zip zlib
	# unrar #unfree
	file # specifies that a series of tests are performed on the file
	fff # file mgr
#___________________________________________________________
# Backup and Recovery
	  dedup # Deduplicating backup program
	  timeshift # System restore utility
	  gparted # Partition editor
# Terminal and Shell Utilities
	  kitty # Terminal emulator
	  lsd # Modern ls command
	  eza # Improved ls replacement
	  colordiff # Colored diff tool
	  lscolors # Colorize paths using LS_COLORS
	  lcms # Color management engine
	  terminal-colors # Display terminal colors
	  colorpanes # Terminal pane colors
	  sanctity # Terminal color combinations
	  notcurses # c compile , TUIs and character graphics
	  terminal-parrot # Shows colorful, animated party parrot in your terminial
	  bat-extras.batman # scripts: batgrep, batman, batpipe (less), batwatch, batdiff, prettybat 
# Miscellaneous
	  thefuck # Corrects previous console commands
	  ripgrep # Fast search tool
	  banner # Text banner tool
	  toilet # Text banner tool
	  tealdeer # Simplified man pages
	  neo-cowsay # ASCII art tool
	  xcowsay # Customize cowsay with images
	 zsh-completions # Additional completions
	  fortune # Display random quotes
	  clolcat # Colorize output
	  blahaj # Fun terminal tool
# SHELL
	 zsh # Shell
	 zsh-autosuggestions # Command line suggestions
	 zsh-autocomplete # Autocomplete for Zsh
	 zsh-syntax-highlighting # Syntax highlighting
	 zsh-completions # Additional completions
#	 zsh-powerlevel9k # Zsh theme
#	 zsh-powerlevel10k # Enhanced Zsh theme
         starship #minimal, blazing-fast, and infinitely customizable prompt
	 zsh-nix-shell # Use Zsh in nix-shell
	 nix-zsh-completions # Nix completions for Zsh
         navi cheat
	 fzf # Command-line fuzzy finder
	 fzf-zsh # Fzf integration for Zsh
	 fzf-git-sh # Git utilities powered by fzf
	 ################### 
	  mcfly # An upgraded ctrl-r where history results make sense
	  mcfly-fzf # Integrate Mcfly with fzf to combine a solid command history database with a widely-loved fuzzy search UI
	  bat
	  zoxide
	   zsh-forgit # Git utility tool
	  # tmux # Terminal multiplexer
	  coreutils # Core utilities expected on every OS
	  logrotate # Rotate and compress system logs
	  tree # Display directories as trees
   	  inxi # System information tool
	  lshw # Detailed hardware information
	  nix-index # Quickly locate nix packages
#	  nix-tree # Interactively browse Nix store paths
	  nix-info # System information for Nix
#	  nix-diff # Compare Nix derivations
#	  nix-output-monitor # Process output of Nix commands
nix-prefetch-github #Prefetch sources from github seppeljordan/nix-prefetch-github
	  btop # Resource monitor
	  duf # Disk usage/free utility
	   htop # Interactive process viewer
	  toybox # ascii bblkid blockdev bunzip2 ... uvm
	  jq # lightweight and flexible command-line JSON processo
	  neofetch hyfetch
  dotacat # Like lolcat, but fast
	  graphviz #graph visualization tools
	 theme-sh
	 pingu # Ping command implementation in Go but with colorful output and pingu ascii art
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
# ASCII
	asciiquarium-transparent #  Aquarium/sea animation in ASCII art 
	ascii-image-converter # Convert images into ASCII art on the console
	pablodraw # Ansi/Ascii text and RIPscrip vector editor/viewer
 	asciinema # Record terminal sessions
 	ascii-draw #
 	uni2ascii # UTF-8 to ASCII conversion
 	artem # Small CLI program to convert images to ASCII art
 	gifsicle
 	gif-for-cli # Render gifs as ASCII art in your cli
	python312Packages.ascii-magic # Converts pictures into # ASCII art
	python312Packages.art # ASCII art library for Python

#### Python Development
	  jetbrains.pycharm-community-bin # py IDE. Syntax-Hervorhebng, Debugging-Tools, Refactoring-Unterstützung und Integration mit Versionskontrollsystemen.
	  python312Packages.pip #PyPA recommended tool for installing Python packages
	  python312Packages.feedparser # Universal feed parser
	  python312Packages.keyrings-alt # Alternate keyring implementations
	  python312Full # Python 3.12 interpreter
	  python312Packages.pip # PyPA recommended tool for installing Python packages
	  python312Packages.pygments # Syntax highlighting library
	  python312Packages.speechrecognition # Speech recognition module for Python, supporting several engines and APIs, online and offline        
	  python312Packages.pydub # Manipulate audio with a simple and easy high level interface
	  python312Packages.markdown2 # Fast and complete Python implementation of Markdown
	  
	 # jupyter # webbasierte interaktive Entwicklungsumgebung. Sie eignet sich hervorragend für explorative Datenanalyse und prototypisches Coden, was für die Entwicklung von Phytom-Anwendungen
	 # Version Control
#	  git-hub # Interface to GitHub from the command line 
#        github-desktop # GUI for managing Git and GitHub. 
 gitFull # Distributed version control system	  
 gitnr # Create `.gitignore` files using templates
	#  gitlab # GitLab Community Edition 	 	 
	git-doc # Git documentation 	  
	gitstats # Generate statistics from Git repositories  g
	gitleaks # Scan git repos for secrets	 
	gitlint # Linting for git commit messages
 # GNOME Utilities
	  gnome-logs # Logs viewer
	  dconf-editor # Configuration editor
	  gnome-firmware # Firmware updater
	  gnome-disk-utility # Disk utility
	  gnome-text-editor # Simple text editor
# Theming and Appearance
	  whitesur-gtk-theme # MacOS Big Sur theme for GNOME
	  numix-cursor-theme # Cursor theme
	  pop-icon-theme # Pop!_OS icon theme
	 #  pop-gtk-theme # Pop!_OS GTK theme
	  theme-sh # Script to set terminal theme
# Multimedia, ohne audio
	imagemagick # Image manipulation tool
	  shotwell # Photo organizer
	  evince # Document viewer
	  drawing # Basic image editor
	  pandoc # Convert markup formats

	wget
    	libreoffice
   	pdfarranger
    	ghostscript
    	gimp-with-plugins
    	inkscape-with-extensions

	  # Clipboard and Text Utilities
	  xclip # X11 clipboard manipulation
	  emacsPackages.pbcopy # Clipboard integration for Emacs

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
vscode-with-extensions # Open source source code editor developed by Microsoft for Windows, Linux and macOS 
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
 # Fonts and Typography
	  nerdfonts # Patched fonts for developers
	  meslo-lgs-nf # Meslo Nerd Font for Powerlevel10k
	#  lalezar-fonts # Decorative Arabic/Persian font
	  tt2020 # open source, hyperrealistic typewriter font
];

fonts.enableDefaultPackages = false;  # Deaktiviert die Standard-Schriftarten
# ~/.local/share/font + fc-cache für costume fonts
fonts.packages = with pkgs; [ 
	meslo-lgs-nf 
	tt2020 
	#nerd-fonts.hack
	#nerd-fonts.3270
	#nerd-fonts.agave
	#nerd-fonts.lekton
        #nerd-fonts.monofur
        #nerd-fonts.proggyclean
        ];
}
/* ALT: 	(nerdfonts.override { fonts =		[  "Hack" "3270" "Agave"  # "EnvyCodeR" "Mononoki" "ProFont" "Lekton" "Monofur" "ProggyClean" ]; # "FiraCode" 	"DroidSansMono"  } ) ]; */ 

#  fonts = {
#  fontconfig.enable
#    fontconfig.defaultFonts.sansSerif = [ "Exo 2" "Symbols Nerd Font" ];
#    fontconfig.defaultFonts.serif = [ "Tinos" "Symbols Nerd Font" ];
#   fontconfig.defaultFonts.monospace = [ "Cascadia Code PL" "Symbols Nerd Font" ];
#    fontconfig.defaultFonts.emoji = [ "JoyPixels" ];
#  };

/* environment.xfce.excludePackages = [	            pkgs.xfce.mousepad 	 pkgs.xfce.parole
	            pkgs.xfce.ristretto	 pkgs.xfce.thunar ]; 
environment.gnome.excludePackages = [
	   		pkgs.gnome.gnome-backgrounds pkgs.gnome.gnome-characters
	   		pkgs.gnome.geary  pkgs.gnome.gnome-music
	   		pkgs.gnome-photos pkgs.gnome.nautilus
	   		pkgs.gnome.totem  pkgs.gnome.yelp
	   		pkgs.gnome.cheese     	 ];
	   		
# environment.packageOverrides = pkgs: { # environment.cinnamon.Packages gibts nicht
  #		removePackages = pkgs.lib.removeDerivations [ 
  #			pkgs.onboard 
 # 			pkgs.cinnamon.mint-x-icons
#	   		pkgs.cinnamon.mint-l-theme pkgs.cinnamon.mint-l-icons
#	   		pkgs.cinnamon.xreader
 # 			];
#		}; 
}
*/


