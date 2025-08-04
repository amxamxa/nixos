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
    configurationLimit = 77;
      fontSize = 14;
      gfxmodeEfi = "1920x1080";
      extraConfig = '' set timeout_style=hidden '';
      extraEntriesBeforeNixOS = false;
      extraEntries = ''
         menuentry "Netboot.xyz (UEFI)" {
         insmod part_gpt
         insmod fat
         search --no-floppy --fs-uuid ED08-2B0B --set=root
         chainloader ($root)/netboot/netboot.xyz.efi
         }
       
        menuentry "Reboot" { reboot }  
	menuentry "Poweroff" { halt }
      '';
    }; 
  };
      /*
      ''
  menuentry "Windows 7" {  # GRUB 2 example
    chainloader (hd0,4)+1
  }
  menuentry "Fedora" {   # GRUB 2 with UEFI example, chainloading another distro
    set root=(hd1,1)
    chainloader /efi/fedora/grubx64.efi       
  }
''
*/
    
# ISO-Datei bereitstellen 
/*
environment.etc."netboot.xyz.iso" = {
    source = pkgs.fetchurl {
      url = "https://github.com/netbootxyz/netboot.xyz/releases/download/2.0.72/netboot.xyz.iso";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Aktuelle Hash eintragen!
    };
    target = "var/lib/netboot/netboot.xyz.iso";
  };
  */
}

