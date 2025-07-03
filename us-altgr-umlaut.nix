{ config, pkgs, ... }:
/*
# ZIEL:   
  Standard US-Layout:
    Wenn du das US-Layout ausgewählt hast, funktionieren die normalen US-Tasten.
    Zusätzlich sind die deutschen Umlaute (ä, ö, ü, Ä, Ö, Ü) über die AltGr-
    Taste in Kombination mit a, o, u (bzw. A, O, U) eingebar.
  Deutsches Layout: 
    Wenn du zum deutschen Layout wechselst (mit Win + Leertaste), funktioniert 
    das Standard-deutsche Tastaturlayout.
  
TSHOOT: Prüfe die X-Server-Logs auf Fehlermeldungen (/var/log/Xorg.0.log oder ähnliches).
*/

# Select internationalisation properties.
 {
 services.xserver = {
    enable = true;	  # Enable the X11 windowing system.
    xkb.layout = "us,de";      # Definiert die verfügbaren Tastaturlayouts. Hier sind "us" (amerikanisch) und "de" (deutsch) angegeben. Die Reihenfolge ist wichtig, da das erste Layout standardmäßig verwendet wird.
   
   #  Option, wie zwischen den Layouts wechselst. grp:alt_shift_toggle : Alt + Shift und grp_led:scroll kann die Scroll-Lock-LED verwenden, um anzuzeigen, welches Layout aktiv ist. grp:win_space_toggle (Windows-Taste + Leertaste) .
      # grp:alt_shift_toggle,grp_led:scroll

#    xkbVariant = "altgr_umlauts,"; # Deine benutzerdefinierte Variante für US
    # spezifische XKB-Variante für das erste Layout in der layout-Liste (in diesem Fall "us"). Indem du "altgr_umlauts," angibst, sagst du NixOS, dass es die benutzerdefinierte Symbol-Datei altgr_umlauts für das US-Layout verwenden soll. Das Komma am Ende bedeutet, dass für das zweite Layout ("de") die Standardvariante verwendet wird (was normalerweise leer ist).
  xkb.options = " grp:win_space_toggle"; # Option zum Umschalten der Layouts
  };

  # Kopiere deine benutzerdefinierte Symbol-Datei nach /etc/X11/xkb/symbols
/*
system.activationScripts.xkb-symbols = pkgs.writeShellScript "xkb-symbols" ''
    mkdir -p /etc/X11/xkb/symbols
    cp /etc/nixos/us-altgr-umlauts /etc/X11/xkb/symbols/altgr_umlauts
  '';
 #  system.activationScripts.xkb-symbols.after = [ "fileSystems./etc/X11/xkb/symbols.mount" ];

 */
 
i18n = {
    defaultLocale = "de_DE.UTF-8";
    supportedLocales =      [ "de_DE.UTF-8/UTF-8"   # Modern, universell unterstützt große Anzahl von Zeichen
     					    "en_US.UTF-8/UTF-8"    ];   # Sprache auf Deutsch/Englisch begrenzen
    extraLocaleSettings = {
    	LC_NAME = 		  "de_DE.UTF-8";
        LC_TIME = 		  "de_DE.UTF-8";
        LC_PAPER = 		  "de_DE.UTF-8";
     	LC_ADDRESS =	  "de_DE.UTF-8";
	LC_MEASUREMENT = "de_DE.UTF-8";
      	LC_MONETARY = 	  "de_DE.UTF-8";
       	LC_NUMERIC =          "de_DE.UTF-8";
	LC_TELEPHONE = 	  "de_DE.UTF-8";
	LC_IDENTIFICATION = "de_DE.UTF-8";
    };
 };
 
 fonts.packages = with pkgs; [ terminus_font ];

   console = {
    font = "Agafari-16"; # "sun12x22"; # ls /run/current-system/sw/share/consolefonts/"Lat2-Terminus16";  # Schriftart für die Konsole
  #  keyMap = "us,de";  # Deutsche Tastaturbelegung in der Konsole
  };
    
}
