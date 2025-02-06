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
        menuentry "netboot.xyz" {
          insmod fat
          insmod loopback
          insmod chain
          insmod iso9660  # Für ISO-Container

          search --set=root --file /boot/netboot.xyz.iso # ISO finden und Root-Device def.
          loopback loop /boot/netboot.xyz.iso # macht die ISO als virtuelles Laufwerk verfügbar
          chainloader (loop)/EFI/BOOT/BOOTX64.EFI #  Standard-EFI-Pfad für x86_64 Systeme
 
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

}
