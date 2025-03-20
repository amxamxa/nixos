{ config, pkgs, ... }:

{
  boot.loader = {
  # UEFI
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  # SYSTEMD-BOOT
   systemd-boot = { enable = false; };
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
    menuentry "lkrn-iso-netboot.xyz" {
          insmod fat
          insmod loopback
          insmod chain
          insmod iso9660  # Für ISO-Container
          insmod linux

          search --set=root --file /netboot/netboot.xyz.iso # ISO finden und Root-Device def.
        linux /netboot/netboot.xyz.lkrn
        
         }
    menuentry "iso-netboot.xyz" {
          insmod fat
          insmod loopback
          insmod chain
          insmod iso9660  # Für ISO-Container
          insmod linux

          search --set=root --file /netboot/netboot.xyz.iso # ISO finden und Root-Device def.
          loopback loop /netboot/netboot.xyz.iso # macht die ISO als virtuelles Laufwerk verfügbar
        
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
}
*/


	 
# LightDM Slick Greeter 
services.xserver.displayManager = {
  gdm.enable = false;
  lightdm.enable = true;
  # lightdm.greeters.tiny = {   enable = true;    #background = "/share/wallpaper/sonstige/blitz.png"; };
   lightdm.greeters.slick = {
     enable = true;
       theme = {
    name = "autoreiv";
    package = pkgs.dwarf-fortress-packages.themes.autoreiv;
           };
     iconTheme.package = pkgs.faba-mono-icons;
     iconTheme.name = "Faba-Mono-Dark";
     font.package = pkgs.meslo-lgs-nf;
     font.name = "MesloLGS NF 48";
    # draw-user-backgrounds= true; # steuert, ob Hintergrund des Nutzers auf Login-Bildschirm erscheint
     # tshoot:  /var/log/lightdm/lightdm.log
     extraConfig = ''
    # LightDM GTK+ Configuration file 
    # for /etc/lightdm/slick-greeter.conf        
    # stretch-background-across-monitors=true #?
 
        # Sets monitor on which is login; -1 means "follow the mouse"
        only-on-monitor=HDMI-1
        background=/etc/lightdm/lightDM-bg.png
        logo=/etc/lightdm/logo-aramgedon.png 
        other-monitors-logo=/etc/lightdm/logo-aramgedon.png 
    #   other-monitors-logo=/share/wallpaper/logo-Nihilisten.png
     #   background-color="#502962"  
        # show-power=false        # show-keyboard=false
        show-hostname=true  
        show-clock=true 
        show-quit=true 
        xft-hintstyle="hintmedium" # hintnone/hintslight/hintmedium/hintfull  
        
        enable-hidpi=auto # to enable HiDPI support (on/off/auto)   # xft-rgba=Type of subpixel antialiasing (none/rgb/bgr/vrgb/vbgr)  # xft-antialias=Whether to antialias Xft fonts (true or false) # xft-dpi=Resolution for Xft in dots per inch
        clock-format=" %d.%b.%g %H:%"
	 '';  };
   };



}
