{ config, pkgs, lib,  ... }:
     # sudo nixos-rebuild boot --profile-name xam4boom --cores 2 --show-trace
{
  # Optional: Disable warning about excluded packages
  services.desktopManager.cosmic.showExcludedPkgsWarning = false

 environment.systemPackages = [
   cosmic-store # App Store for the COSMIC Desktop Envir
   

  # Exclude specific COSMIC packages
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-term        # alternative terminal preferred
    cosmic-randr #    Library and utility for displaying and configuring Wayland outputs
    cosmic-icons #     System76 Cosmic icon theme for Linux
cosmic-applets
cosmic-protocols # Additional wayland-protocols used by the COSMIC desktop environment
cosmic-ext-tweaks # Tweaking tool for the COSMIC Desktop Environment
cosmic-ext-calculator # Calculator for the COSMIC Desktop Envir
cosmic-ext-applet-minimon # COSMIC applet for displaying CPU/Memory/Network/Disk/GPU usage in the Panel or Dock
quick-webapps # Web App Manager for the COSMIC desktop
examine # System information viewer for the COSM
xdg-desktop-portal-cosmic #XDG Desktop Portal for the COSMIC Desktop Environment
tasks # Simple task management application for the COSMIC desktop
      ];

# --- Desktop Environment: COSMIC ---
# Ohne Flakes wird das Modul direkt aus dem 25.11 Channel bezogen
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
# Performance-Optimierung (System76 Integration)
  services.system76-scheduler.enable = true;
#-------------------------------------------
# LightDM Slick Greeter 
services.xserver.displayManager = {
  gdm.enable = false;
  lightdm.enable = false;
    };          ###########################!!!

 services.xserver.desktopManager = {
    cinnamon.enable	= false;
    gnome.enable	= false;
    pantheon.enable	= false;
    lxqt.enable		= false;
    xfce.enable		= false; 
    };
  
 nix.settings = {
    # Erlaubt das Beziehen von fertigen COSMIC-Builds ohne Flakes
    substituters = [ "https://cosmic.cachix.org" ];
    trusted-public-keys = [ "cosmic.cachix.org-1:9/S695oLGOnS9e12Rh9CLGiL9uX9HId+6A473Y9U158=" ];
  };
/*
  # siehe /run/current-system/sw/share/backgrounds
 let
   customWallpapers = pkgs.stdenv.mkDerivation {
     name = "custom-wallpapers";
     src = /share/wallpaper;  # meine Wallpapers
     installPhase = ''
       mkdir -p $out/share/wallpapers
       cp -r $src/* $out/share/wallpapers/
     '';
   };
 in {
# Füge das Paket zu systemPackages hinzu
   environment.systemPackages = [ customWallpapers ];
# Info an NixOS, welche Pfade verlinkt werden sollen
   environment.pathsToLink = [ "/share/wallpapers" ];
 };
*/
/*
# Ensure background image directory exists and has correct permissions
  systemd.tmpfiles.rules = [
    "d /etc/nixos/assets 0755 root root -"
    "f /etc/nixos/assets/bg2.png 0644 root root -"
    "f /etc/nixos/assets/regreet.css 0644 root root -" 
  ];
*/

}
