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
## COMMENTS: no:	incl. flakes, since 21-feb-2024
##				deshalb unbedingt auch 
##				/etc/nixos/flake.nix beachten
###########################################

# your system.  Help is available in the configuration.nix(5) man page
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

  # Bootlo
### Bootloader.
## (U)EFI
boot.loader.efi.canTouchEfiVariables = true;
boot.loader.efi.efiSysMountPoint  =  "/boot";
## SYSTEMD-BOOT
boot.loader.systemd-boot.enable = false;
## GRUB2
boot.loader.grub.enable = true;
boot.loader.grub.efiSupport = true;
boot.loader.grub.configurationLimit = 55;
#boot.loader.grub.theme ="/boot/grub/themes/dark-matter/theme.txt";
boot.loader.grub.memtest86.enable = true;
#boot.loader.grub.fsIdentifier = "label";
boot.loader.grub.devices = [ "nodev" ];
boot.loader.grub.useOSProber = true;
boot.loader.grub.default = "saved"; #ndex of the default menu item to be booted. Can also be set to “saved”, which will make GRUB select the menu item that was used at the last boot.
boot.loader.grub.backgroundColor  = "#7EBAE4"; # background color to be used to fill the areas the image isn’t filling.
#boot.loader.grub.splashImage ="./my-background.png" # background image used for GRUB. Set to null to run GRUB in text mode.
#boot.loader.grub.splashMode = "stretch"; # oder normal

#boot.loader.grub.font = "/path"; # Path to a TrueType, OpenType, or pf2 font to be used by Grub.
#boot.loader.grub.fontSize = 14; # ...wird ignoriert, es sei denn, die Schriftart ist auf eine TTF- oder OTF-Schriftart eingestellt.
  networking.hostName = "nixos-mxx"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

fileSystems."/home/manix/share" =
  { device = "/dev/disk/by-uuid/6dd1854a-047e-4f08-9ca1-ca05c25d03af";
    fsType = "btrfs";  };

  # Enable networking
  networking.networkmanager.enable = true;
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
	# set to true the wallpaper will stretch across all screens:
 services.xserver.desktopManager.wallpaper.combineScreens= true;
 #services.xserver.displayManager.defaultSession = "gnome-xorg";
  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
   services.xserver.desktopManager.gnome.enable = false;
# service for xfce display magmt
   services.picom = { 
     enable = true;
     fade = true;
     inactiveOpacity = 0.9;
     shadow = true;
     fadeDelta = 4;
   };
  services.logind.extraConfig = ''
				HandlePowerKey = "poweroff";
				powerKeyLongPress = "reboot";
				'';

# Enable automatic login for the user.
#  services.xserver.displayManager.autoLogin.enable = true;
#  services.xserver.displayManager.autoLogin.user = "xyz";
#systemd.services."getty@tty1".enable = false;
#systemd.services."autovt@tty1".enable = false;

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };
  # Configure console keymap
  console.keyMap = "de";
  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    media-session.enable = true;
  };
  # services.pipewire.wireplumber.enable = false; # enable Wireplumber, a modular session / policy manager for PipeWire

nixpkgs.config.pulseaudio = true; # built with explicit PulseAudio support which is disabled by default. 

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


#-----------------------------------
#        ██████╗ ██████╗ ██╗   ██╗
#       ██╔════╝ ██╔══██╗██║   ██║
#       ██║  ███╗██████╔╝██║   ██║
#       ██║   ██║██╔═══╝ ██║   ██║
#       ╚██████╔╝██║     ╚██████╔╝
#        ╚═════╝ ╚═╝      ╚═════╝ 
#---ansi shadow-----------------------
  boot.kernelParams = [ "modprobe.blacklist=nouveau" ];
  services.xserver.videoDrivers = [ "nvidia" ];  # [ "modesetting" ];   "nouvea>
  hardware.nvidia = {
  # modesetting when using the NVIDIA proprietary driver.
        modesetting.enable = true;
  # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        powerManagement.enable = false;
        powerManagement.finegrained = false;
  # supported GPUs is at: # https://github.com/NVIDIA/open-gpu-kernel-modules#c>
  # Currently alpha-quality/buggy, so false is currently the recommended settin>
        open = false; #Ob das Open-Source-NVIDIA-Kernelmodul aktiviert werden s>
        nvidiaSettings = true; #  the settings menu, via nvidia-settings
        nvidiaPersistenced = true; #es stellt sicher, dass alle GPUs auch im He>
         };
# Enable OpenGL
 #hardware.opengl = {
#	enable = true;
#       driSupport = true;
#       driSupport32Bit = true;
#                                        };
# newer HW (>2014): intel-media-driver, older HW: intel-vaapi-drive
#ardware.opengl.extraPackages = [ "intel-ocl" ];
#ardware.opengl.extraPackages32 = [ "driversi686Linux.intel-vaapi-driver" ];

