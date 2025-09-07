# You can get a list of the available packages as follows:
# nix-env -qaP '*' --description
#lslbk -f 
#lsblk -f --topology --ascii --all --list 
# setxkbmap -query -v

#https://github.com/Misterio77/flavours
# https://www.youtube.com/watch?v=AGVXJ-TIv3Y
{ config, pkgs, ... }:

{
#    ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
system.activationScripts.diff = {
  supportsDryActivation = true;
  text = ''
  	  ${pkgs.nvd}/bin/nvd --color auto --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
    '';
};

# Globale Umgebungsvariablen
  environment.variables = {
    BROWSER 		  = 	"firefox";
    EDITOR 		  =	 "micro";
    PRO 		  = 	"/home/project";
    SHAREDIR 		  = 	"/share";
    EMACSDIR		  =	"/share/emacs";
    ZDOTDIR 		  = 	"/share/zsh";
    TEALDEER_CONFIG_DIR = 	"/share/zsh/tldr";	# tealdeer-rs
    NAVI_CONFIG 	  = 	"/share/zsh/navi/config.yaml";
    GIT_CONFIG            = 	"/share/zsh/git/config";
    BAT_CONFIG_FILE	    = 	"/share/bat/config.toml";
    KITTY_CONFIG_DIRECTORY  = 	"/share/kitty";    # kitty-Terminal Konfigurationspfad
    NIX_INDEX_DATABASE 	= 	"/share/nix-index";    # Nix-Index-Datenbank
         # SPACESHIP_CONFIG = "$ZDOTDIR/prompt/starship.toml"; # Spaceship Prompt Konfigurationspfad
  };

  # Sitzungsspezifische Umgebungsvariablen
  environment.sessionVariables = {
    XDG_CACHE_HOME      = 	"$HOME/.cache";
    XDG_CONFIG_HOME     = 	"$HOME/.config";
    XDG_DATA_HOME       = 	"$HOME/.local/share";
    XDG_STATE_HOME      = 	"$HOME/.local/state";  
        # XAUTHORITY = "$XDG_CONFIG_HOME/Xauthority";  # Kommentiert, aber bei Bedarf nutzbar
    CARGO_HOME         = 	"$HOME/.config/cargo";       # Für Rust-Projekte, falls benötigt
    WWW_HOME           = 	"$HOME/.config/w3m";           # w3m (Browser) Konfigurationspfad
    PYTHONPATH = "${pkgs.python3Full}/${pkgs.python3Full.sitePackages}";
  };

  environment.etc."xdg/user-dirs.defaults".text = ''
   #  DESKTOP=desktop
   DOCUMENTS=dokumente
   DOWNLOAD=downloads
   # MUSIC=musik
     PICTURES=bilder
    PUBLICSHARE=public
    TEMPLATES=tmp
#    VIDEOS=videos
  '';

  # Weitere Pfade und Optionen
  environment.homeBinInPath = true;   # Fügt ~/bin/ dem $PATH hinzu
  environment.pathsToLink = [
    "/share/icons"   # Verlinkt das Icon-Verzeichnis im SystemüList of directories to be symlinked in /run/current-system/sw.
  ];

  /* ---------------------------------------------------------------------
                    __  _             __  _                                  
        ____ ______/ /_(_)   ______ _/ /_(_)___  ____                        
 ______/ __ `/ ___/ __/ / | / / __ `/ __/ / __ \/ __ \__________________     
/_____/ /_/ / /__/ /_/ /| |/ / /_/ / /_/ / /_/ / / / /_____/_____/_____/     
      \__,_/\___/\__/_/ |___/\__,_/\__/_/\____/_/ /_/                        
                    _______________(_)___  / /______                         
 __________________/ ___/ ___/ ___/ / __ \/ __/ ___/_________________        
/_____/_____/_____(__  ) /__/ /  / / /_/ / /_(__  )_____/_____/_____/        
                 /____/\___/_/  /_/ .___/\__/____/                           
                                 /_/   für User, Grps, ch-Rechte, ln, ...                          
_________________________________________________________________________ */

# Aktivierungsskripte für Benutzerrechte 
system.activationScripts = {
  setPermissions = {
    text = ''
    LOG_FILE=/var/log/setPermissions.log
      echo "===== $(date '+%Y-%m-%d %H:%M:%S') - Start setPermissions Script =====" > $LOG_FILE

  # Setze Berechtigungen auf 755 für /home-Verzeichnisse und 644 für Dateien
      chown -R :mxx /home && echo "Gruppe 'mxx' für /home erfolgreich gesetzt" >> $LOG_FILE
    
     # fd --full-path /home --type directory --exec-batch chmod -R 0755 {} \; && echo "Berechtigungen auf 0755 für /home-Verzeichnisse erfolgreich gesetzt" >> $LOG_FILE
     # fd --full-path /home --type file --exec-batch chmod 644 {} \; && echo "Berechtigungen auf 644 für /home-Dateien erfolgreich gesetzt" >> $LOG_FILE

  # Setze Berechtigungen auf 2760 für /share
      chmod -R 0755 /share && echo "Berechtigungen auf 2760 für /share erfolgreich gesetzt" >> $LOG_FILE
      chown -R :mxx /share && echo "Gruppe 'mxx' für /share erfolgreich gesetzt" >> $LOG_FILE
 # Erstelle symbolische Links für bestimmte Verzeichnisse
      name="finja"
      for dir in Bilder Dokumente Video Vorlagen Musik; do
        if [ -d "/home/amxamxa/$dir" ] && [ ! -e "/home/$name/$dir" ]; then
          ln -s "/home/amxamxa/$dir" "/home/$name/$dir" && echo "Symbolischer Link von /home/amxamxa/$dir zu /home/$name/$dir erstellt" >> $LOG_FILE
        else
          echo "Symbolischer Link von /home/amxamxa/$dir zu /home/$name/$dir NICHT erstellt" >> $LOG_FILE
        fi
      done

 # Setze SSH-Berechtigungen
      find /home -name ".ssh" -exec chmod 0700 {} \; && echo "chmod 0700 für ~/.ssh gesetzt" >> $LOG_FILE
      find /home -type f -name "id_ed25519" -exec chmod 0600 {} \; && echo "chmod 0600 für id_ed25519 gesetzt" >> $LOG_FILE
      find /home -type f -name "id_ed25519.pub" -exec chmod 0644 {} \; && echo "chmod 0644 für id_ed25519.pub gesetzt" >> $LOG_FILE

      echo "===== $(date '+%Y-%m-%d %H:%M:%S') - End setPermissions Script =====" >> $LOG_FILE
    '';
    deps = [];
  };
};

/* ________________________  _  ___  _   ____________________________
                          ( )     ( )
 _   _ ___  ___ _ __ ___  |/ _ __ |/
| | | / __|/ _ \ '__/ __|   | '_ \
| |_| \__ \  __/ |  \__ \   | | | |
 \__,_|___/\___|_|  |___/   |_| |_|
      __ _ _ __ ___  _   _ _ __  ___
     / _` | '__/ _ \| | | | '_ \/ __|
    | (_| | | | (_) | |_| | |_) \__ \
     \__, |_|  \___/ \__,_| .__/|___/
      __/ |               | |
     |___/                |_|   big________ */

  # Gruppen und Benutzerkonfiguration
  nix.settings.trusted-users = [ "@mxx" "amxamxa" ];  # Nutzer mit erweiterten Rechten bei der Verbindung zum Nix-Daemon
  
  # Gruppen und Benutzer
  users.groups.mxx = {
  	gid = 1001;  # Festgelegte GID für die Gruppe "mxx"
  	members = [ "amxamxa" "frinja" ];  # Gruppenmitglieder
  };
  
  users.mutableUsers = false;   # Wenn true, können "useradd" und "groupadd"-Befehle verwendet werden
  # Nützliche Hinweise
  # VM enthält keine Daten des Hosts, daher werden vorhandene Benutzer nicht automatisch übernommen, außer mutableUsers = false wird gesetzt. 
  # oder "InitialHashedPassword" kann ebenfalls verwendet werden.

#______Benutzerkonfiguration_________________________________________
#    __ __  ______ ___________  _____    ____  ____
#   |  |  \/  ___// __ \_  __ \ \__  \ _/ ___\/ ___\
#   |  |  /\___ \\  ___/|  | \/  / __ \\  \__\  \___
#   |____//____  >\___  >__|    (____  /\___  >___  >
#           \/     \/   user accounts    \/     \/    \/
# ------------------------------------------------------------------
# Define a user account. Don't forget to set a password with ‘passwd’.
# ----------------------------------------------------------------------
  users.users.amxamxa = {
    name = "amxamxa";
    isNormalUser = true;
    initialHashedPassword = "$6$HNT32bO29gVtrQad$kanyT7X4pD.IcrE3obH9c3wmWfv4ZPAJ933Pw4NI.TNIvCmP1E9US47lmVz8iuR.VrtbmB1cXwSQ/PD.sQXRw.";
    description = "max.kempter@gmail.com";
    group = "mxx";
    extraGroups = [ "networkmanager" "wheel" "video" ]; # audio grps in audio.nix
    packages = with pkgs; [ 
    	libnotify # notify-send to a notification daemon
    	/* thunderbird */ 
    	];
  };

  users.users.finja = {
    name = "finja"; 
    isNormalUser = true;
    description = "finja ehem mxxkee";
    initialHashedPassword = "$6$HNT32bO29gVtrQad$kanyT7X4pD.IcrE3obH9c3wmWfv4ZPAJ933Pw4NI.TNIvCmP1E9US47lmVz8iuR.VrtbmB1cXwSQ/PD.sQXRw.";
    group = "mxx";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [   ];
  };
 
/*  users.users.alice = {
    isNormalUser = true;
    description = "alice - the real nix";
    group = "mxx";    
    initialHashedPassword = "$6$HNT32bO29gVtrQad$kanyT7X4pD.IcrE3obH9c3wmWfv4ZPAJ933Pw4NI.TNIvCmP1E9US47lmVz8iuR.VrtbmB1cXwSQ/PD.sQXRw.";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [  ];
  }; 
*/

# Sudo-Konfiguration
security.sudo = {
  extraRules = [
    { 
      groups = ["mxx"];
      commands = [
      # Dateisystemnutzung anzeigen
        { command = "${pkgs.coreutils}/bin/df"; options = ["NOPASSWD"]; } 
      # System neu starten
        { command = "${pkgs.toybox}/bin/reboot"; options = ["NOPASSWD"]; } 
      # System ausschalten
        { command = "${pkgs.toybox}/bin/shutdown"; options = ["NOPASSWD"]; }
      ]; 
    }
  ];
  extraConfig = ''
    Defaults env_reset             # Sicherheitsmaßnahme zum Zurücksetzen ENV
    Defaults pwfeedback  	   # ****
    Defaults mail_badpass          # E-Mail bei fehlgeschlagenem Passwort
    Defaults mailto="9xffjgjob@mozmail.com" 	 # Mail an diese Adresse senden
    Defaults timestamp_timeout = 50
    Defaults logfile = /var/log/sudo.log # Protokolliert Sudo-Aktionen
    Defaults lecture = always     	 # Immer das Lecture-Skript anzeigen
  '';
  };

}

