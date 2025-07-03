{ config, pkgs, ... }:

{
  boot.loader = {
  # UEFI
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  # SYSTEMD-BOOT
 #  systemd-boot = { enable = true; };
   
  # GRUB2
    grub = {
      enable = true;
      efiSupport = true;
      memtest86.enable = true;
      fsIdentifier = "label";
      devices = [ "nodev" ];
      useOSProber = true;
      splashImage = "/share/background.png";
      backgroundColor = "#7EBAE4";
      fontSize = 24;
      gfxmodeEfi = "1920x1080";
#      extraConfig = '' set timeout_style=hidden '';
      extraEntries = ''
     menuentry "netboot.xyz (EFI Boot)" {
        insmod fat
        search --set=root --file /netboot/netboot.xyz.efi
        chainloader /netboot/netboot.xyz.efi
    }
 
         
        menuentry "Reboot" { reboot }  
	menuentry "Poweroff" { halt }
      '';
    }; 
    
  };


# ISO-Datei bereitstellen (optional per Download)
/*  environment.etc."netboot.xyz.iso" = {
    source = pkgs.fetchurl {
      url = "https://github.com/netbootxyz/netboot.xyz/releases/download/2.0.72/netboot.xyz.iso";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Aktuelle Hash eintragen!
    };
    target = "var/lib/netboot/netboot.xyz.iso";
  };
} */

# LightDM Slick Greeter 
services.xserver.displayManager = {
  gdm.enable = false;
  lightdm.enable = true;
  # lightdm.greeters.tiny = {   enable = true;    #background = "/share/wallpaper/sonstige/blitz.png"; };
     #environment.etc."lightdm/lightDM-bg.png".source = ./path/to/your/image.png; #environment.etc."lightdm/logo-aramgedon.png".source = ./path/to/your/logo.png;
   lightdm.greeters.slick = {
       enable = true;
       theme = {
   		# name = "autoreiv";    		 package = pkgs.dwarf-fortress-packages.themes.autoreiv;  
   		name = "andromeda";
   		package = pkgs.andromeda-gtk-theme;
   		};
     iconTheme = {
		name = "Faba-Mono-Dark"; 
		package = pkgs.faba-mono-icons;
		};
     font  = {
     		name = "MesloLGS NF 24";
     		package = pkgs.meslo-lgs-nf;
     		};
    # draw-user-backgrounds= true; # steuert, ob Hintergrund des Nutzers auf Login-Bildschirm erscheint
     # tshoot:  /var/log/lightdm/lightdm.log
     extraConfig = ''
    # LightDM GTK+ Configuration file 
    # for /etc/lightdm/slick-greeter.conf        
        stretch-background-across-monitors=false # to stretch the background across multiple monitors (false by default) 
        only-on-monitor=HDMI-1  # Sets monitor on which is login; -1 means "follow the mouse"
        background-color="#502962"  # load before pic
        background=/etc/lightdm/lightDM-bg.png
        logo=/etc/lightdm/logo-aramgedon.png 
        other-monitors-logo=/etc/lightdm/logo-aramgedon.png 
        # show-power=false        # show-keyboard=false
        show-hostname=true  
        show-clock=true 
        show-quit=true # show the quit menu in the menubar 
        xft-hintstyle="hintmedium" # hintnone/hintslight/hintmedium/hintfull  
 clock-format=" %d.%b.%g %H:%" #  clock format to use (e.g., %H:%M or %l:%M %p)
        
        # xft-antialias=Whether to antialias Xft fonts (true or false)  # xft-dpi=Resolution for Xft in dots per inch
	# xft-rgba=Type of subpixel antialiasing (none/rgb/bgr/vrgb/vbgr)
	 '';  
	 };
   };


}

