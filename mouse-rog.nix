# this config is for Gaming Mouse: ASUS ROG GX850 
{ config, pkgs, ... }:

{
  services.udev.extraRules = ''
    # ASUS ROG Gladius III
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0b05", ATTRS{idProduct}=="17ac", TAG+="uaccess"
  '';
}