# hardware.bumblebee.enable = true;
# hardware.bumblebee.driver = "nouveau";  #"nvidia" or "nouveau"
# hardware.bumblebee.pmMethod = "auto"; #Set preferred power management method >
                                                                            
 hardware.cpu.intel.updateMicrocode = true; # update the CPU microcode for Intel processors.

 hardware.enableAllFirmware = true; # enable all firmware regardless of license
    								
  #system.autoUpgrade.enable = true;
  #system.autoUpgrade.allowReboot = true;
  #nix.settings.auto-optimise-store = true;
  
# Allow unfree packages
	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.nvidia.acceptLicense = true;

# Enable the Flakes feature and the accompanying new nix command-line tool
# https://nixos.org/manual/nix/stable/contributing/experimental-features
#nix.settings.experimental-features = [ 
#						"nix-command" 
#						"flakes"
#						"auto-allocate-uids"		
#								];
#programs.nix-index.enable # whether to enable nix-index, a file database for nixpkgs.
#programs.nix-index.package # package providing the nix-index tool.
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xyz = {
    isNormalUser = true;
    description = "xyz";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [
	boohu # new coffee-break roguelike game
    ];
  };
 users.users.manix = {
    isNormalUser = true;
    description = "manix";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [
	pkgs.bsdgames  #Ports of all the games from NetBSD-current that are free
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
			"AUTO_CD"				"NOMATCH"
									#	"no_global_rcs"
				        ];
#		dotDir = "$ZDOTDIR"; 
#		initExtra = ''
#		            # Powerlevel10k Zsh theme  
#		            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme  
##		            test -f ~/.config/zsh/.p10k.zsh && source ~/.config/zsh/.p10k.zsh  
#		          '';
		};

programs.thefuck.enable = true;
programs.thefuck.alias = "F0";
# programs.starship.enable = true; programs.starship.settings programs.starship.interactiveOnly = true;	# whether to enable  whenis interactive. Some plugins require this to be set to false 
programs.command-not-found.enable = true;  # interactive shells should show which Nix package (if any) provides a missing command.
programs.gnome-disks.enable = true; # whether to enable GNOME Disks daemon
environment.variables.EDITOR = "micro";

#--------------------------------------------
# ┌─┐┬ ┬┌─┐┌┬┐┌─┐┌┬┐╔═╗┌─┐┌─┐┬┌─┌─┐┌─┐┌─┐┌─┐
# └─┐└┬┘└─┐ │ ├┤ │││╠═╝├─┤│  ├┴┐├─┤│ ┬├┤ └─┐
# └─┘ ┴ └─┘ ┴ └─┘┴ ┴╩  ┴ ┴└─┘┴ ┴┴ ┴└─┘└─┘└─┘
#--------------------------------------------
environment.systemPackages = with pkgs; [
# EFI boot tools 	############################
	grub2 	memtest86-efi
	efibootmgr 	os-prober
#	refind
# nix	############################
#	nix-du
#	nix-web
#	nix-plugins   	nix-top   	nix-template   	nix-tree
#  	nix-info   	nix-diff 	nix-output-monitor 	nix-index  	nix-query-tree-viewer
# 	nixos-background-info  	binutils-unwrapped-all-targets #Tools for manipulating binaries (linker, assembler, etc.)
# div tools
ntfs3g # FUSE-based NTFS driver with full write support
	curl wget openssl inetutils
	#colord-gtk4 # color themes terminal
	gnupg 
	unzip zip zlib
	# unrar #unfree
	file # specifies that a series of tests are performed on the file
	bat
	xclip #access the X clipboard from a console application
	#xsel #getting and setting the contents of the X selection
	pciutils # inspecting and manipulating configuration of PCI devices: lspci setpci
	coreutils # the core utilities which are expected to exist on every OS
	usbutils # tools for working with USB device
	lshw # provide detailed information on the hardware configuration of the machine
	lm_sensors # tools for reading hardware sensors, fans
	logrotate # rotates and compresses system logs
	btop
	tree
	parcellite #GTK clipboard manager
##################################

##		GUI internet tools
	firefox
	vlc
	gnome.gnome-disk-utility
	gnome-text-editor
	cinnamon.nemo #cinnamon.nemo-emblems 
	cinnamon.nemo-fileroller 
	cinnamon.nemo-python 
# cinnamon.folder-color-switcher #unstable

##		GUI Zubehör
evince #     gnome document viewer
pdfarranger
	shotwell # hoto organizer for the GNOME desktop
### 		GUI system
	timeshift
#	GUI knowledge base	
	marker # markdown editor
	cherrytree #db note taking application
	obsidian # installiert über flatpak
	pandoc # Conversion html- markup formats
	#------------------------------------
	### 		CLI tools
	### 	---------------------------
#	starship # customizable prompt for any shell
	zsh zsh-autosuggestions zsh-autocomplete 
		zsh-syntax-highlighting zsh-completions
#	zsh-history 	# zsh-edit #powerful extensions to the Zsh command line editor#	zsh-you-should-use #plugin that reminds you to use existing aliases for commands #	zsh-command-time #utput time: xx after long commands
	zsh-fzf-tab #Replace zsh's default completion selection menu with fzf!
	#zsh-autoenv #Automatically sources whitelisted .autoenv.zsh files
	#zsh-clipboard #Ohmyzsh plugin that integrates kill-ring with system clipboard
	zsh-nix-shell #to use zsh in nix-shell shell
	nix-zsh-completions
#	zsh-git-prompt
	zoxide thefuck # app which corrects your previous console command
	fff #Fucking Fast File-Manager
	fzf 	fzf-zsh #	fzf-git-sh
#	zsh-forgit # utility tool powered by fzf for using git interactively
#	powerline-go
#	zsh-powerlevel9k #Powerlevel9k ZSH theme
#	zsh-powerlevel10k
logrotate
git
git-hub
git-doc

clipboard-jh # cb --help

	gparted
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
	#fzf-zsh 	#fzf 	#fzf-obc
	neo-cowsay xcowsay fortune
	clolcat blahaj
	theme-sh #script which lets you set your $terminal theme
	duf ## color mounts Disk Usage/Free Utility
	
	btop inxi lsd #eza
#	exa #'exa' has been removed because it is unmaintained
		#python311Packages.pip
	#####
	xfce.xfce4-terminal
	haskellPackages.hackertyper #hack" like a programmer in movies and games!

#	#fonts
	tt2020 	nerdfonts 	terminus-nerdfont
	powerline-fonts 	_3270font
# GPU
#intel-ocl
# 	intel-vaapi-driver
	libva-utils #utilities and examples to exercise VA-API in accordance with the libva project.
	glxinfo #utilities for OpenGL
	glmark2 #glmark2 is a benchmark for OpenGL (ES) 2.0
	xorg.xrandr	arandr


#audio
xfce.xfce4-pulseaudio-plugin # adjust the audio volume of the PulseAudio sound system
pavucontrol # pulseAudio Volume Control
pipewire
pwvucontrol # Pipewire Volume Control
helvum # GTK patchbay for pipewire
#themes
	flat-remix-icon-theme #Flat remix is a pretty simple icon theme inspired on material design
#	papirus-icon-theme pop-icon-theme
#	gnome.adwaita-icon-theme
	whitesur-gtk-theme #MacOS Big Sur like theme for Gnome desktops
#	mojave-gtk-theme #https://github.com/vinceliuice/Mojave-gtk-theme
# 	numix-icon-theme-circle  pop-gtk-theme
							];

