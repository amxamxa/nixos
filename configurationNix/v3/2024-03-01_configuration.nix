## ╔═╗╦╦  ╔═╗ ############################
## ╠╣ ║║  ║╣ 	nixOS config file
## ╚  ╩╩═╝╚═╝   
##	 -PATH:    	/etc/nixos/
##	 -NAME:	  	configuration.nix
##	 -STATUS:	work in progress
##	 -USAGE:	config nixOS 23.05
## -------------------------------------
## FILE DATES	[yyyy-mmm-dd]
## .. SAVE:	  	2024-feb-23
## .. CREATION: july 2023
## -----------------------------------------
## AUTHOR:		mxx
## COMMENTS: 	incl. flakes, since 21-feb-2024
##				deshalb unbedingt auch 
##				/etc/nixos/flake.nix beachten
###########################################

# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ]; 
#  ┐ ┌─┐┌─┐┌┬┐┬  ┌─┐┌─┐┌┬┐┌─┐┬─┐
# ├┴┐│ ││ │ │ │  │ │├─┤ ││├┤ ├┬┘
# └─┘└─┘└─┘ ┴ ┴─┘└─┘┴ ┴─┴┘└─┘┴└─
####################### (U)EFI Bootloader.

boot.loader.efi.canTouchEfiVariables = true;
boot.loader.efi.efiSysMountPoint  =  "/boot";
## SYSTEMD-BOOT
#boot.loader.systemd-boot.enable = true;
## GRUB2
#boot.loader.grub.enable = false;
boot.loader.grub.enable = true;
boot.loader.grub.efiSupport = true;
boot.loader.grub.configurationLimit = 55;
#boot.loader.grub.theme ="/boot/grub/themes/dark-matter/theme.txt";
boot.loader.grub.memtest86.enable = true;
boot.loader.grub.fsIdentifier = "label";
boot.loader.grub.devices = [ "nodev" ];
boot.loader.grub.useOSProber = true;

fileSystems."/share" =
  { device = "/dev/disk/by-uuid/6dd1854a-047e-4f08-9ca1-ca05c25d03af";
    fsType = "btrfs";
  };


####################### ####################### #######################                                                            
# |              o                              o               
# |---.,---.,---..,---.    ,---.,---.,---..    ,.,---.,---.,---.
# |   |,---|`---.||        `---.|---'|     \  / ||    |---'`---.
# `---'`---^`---'``---'    `---'`---'`      `'  ``---'`---'`---'
####################### ####################### ####################### 
services.logind.extraConfig = ''
							HandlePowerKey = "poweroff";
							powerKeyLongPress "reboot";
							'';
                                                                                                                 
hardware.cpu.intel.updateMicrocode = true;
# Enable the X11 windowing system.
services.xserver.enable = true;
services.xserver.autorun = true;

services.xserver.displayManager.gdm.enable = true;
services.xserver.displayManager.gdm.banner = ''
  hallo keule!!;
 '';
services.xserver.displayManager.gdm.wayland = true; #Allow GDM to run on Wayland instead of Xserver.

#i18n.inputMethod.fcitx5.waylandFrontend

 # Wird aus den Display-Manager-Einstellungen oder den 
 # Window-Manager-Einstellungen übernommen, sofern einer dieser Parameter festgelegt ist.
 #Graphical session to pre-select in the session chooser, only for .
 # ... GDM, LightDM and SDDM, it will also be used as a session for auto-login.
# desktopManager + WindoManager services.xserver.displayManager.defaultSession = "gnome-xorg"; # + bspwm"; #define your default window manager and desktop environment"xfce";
 

# Enable the GNOME Desktop Environment.
services.xserver.desktopManager.gnome.enable = true;
#services.xserver.desktopManager.gnome.session = true;

# Enable the CINNAMON Desktop Environment.
#services.xserver.desktopManager.cinnamon.enable = true;
#services.xserver.desktopManager.xfce.enable = true;

# Set your time zone.
  time.timeZone = "Europe/Berlin";

#### NETWORK                                   
 networking.hostName = "nixos"; # Define your hostname.
 # Enable networking
 networking.networkmanager.enable = true;
 # Enables wireless support via wpa_supplicant.
 networking.wireless.enable = false;  

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "de";
    xkb.variant = "";
  };

# Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
# Configure console keymap
  console.keyMap = "de";

# Enable CUPS to print documents;
# services.printing.enable = true;  
 
# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;

# Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };


# Enable the Flakes feature and the accompanying new nix command-line tool
# https://nixos.org/manual/nix/stable/contributing/experimental-features
nix.settings.experimental-features = [ 
						"nix-command" 
						"flakes"
#						"auto-allocate-uids"		
								];

environment.variables.EDITOR = "micro";
								
#system.autoUpgrade.enable = true;
#system.autoUpgrade.allowReboot = true;
nix.settings.auto-optimise-store = true;

#-----------------------------------
#	 ██████╗ ██████╗ ██╗   ██╗
#	██╔════╝ ██╔══██╗██║   ██║
#	██║  ███╗██████╔╝██║   ██║
#	██║   ██║██╔═══╝ ██║   ██║
#	╚██████╔╝██║     ╚██████╔╝
#	 ╚═════╝ ╚═╝      ╚═════╝ 
#---ansi shadow-----------------------
#boot.kernelPackages = pkgs.linuxPackages_latest; #für kerne 6.7
#boot.kernelPackages = pkgs.linuxPackages_5_4;  
 services.xserver.videoDrivers = [ "intel" "modestting" ];
#services.xserver.videoDrivers = [ "modesetting" ];
#	"nouveau"
	 # grundlegende GPU func, stabiler als `nouveau` ode proprietären Treiber  von NVIDIA oder AMD. 
# 	"amdgpu-pro"  #AMD provides a proprietary driver that is not enabled by default because it’s not Free Software
#	"nvidiaLegacy340" #"nvidiaLegacy390"	"nvidiaLegacy304" 
#	"nvidia"
#nouveau
#	"intel" # specific intel driver, but not recommended by most distributions
		   			 
#hardware.nvidia.package = [ "config.boot.linuxKernel.packages.linux_5_15.nvidia_x11" ];
#hardware.nvidia.package = [ "config.boot.kernelPackages.nvidiaPackages.legacy_390" ];

#hardware.nvidia = {
# Modesetting is required. Whether to enable kernel 
# modesetting when using the NVIDIA proprietary driver.
#	modesetting.enable = true;
# Nvidia power management. Experimental, and can cause sleep/suspend to fail.
  #	powerManagement.enable = false;
 #	powerManagement.finegrained = false;

# supported GPUs is at: # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
# Currently alpha-quality/buggy, so false is currently the recommended setting.
 #  open = false; #Ob das Open-Source-NVIDIA-Kernelmodul aktiviert werden soll.
 #  nvidiaSettings = false;#  the settings menu, via nvidia-settings
# nvidiaPersistenced = true; #es stellt sicher, dass alle GPUs auch im Headless-Modus aktiv bleiben.
# Optionally, you may need to select the appropriate driver version for your specific GPU:
#	package = config.boot.linuxKernel.packages.linux_.nvidia_x11_legacy_340;

#  package = config.boot.kernelPackages.nvidiaPackages.legacy_340;
 #	package = config.boot.linuxKernel.packages.linux_5_15.nvidia_x11_production_open; #für nouveu
#  			 };
  			 
# Enable OpenGL
# hardware.opengl = {
#			    enable = true;
#			    driSupport = true;
#			    driSupport32Bit = true;
 #					 };
# newer HW (>2014): intel-media-driver, older HW: intel-vaapi-drive
# hardware.opengl.extraPackages = [ intel-vaapi-driver ];

# hardware.bumblebee.enable = true;
# hardware.bumblebee.driver = "nouveau";  #"nvidia" or "nouveau"
# hardware.bumblebee.pmMethod = "auto"; #Set preferred power management method for unused card.

# Allow unfree packages
nixpkgs.config.allowUnfree = true;
#nixpkgs.config.nvidia.acceptLicense = true;

#nixpkgs.config.allowBroken = true; # für nvidia

