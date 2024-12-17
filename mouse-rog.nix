# this config is for Gaming Mouse: ASUS ROG Gladius III

{ config, pkgs, ... }:

{



  # Notwendige Pakete
  environment.systemPackages = with pkgs; [
    piper # GTK frontend for ratbagd mouse config daemon
    libratbag # Configuration library for gaming mice
    openrgb
    asusctl  # ASUS ROG-spezifische Steuerung
  ];
  # Basis-Support für die ROG Gladius III, installiert Unterstützung der ROG Gladius III Mausund  Steuerung der RGB-Beleuchtung 
  services.udev.packages = with pkgs; [
    openrgb
  #  ratbagd
  ];
  
  # Aktivierung der Services
  services.ratbagd.enable = true; #Ratbagd-Service, der für die Maussteuerung benötigt wird.

  # USB-Regeln für die ROG Gladius III, USB-Regeln für die ROG Gladius III, um den Zugriff auf das Gerät zu ermöglichen
  services.udev.extraRules = ''
    # ASUS ROG Gladius III
    SUB# ASUS ROG Gladius IIISYSTEM=="usb", ATTRS{idVendor}=="0b05", ATTRS{idProduct}=="1958", TAG+="uaccess"
  '';

  # RGB-Steuerung,  aktiviert die Steuerung der RGB-Beleuchtung
  services.hardware.openrgb = {
    enable = true;
  };
}

