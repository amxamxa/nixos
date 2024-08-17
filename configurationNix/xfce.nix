# xfce.nix
# NUR BEI XFCE4 sourcen!!
{ config, pkgs, ... }:
			
{
services.xserver.desktopManager.xfce.enable = true;
  services.displayManager.defaultSession = "xfce";
  {
  services.picom = {
    enable = true;
    fade = true;
    inactiveOpacity = 0.9;
    shadow = true;
    fadeDelta = 4;
  };
}

  
   	    	### 		xfce tools
   	xfce.xfce4-panel   xfce.xfce4-session # panel u session manager for Xfce   "Iosevka"
    xfce.xfce4-notifyd xfce.xfce4-settings    	xfce.xfwm4 		xfce.exo # Application library for Xfce
     	xfce.xfce4-taskmanager		xfce.libxfce4ui #      Widgets library for Xfce
#   	xfce.xfce4-cpugraph-plugin 		xfce.xfce4-fsguard-plugin # monitors the free space on your filesystems
   	xfce.xfce4-clipman-plugin	#	xfce.xfce4-genmon-plugin # display various types of information, such as system stats, weathe
   	xfce.xfce4-notes-plugin 	#	xfce.xfce4-netload-plugin #    xfce.xfce4-xkb-plugin # bildschirmschoner
   
 	#parcellite #GTK clipboard manager
 	xfce.xfce4-systemload-plugin   xfce.xfce4-whiskermenu-plugin 