# fonts.fontDir.enable = true;
# fonts.packages = with pkgs; [
        # cantarell-fonts
        # dejavu_fonts
        # source-code-pro # Default monospace font in 3.32
        # source-sans
        # unifont
   # #     hack
   # #     Cirquee
    # #    Chomsky
     # #   freemono
     # #   GeneraleStation
    # #    Keypunch029
   # #     Minecrafter
     # #   NaziTypewriterRegular
      # #  NeomatrixCode
   # #     RichEatin
    # #    Semyon
     # #   Warszawa
        # tt2020
       # # 3270font
      # ];
# environment.xfce.excludePackages = [
#                        pkgs.xfce.mousepad
#			pkgs.xfce.parole
#			pkgs.xfce.thunar
#			pkgs.xfce.ristretto
#				];


environment.gnome.excludePackages = [
   			pkgs.gnome.gnome-backgrounds
   			pkgs.gnome.geary
   			pkgs.gnome.gnome-music
   			pkgs.gnome-photos
   			pkgs.gnome.nautilus
   			pkgs.gnome.totem
   			pkgs.gnome.yelp
   			pkgs.gnome.gnome-characters
   			pkgs.gnome.cheese     
				 ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
##################################################                     
#	                       (_)                
#	  ___  ____  ____ _   _ _  ____ ____  ___ 
#	 /___)/ _  )/ ___) | | | |/ ___) _  )/___)
#	|___ ( (/ /| |    \ V /| ( (__( (/ /|___ |
#	(___/ \____)_|     \_/ |_|\____)____|___/ 
###################################################		                 
# List services that you want to enable:				
#	services.gnome.games.enable = false;
  # services.gnome.evolution-data-server.enable = false;
#	services.gnome.gnome-initial-setup.enable = false;

# Enable the OpenSSH daemon.
#	services.openssh.enable = true;
## Enable the Flatpak
#	xdg.portal.enable = true;      # Eable xdg desktop integration.  https://github.com/flatpak/xdg-desktop-portal-gtk
# xdg.portal.extraPortals = [ xdg-desktop-portal-gtk ];
#	services.flatpak.enable = true;         

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  


#--------------
     						
services.logrotate.enable = true;
services.logrotate.configFile = pkgs.writeText "logrotate.conf" ''
				size  100M
  				rotate  5
  				compress
  				delaycompress
  				missingok
  				notifempty
  				weekly			'';
#--------------
 services.journald.extraConfig = ''
   				SystemMaxUse=100M
	    			SystemMaxFiles=10
				Compress=yes
    				MaxFileSec=1week
	    			ForwardToSyslog=yes
 				ForwardToKMsg=yes 	'';	

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
