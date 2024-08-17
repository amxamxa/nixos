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
      gfxmodeEfi = "auto"; #gfxmode to pass to GRUB when loading a graphical boot interface under EFI.
		gfxpayloadEfi = "keep"; # loading a graphical boot interface under EFI

  splashImage ="/boot/grub/grub-sw.png"; # background image used for GRUB. Set to null to run GRUB in text mode.
  	splashMode = "stretch"; # oder normal
  	font = "/boot/grub/fonts/neo.pf2"; # Path to a TrueType, OpenType, or pf2 font to be used by Grub.
  	fontSize = 16; # ...wird ignoriert, es sei denn, die Schriftart ist auf eine TTF- oder OTF-Schriftart eingestellt.
 	extraConfig = ''
 #  	set background_image="/path/to/your/image.png"
 set color_normal=green/white 
    #	set color_normal=#54fe54;
    	# black/light-yellow;
   '';

 #extraFiles = [ pkgs.grub-mkrescue ];
#     extraConfig = ''
#       set iso_path="/boot/grub/netboot.xyz.iso"
#       menuentry "netzboot.xyz" {
#         loopback loop $iso_path
#         linux (loop)/boot/vmlinuz-linux iso-scan/filename=$iso_path
#         initrd (loop)/boot/initramfs-linux.img
#       }
 #    '';
#	 ipxe = {
#	 	netbootxyz = ''	    
#	 		#!ipxe
#	 		dhcp
	# 		chain --autofree https://boot.netboot.xyz
#	 	 	chain --autofree http://boot.netboot.xyz
#	   		'';
#	   	  };
  }; #grub ende
  
  networking.hostName = "nixos-mxx"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #ssd
  fileSystems."/home/manix/share" =
   { device = "/dev/disk/by-uuid/6dd1854a-047e-4f08-9ca1-ca05c25d03af";
    fsType = "btrfs";  };
  # hdd
  fileSystems."/home/manix/videos" =
   { device = "/dev/disk/by-uuid/fa3cda61-29bf-4727-946e-4b8bffd0acf3";
     fsType = "ext4";  };
#ssd
  fileSystems."/home/manix/games" =
   { device = "/dev/disk/by-uuid/47fbde41-a7a9-4224-bd85-d9ca36299a90";
     fsType = "ext4";  };

# gdrive 
 # service für gdrive  rclone-Konfiguration
 # damit start systemctl beim start rclone
 # Pfad zur rclone-Konfigurationsdatei
#  # damit wird rclone beim start gemountet
# systemd.services.rclone-mount = {
#    enable= true;
#    description = "mount gdrive via rclone remote";
#    after = [ "network.target" ]; # Service nach dem Starten des Netzwerks gestartet werden soll.
#    wantedBy = [ "multi-user.target" ]; # Service beim Starten des Multi-User-Targets
#    serviceConfig = {
#       Type = "oneshot"; # Service nur einmal ausgeführt wird und dann beendet wird
# # Befehl, der beim Starten des Services ausgeführt wird
#      ExecStart = ''	
#     	${pkgs.rclone}/bin/rclone mount \
#     	--config $XDG_CONFIG_HOME/rclone/rclone.conf gdrive: $HOME/gdrive \
#      	--dir-cache-time 24h \
#         --vfs-cache-mode full \
#         --vfs-cache-max-age 48h \
#         --vfs-read-chunk-size 10M \
#         --vfs-read-chunk-size-limit 512M \
#         --buffer-size 512M
# 				'';
# Befehl, der beim Beenden des Services ausgeführt wird
	  #ExecStop = "/run/wrappers/bin/fusermount -u $HOME/gdrive";
      #RemainAfterExit = true; # gibt an, dass der Service als "aktiv" markiert bleibt, auch nachdem er beendet wurde
#Diese Option setzt die Umgebungsvariablen für den Service. In diesem Fall wird der Pfad für das FUSE-Modul und den Wrapper-Binärordner gesetzt.
     # Environment = [ "PATH=${pkgs.fuse}/bin:/run/wrappers/bin/:$PATH" ];
       #             };
        #      };

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
     inactiveOpacity = 0.985;
     shadow = true;
     fadeDelta = 2;
   };
  services.logind.extraConfig = ''
				HandlePowerKey = "poweroff";
				powerKeyLongPress = "reboot";
				'';
# Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "manix";
systemd.services."getty@tty1".enable = false;
systemd.services."autovt@tty1".enable = false;

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";  };
    
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

   # pipewire-media-session is no longer supported, switch to `services.pipewire.wireplumber`.
   # media-session.enable = true;
  };
   services.pipewire.wireplumber.enable = true; # enable Wireplumber, a modular session / policy manager for PipeWire

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
#	boot.extraModulePackages = [ pkgs.linuxPackages.nvidia_x11 ];
	boot.blacklistedKernelModules = [
	 "nouveau"  "nvidia_drm" 
	 "nvidia_modeset" "nvidia" ];
	 
 # boot.kernelParams = [ "modprobe.blacklist=nouveau" ];

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
  hardware.opengl = {
	enable = true;
       driSupport = true;
       driSupport32Bit = true;
                   };
