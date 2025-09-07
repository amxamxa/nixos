{ config, pkgs, lib,  ... }:
let
  backgroundColor = "#7EBAE4";
in

{

  imports =
    [ # Include the results of the hardware scan.
      	./hardware-configuration.nix	
      	./adBloxx.nix # ehem. ./AdBloxx.nix
      	./audio.nix
      	./boot.nix # grub2 & lightDM
      	./docker.nix
      	./fonts.nix
    #   ./gpu-GV-N960.nix # nicht mehr drin
	./mouse-rog.nix
      	./packages.nix # env.pkgs
      	./python.nix # ehem.	./ld.nix
      	./users.nix
        #	./us-altgr-umlaut.nix  # Tastatur Konfig hier integriert
      	# ./firefox.nix # todo
      	./zsh.nix
    ];


fileSystems."/share" =
  { device = "/dev/disk/by-uuid/6dd1854a-047e-4f08-9ca1-ca05c25d03af";
    fsType = "btrfs";
  };
  
 hardware.cpu.intel.updateMicrocode = true; # update the CPU microcode for Intel processors.
 networking.hostName = "local"; # Define your hostname.
 # Enable networking
 networking.networkmanager.enable = true;
 networking.usePredictableInterfaceNames = false; # eth0 statt ensp0
 networking.nameservers = [
	# www.ccc.de/censorship/dns-howto
	    "5.9.164.112" # (digitalcourage, Informationsseite)
	    "204.152.184.76" # (f.6to4-servers.net, ISC, USA)
	    "2001:4f8:0:2::14" # (f.6to4-servers.net, IPv6, ISC)
	    "194.150.168.168" # (dns.as250.net; Berlin/Frankfurt) 
	         ];
 networking.networkmanager.appendNameservers = [
	# www.ccc.de/censorship/dns-howto
	    "5.9.164.112" # (digitalcourage, Informationsseite)
	    "204.152.184.76" # (f.6to4-servers.net, ISC, USA)
	    "2001:4f8:0:2::14" # (f.6to4-servers.net, IPv6, ISC)
	    "194.150.168.168" # (dns.as250.net; Berlin/Frankfurt) 
	         ];
  networking.networkmanager.dns = "default"; # default", "dnsmasq", "systemd-resolved", "none"
  # networking.interfaces.enp4s0.useDHCP = true;
  # networking.interfaces.enp4s0.name = [ "eth0" ];
  
    services.logind.extraConfig = '' 
    	HandlePowerKey = poweroff;
    	HandlePowerKeyLongPress = reboot; 
	'';	
  
  # Wipe /tmp on boot.
  boot.tmp.cleanOnBoot  = true;

  # Set your time zone.
   time.timeZone = "Europe/Berlin";
   
# Enable the - d e s k t o p  m a n a g e r - Environment. # slick-greeter; | lightdm-enso-os-greeter| lightdm-tiny-greeter 
  # Include LightDM configuration if necessary
# services.xserver.displayManager.lightdm.enable = true;
# services.xserver.displayManager.lightdm.greeters.slick.enable = true;
# -------------------------------------------

# LightDM Slick Greeter 
services.xserver.displayManager = {
  gdm.enable = false;
  lightdm.enable = true;
  # lightdm.greeters.tiny = {   enable = true;    #background = "/share/wallpaper/sonstige/blitz.png"; };
   lightdm.greeters.slick = {
     enable = true;
     theme = 	 { name = "andromeda"; package = pkgs.andromeda-gtk-theme; };
     iconTheme = { name = "Faba-Mono-Dark"; package = pkgs.faba-mono-icons; };
     font  = 	 { name = "MesloLGS NF 24"; package = pkgs.meslo-lgs-nf;	};
     draw-user-backgrounds= true; # steuert, ob Hintergrund des Nutzers auf Login-Bildschirm erscheint
     # tshoot:  /var/log/lightdm/lightdm.log
     extraConfig = ''
    # LightDM GTK+ Configuration file for /etc/lightdm/slick-greeter.conf        
        stretch-background-across-monitors=false # to stretch the background across multiple monitors
        only-on-monitor=HDMI-1  # Sets monitor on which is login; -1 means "follow the mouse"
        background=/etc/lightdm/lightDM-bg.png
# logo=/etc/lightdm/logo-aramgedon.png         other-monitors-logo=/etc/lightdm/logo-aramgedon.png          show-power=false        # show-keyboard=false         show-hostname=true        show-clock=true        show-quit=true # show the quit menu in the menubar 
        xft-hintstyle="hintmedium" # hintnone/hintslight/hintmedium/hintfull  
	clock-format=" %d.%b.%g %H:%" #  clock format to use (e.g., %H:%M or %l:%M %p)
# xft-antialias=Whether to antialias Xft fonts (true or false)  # xft-dpi=Resolution for Xft in dots per inch
# xft-rgba=Type of subpixel antialiasing (none/rgb/bgr/vrgb/vbgr)
	 '';  
	 };
   };

services.displayManager = {
	autoLogin.enable = true;
	autoLogin.user = "amxamxa";
	defaultSession = "cinnamon";	
	};    

 services.xserver.desktopManager = {
    cinnamon.enable 	= true;
    gnome.enable	= false;
    pantheon.enable 	= false;
    lxqt.enable		= false;
    xfce.enable		= false; 
    };
services.xserver.displayManager.startx.enable = true; # Whether to enable the dummy “startx” pseudo-display manager, which allows users to start X manually via the startx command from a virtual terminal.

services.xserver = {
    enable = true;	  # Enable the X11 windowing system. Die Reihenfolge ist wichtig, da das erste Layout standardmäßig verwendet wird.
     xkb.layout = "de";  
     xkb.variant = "";
     xkb.options = "lv3:ralt_switch"; # Option zum Umschalten der Layouts, # AltGr als Level-3-Taste (für Sonderzeichen)
  };
  
  services.xserver.exportConfiguration = true; # Makes it so the above mentioned xkb directory (and the xorg.conf file) gets exported to /etc/X11/xkb
 
services.xserver.displayManager.sessionCommands = ''xcowsay " \n "Hello World!" this is \n  	-- Greeting from GUI -- \n  	&& Hi Xamxama"'';

services.xserver.desktopManager.runXdgAutostartIfNone = true; # whether to run XDG autostart files for sessions without a desktop manager (with only a window manager), these sessions usually don’t handle XDG autostart files by defaul
 
 console.enable = true;
 console.font = "Lat2-Terminus16"; # Beispiel  # ls  $(nix-shell -p kbd --run "ls \$out/share/kbd/consolefonts/")
 console.useXkbConfig = true; # Makes it so the tty console has about the same layout as the one configured in the services.xserver options.
  console.keyMap = lib.mkForce "de"; # keyboard mapping table for the virtual consoles.

  i18n = {
    defaultLocale = "de_DE.UTF-8";
 #   extraLocales = [ "en_US.UTF-8" ];
    extraLocaleSettings = {
    	LC_NAME = 		  "de_DE.utf8";
        LC_TIME = 		  "de_DE.utf8";
        LC_PAPER = 		  "de_DE.utf8";
     	LC_ADDRESS =		  "de_DE.utf8";
	LC_MEASUREMENT = 	  "de_DE.utf8";
      	LC_MONETARY = 	 	  "de_DE.utf8";
       	LC_NUMERIC =              "de_DE.utf8";
	LC_TELEPHONE = 	 	  "de_DE.utf8";
	LC_IDENTIFICATION =	  "de_DE.utf8";
    };
  };
  # de_DE/ISO-8859-1  en_US.UTF-8/UTF-8 en_US/ISO-8859-1  de_DE.UTF-8/UTF-8 de_DE/ISO-8859-1 \de_DE@euro/ISO-8859-15 
  
  
# Enable CUPS to print documents.
  services.printing.enable = false;
# Enable touchpad support (enabled default in most desktopManager)
  services.libinput.enable = false;
  	  
  nix.settings.auto-optimise-store = true;
  nix.settings.sandbox = true;

# Enable the Flakes feature and the accompanying new nix command-line tool
# nixos.org/manual/nix/stable/contributing/experimental-features
 # "flakes"
 nix.settings.experimental-features = [ "nix-command" ];  
  # to install from unstable-channel, siehe packages.nix
  nixpkgs.config = { 
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
             "vivaldi"  
             "vagrant"  
             "memtest86-efi"
             "sublimetext" "obsidian" "typora"
             "decent-sampler"
           ];
    allowUnfree = false;
    
    packageOverrides = pkgs: {
     unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
    };
  };

  #  Allow InsecurePackages
 nixpkgs.config.permittedInsecurePackages = [ 
 	"openssl-1.1.1w" 	
 	"gradle-6.9.4" 
 	"electron-25.9.0" 	
 	# "dotnet-sdk-7.0.410"
 	# "dotnet-runtime-7.0.20"
 	];
                

