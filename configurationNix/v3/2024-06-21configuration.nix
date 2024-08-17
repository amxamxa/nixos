## ╔═╗╦╦  ╔═╗ ############################
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
## COMMENTS: no:
###########################################
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# 
 { config, pkgs, lib, ... }:

 {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

   #  ┐ ┌─┐┌─┐┌┬┐┬  ┌─┐┌─┐┌┬┌─┐┬─┐
   # ├┴┐│ ││ │ │ │  │ │├─┤ ││├┤ ├┬┘
   # └─┘└─┘└─┘ ┴ ┴─┘└─┘┴ ┴─┴┘└─┘┴└─
   ####################### (U)EFI Bootloader.
   
   ## (U)EFI bootloader
   boot.loader.efi = {
   	canTouchEfiVariables = true;
   	efiSysMountPoint  =  "/boot";
   				};
      ## SYSTEMD-BOOT bootloader
   	boot.loader.systemd-boot.enable = false;
   ## GRUB2 bootloader
     boot.loader.grub = {
     	enable = true;
       efiSupport = true;
       configurationLimit = 25;
      #boot.loader.grub.theme ="/boot/grub/themes/dark-matter/theme.txt";
      	memtest86.enable = true;
   #  	fsIdentifier = "label";
     	devices = [ "nodev" ];
     	useOSProber = true;
     	default = "saved"; #ndex of the default menu item to be booted. Can also be set to “saved”, which will make GRUB select the menu item that was used at the last boot.
     #backgroundColor  = "#7EBAE4"; # background color to be used to fill the areas the image isn’t filling.
     # Konfigurieren des Hintergrundbildes
     gfxmodeEfi = "1024x768"; # "auto"; #gfxmode loading a graphical boot interface under EFI.
   	 gfxpayloadEfi = "keep"; # loading a graphical boot interface under EFI
     splashImage = "/boot/grub/color-lila.png"; # background image used for GRUB. Set to null to run GRUB in text mode.
     splashMode = "normal"; # "stretch" oder normal
     font = "/boot/grub/fonts/nr.pf2"; # Path to a TrueType, OpenType, or pf2 font to be used by Grub.
     fontSize = 36; # ...wird ignoriert, es sei denn, die Schriftart ist auf eine TTF- oder OTF-Schriftart eingestellt.
    extraConfig = ''
    	# set color_normal = green/grey
     	# set background_image = "/boot/grub/grub-sw.png"
      				'';
   	 ipxe = 		{
   	 	netbootxyz = ''	    
   	 		#!ipxe
   	 		dhcp
   	 	 	chain --autofree http://boot.netboot.xyz
   	   		'';	   	  };
     
	subEntryOptions = "Sub-Entry-Feld: Juni 2024";
   	configurationName = "conf-name: mmxxx";
   	extraEntriesBeforeNixOS = false;
 }; #grub ende

       networking.hostName = "nixos-mxx"; # Define your hostname.
     # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
   /* ssd  */     fileSystems."/home/manix/share" =
      { device = "/dev/disk/by-uuid/6dd1854a-047e-4f08-9ca1-ca05c25d03af"; fsType = "btrfs";  };
   /* hdd */
     fileSystems."/home/manix/videos" =
      { device = "/dev/disk/by-uuid/fa3cda61-29bf-4727-946e-4b8bffd0acf3"; fsType = "ext4";  };
   /*ssd */
     fileSystems."/home/manix/games" =
      { device = "/dev/disk/by-uuid/47fbde41-a7a9-4224-bd85-d9ca36299a90"; fsType = "ext4";  };
  # GDRIvE # service für gdrive rclone-Konfiguration# damit start systemctl beim start rclone
    # Pfad zur rclone-Konfigurationsdatei, damit wird rclone beim start gemountet
    systemd.services.rclone-mount = {
       enable= true;
       description = "mount gdrive via rclone remote";
       after = [ "network.target" ]; # Service nach dem Starten des Netzwerks gestartet werden soll.
       wantedBy = [ "multi-user.target" ]; # Service beim Starten des Multi-User-Targets
       serviceConfig = {
          Type = "oneshot"; # Service nur einmal ausgeführt wird und dann beendet wird
    # Befehl, der beim Starten des Services ausgeführt wird
         ExecStart = ''	
        	${pkgs.rclone}/bin/rclone mount \
        	--config=$XDG_CONFIG_HOME/rclone/rclone.conf gdrive: $HOME/gdrive \
         	--dir-cache-time 24h \
            --vfs-cache-mode full \
            --vfs-cache-max-age 48h \
            --vfs-read-chunk-size 10M \
            --vfs-read-chunk-size-limit 512M \
            --buffer-size 512M
    				'';
   # Befehl, der beim Beenden des Services ausgeführt wird
   	  ExecStop = "/run/wrappers/bin/fusermount -u $HOME/gdrive";
         RemainAfterExit = true; # gibt an, dass der Service als "aktiv" markiert bleibt, auch nachdem er beendet wurde
   #Diese Option setzt die Umgebungsvariablen für den Service. In diesem Fall wird der Pfad für das FUSE-Modul und den Wrapper-Binärordner gesetzt.
         Environment = [ "PATH=${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH" ];
                     };
              };
   
     # Enable networking
     networking.networkmanager.enable = true;
     networking.usePredictableInterfaceNames = false; # eth0 statt ensp0
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
   #services.xserver.displayManager.defaultSession = "gnome-xorg";
   
    # Enable the XFCE Desktop Environment.
    services.xserver.desktopManager ={
   	xfce.enable = true;
    	gnome.enable = false;
   # set to true the wallpaper will stretch across all screens:
   	wallpaper.combineScreens= true;
    								};
   # service for xfce display magmt
   services.picom = { 
        enable = true;
        fade = true;
        inactiveOpacity = 0.95;
        shadow = true;
        fadeDelta = 4;
         opacityRules = [ # NO OPACITY for firefox, kitty, obsidian, cherrytree
	   	    "100:class_g = 'firefox' && _NET_WM_STATE@:32a"   # firefox  mit Fokus
	   	    "95:class_g = 'firefox' && ! _NET_WM_STATE@:32a" #  ohne Fokus
	   	    "100:class_g = 'kitty' && _NET_WM_STATE@:32a"   	# kitty mit Fokus
	   	    "90:class_g = 'kitty' && ! _NET_WM_STATE@:32a"   	#      ohne Fokus   
	   	    "100:class_g = 'obsidian'"
	   	    "100:class_g = 'cherrytree'" 
	   	    "100:class_g = 'nemo' && _NET_WM_STATE@:32a"   # nemo  mit Fokus
	   	    "80:class_g = 'nemo' && ! _NET_WM_STATE@:32a"   #   ohne Fokus
   	    ];   };
     
   # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "manix";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.logind.extraConfig = ''
    			HandlePowerKey = "poweroff";
    		 	HandlePowerKeyLongPress = "reboot";	'';
   
     # Configure keymap in X11
     services.xserver = {
       layout = "de";
       xkbVariant = "";
     };
     # Configure console keymap
     console.keyMap = "de";
     # Enable CUPS to print documents.
     services.printing.enable = false;
     services.tumbler.enable = true; # enable Tumbler, A D-Bus thumbnailer service.
   
    # Enable sound with pipewire.
     sound.enable = true;
     hardware.pulseaudio.enable = false; # pipewire ist altenative zu pulseaudio
     security.rtkit.enable = true; #ealtimeKit system service, which hands out realtime scheduling priority to user processes on demand
     services.pipewire = {
       enable = true;
       alsa.enable = true;
       alsa.support32Bit = true;
       # If you want to use JACK applications, uncomment this
       #jack.enable = true;
       wireplumber.enable = true; # a modular session / policy manager for PipeWire   # pipewire-media-session is no longer supported, switch to `services.pipewire.wireplumber`.
     };
   system.copySystemConfiguration = true;  #copies the NixOS configuration 
   # file and links it from the resulting system (getting to 
   # /run/current-system/configuration.nix).
      #-----------------------------------
   #        ██████╗ ██████╗ ██╗   ██╗
   #       ██╔════╝ ██╔══██╗██║   ██║
   #       ██║  ███╗██████╔╝██║   ██║
   #       ██║   ██║██╔═══╝ ██║   ██║
   #       ╚██████╔╝██║     ╚██████╔╝
   #        ╚═════╝ ╚═╝      ╚═════╝ 
   #---ansi shadow-----------------------
   	boot.extraModulePackages = [ pkgs.linuxPackages.nvidia_x11 ];
   	boot.blacklistedKernelModules = [
   	 "nouveau"  "nvidia_drm" "nvidia_modeset" "nvidia" ];
   	boot.kernelParams = [ "modprobe.blacklist=nouveau" ];
   	services.xserver.videoDrivers = [  "nvidia" ];  # [ "modesetting" ];   "nouvea>
     hardware.nvidia = {
     # modesetting when using the NVIDIA proprietary driver.
           modesetting.enable = false;
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
   hardware.opengl = {
    	enable = true;
          driSupport = true;
          driSupport32Bit = true;
          extraPackages = with pkgs; [ 
          	intel-media-driver  libvdpau-va-gl ];   /* Treiber HW-beschleunigung von Medienfunktione */ 
          extraPackages32 = with pkgs.pkgsi686Linux; [libvdpau-va-gl ];
                              };
    #hardware.bumblebee.enable = true;
   #  hardware.bumblebee.driver = "nvidia";  #"nvidia" or "nouveau"
   #  hardware.bumblebee.pmMethod = "auto"; #Set preferred power management method >
                                                                               
    hardware.cpu.intel.updateMicrocode = true; # update the CPU microcode for Intel processors.
    hardware.enableAllFirmware = true; # enable all firmware regardless of license								
     system.autoUpgrade.enable = true;
     #system.autoUpgrade.allowReboot = true;
     nix.settings.auto-optimise-store = true;
   # Allow unfree packages
   	nixpkgs.config.allowUnfree = true;
   	nixpkgs.config.nvidia.acceptLicense = true;
   # Allow InsecurePackages
   nixpkgs.config.permittedInsecurePackages = [         "electron-25.9.0"     ];
   
   # Enable the Flakes feature and the accompanying new nix command-line tool
   # https://nixos.org/manual/nix/stable/contributing/experimental-features
   nix.settings.experimental-features = [ 
   						"nix-command" 
   #						"flakes"
   #						"auto-allocate-uids"		
  						];
   
     # Define a user account. Don't forget to set a password with ‘passwd’.
     users.users.xyz = {
       isNormalUser = true;
       description = "xyz";
       extraGroups = [ "networkmanager" "audio" ];
       packages = with pkgs; [
   	boohu # new coffee-break roguelike game
       	];
     };
    users.users.manix = {
       isNormalUser = true;
       description = "manix";
       extraGroups = [ "networkmanager" "wheel" "audio" "firefox" ];
        # openssh.authorizedKeys.keys = [ "<alice's public key>" ]; # wenn du auch SSH-Zugriff konfigurieren möchtest
       packages = with pkgs; [
   	pkgs.bsdgames  #Ports of all the games from NetBSD-current that are free
     	];
     };
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
        environment.sessionVariables =  {
            XDG_CACHE_HOME  = "$HOME/.cache";
            XDG_CONFIG_HOME = "$HOME/.config";
            XDG_DATA_HOME   = "$HOME/.local/share";
            XDG_STATE_HOME  = "$HOME/.local/state";
            		ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
            	 XAUTHORITY = "$XDG_CONFIG_HOME/Xauthority";
            	 GIT_CONFIG = "$XDG_CONFIG_HOME/git/config";
        	       WWW_HOME = "$XDG_CONFIG_HOME/w3m";       # w3m config path
	 KITTY_CONFIG_DIRECTORY = "$XDG_CONFIG_HOME/kitty";  	# kitty, nur PATH angeben:
                      }; 
   #--------------------------------------------
   # ┌─┐┬ ┬┌─┐┌┬┐┌─┐┌┬┐╔═╗┌─┐┌─┐┬┌─┌─┐┌─┐┌─┐┌─┐
   # └─┐└┬┘└─┐ │ ├┤ │││╠═╝├─┤│  ├┴┐├─┤│ ┬├┤ └─┐
   # └─┘ ┴ └─┘ ┴ └─┘┴ ┴╩  ┴ ┴└─┘┴ ┴┴ ┴└─┘└─┘└─┘
   #--------------------------------------------
   environment.systemPackages = with pkgs; [
   # EFI boot tools 	############################
   	grub2 	nixos-grub2-theme
   	memtest86-efi
   	efibootmgr 	os-prober
   #	refind
   # nix	############################
   	nix-du #Find which gc-roots take disk space in a nix store
   	nix-index  #Quickly locate nix packages with specific files
   # VULANARABILITY:	nix-web
   #	nix-plugins   	nix-top   	nix-template   	
   nix-tree # Interactively browse a Nix store paths dependencies
   #  	nix-info   	nix-diff 	
   nix-output-monitor 	 	#Processes output of Nix commands to show helpful and pretty information
     	nix-query-tree-viewer #GTK viewer for the output of `nix store --query --tree`
   	nix-prefetch-scripts # find nötinge Paramet für nix-build,
   	# siehe github.com/seppeljordan/nix-prefetch-github
   	# nix-prefetch-github-latest-release NAME
   # div tools
   	ntfs3g # FUSE-based NTFS driver with full write support
   	curl wget openssl inetutils
   	#colord-gtk4 # color themes terminal
   	gnupg unzip zip zlib unrar-wrapper
   #	stdenvNoCC
   nodePackages_latest.nodejs
   python3
    youtube-dl
   gnustep.stdenv
   xdg-desktop-portal-xapp
   	# unrar #unfree 
   	file # specifies that a series of tests are performed on the file
   	bat
   	#colorz # color scheme generator
   	gcolor2 	graphviz
   	xclip #access the X clipboard from a console application
   	#xsel #getting and setting the contents of the X selection
   	pciutils # inspecting and manipulating configuration of PCI devices: lspci setpci
   	coreutils # the core utilities which are expected to exist on every OS
   	usbutils # tools for working with USB device
   	lshw # provide detailed information on the hardware configuration of the machine
   	lm_sensors # tools for reading hardware sensors, fans
   	logrotate # rotates and compresses system logs
   	btop 	tree 	inxi
      #------------------------------------
   #GNOME
   	gnome.gnome-disk-utility 	gnome-text-editor	 gnome.gnome-logs
   	cinnamon.nemo 	cinnamon.nemo-emblems #change a folder or file emblem
   	cinnamon.nemo-fileroller #  compress and extract functions of the FileRoller archive adds entries to the context menu in Nemo, 
   	cinnamon.nemo-python 	 cinnamon.folder-color-switcher #Change folder colors for Nemo and Caja
      	### 		xfce tools
   	xfce.xfce4-panel   xfce.xfce4-session # panel u session manager for Xfce   "Iosevka"
    xfce.xfce4-notifyd xfce.xfce4-settings    	xfce.xfwm4 		xfce.exo # Application library for Xfce
 	xfce.catfish       		xfce.gigolo    		xfce.orage    	xfce.xfburn
    xfce.xfce4-appfinder 	xfce.xfce4-taskmanager
    xfce.xfdashboard 		xfce.libxfce4ui #      Widgets library for Xfce
# ----
   	xfce.xfce4-cpugraph-plugin 		xfce.xfce4-fsguard-plugin # monitors the free space on your filesystems
   	xfce.xfce4-clipman-plugin		xfce.xfce4-genmon-plugin # display various types of information, such as system stats, weathe
   	xfce.xfce4-notes-plugin 		xfce.xfce4-netload-plugin #    xfce.xfce4-xkb-plugin # bildschirmschoner
   
 	#parcellite #GTK clipboard manager
 	xfce.xfce4-systemload-plugin   xfce.xfce4-whiskermenu-plugin     
 	xfce.xfce4-weather-plugin

    elementary-xfce-icon-theme xfce.xfce4-icon-theme
    xcolor #      xdo#      xdotool
      xorg.xev      #xsel     # xtitle    #  xwinmosaic  
    #  foliate    #      gimp-with-plugins#      inkscape-with-extensions
  	#### -------------------------------
	### 		CLI tools
	### 	---------------------------
	starship # customizable prompt for any shell
	kitty
	zsh zsh-autosuggestions zsh-autocomplete 
	zsh-syntax-highlighting zsh-completions
#	zsh-history 	# zsh-edit #powerful extensions to the Zsh command line editor#	zsh-you-should-use #plugin that reminds you to use existing aliases for commands #	zsh-command-time #utput time: xx after long commands
	zsh-fzf-tab #Replace zsh's default completion selection menu with fzf!

# salt 	
python312Packages.pygments #https://pygments.org/

	xfce.xfce4-terminal 
#  foliate     #ebook reader
    	xcolor       xdo      xdotool xorg.xdpyinfo # Informationen über einen X-Server anzeigt
 drawing 
    ###	    ---------------------------
    ### 	###  DEV /	CLI tools   ###
    ### 	---------------------------
#    qemu 		# generic and open source machine emulator and virtualizer
 #   qtemu 		# Qt-based front-end for QEMU emulator
  #  OVMF 		# UEFI firmware for QEMU and KVMand virtualizer
    unipicker # search tool for unicode
    stdenvNoCC
    gcc
    rustup cargo # rust dev env 
    libgcc # GNU Compiler Collection
    nodePackages_latest.nodejs
    python3
    gnustep.stdenv
    
    kitty # starship # customizable prompt for any shell
    zsh-powerlevel10k  zoxide   thefuck # app which corrects your previous console command
    zsh zsh-autosuggestions zsh-autocomplete 
   	zsh-syntax-highlighting zsh-completions
   #	zsh-history 	# zsh-edit #powerful extensions to the Zsh command line editor#	zsh-you-should-use #plugin that reminds you to use existing aliases for commands #	zsh-command-time #utput time: xx after long commands
   	zsh-fzf-tab #Replace zsh's default completion selection menu with fzf!
   	#zsh-autoenv #Automatically sources whitelisted .autoenv.zsh files
   	zsh-nix-shell #to use zsh in nix-shell shell
   	nix-zsh-completions
    #	zsh-git-prompt
   	fff #Fucking Fast File-Manager
   	fzf 	fzf-zsh #	fzf-git-sh
   	zsh-forgit # utility tool powered by fzf for using git interactively
   	git 	git-hub		git-doc
   	rclone 	rclone-browser # terminal sync files and directories to and from major cloud storage gui to Rclone written in Qt
    # salt 	ru
   	openssl # e.g. pw hash
    #wineWow64Packages.unstable #wine-wow64	
   	shellspec #full-featured BDD unit testing framework for bash, ksh, zsh, dash and all POSIX shells
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
    #libgtkflow4 # Flow graph widget for GTK 4
##		GUI internet tools
	timeshift  deja-dup # backup
	 gparted
	#flatpak 
	 flatpak     xdg-desktop-portal     xdg-desktop-portal-gtk xdg-desktop-portal-xapp

    #	GUI OFFICE
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

### FONTS
	tt2020 	nerdfonts 
	# powerline-fonts 	_3270font	lalezar-fonts
# GPU
	linuxPackages.nvidia_x11
 	intel-media-driver  driversi686Linux.intel-vaapi-driver #VA-API user mode driver for Intel GEN Graphics family
 	libvdpau-va-gl driversi686Linux.libvdpau-va-gl intel-ocl
bumblebee # daemon for managing Optimus videocards (power-on/off, spawns xservers)

libva	libva-utils #utilities and examples to exercise VA-API in accordance with the libva project.
	glxinfo #utilities for OpenGL
	glmark2 #glmark2 is a benchmark for OpenGL (ES) 2.0
		clinfo 		# print all known information about all available OpenCL platforms and devices in the system	
    	bumblebee # daemon for managing Optimus videocards (power-on/off, spawns xservers)
    	mangohud # OpenGL overlay for monitoring FPS, temperatures, CPU/GPU
    	xorg.xrandr	arandr # für xfce nicht nötig	#	
xorg.xdpyinfo #Informationen über einen X-Server anzeigt
#audio 
	ardour 		# audio recording software
	zam-plugins		x42-plugins	# vst
	losslesscut-bin # swiss army knife of lossless video/audio editing
	ffmpeg_5-full 	wireplumber # modular session / policy manager for PipeWire
	pipewire # d.h. auch kein  pulseaudio
	easyeffects # audio effects for PipeWire application
 	pwvucontrol # Pipewire Volume Control
	helvum # GTK patchbay for pipewire
# 	espeakup espeak-classic
#gtk themes
material-black-colors # GTK, xfwm4, openbox-3, GNOME-Shell Themes, and Cinnamon themes
	flat-remix-icon-theme #Flat remix is a pretty simple icon theme inspired on material design
#	papirus-icon-theme pop-icon-theme #	gnome.adwaita-icon-theme
	whitesur-gtk-theme #MacOS Big Sur like theme for Gnome desktops
#	mojave-gtk-theme #https://github.com/vinceliuice/Mojave-gtk-theme
# 	numix-icon-theme-circle  pop-gtk-theme

	]; 	#---ENDE enviroment pkgs--------

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
############################# 
# ┌─┐┌─┐┬ ┬  ┌─┐┌─┐┌┐┌┌─┐┬┌─┐
# ┌─┘└─┐├─┤  │  │ ││││├┤ ││ ┬
# └─┘└─┘┴ ┴  └─┘└─┘┘└┘└  ┴└─┘
############################# ZSH
programs.starship = { enable = false;    /* settings = starshipConfig;*/  interactiveOnly = true;      };
#jetpack.toml   # settings = pkgs.lib.importTOML $XDG_CONFIG_HOME/starship/nerd-font-symbols.toml;  #   programs.starship.settings  = pkgs.lib.importTOML $XDG_CONFIG_HOME/starship/starship-bracketed.toml #    programs.starship.settings  = pkgs.lib.importTOML $XDG_CONFIG_HOME/starship/starship-groovebox.toml #    programs.starship.settings  = pkgs.lib.importTOML $XDG_CONFIG_HOME/starship/starship.toml #    
#programs.starship.settings  = pkgs.lib.importTOML $XDG_CONFIG_HOME/starship/tokyo-night.toml

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
		source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh '';        
		promptInit = ''
source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/internal/p10k.zsh
					'';
#	  	  shellAliases = "$ZDOTDIR/aliases.zsh";
		  histSize = 10000;
		  histFile = "$ZDOTDIR/zhistory.zsh";
		 # histFile = "$HOME/zsh/zhistory.zsh";

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

  # networking.firewall.allowedTCPPorts = [ ... ];  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.  # networking.firewall.enable = false;
##################################################                     
#	                       (_)                
#	  ___  ____  ____ _   _ _  ____ ____  ___ 
#	 /___)/ _  )/ ___) | | | |/ ___) _  )/___)
#	|___ ( (/ /| |    \ V /| ( (__( (/ /|___ |
#	(___/ \____)_|     \_/ |_|\____)____|___/ 
###################################################		                 

# List services that you want to enable:				
	services.gnome.games.enable = false;
  # services.gnome.evolution-data-server.enable = false;
	services.gnome.gnome-initial-setup.enable = false;

# Enable the OpenSSH daemon.
#	services.openssh.enable = true;

# Enable the Flatpak
  services.flatpak.enable = true;         
  # Enable xdg-desktop-portal for better integration with Flatpak
  xdg.portal = {
    enable = true;
    extraPortals = [
      	pkgs.xdg-desktop-portal-gtk  # integrasion for sandbox app, Ensures GTK support for XFCE, xdg-desktop-port
    	pkgs.xdg-desktop-portal-xapp # integration for XFCE, ..
    ];
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.  # networking.firewall.enable = false;
  #--------------
     						
services.logrotate.enable = true;
services.logrotate.configFile = pkgs.writeText "logrotate.conf" ''
				weekly
				rotate 4
				create
				dateext
				compress
				missingok
				notifempty
				'';
#--------------
 services.journald.extraConfig = ''
   				SystemMaxUse=256M	
   				SystemMaxFiles=10
				Compress=yes		
				MaxFileSec=1week
	    		ForwardToSyslog=yes	
	    		ForwardToKMsg=yes 	
	    		'';	

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