# newer HW (>2014): intel-media-driver, older HW: intel-vaapi-drive
#	hardware.opengl.extraPackages = ["intel-vaapi-driver"];
#	hardware.opengl.extraPackages32 = [ "intel-vaapi-driver" ];

 # hardware.bumblebee.enable = true;
 # hardware.bumblebee.driver = "nvidia";  #"nvidia" or "nouveau"
 # hardware.bumblebee.pmMethod = "auto"; #Set preferred power management method >
                                                                            
 hardware.cpu.intel.updateMicrocode = true; # update the CPU microcode for Intel processors.

 hardware.enableAllFirmware = true; # enable all firmware regardless of license
    								
  #system.autoUpgrade.enable = true;
  #system.autoUpgrade.allowReboot = true;
  #nix.settings.auto-optimise-store = true;
  
# Allow unfree packages
	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.nvidia.acceptLicense = true;
# Allow InsecurePackages
nixpkgs.config.permittedInsecurePackages = [
                "electron-25.9.0"
              ];

 services.xserver.displayManager.sessionCommands = ''
  # test
  	xcowsay ... läuft &
  # set nemo as default
  	xfconf-query -c xfce4-session -p /sessions/Failsafe/Client0_Command -t string -s "nemo --no-desktop" &
	'';
              

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
    extraGroups = [ "networkmanager" "audio" ];
    packages = with pkgs; [
	boohu # new coffee-break roguelike game
    ];
  };
 users.users.manix = {
    isNormalUser = true;
    description = "manix";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
     # openssh.authorizedKeys.keys = [ "<alice's public key>" ]; # wenn du auch SSH-Zugriff konfigurieren möchtest

    packages = with pkgs; [
	pkgs.bsdgames  #Ports of all the games from NetBSD-current that are free
  	];
  };
security.sudo = {
  extraConfig = ''
	Defaults env_reset
    Defaults mail_badpass
	Defaults lecture_file = /etc/sudoers.lecture #  Legt eine benutzerdefinierte Sudo-Meldung fest.
	Defaults logfile = /var/log/sudo.log #  Speichert Sudo-Aktionen in  Logdatei
	Defaults secure_path = /nix/store:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin # Setzt den sicheren Pfad, in dem Sudo-Befehle ausgeführt werden.

    Defaults timestamp_timeout=50 # 50 min

	manix ALL=(ALL:ALL) NOPASSWD: /sbin/shutdown
    # alice ALL=(ALL) NOPASSWD: ALL
  '';
	};

programs.thefuck.enable = true;
programs.thefuck.alias = "F0";
# programs.starship.enable = true; programs.starship.settings programs.starship.interactiveOnly = true;	# whether to enable  whenis interactive. Some plugins require this to be set to false 
programs.command-not-found.enable = true;  # interactive shells should show which Nix package (if any) provides a missing command.
programs.gnome-disks.enable = true; # whether to enable GNOME Disks daemon
#environment.variables.EDITOR = "micro";

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
	nix-du
# VULANARABILITY:	nix-web
#	nix-plugins   	nix-top   	nix-template   	nix-tree
  	nix-info   	nix-diff 	nix-output-monitor 	nix-index  	
  	nix-query-tree-viewer
# 	nixos-background-info  	binutils-unwrapped-all-targets #Tools for manipulating binaries (linker, assembler, etc.)
# div tools
ntfs3g # FUSE-based NTFS driver with full write support
	curl wget openssl inetutils
	#colord-gtk4 # color themes terminal
	gnupg 
	unzip zip zlib
	unrar-wrapper
	
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
	btop 	tree

##################################

##		GUI internet tools
	timeshift 
	flatpak xdg-desktop-portal-xapp
	gnome.gnome-disk-utility gparted
	gnome-text-editor

	firefox
	vlc

	cinnamon.nemo 	cinnamon.nemo-emblems #change a folder or file emblem
	cinnamon.nemo-fileroller #  compress and extract functions of the FileRoller archive adds entries to the context menu in Nemo, 
	cinnamon.nemo-python 	 cinnamon.folder-color-switcher #Change folder colors for Nemo and Caja

	parcellite #GTK clipboard manager
#	GUI knowledge base	
	marker # markdown editor
	cherrytree #db note taking application
	obsidian # installiert über flatpak
	pandoc # Conversion html- markup formats
	