# Some programs need SUID wrappers, can be configured further or are started in user sessions.
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
  networking.firewall.enable = false;
  
  # Firewall für Warpinator-Ports öffnen
  #networking.firewall = {
   #allowedTCPPorts = [ 42000 ]; # Standard-Port für Warpinator
   #allowedUDPPorts = [ 42000 ];  
   #};
   
services.gvfs.enable = true;

/*
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
 #xdg-desktop-portal-gtk 	# -> flatpak.github.io/xdg-desktop-portal/
# Flatpak Ende     						
*/


# Avahi für Netzwerk-Discovery aktivieren
  services.avahi = {
    enable = true;
    nssmdns4 = true;           # mDNS-Unterstützung
    publish = {
      enable = true;
      addresses = true;       # IP-Adresse veröffentlichen
      userServices = true;    # Nutzerdienste sichtbar machen
    };
  };

    programs.xwayland.enable = true;            # Aktiviere XWayland
    # programs.sway.enable = true;
    programs.thunar.enable = lib.mkForce false;  # Deaktiviere Thunar
    programs.traceroute.enable = true;          # Aktiviere Traceroute
    programs.file-roller.enable = true;         # Aktiviere File Roller
    programs.gnome-disks.enable = true;         # Aktiviere GNOME Disks
    programs.git = {
      enable = true;
      prompt.enable = true;            # Git-Prompt aktivieren
    };
    
 services.postgresql.enable = true;
 services.vnstat.enable = true; # Aktivieren `vnstat`-Dienst für "Console-based network statistics"
 services.playerctld.enable = true;   # enable the playerctld daemon.
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
 
 # Enable NixOS-specific documentation, including the NixOS manual
  documentation.nixos.enable = true;
  # Enable system-wide man pages. This uses man-db by default.
  documentation.man.enable = true;
  # Crucially, enable the generation of the 'whatis' database cache.
  # This is required for search functionality like 'man -k' and our fzf widget.
  documentation.man.generateCaches = true;
  documentation.man.man-db.enable = true;
  
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you accidentally delete configuration.nix.
   system.copySystemConfiguration = true;

# xdg.portal.wlr.enable = true;  # Whether to enable desktop portal for wlroots-based desktops SWAY, HYPRLAND, .... This will add the xdg-desktop-portal-wlr package into the xdg.portal.extraPortals option, and provide the configuration file .

/* programs.sway.enable = true; #  launch Sway by executing “exec sway” on a TTY. Copy /etc/sway/config to ~/.config/sway/config to modify the default configuration. See https://github.com/swaywm/sway/wiki and “man 5 sway” for more information.
  programs.waybar.enable = true;
 programs.sway.extraSessionCommands = ''
  export SDL_VIDEODRIVER=wayland 
  # QT (needs qt5.qtwayland in systemPackages):
   export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
  # Fix for some Java AWT applications (e.g. Android Studio), use this if they aren't displayed properly:
  export _JAVA_AWT_WM_NONREPARENTING=1
'';  */
 
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration, 
  system.stateVersion = "24.05"; # Did you read the comment?

}

