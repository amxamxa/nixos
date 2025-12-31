{ config, pkgs, lib,  ... }:
     # sudo nixos-rebuild boot --profile-name xam4boom --cores 2 --show-trace
{

# --- Desktop Environment: COSMIC ---
# Ohne Flakes wird das Modul direkt aus dem 25.11 Channel bezogen
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
# Performance-Optimierung (System76 Integration)
  services.system76-scheduler.enable = true;
  # Enable the - d e s k t o p  m a n a g e r - Environment. # slick-greeter; | lightdm-enso-os-greeter| lightdm-tiny-greeter 
  # Include LightDM configuration if necessary
# services.xserver.displayManager.lightdm.enable = true;
# services.xserver.displayManager.lightdm.greeters.slick.enable = true;

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

  
  # lightdm.greeters.tiny = {   enable = true;    #background = "/share/wallpaper/sonstige/blitz.png"; };
/*
lightdm.greeters.slick = {
     enable = true;
     theme = 	 { name = "andromeda"; package = pkgs.andromeda-gtk-theme; };
     iconTheme = { name = "Faba-Mono-Dark"; package = pkgs.faba-mono-icons; };
     font  = 	 { name = "MesloLGS NF 24"; package = pkgs.meslo-lgs-nf;	};
     draw-user-backgrounds= true; # steuert, ob Hintergrund des Nutzers auf Login-Bildschirm erscheint
     # tshoot:  /var/log/lightdm/lightdm.log
     extraConfig = ''
    # LightDM GTK+ Configuration file for /etc/lightdm/slick-greeter.conf        
        stretch-background-across-monitors=false # to stretch the background across multiple monitors
        only-on-monitor=HDMI-1  # Sets monitor on which is login; -1 means "follow the mouse"
        background=        background="./assets/background.png"
# logo=/etc/lightdm/logo-aramgedon.png         other-monitors-logo=/etc/lightdm/logo-aramgedon.png          show-power=false        # show-keyboard=false         show-hostname=true        show-clock=true        show-quit=true # show the quit menu in the menubar 
        xft-hintstyle="hintmedium" # hintnone/hintslight/hintmedium/hintfull  
	clock-format=" %d.%b.%g %H:%" #  clock format to use (e.g., %H:%M or %l:%M %p)
# xft-antialias=Whether to antialias Xft fonts (true or false)  # xft-dpi=Resolution for Xft in dots per inch
# xft-rgba=Type of subpixel antialiasing (none/rgb/bgr/vrgb/vbgr)
	 '';  
	 };
   };

services.displayManager = {
	autoLogin.enable = true;
	autoLogin.user = "amxamxa";
	defaultSession = "cinnamon";	
	};   
*/

/*
# Deaktivierung konkurrierender Display-Manager
services.displayManager = {
  lightdm.enable =true;
  gdm.enable = false;	# lib.Force true;
  sddm.enable = false; #  lib.mkForce false;
 };
*/

# Alter-Option: Keep Cinnamon + GDM (Recommended for stability)
#services.xserver.displayManager.gdm.enable = true;
#services.xserver.displayManager.gdm.wayland = false; # Cinnamon needs X11


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
# Greeter User hat keine Login-Shell und dient 
# nur als Container für den Greeter-Prozess.
# Greeter-Benutzer für Wayland
  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
    home = "/var/lib/greeter";
    createHome = true;
    shell = "${pkgs.shadow}/bin/nologin";
  };
  
  users.groups.greeter = {};

# Ensure background image directory exists and has correct permissions
  systemd.tmpfiles.rules = [
    "d /etc/nixos/assets 0755 root root -"
    "f /etc/nixos/assets/bg2.png 0644 root root -"
    "f /etc/nixos/assets/regreet.css 0644 root root -" 
  ];
*/
/*

  # PAM-Konfiguration für regreet
  security.pam.services.regreet = {
    enableGnomeKeyring = true;
    # GDM-kompatible PAM-Regeln für bessere Integration
    text = ''
      auth     requisite      pam_nologin.so
      auth     required       pam_env.so
      auth     required       pam_faillock.so preauth
      auth     required       pam_shells.so
      auth     include        login-common
      auth     optional       pam_gnome_keyring.so
      account  include        login-common
      
      password requisite      pam_deny.so
      password include        login-common
      password optional       pam_gnome_keyring.so use_authtok
      
      session  required       pam_limits.so
      session  include        login-common
      session  optional       pam_gnome_keyring.so auto_start
      session  optional       pam_systemd.so
    '';
  };
  */
/*
  services.greetd = {
  enable = true;
  restart = false; # Whether to restart greetd when it terminates (e.g. on failure). This is usually desirable so a user can always log in, but should be disabled when using ‘settings.initial_session’ (autologin), because every greetd restart will trigger the autologin again.

  settings = {
    initial_session = {
      command = "${pkgs.regreet}/bin/regreet";
      user = "greeter";
    };

    default_session = {
      # Cinnamon läuft hier bewusst unter X11
      command = "${pkgs.cage}/bin/cage -- ${pkgs.cinnamon}/bin/cinnamon-session";
      user = "amxamxa";
    };
  };
};



/*  services.greetd = {
    enable = true;
 settings = {
   initial_session = {
      command = "${pkgs.greetd.regreet}/bin/regreet";
      user = "greeter";
    };
    default_session = {
      command = "${pkgs.cage}/bin/cage -- ${pkgs.cinnamon}/bin/cinnamon-session --wayland";
      user = "amxamxa";  # oder der jeweilige Benutzer, aber eigentlich wird dies von regreet gesetzt
    };
  };


  # ReGreet (Der grafische Greeter)
  programs.regreet = {
    enable = true;
    theme = {
      name = "Andromeda";
      package = pkgs.andromeda-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Xcursor";
      package = pkgs.xcursor-themes;
        };
    # Schriftart (NixOS 25.x Syntax)
    font = {
      name = "3270 Nerd Font Mono";
      package = pkgs.nerd-fonts._3270;
      size = 22;
    };
   cageArgs = ["last"];

    # CSS-Anpassung
    # Liest die lokale Datei und kopiert sie in den Nix-Store. 
    # Löst das Berechtigungsproblem automatisch.
    extraCss = builtins.readFile ./assets/regreet.css;
    # ReGreet Einstellungen (TOML)
    settings = {
      background = {
        # Referenziert die Datei als Pfad -> Kopie in den Nix-Store -> Lesbar für 'greeter'
        path = ./assets/bg2.png;
        fit = "Cover";  # Options: Cover, Contain, Fill, ScaleDown
        };

      # User and session memory
      remember = {
        user = true;
        session = true;
      };
      # Appearance settings
      appearance = {
        greeting_msg = "Willkommen zurück!";
            };
      GTK = {
        application_prefer_dark_theme = true;
        cursor_blink = true;
      };
      commands = {
        reboot = [ "systemctl" "reboot" ];
        poweroff = [ "systemctl" "poweroff" ];
      };
    };
    };

 systemd.services.greetd = {
    after = [ "network.target" "systemd-user-sessions.service" ];
    wants = [ "network.target" ];
  };
*/
}
