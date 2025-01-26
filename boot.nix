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

      extraConfig = ''
        set timeout_style=hidden
      '';

      extraEntries = ''
        menuentry "netboot.xyz" {
          insmod fat
          insmod loopback
          insmod chain

          search --set=root --file /boot/netboot.xyz.iso
          loopback loop /boot/netboot.xyz.iso
          chainloader (loop)/EFI/boot/bootx64.efi
        }
      '';
    };
  };
}