#hardware.enableAllFirmware = true;
####################### ####################### 
# 	 __   __  _______  _______  ______   
# 	|  | |  ||       ||       ||    _ |  
# 	|  | |  ||  _____||    ___||   | ||  
#	|  |_|  || |_____ |   |___ |   |_||_ 
# 	|       ||_____  ||    ___||    __  |
#	|       | _____| ||   |___ |   |  | |
#	|_______||_______||_______||___|  |_|                                                                                                                                             
######################## benutzer anlegen ...                                                                         
  users.users.max = {
    isNormalUser = true;
    description = "nix";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nix = {
    isNormalUser = true;
    description = "nix";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

############################# 
# ┌─┐┌─┐┬ ┬  ┌─┐┌─┐┌┐┌┌─┐┬┌─┐
# ┌─┘└─┐├─┤  │  │ ││││├┤ ││ ┬
# └─┘└─┘┴ ┴  └─┘└─┘┘└┘└  ┴└─┘
############################# ZSH
#enable zsh system-wide use 
users.defaultUserShell = pkgs.zsh;
	programs.nix-index.enableZshIntegration  = true;
# add a shell to /etc/shells
environment.shells = with pkgs; [ zsh ];
	programs.zsh = {
		enable	= true;
		enableCompletion = true;
		enableBashCompletion= true;
		autosuggestions.enable = true;
		syntaxHighlighting.enable=true;
	#	shellAliases = "$HOME/zsh/aliases.zsh";
		  histSize = 10000;
		  histFile = "$ZDOTDIR/zhistory.zsh";
		  setOptions = [		# see man 1 zshoptions
			"APPEND_HISTORY" 		"INC_APPEND_HISTORY"
			"SHARE_HISTORY" 		"EXTENDED_HISTORY"
			"HIST_IGNORE_DUPS" 	  	"HIST_IGNORE_ALL_DUPS"
			"HIST_FIND_NO_DUPS" 	"HIST_SAVE_NO_DUPS"
			"RM_STAR_WAIT"			"PRINT_EXIT_VALUE"
			"sh_word_split" 		"correct"
			"notify" 				"INTERACTIVE_COMMENTS"
			"ALIAS_FUNC_DEF"		"EXTENDEDGLOB"
			"AUTO_CD"			#	"no_global_rcs"
				        ];
#		dotDir = "$ZDOTDIR"; 
#		initExtra = ''
#		            # Powerlevel10k Zsh theme  
#		            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme  
##		            test -f ~/.config/zsh/.p10k.zsh && source ~/.config/zsh/.p10k.zsh  
#		          '';
		};
# programs.zsh.ohMyZsh = {
    # enable = true;
# #    plugins = [ "git" "python" "man" ]; #
    # plugins = [ "colored-man-pages" "colorize" "command-not-found" "extract" "thefuck" ];
    # theme = "fino-time"; #"agnoster";
  # };
programs.thefuck.enable = true;
programs.thefuck.alias = "F0";

programs.command-not-found.enable = true;  # interactive shells should show which Nix package (if any) provides a missing command.

programs.gnome-disks.enable = true;

# ┌─┐┬ ┬┌─┐┌┬┐┌─┐┌┬┐╔═╗┌─┐┌─┐┬┌─┌─┐┌─┐┌─┐┌─┐
# └─┐└┬┘└─┐ │ ├┤ │││╠═╝├─┤│  ├┴┐├─┤│ ┬├┤ └─┐
# └─┘ ┴ └─┘ ┴ └─┘┴ ┴╩  ┴ ┴└─┘┴ ┴┴ ┴└─┘└─┘└─┘
  
environment.systemPackages = with pkgs; [

#	EFI boot tools 	############################
	grub2 	memtest86-efi
	efibootmgr 	os-prober
	#refind
# nix	############################
#	nix-du
#	nix-web
#	nix-plugins   	nix-top   	nix-template   	nix-tree
#  	nix-info   	nix-diff 	nix-output-monitor 	nix-index  	nix-query-tree-viewer
# 	nixos-background-info  	binutils-unwrapped-all-targets #Tools for manipulating binaries (linker, assembler, etc.)

# cinnamon	############################
	 cinnamon.cinnamon-common cinnamon.cinnamon-control-center
	 cinnamon.cinnamon-settings-daemon cinnamon.cinnamon-session
	 cinnamon.cinnamon-menus cinnamon.cinnamon-translations
	 cinnamon.folder-color-switcher
	 cinnamon.cinnamon-screensaver cinnamon.cinnamon-desktop
	 cinnamon.nemo cinnamon.nemo-with-extensions
	 # nemo-qml-plugin-dbus 
	 cinnamon.nemo-emblems
	 cinnamon.nemo-fileroller cinnamon.nemo-python

#gnome	############################

	gnome.gnome-session gnome.gnome-session-ctl
	gnome.gnome-shell-extensions 
	gnome.gnome-tweaks	gnome.gnome-logs
	gnome.gnome-terminal gnome.gnome-color-manager
#	gnome.dconf-editor
	 gnome.gnome-themes-extra 
#	gnomeExtensions.another-window-session-manager #  https://github.com/nlpsuge/gnome-shell-extension-another-window-session-manager/blob/feature-close-save-session-while-logout/README.md.
	 #customize advanced GNOME 3 options
	gedit
		# gnome.gnome-screenshot gnome-firmware

#####################
# gnomeExtensions
	gnomeExtensions.forge #Tiling and window manager 
	#gnomeExtensions.pano
	gnomeExtensions.freon # Shows CPU temperature, disk temperature, video card temperature 
	gnomeExtensions.move-panel #Moves panel to secondary monitor on startup, without changing the primary display. Only works on Wayland
	gnomeExtensions.gnome-40-ui-improvements #Tunes gnome 40-43 Overview UI to make it more usable.
	#gnomeExtensions.gtk4-desktop-icons-ng-ding #gtk4 port of Desktop Icons NG with GSconnect Integration, Drag and Drop on to Dock or Dash
	gnomeExtensions.applications-overview-tooltip #hows a tooltip over applications icons on applications overview with application name and/or description
	gnomeExtensions.dock-from-dash #Dock for GNOME Shell 40+. Does use native GNOME Shell Dash. Very light extension
#funzt nicht	gomeExtensions.clipboard-indicator #gnomeExtensions.clipboard-indicator
 	gnomeExtensions.gnome-clipboard
#	gnomeExtensions.tray-icons-reloaded
	gnomeExtensions.topiconsfix
	 gnomeExtensions.topicons-plus #brings all icons back to the top panel,

	gnomeExtensions.desktop-icons-neo #adds desktop icons to GNOME. A fork of Desktop Icons NG with a massive amount of customizations
	gnomeExtensions.coverflow-alt-tab #Replacement of Alt-Tab, iterates through windows in a cover-flow manner.
#	gnomeExtensions.compact-quick-settings
	gnomeExtensions.just-perfection
	gnomeExtensions.add-to-desktop
	#gnomeExtensions.tweaks-in-system-menu
	#gnomeExtensions.switch-workspace
	gnomeExtensions.syncthing-icon
	gnomeExtensions.desktop-cube #nostalgia with useless 3D effects.
#	gnomeExtensions.clipman # clipboard manager for Wayland
	gnomeExtensions.compact-quick-settings #Compact quick settings menu for GNOME 43 and newer
#	gnomeExtensions.burn-my-windows
	#dynamic-wallpaper #https://github.com/dusansimic/dynamic-wallpaper
	variety #wallpaper mgmt
	#	gnomeExtensions.topicons-plus
		#nomeExtensions.wallpaper-changer-continued #Fork of wallpaper-changer@jomik.org, updated for Gnome 4
	#########################################################
	
clipboard-jh # cb --help
 pop-gtk-theme
	flat-remix-icon-theme #Flat remix is a pretty simple icon theme inspired on material design
	papirus-icon-theme pop-icon-theme
	gnome.adwaita-icon-theme
	whitesur-gtk-theme #MacOS Big Sur like theme for Gnome desktops
	mojave-gtk-theme #https://github.com/vinceliuice/Mojave-gtk-theme
#numix-icon-theme-circle
	#nordzy-icon-theme theme-obsidian2 numix-cursor-theme sierra-gtk-theme	-  schrott 	
	#ubuntu-themes
	#tela-icon-theme colloid-gtk-theme #
	#ightfox-gtk-theme #https://github.com/Fausto-Korpsvart/Nightfox-GTK-Theme
##################################
# div tools
	wget openssl inetutils
	#colord-gtk4 # color themes terminal
	gnupg 
	unzip zip zlib.dev unrar #extract
	file # specifies that a series of tests are performed on the file
	bat
	xclip #access the X clipboard from a console application
	#xsel #getting and setting the contents of the X selection
	pciutils # inspecting and manipulating configuration of PCI devices: lspci setpci
	coreutils # the core utilities which are expected to exist on every OS
	lshw #Provide detailed information on the hardware configuration of the machine
	usbutils #tools for working with USB device
		gparted
##################################

##		GUI internet tools
	firefox
##		GUI Zubehör
	shotwell
### 		GUI system
	timeshift
#	GUI knowledge base	
	marker # markdown editor
	cherrytree #db note taking application
	#obsidian # installiert über flatpak
	pandoc # Conversion html- markup formats
	#------------------------------------
	### 		CLI tools
	### 	---------------------------
	zsh zsh-autosuggestions zsh-autocomplete 
		zsh-syntax-highlighting zsh-completions
#	zsh-history
	# zsh-edit #powerful extensions to the Zsh command line editor
#	zsh-you-should-use #plugin that reminds you to use existing aliases for commands 
#	zsh-command-time #utput time: xx after long commands
	zsh-fzf-tab #Replace zsh's default completion selection menu with fzf!
	#zsh-autoenv #Automatically sources whitelisted .autoenv.zsh files
	#zsh-clipboard #Ohmyzsh plugin that integrates kill-ring with system clipboard
	zsh-nix-shell #to use zsh in nix-shell shell
	nix-zsh-completions
#	zsh-git-prompt
	#oh-my-zsh
	zoxide thefuck # app which corrects your previous console command
	fff #Fucking Fast File-Manager
	fzf 	fzf-zsh #	fzf-git-sh
#	zsh-forgit # utility tool powered by fzf for using git interactively
#	powerline-go
#	zsh-powerlevel9k #Powerlevel9k ZSH theme
#	zsh-powerlevel10k
	meslo-lgs-nf #Meslo Nerd Font patched for Powerlevel10k
	git git-doc gitFull #Distributed version control system
	#gitnr #Create `.gitignore` files using one or more templates from TopTal, GitHub or your own collection
	#gitlab #GitLab Community Edition
	#git-my #List remote branches if they're merged and/or available locally
#	git-mit #Minimalist set of hooks to aid pairing and link commits to issues
#	git-hub #interface to GitHub, enabling most useful GitHub tasks (like creating and listing pull request or issues) to be accessed directly through the Git command line.
	#gitstats
	#gitleaks #Scan git repos (or files) for secretslinhjt
#	gitlint #Linting for your git commit messages
#	shellspec #full-featured BDD unit testing framework for bash, ksh, zsh, dash and all POSIX shells
ripgrep # grep 2.0
banner toilet # like banner
libsixel # img2sixel - library for console graphics, and converter programs
	tealdeer #tldr
	fd # user-friendly find
	tree
	neofetch hyfetch
	#perl
	micro
	#fzf-zsh
	#fzf
	#fzf-obc
	neo-cowsay xcowsay fortune
	clolcat blahaj
	theme-sh #script which lets you set your $terminal theme
	duf ## color mounts Disk Usage/Free Utility
	
	btop inxi lsd eza
#	exa #'exa' has been removed because it is unmaintained
		#python311Packages.pip
	#####
	#xfce.xfce4-terminal
	#haskellPackages.general-games
	#steam
	haskellPackages.hackertyper #hack" like a programmer in movies and games!
	#fonts
	#fontfinder
	tt2020 	nerdfonts 	terminus-nerdfont
	powerline-fonts 	_3270font
# GPU
#intel-ocl
 	intel-vaapi-driver
	libva-utils #utilities and examples to exercise VA-API in accordance with the libva project.
	glxinfo #utilities for OpenGL
	glmark2 #glmark2 is a benchmark for OpenGL (ES) 2.0
	xorg.xrandr	arandr
	eww #ElKowars wacky widgets
#	driversi686Linux.vdpauinfo
#	driversi686Linux.intel-vaapi-driver
# linuxKernel.packages.linux_latest

#	linuxKernel.packages.linux_5_4.nvidia_x11_production_open #NVIDIA Linux Open GPU Kernel Module
#	linuxKernel.packages.linux_5_5.nvidia_x11_production_open #NVIDIA Linux Open GPU Kernel Module
#	linuxKernel.packages.linux_5_10.nvidia_x11_production_open #NVIDIA Linux Open GPU Kernel Module
#	linuxKernel.packages.linux_5_15.nvidia_x11_production_open #NVIDIA Linux Open GPU Kernel Module

# intel-ocl #Official OpenCL runtime for Intel CPUs
# linuxKernel.packages.linux_5_4.nvidia_x11_legacy470
# linuxKernel.packages.linux_5_10vidia_x11_legacy470
# linuxKernel.packages.linux_5_10.nvidia_x11_legacy340

# linuxKernel.packages.linux_latest_libre.nvidia_x11_legacy470
# linuxKernel.packages.linux_latest_libre.nvidia_x11_legacy340
# linuxKernel.packages.linux_latest_libre.nvidia_x11_legacy390
		];

environment.gnome.excludePackages = [
   			pkgs.gnome.gnome-backgrounds
   		#	pkgs.gnome.geary
   			pkgs.gnome.gnome-music
   			pkgs.gnome-photos
   			pkgs.gnome.nautilus
   			pkgs.gnome.totem
   			pkgs.gnome.yelp
   			pkgs.gnome.gnome-characters
   			pkgs.gnome.cheese
   								];
fonts.fontDir.enable = true;

fonts.packages = with pkgs; [
        cantarell-fonts
        dejavu_fonts
        source-code-pro # Default monospace font in 3.32
        source-sans
        unifont
   #     hack
   #     Cirquee
    #    Chomsky
     #   freemono
     #   GeneraleStation
    #    Keypunch029
   #     Minecrafter
     #   NaziTypewriterRegular
      #  NeomatrixCode
   #     RichEatin
    #    Semyon
     #   Warszawa
        tt2020
       # 3270font
      ];
      

environment.cinnamon.excludePackages = [
		pkgs.gnome.geary
	];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

################################################################################
#                                          /  |                              
#   _______   ______    ______   __     __ $$/   _______   ______    _______ 
#  /       | /      \  /      \ /  \   /  |/  | /       | /      \  /       |
# /$$$$$$$/ /$$$$$$  |/$$$$$$  |$$  \ /$$/ $$ |/$$$$$$$/ /$$$$$$  |/$$$$$$$/ 
# $$      \ $$    $$ |$$ |  $$/  $$  /$$/  $$ |$$ |      $$    $$ |$$      \ 
#  $$$$$$  |$$$$$$$$/ $$ |        $$ $$/   $$ |$$ \_____ $$$$$$$$/  $$$$$$  |
# /     $$/ $$       |$$ |         $$$/    $$ |$$       |$$       |/     $$/ 
# $$$$$$$/   $$$$$$$/ $$/           $/     $$/  $$$$$$$/  $$$$$$$/ $$$$$$$/  
################################################################################
                                                                                                                                          
                                                                           
# List services that you want to enable:				
	services.gnome.games.enable = false;
  # services.gnome.evolution-data-server.enable = false;
	services.gnome.gnome-initial-setup.enable = false;

# Enable the OpenSSH daemon.
	services.openssh.enable = true;
## Enable the Flatpak
	services.flatpak.enable = true;         


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
# services.picom = { # for nicexcfe
#   enable = true;
#   fade = true;
#   inactiveOpacity = 0.9;
#   shadow = true;
#   fadeDelta = 4;
# };
     						
services.logrotate.enable = true;
services.logrotate.configFile = pkgs.writeText "logrotate.conf" ''
  size  100M
  rotate  5
  compress
  delaycompress
  missingok
  notifempty
  weekly
'';


# 
 services.journald.extraConfig = ''
   	SystemMaxUse=100M
     SystemMaxFiles=10
     Compress=yes
     MaxFileSec=1week
     ForwardToSyslog=yes #Weiterleitung an Syslog
 	ForwardToKMsg=yes   # Weiterleitung an Kernel-Messaging-Daemon.
 		'';	

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

