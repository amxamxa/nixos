# this config is for Gaming Mouse: ASUS ROG GX850 
{ config, pkgs, ... }:

{
  services.ratbagd.enable = true;

  services.udev.extraRules = ''
    # ASUS ROG Gladius III
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0b05", ATTRS{idProduct}=="17ac", TAG+="uaccess"
  '';

  environment.systemPackages = with pkgs; [
 # sensible-side-buttons #Utilize mouse side navigation buttons
 #   libratbag # mouse wird nicht supported
 #   piper	   # mouse wird nicht supported
  ];
}


