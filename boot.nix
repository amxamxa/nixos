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
      fontSize = 14;
      gfxmodeEfi = "1920x1080";
#      extraConfig = '' set timeout_style=hidden '';
extraEntriesBeforeNixOS = true;
configurationLimit = 77;
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
# ISO-Datei bereitstellen 
/*  environment.etc."netboot.xyz.iso" = {
    source = pkgs.fetchurl {
      url = "https://github.com/netbootxyz/netboot.xyz/releases/download/2.0.72/netboot.xyz.iso";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Aktuelle Hash eintragen!
    };
    target = "var/lib/netboot/netboot.xyz.iso";
  };
} */
}

