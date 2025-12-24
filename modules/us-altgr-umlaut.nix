{ config, pkgs, ... }:


 {
 services.xserver = {
    enable = true;	  # Enable the X11 windowing system. Die Reihenfolge ist wichtig, da das erste Layout standardmäßig verwendet wird.
   
     xkb.options = " grp:win_space_toggle"; # Option zum Umschalten der Layouts
  };

}
  console.useXkbConfig = true; # Makes it so the tty console has about the same layout as the one configured in the services.xserver options.
  
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


/*  BESSER

services.xserver.displayManager.sessionCommands =
  "${pkgs.xorg.xmodmap}/bin/xmodmap ${pkgs.writeText  "xkb-layout" ''
    ! Map umlauts to RIGHT ALT + <key>
      keycode 108 = Mode_switch
      keysym e = e E EuroSign
      keysym c = c C cent
      keysym a = a A adiaeresis Adiaeresis
      keysym o = o O odiaeresis Odiaeresis
      keysym u = u U udiaeresis Udiaeresis
      keysym s = s S ssharp
    
      ! disable capslock
      ! remove Lock = Caps_Lock
  ''}"

als  */

# Select internationalisation properties.

   #  Option, wie zwischen den Layouts wechselst. grp:alt_shift_toggle : Alt + Shift und grp_led:scroll kann die Scroll-Lock-LED verwenden, um anzuzeigen, welches Layout aktiv ist. grp:win_space_toggle (Windows-Taste + Leertaste) .
      # grp:alt_shift_toggle,grp_led:scroll

#    xkbVariant = "altgr_umlauts,"; # Deine benutzerdefinierte Variante für US
    # spezifische XKB-Variante für das erste Layout in der layout-Liste (in diesem Fall "us"). Indem du "altgr_umlauts," angibst, sagst du NixOS, dass es die benutzerdefinierte Symbol-Datei altgr_umlauts für das US-Layout verwenden soll. Das Komma am Ende bedeutet, dass für das zweite Layout ("de") die Standardvariante verwendet wird (was normalerweise leer ist).


  # Kopiere deine benutzerdefinierte Symbol-Datei nach /etc/X11/xkb/symbols
/*
system.activationScripts.xkb-symbols = pkgs.writeShellScript "xkb-symbols" ''
    mkdir -p /etc/X11/xkb/symbols
    cp /etc/nixos/us-altgr-umlauts /etc/X11/xkb/symbols/altgr_umlauts
  '';  
 #  system.activationScripts.xkb-symbols.after = [ "fileSystems./etc/X11/xkb/symbols.mount" ];

 */
 
