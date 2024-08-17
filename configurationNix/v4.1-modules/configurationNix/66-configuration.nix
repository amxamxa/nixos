# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
			
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

### Bootloader.
## (U)EFI
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



# Set your time zone.
   time.timeZone = "Europe/Berlin";

#  Enable networking
#  ------------------
                     networking.hostName		= "nixos"; #  Define your hostname.
         networking.networkmanager.enable		= true;
   networking.usePredictableInterfaceNames 		= false; #  eth0 statt ensp0
   networking.networkmanager.appendNameservers 	= [ 
   		/*  www.ccc.de/censorship/dns-howto */
	  	/* digitalcourage, Informationsseite */		"5.9.164.112"
		/*f.6to4-servers.net, ISC, USA */	    	"204.152.184.76"
		/*dns.as250.net; Berlin/Frankfurt */ 		"194.150.168.168"
		/*f.6to4-servers.net, IPv6, ISC */	    	"2001:4f8:0:2::14"
		 
	         ];
	         
 #  Select internationalisation properties.
 #  -----------------------------------
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

 #  	system.autoUpgrade.enable = false;
 #		system.autoUpgrade.allowReboot = true;
 #  	nix.settings.auto-optimise-store = true;

	nix.settings.sandbox = true;
 #  nixpkgs.config.allowBroken = true;

   #  Allow InsecurePackages
   nixpkgs.config.permittedInsecurePackages = [   "electron-25.9.0"     ];
   
   #  Enable the Flakes feature and the accompanying new nix command-line tool
   #  https://nixos.org/manual/nix/stable/contributing/experimental-features
  nix.settings.experimental-features = [ "nix-command" ]; /*  "flakes" "auto-allocate-uids"		*/

 #  Configure console
  console = {
       font = "Lat2-Terminus16";
       keyMap = lib.mkForce "de";
       useXkbConfig = true; #  use xkb.options in tty.
     };
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.desktopManager.xfce.enable = true;
services.displayManager.defaultSession = "xfce";
  #services.xserver.displayManager.gdm.enable = true;
  
  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

 # Enable CUPS to print documents.
 # services.printing.enable = true;

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # Sudo-Version 1.9.15p2 -Policy-Plugin Ver 1.9.15p2 Sudooers-Datei-Grammatik-Version 50
   # Sudoers - I/O plugin version 1.9.15p2  Sudoers - audit plugin version 1.9.15p2
   	security.sudo = {
   	  extraRules = [
   	  	{ groups = ["wheel"];
   	      commands = [
   	        {	command = "${pkgs.coreutils}/sbin/df"; 	options = ["NOPASSWD"];  } 
   	        { command = "${pkgs.systemd}/bin/systemctl suspend"; options = ["NOPASSWD"]; }
   	        { command = "${pkgs.systemd}/bin/reboot"; options = ["NOPASSWD"];     }
   	        { command = "${pkgs.systemd}/bin/poweroff"; options = ["NOPASSWD"];   }
   	        { command = "${pkgs.systemd}/sbin/shutdown"; options = ["NOPASSWD"];  }
   	      ];
   	    }
   	  ];
   	   extraConfig = ''
   		Defaults env_reset #  safety measure used to clear potentially harmful environmental variables 
   	  	 Defaults mail_badpass   	  	# Mail bei fehlgeschlagenem Passwort
   	 #    Defaults mailto="admin@example.com"   	 # Mail an diese Adresse senden
   		Defaults timestamp_timeout = 50
   		Defaults logfile = /var/log/sudo.log #  Speichert Sudo-Aktionen in  Logdatei
   		Defaults lecture = always #, script=/etc/sudoers.lecture.sh
     					'';	
   	};
   	    	#	''wheel ALL=(ALL:ALL) NOPASSWD: /sbin/shutdown''
        environment.variables.EDITOR = "micro";
         environment.variables.ZDOTDIR = "/share/zsh";
        environment.sessionVariables =  {
            XDG_CACHE_HOME  = "${HOME}/.cache";
            XDG_CONFIG_HOME = "${HOME}/.config";
            XDG_DATA_HOME   = "${HOME/.local/share}";
            XDG_STATE_HOME  = "${HOME/.local/state}";
            	
            #	 XAUTHORITY = "${XDG_CONFIG_HOME}/Xauthority";
            	 GIT_CONFIG = "${XDG_CONFIG_HOME/git/config}";
        	       WWW_HOME = "${XDG_CONFIG_HOME}/w3m";       # w3m config path
	 KITTY_CONFIG_DIRECTORY = "${XDG_CONFIG_HOME}/kitty";  	# kitty, nur PATH angeben:
                      }; 

  users.users.max = {
    isNormalUser = true;
    description = "nix";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alice = {
    isNormalUser = true;
    description = "nix";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [

#      firefox
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


############################# ZSH
programs.command-not-found.enable = false;
# programs.zsh.interactiveShellInit = '' source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh '';
 programs.bash.interactiveShellInit = ''  	source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh '';
programs.nix-index = 		{ #damit command: nix-locate pattern 
 enable = true;   # whether to enable nix-index, a file database for nixpkgs.  
 package = pkgs.nix-index;
 enableBashIntegration = true;  
 enableZshIntegration = true;    };
 

#enable zsh system-wide use 
programs.bash.enableCompletion = true;
programs.bash.enableLsColors =true; 
programs.fzf.fuzzyCompletion = true;

programs.thefuck.enable = true;
programs.thefuck.alias = "F0";

users.defaultUserShell = pkgs.zsh;
# add a shell to /etc/shells
environment.shells = with pkgs; [ zsh ];
	programs.zsh = {
		enable	= true;
		enableCompletion = true; #Enable zsh completion for all interactive zsh shells.
		enableBashCompletion = true;
		enableLsColors = true;
		autosuggestions.enable = true; # enable zsh-autosuggestions.
		syntaxHighlighting.enable = true; #enable zsh-syntax-highlighting.
		interactiveShellInit = '' 

  source /share/zsh/zshrc

		source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh '';        

		promptInit = ''
#source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
#source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/internal/p10k.zsh
					'';
#	  	  shellAliases = "$ZDOTDIR/aliases.zsh";
		  histSize = 10000;
		  histFile = "$ZDOTDIR/history/zhistory";

		  setOptions = [		# see man 1 zshoptions
			"APPEND_HISTORY" 		"INC_APPEND_HISTORY"
			"SHARE_HISTORY" 		"EXTENDED_HISTORY"
			"HIST_IGNORE_DUPS" 	  	"HIST_IGNORE_ALL_DUPS"
			"HIST_FIND_NO_DUPS" 	"HIST_SAVE_NO_DUPS"
			"RM_STAR_WAIT"			"PRINT_EXIT_VALUE"
			"SH_WORD_SPLIT" 		"CORRECT"
			"NOTIFY" 				"INTERACTIVE_COMMENTS"
			"ALIAS_FUNC_DEF"		"EXTENDEDGLOB"
			"AUTO_CD"				"NOMATCH"		#	"no_global_rcs"
				        ]; };
				        
##-

  
environment.systemPackages = with pkgs; [

	###		EFI boot tools
	grub2
	memtest86-efi
	#refind
	os-prober
	## 		Gnome
	gnome.gnome-logs
	gnome.dconf-editor
	gnome-firmware
	colord-gtk4
	bat
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
   	xfce.xfce4-cpugraph-plugin 		xfce.xfce4-fsguard-plugin # monitors the free space on your filesystems
   	xfce.xfce4-clipman-plugin		xfce.xfce4-genmon-plugin # display various types of information, such as system stats, weathe
   	xfce.xfce4-notes-plugin 		xfce.xfce4-netload-plugin #    xfce.xfce4-xkb-plugin # bildschirmschoner
   
 	#parcellite #GTK clipboard manager
 	xfce.xfce4-systemload-plugin   xfce.xfce4-whiskermenu-plugin 

  	gnome.gnome-disk-utility 	gnome-text-editor	 gnome.gnome-logs
	#dynamic-wallpaper #https://github.com/dusansimic/dynamic-wallpaper

	#########################################################

	papirus-icon-theme
	#gnome.adwaita-icon-theme
	#whitesur-gtk-theme #MacOS Big Sur like theme for Gnome desktops
	numix-icon-theme-circle
	#numix-cursor-theme
	#nordzy-icon-theme 	# schrott
	#theme-obsidian2	#schrott
	sierra-gtk-theme
	#ubuntu-themes
	pop-icon-theme
	mojave-gtk-theme # Mac OSX Mojave like theme for GTK based desktop environments
	pop-gtk-theme
	##		GUI internet tools
	firefox
	##		GUI Zubehör
gnome-text-editor
	cinnamon.nemo
	cinnamon.nemo-with-extensions
	nemo-qml-plugin-dbus
	cinnamon.nemo-emblems
	cinnamon.folder-color-switcher
	cinnamon.nemo-fileroller
	cinnamon.nemo-python


	### 		GUI system
	timeshift
	gparted

	##		GUI knowledge base		

	cherrytree
	#### Obsidian
	obsidian
	pandoc # Conversion html- markup formats

	glxinfo
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
	 flatpak     xdg-desktop-portal     xdg-desktop-portal-gtk xdg-desktop-portal-xapp
firefox	vlc 
   	libreoffice
   	pdfarranger
 texliveSmall # LaTex
    	#	wpsoffice		#doof:  office editor
   	typora 			# markdown editor
   	cherrytree 		# db note taking application
    obsidian 		pandoc # convert format: html <-> markup 
    drawing 		# basic image editor (ms paint)
    ghostscript
    # 	#  graphic
    evince 			# gnome document viewer
    shotwell 		# photo organizer for the GNOME desktop
    #      gimp-with-plugins 
    #      inkscape-with-extensions  # vector draw
imagemagick #  software suite to create, edit, compose, or convert bitmap images
    nufraw-thumbnailer # utility to read and manipulate raw images from digital cameras
    libsixel 		# img2sixel - library for console graphics, and converter programs
    libpng  		# lib für *.png
    libavif  		# lib für *.avif
    jpegoptim 		# optimize JPEG files
    jpeginfo 		# info and tests integrity of JPEG/JFIF files
    webp-pixbuf-loader # WebP GDK Pixbuf Loader library
    # xmp 				# xmp - extended module player - plays obscure module formats
libva	libva-utils #utilities and examples to exercise VA-API in accordance with the libva project.
	glxinfo #utilities for OpenGL
	glmark2 #glmark2 is a benchmark for OpenGL (ES) 2.0
		clinfo 		# print all known information about all available OpenCL platforms and devices in the system	
    #	bumblebee # daemon for managing Optimus videocards (power-on/off, spawns xservers)
    #	mangohud # OpenGL overlay for monitoring FPS, temperatures, CPU/GPU
    	xorg.xrandr	arandr # für xfce nicht nötig	#	
xorg.xdpyinfo #Informationen über einen X-Server anzeigt
### FONTS
	tt2020 	nerdfonts 
	# powerline-fonts 	_3270font	lalezar-fonts
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
	xcowsay 
	fortune
	clolcat
	blahaj
	theme-sh #script which lets you set your $terminal theme
	duf ## color mounts Disk Usage/Free Utility
	
	btop
	inxi
	lsd
	
	haskellPackages.hackertyper #hack" like a programmer in movies and games!

	#fonts
	#fontfinder
	kitty
	tt2020
	nerdfonts
	terminus-nerdfont
	powerline-fonts

];
	# ~/.local/share/font + fc-cache für costume fonts
fonts.packages = with pkgs; [
  (nerdfonts.override { fonts = [  "Hack" 	"3270"	 "Agave" 
  						"Inconsolata"  "Lekton" "Monofur" "ProggyClean" ]; })
					tt2020 						]; 	#  "Iosevka"	"FiraCode" 	"DroidSansMono" 	"EnvyCodeR" "Mononoki" "ProFont"
 environment.xfce.excludePackages = [
            pkgs.xfce.mousepad 	    pkgs.xfce.parole
            pkgs.xfce.ristretto		pkgs.xfce.thunar 		];
			
environment.gnome.excludePackages = [
   			pkgs.gnome.gnome-backgrounds pkgs.gnome.gnome-characters
   			pkgs.gnome.geary  pkgs.gnome.gnome-music
   			pkgs.gnome-photos pkgs.gnome.nautilus
   			pkgs.gnome.totem  pkgs.gnome.yelp
   			pkgs.gnome.cheese     	 ];

  # for home-manager, use programs.bash.initExtra instead
   programs.thunar.enable = lib.mkForce false;
   programs.gnome-disks.enable = true;

#nixpkgs.config.allowBroken = true;
# # Enable OpenGL
 hardware.opengl = {
				     enable = true;
				     driSupport = true;
				     driSupport32Bit = true;
  					 };
  services.xserver.videoDrivers = [
				 "nvidia"
				   ];
# 
 hardware.nvidia = {
			    # # Modesetting is required.
			     modesetting.enable = true;
# 
			    # # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
			     powerManagement.enable = false;
			    # # Fine-grained power management. Turns off GPU when not in use.
			    # # Experimental and only works on modern Nvidia GPUs (Turing or newer).
			     powerManagement.finegrained = false;
# 
			    # # Use the NVidia open source kernel module (not to be confused with the
			    # # independent third-party "nouveau" open source driver).
			    # # Support is limited to the Turing and later architectures. Full list of
			    # # supported GPUs is at:
			    # # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
			    # # Only available from driver 515.43.04+
			    # # Currently alpha-quality/buggy, so false is currently the recommended setting.
			     open = false;
# 
			    # # Enable the Nvidia settings menu,
				# # accessible via `nvidia-settings`.
			     nvidiaSettings = true;
# 
				# # Update for NVIDA GPU headless mode
				# # It ensures all GPUs stay awake even during headless mode.
# 
				# nvidiaPersistenced = true;
			    # # Optionally, you may need to select the appropriate driver version for your specific GPU.
  			 };


services.gnome.games.enable = false;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
	  # Enable the OpenSSH daemon.
#  	 services.openssh.enable = true;
  	 # Enable the Flatpak
#	services.flatpak.enable = true;         


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  #
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
