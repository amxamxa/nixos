{ config, pkgs, ... }:
			
{

  
environment.systemPackages = with pkgs; [

	###		EFI boot tools
	grub2
	memtest86-efi
	#refind
	os-prober
	## 		Gnome
	gnome.gnome-logs 	gnome.dconf-editor	gnome-firmware
  	gnome.gnome-disk-utility 	gnome-text-editor	 gnome.gnome-logs
	bat
	colord-gtk4 

	#xclip #access the X clipboard from a console application
	#xsel #getting and setting the contents of the X selection
	pciutils # inspecting and manipulating configuration of PCI devices: lspci setpci
	coreutils # the core utilities which are expected to exist on every OS
	lshw #Provide detailed information on the hardware configuration of the machine
   	usbutils # tools for working with USB device
	lm_sensors # tools for reading hardware sensors, fans
   	logrotate # rotates and compresses system logs
   	btop 	tree 	inxi
   	    	### 		xfce tools
   	xfce.xfce4-panel   xfce.xfce4-session # panel u session manager for Xfce   "Iosevka"
    xfce.xfce4-notifyd xfce.xfce4-settings    	xfce.xfwm4 		xfce.exo # Application library for Xfce
     	xfce.xfce4-taskmanager		xfce.libxfce4ui #      Widgets library for Xfce
#   	xfce.xfce4-cpugraph-plugin 		xfce.xfce4-fsguard-plugin # monitors the free space on your filesystems
   	xfce.xfce4-clipman-plugin	#	xfce.xfce4-genmon-plugin # display various types of information, such as system stats, weathe
   	xfce.xfce4-notes-plugin 	#	xfce.xfce4-netload-plugin #    xfce.xfce4-xkb-plugin # bildschirmschoner
   
 	#parcellite #GTK clipboard manager
 	xfce.xfce4-systemload-plugin   xfce.xfce4-whiskermenu-plugin 

	#dynamic-wallpaper #https://github.com/dusansimic/dynamic-wallpaper

	#########################################################

	papirus-icon-theme
	whitesur-gtk-theme #MacOS Big Sur like theme for Gnome desktops
	numix-icon-theme-circle
	numix-cursor-theme
	sierra-gtk-theme
	pop-icon-theme
	mojave-gtk-theme # Mac OSX Mojave like theme for GTK based desktop environments
	pop-gtk-theme
	##		GUI internet tools
x
	##		GUI Zubehör
gnome-text-editor
#	cinnamon.nemo-with-extensions

	cinnamon.nemo
	nemo-qml-plugin-dbus
	cinnamon.nemo-emblems
	cinnamon.folder-color-switcher
	cinnamon.nemo-fileroller
	cinnamon.nemo-python


	### 		GUI system
	# timeshift
	gparted

	##		GUI knowledge base		

	cherrytree
	#### Obsidian
	obsidian
#	pandoc # Conversion html- markup formats

#	glxinfo
	xorg.xrandr
	arandr
	###

	#------------------------------------
	### 		CLI tools
	### 	---------------------------
	zsh
	#zsh-history
	# zsh-edit #powerful extensions to the Zsh command line editor
	zsh-autosuggestions
	zsh-autocomplete
	zsh-syntax-highlighting
	zsh-completions
	#zsh-you-should-use #plugin that reminds you to use existing aliases for commands 
	#zsh-command-time #utput time: xx after long commands
	zsh-fzf-tab
	#zsh-autoenv #Automatically sources whitelisted .autoenv.zsh files
	#zsh-clipboard #Ohmyzsh plugin that integrates kill-ring with system clipboard
	zsh-nix-shell #to use zsh in nix-shell shell
	nix-zsh-completions
	zoxide
	#zsh-git-prompt
	#oh-my-zsh
	thefuck
   	ripgrep # grep 2.0
   	banner toilet tealdeer fd # user-friendly find
   	tree	neofetch 	hyfetch
   	#perl 
   	micro ccze	fzf	 # nix-store -q --outputs $(which fzf) #--references # --requisites
   	#fzf-zsh 	 	#fzf-obc
   	w3m # terminal-browser  ccze # Fast, modular log colorizer
   	neo-cowsay xcowsay fortune clolcat blahaj
   	duf ## color mounts Disk Usage/Free Utility
   	btop inxi lsd eza #	exa #'exa' has been removed because it is unmaintained
   		#python311Packages.pip
    theme-sh #script which lets you set your $terminal theme
    colordiff
    lscolors #  tool to colorize paths using LS_COLORS
    lcms # $ LCMS # color management engine
    terminal-colors # Script displaying terminal colors in various formats
    colorpanes	# Panes in the 8 bright terminal colors with shadows
    sanctity # 16 terminal colors in all combinations
    notcurses  # Blingful TUIs and character graphics
    #colorz 		# color scheme generator
    gcolor3 		# color chooser written in GTK3	
    graphviz 	# graph visualization tools
    inotify-tools #  C library and a set of command-line programs for Linux providing a simple interface to inotify
    libgtkflow3 # Flow graph widget for GTK 3
	fzf
	fzf-zsh
	fzf-git-sh
	zsh-forgit # utility tool powered by fzf for using git interactively
#	 flatpak     xdg-desktop-portal     xdg-desktop-portal-gtk xdg-desktop-portal-xapp
firefox	vlc 
  # 	libreoffice
  # 	pdfarranger
 texliveSmall # LaTex
    	#	wpsoffice		#doof:  office editor
   	typora 			# markdown editor
   	cherrytree 		# db note taking application
    obsidian 		pandoc # convert format: html <-> markup 
    drawing 		# basic image editor (ms paint)
 #   ghostscript
    # 	#  graphic
  #  evince 			# gnome document viewer
   # shotwell 		# photo organizer for the GNOME desktop
    #      gimp-with-plugins 
    #      inkscape-with-extensions  # vector draw
# imagemagick #  software suite to create, edit, compose, or convert bitmap images
    nufraw-thumbnailer # utility to read and manipulate raw images from digital cameras
    libsixel 		# img2sixel - library for console graphics, and converter programs
    libpng  		# lib für *.png
    libavif  		# lib für *.avif
    jpegoptim 		# optimize JPEG files
    jpeginfo 		# info and tests integrity of JPEG/JFIF files
    webp-pixbuf-loader # WebP GDK Pixbuf Loader library
    # xmp 				# xmp - extended module player - plays obscure module formats
libva	libva-utils #utilities and examples to exercise VA-API in accordance with the libva project.
#	glxinfo #utilities for OpenGL
#	glmark2 #glmark2 is a benchmark for OpenGL (ES) 2.0
#		clinfo 		# print all known information about all available OpenCL platforms and devices in the system	
    #	bumblebee # daemon for managing Optimus videocards (power-on/off, spawns xservers)
    #	mangohud # OpenGL overlay for monitoring FPS, temperatures, CPU/GPU
 #   	xorg.xrandr	arandr # für xfce nicht nötig	#	
xorg.xdpyinfo #Informationen über einen X-Server anzeigt
### FONTS
	tt2020 	nerdfonts 
	# powerline-fonts 	_3270font	
	lalezar-fonts
	#	powerline-go
		zsh-powerlevel9k #Powerlevel9k ZSH theme
		zsh-powerlevel10k
		meslo-lgs-nf #Meslo Nerd Font patched for Powerlevel10k
		
		gitFull #Distributed version control system
		#gitnr #Create `.gitignore` files using one or more templates from TopTal, GitHub or your own collection
		#gitlab #GitLab Community Edition
		#git-my #List remote branches if they're merged and/or available locally
	#	git-mit #Minimalist set of hooks to aid pairing and link commits to issues
		git-hub #interface to GitHub, enabling most useful GitHub tasks (like creating and listing pull request or issues) to be accessed directly through the Git command line.
		git-doc
		#gitstats
		#gitleaks #Scan git repos (or files) for secretslinhjt
		gitlint #Linting for your git commit messages
		shellspec #full-featured BDD unit testing framework for bash, ksh, zsh, dash and all POSIX shells
	
		tealdeer #tldr
		tree
		neofetch
		hyfetch
		#perl
		micro
		#fzf-zsh
		fzf
		#fzf-obc
		neo-cowsay
#		xcowsay 
		fortune
		clolcat
		blahaj
		theme-sh #script which lets you set your $terminal theme
		duf ## color mounts Disk Usage/Free Utility

		lsd
		
		haskellPackages.hackertyper #hack" like a programmer in movies and games!
	
		#fonts
		#fontfinder
		kitty
		tt2020
		nerdfonts
	
	];
		# ~/.local/share/font + fc-cache für costume fonts
	fonts.packages = with pkgs; [
	  (nerdfonts.override { 	lalezar-fonts  tt2020  fonts = [  "Hack" 	"3270"	 "Agave" 
	  						"Inconsolata"  "Lekton" "Monofur" "ProggyClean" ]; })
						 						]; 	#  "Iosevka"	"FiraCode" 	"DroidSansMono" 	"EnvyCodeR" "Mononoki" "ProFont"
	 environment.xfce.excludePackages = [
	            pkgs.xfce.mousepad 	    pkgs.xfce.parole
	            pkgs.xfce.ristretto		pkgs.xfce.thunar 		];
				
	environment.gnome.excludePackages = [
	   			pkgs.gnome.gnome-backgrounds pkgs.gnome.gnome-characters
	   			pkgs.gnome.geary  pkgs.gnome.gnome-music
	   			pkgs.gnome-photos pkgs.gnome.nautilus
	   			pkgs.gnome.totem  pkgs.gnome.yelp
	   			pkgs.gnome.cheese     	 ];

}