#------------------------------------
#		GUI Zubehör
#------------------------------------
## 		graphic
	evince #     gnome document viewer
	pdfarranger
	shotwell # hoto organizer for the GNOME desktop
	libpng  # lib für *.png
	libavif  # lib für *.avif
jpegoptim #Optimize JPEG files
jpeginfo # Prints information and tests integrity of JPEG/JFIF files	jpeg
webp-pixbuf-loader # WebP GDK Pixbuf Loader library
xmp # xmp - extended module player - plays obscure module formats
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
	git
	git-hub
	git-doc
	clipboard-jh # cb --help

logrotate
rclone # terminal sync files and directories to and from major cloud storage
rclone-browser # gui to Rclone written in Qt
# salt 	
openssl # e.g. pw hash
#wineWow64Packages.unstable #wine-wow64	
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
	neo-cowsay xcowsay fortune 	clolcat blahaj
	theme-sh #script which lets you set your $terminal theme
	duf ## color mounts Disk Usage/Free Utility

	btop inxi lsd eza
#	exa #'exa' has been removed because it is unmaintained
		#python311Packages.pip
	#####
	xfce.xfce4-terminal haskellPackages.hackertyper #hack" like a programmer in movies and games!

#	#fonts
	tt2020 	nerdfonts 	terminus-nerdfont
	powerline-fonts 	_3270font
	lalezar-fonts
# GPU
	linuxPackages.nvidia_x11
#intel-ocl
driversi686Linux.intel-vaapi-driver #VA-API user mode driver for Intel GEN Graphics family
	libva-utils #utilities and examples to exercise VA-API in accordance with the libva project.
	glxinfo #utilities for OpenGL
	glmark2 #glmark2 is a benchmark for OpenGL (ES) 2.0
#	xorg.xrandr	arandr # für xfce nicht nötig
#audio
ffmpeg_5-full
wireplumber # modular session / policy manager for PipeWire
xfce.xfce4-pulseaudio-plugin # adjust the audio volume of the PulseAudio sound system
pavucontrol # pulseAudio Volume Control
pipewire
# pwvucontrol # Pipewire Volume Control
helvum # GTK patchbay for pipewire

#gtk themes
	flat-remix-icon-theme #Flat remix is a pretty simple icon theme inspired on material design
#	papirus-icon-theme pop-icon-theme #	gnome.adwaita-icon-theme
	whitesur-gtk-theme #MacOS Big Sur like theme for Gnome desktops
#	mojave-gtk-theme #https://github.com/vinceliuice/Mojave-gtk-theme
# 	numix-icon-theme-circle  pop-gtk-theme
			];
	#---ENDE enviroment pkgs--------

# fonts.fontDir.enable = true;
# fonts.packages = with pkgs; [
        # cantarell-fonts         # dejavu_fonts
        # source-code-pro # Default monospace font in 3.32
        # source-sans        # unifont
   # #     hack   # #     Cirquee    # #    Chomsky
     # #   freemono     # #   GeneraleStation    # #    Keypunch029
   # #     Minecrafter     # #   NaziTypewriterRegular      # #  NeomatrixCode
   # #     RichEatin    # #    Semyon     # #   Warszawa        
   # tt2020       # # 3270font      # ];
# environment.xfce.excludePackages = [
#            pkgs.xfce.mousepad 
#            pkgs.xfce.ristretto		
#            pkgs.xfce.parole
#			pkgs.xfce.thunar 		
#				];
			
environment.gnome.excludePackages = [
   			pkgs.gnome.gnome-backgrounds
   			pkgs.gnome.geary  pkgs.gnome.gnome-music
   			pkgs.gnome-photos pkgs.gnome.nautilus
   			pkgs.gnome.totem  pkgs.gnome.yelp
   			pkgs.gnome.gnome-characters
   			pkgs.gnome.cheese     			 ];

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
## Enable the Flatpak
#	services.flatpak.enable = true;         
#	xdg.portal.enable = true;      # Enable xdg desktop integration.  https://github.com/flatpak/xdg-desktop-portal-gtk
 #	xdg.portal.extraPortals = [ xdg-desktop-portal-xapp ];
 	#xdg-desktop-portal-gtk 	# -> flatpak.github.io/xdg-desktop-portal/

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.  # networking.firewall.enable = false;
  #--------------
     						
services.logrotate.enable = true;
services.logrotate.configFile = pkgs.writeText "logrotate.conf" ''
			#			size 100k   	
				rotate 5
  				compress  		delaycompress
  				missingok  			'';
#--------------
 services.journald.extraConfig = ''
   				SystemMaxUse=256M	SystemMaxFiles=10
				Compress=yes		MaxFileSec=1week
	    		ForwardToSyslog=yes	ForwardToKMsg=yes 	'';	

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
