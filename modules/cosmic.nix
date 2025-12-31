{ config, pkgs, lib,  ... }:
     # sudo nixos-rebuild boot --profile-name xam4boom --cores 2 --show-trace
{

# --- Desktop Environment: COSMIC ---
# Ohne Flakes wird das Modul direkt aus dem 25.11 Channel bezogen
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
# Performance-Optimierung (System76 Integration)
  services.system76-scheduler.enable = true;

#  Disable warning about excluded packages
  services.desktopManager.cosmic.showExcludedPkgsWarning = false;

  # Exclude specific COSMIC packages
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-term        # alternative terminal preferred
      ];

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

  environment.systemPackages = with pkgs; [
    examine
   quick-webapps
   cosmic-ext-applet-minimon
  cosmic-ext-calculator #     Calculator for the COSMIC Desktop 
    cosmic-design-demo  #      Design Demo for the COSMIC Desktop Environment
      cosmic-applibrary #        Application Template for the COSMIC Desktop Environment
        cosmic-ext-tweaks #           Tweaking tool for the COSMIC Desktop Environment
          cosmic-protocols #          Additional wayland-protocols used by the COSMIC desktop environment  
  
  ];  
}
