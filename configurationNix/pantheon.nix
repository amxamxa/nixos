 { config, pkgs, ... }:
			

 
{
 
 # flatpak remote-add --if-not-exists appcenter https://flatpak.elementary.io/repo.flatpakrepo
 services.xserver.desktopManager.pantheon.enable = true;
 services.xserver.displayManager.lightdm.greeters.pantheon.enable = false;
  services.xserver.displayManager.lightdm.enable = false;
 services.pantheon.apps.enable = false;
 }
