# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, lib,  ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
	#  ./wayland.nix
      ./gpu.nix
 	./zsh.nix
      ./packages.nix
      ./users.nix
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


   networking.hostName = "nixos"; # Define your hostname.
 
     # Enable networking
     networking.networkmanager.enable = true;
     networking.usePredictableInterfaceNames = false; # eth0 statt ensp0
     networking.networkmanager.appendNameservers = [
		# www.ccc.de/censorship/dns-howto
	    "5.9.164.112" # (digitalcourage, Informationsseite)
	    "204.152.184.76" # (f.6to4-servers.net, ISC, USA)
	    "2001:4f8:0:2::14" # (f.6to4-servers.net, IPv6, ISC)
	    "194.150.168.168" # (dns.as250.net; Berlin/Frankfurt) 
	         ];
  # networking.interfaces.enp4s0.useDHCP = true;
  # networking.interfaces.enp4s0.name = [ " eth0 " ];
  
  # Set your time zone.
   time.timeZone = "Europe/Berlin";
 # Configure keymap in X11
   services.xserver.xkb.layout = "de";
  services.xserver.xkb.options = "eurosign:e,caps:escape"; # oder "terminate:ctrl_alt_bksp"; # oder "grp:caps_toggle,grp_led:scroll";
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
   console = {
     font = "Lat2-Terminus16";
#     keyMap = mk.defaut "de";
     useXkbConfig = true; # use xkb.options in tty.
   };

 
  # Enable the X11 windowing system.
  	services.xserver.enable = true;
	programs.sway.enable = true;
  	xdg.portal.wlr.enable = true;
/* programs.sway.enable = true; #  launch Sway by executing “exec sway” on a TTY. Copy /etc/sway/config to ~/.config/sway/config to modify the default configuration. See https://github.com/swaywm/sway/wiki and “man 5 sway” for more information.
 
 programs.waybar.enable = true;
 programs.sway.extraSessionCommands = ''
  export SDL_VIDEODRIVER=wayland 
  # QT (needs qt5.qtwayland in systemPackages):
   export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
  # Fix for some Java AWT applications (e.g. Android Studio), use this if they aren't displayed properly:
  export _JAVA_AWT_WM_NONREPARENTING=1
'';
*/
# Enable the - d e s k t o p  m a n a g e r - Environment.
# -------------------------------------------
 services.displayManager.defaultSession = "cinnamon"; #xfce
# services.xserver.desktopManager.gnome.enable = true;
# services.xserver.desktopManager.pantheon.enable = true;
	services.xserver.desktopManager.cinnamon.enable = true;
# services.xserver.desktopManager.lxqt.enable = true;
# services.xserver.desktopManager.xfce.enable = true;
# set to true the wallpaper will stretch across all scr
# services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.gdm.enable = true;
 # services.xserver.displayManager.gnome.enable = true;
 

  # Enable CUPS to print documents.
  # services.printing.enable = true;

 #  	nix.settings.auto-optimise-store = true;

nix.settings.sandbox = true;
 #  nixpkgs.config.allowBroken = true;

   #  Allow InsecurePackages
   nixpkgs.config.permittedInsecurePackages = [   "electron-25.9.0"     ];


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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.logind.extraConfig = '' HandlePowerKey = "poweroff";
 		 		   HandlePowerKeyLongPress = "reboot"; '';
  
  

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
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
   system.copySystemConfiguration = true;

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

