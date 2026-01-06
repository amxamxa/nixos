/*
evaluation warning: The option `hardware.pulseaudio' defined in `/etc/nixos/modules/audio.nix' has been renamed to `services.pulseaudio'.
evaluation warning: pycharm-comminity-bin: PyCharm Community has been discontinued by Jetbrains. This binary build is no longer updated. Switch to 'jetbrains.pycharm-oss' for open source builds (from source) or 'jetbrains.pycharm' for commercial builds (binary, unfree). See: https://blog.jetbrains.com/pycharm/2025/04/pycharm-2025
*/

# You can get a list of the available packages as follows:
# nix-env -qaP '*' --description
#lslbk -f 
#lsblk -f --topology --ascii --all --list 
# setxkbmap -query -v

#https://github.com/Misterio77/flavours
# https://www.youtube.com/watch?v=AGVXJ-TIv3Y
{ config, pkgs, lib, ... }:

{

system.activationScripts.diff = {
  supportsDryActivation = true;
  text = '' 
  	${pkgs.nvd}/bin/nvd --color auto --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
    ''; };

# Globale Umgebungsvariablen
  environment.variables = {
    BROWSER 		  = 	"firefox";
    PRO		 		  = 	"/home/project";
    SHAREDIR 		  = 	"/share";
    # EMACSDIR		  =	"/share/emacs";
    ZDOTDIR 		  = 	"/share/zsh";
    ZFUNCDIR 		  = 	"/share/zsh/functions";
         
    XDG_CACHE_HOME      = 	"$HOME/.cache";
    XDG_CONFIG_HOME     = 	"$HOME/.config";
    XDG_DATA_HOME       = 	"$HOME/.local/share";
    XDG_STATE_HOME      = 	"$HOME/.local/state";  
  
   #XAUTHORITY = "$XDG_CONFIG_HOME/Xauthority";  # Kommentiert, aber bei Bedarf nutzbar
    CARGO_HOME         = 	"$HOME/.config/cargo";       # Für Rust-Projekte, falls benötigt
    WWW_HOME           = 	"$HOME/.config/w3m";           # w3m (Browser) Konfigurationspfad
    # PYTHONPATH = "${pkgs.python3Full}/${pkgs.python3Full.sitePackages}";        
  };

  # Sitzungsspezifische Umgebungsvariablen
  environment.sessionVariables = {
#    NIX_INDEX_DATABASE 	= 	"/share/nix-index";    # Nix-Index-Datenbank
  	EDITOR 		= "${pkgs.micro}/bin/micro";
    VISUAL 		=  "${pkgs.micro}/bin/micro";
    SYSTEMD_EDITOR =  "${pkgs.micro}/bin/micro";

    TEALDEER_CONFIG_DIR = 	"/share/zsh/tldr";	# tealdeer-rs
    NAVI_CONFIG 	    = 	"/share/zsh/navi/config.yaml";
    GIT_CONFIG          = 	"/share/zsh/git/config";
    BAT_CONFIG_FILE	    = 	"/share/bat/config.toml";
    KITTY_CONFIG_DIRECTORY  = 	"/share/kitty";    # kitty-Terminal Konfigurationspfad
    # SPACESHIP_CONFIG = "$ZDOTDIR/prompt/starship.toml"; # Spaceship Prompt Konfigurationspfad
    
    ###########################################################################          
    # Session / Desktop Identität 4 cosmic w/ WAYLAND
    # ─────────────────────────────────────────────
    # Erzwingt Wayland als Session-Typ
    XDG_SESSION_TYPE = "wayland";
    # Identifiziert COSMIC korrekt für Toolkits
    XDG_CURRENT_DESKTOP = "COSMIC";
    XDG_SESSION_DESKTOP = "COSMIC";
    # GTK (GTK3 / GTK4)────────────────────────────
    # Wayland zuerst, X11 nur Fallback
    GDK_BACKEND = "wayland,x11";
    # Kein DPI-Scaling → normale TFTs (≈96 DPI)
    GDK_SCALE = "1";
    GDK_DPI_SCALE = "1.0";
    # Qt 5 / Qt 6───────────────────────────────
    # Native Wayland, Fallback auf X11
    QT_QPA_PLATFORM = "wayland;xcb";
    # COSMIC liefert Window Decorations selbst
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    # Verhindert automatisches HiDPI-Scaling
    QT_AUTO_SCREEN_SCALE_FACTOR = "0";
    # SDL (Games / Emulatoren)──────────────────────
    # Wayland-native Fenster + Fallback
    SDL_VIDEODRIVER = "wayland,x11";
    # Bessere Controller-Erkennung
    SDL_JOYSTICK_HIDAPI = "1";
    # Mozilla Firefox - Erzwingt Wayland-Rendering
    MOZ_ENABLE_WAYLAND = "1";
    # Saubere Input-Events unter Wayland
    MOZ_USE_XINPUT2 = "1";
    # Electron / Chromium - aktiviert Ozone-Wayland automatisch
    NIXOS_OZONE_WL = "1";
    OZONE_PLATFORM = "wayland";
    # Legacy Toolkits (minimal), für alte GNOME-/EFL-Programme
    CLUTTER_BACKEND = "wayland";
    ELM_ENGINE = "wayland_egl";
   # Erzwingt SDR-Fallback (stabil)
    WLR_DRM_NO_ATOMIC = "0";
    COLOR_MANAGEMENT = "0";
 #############################################################################  
   XDG_CONFIG_HOME="$HOME/.config";
   XDG_CACHE_HOME="$HOME/.cache";
   XDG_STATE_HOME="$HOME/.local/state";
   XDG_RUNTIME_DIR="/run/user/$UID";

# history files
   LESSHISTFILE="$XDG_CACHE_HOME/less_history";
   PYTHON_HISTORY="$XDG_DATA_HOME/python/history";

# moving other files and some other vars
   XINITRC="$XDG_CONFIG_HOME/x11/xinitrc";
   XPROFILE="$XDG_CONFIG_HOME/x11/xprofile";
   XRESOURCES="$XDG_CONFIG_HOME/x11/xresources";
   XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority";
   GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc2.0"; # gtk 3 & 4 are XDG compliant
   WGETRC="$XDG_CONFIG_HOME/wget/wgetrc";
   PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc";
   GNUPGHOME="$XDG_DATA_HOME/gnupg";
  # CARGO_HOME="$XDG_DATA_HOME/cargo";
   GOPATH="$XDG_DATA_HOME/go";
   GOBIN="$GOPATH/bin";
   GOMODCACHE="$XDG_CACHE_HOME/go/mod";
   NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOMEnpm/npmrc";
   GRADLE_USER_HOME="$XDG_DATA_HOME/gradle";
   NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages";
   # _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java";
   #_JAVA_AWT_WM_NONREPARENTING=1;
   PARALLEL_HOME="$XDG_CONFIG_HOME/parallel";
   FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg";

# Anwendungsspezifisch
   ANDROID_SDK_HOME="$XDG_DATA_HOME/android";
   npm_config_cache="$XDG_CACHE_HOME/npm";
   npm_config_userconfig="$XDG_CONFIG_HOME/npm/npmrc";
   npm_config_prefix="$XDG_DATA_HOME/npm";
   VAGRANT_HOME="$XDG_DATA_HOME/vagrant";
   W3M_DIR="$XDG_DATA_HOME/w3m";
   # WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
   # DATE="$(date "+%A, %B %e  %_I:%M%P")";

   FZF_DEFAULT_OPTS="--border rounded \
                     --color=dark \
                     --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 \
                     --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 \
                     --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 \
                     --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 \
                     --layout=reverse --height 40% --preview-window=right:60% \
--preview='[[ \$(file --mime {}) =~ binary ]] && echo {} ist eine Binärdatei || (bat --style=numbers --color=always {} || cat {}) 2>/dev/null | head -300'";

# Mit pygmentize (Python-basiert): #FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 30% --preview='pygmentize -g {} 2>/dev/null || cat {}'" #   FZF_CTRL_R_OPTS="--style minimal --color 16 --info inline --no-sort --no-preview"; # separate opts for history widget
  FZF_CTRL_R_OPTS="--border rounded \
                --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 \
                --info inline --no-sort --no-preview \
        --header '󰅍 Befehlshistory (Enter: Ausführen | CTRL-Y: Kopieren)'";
# Sehr minimalistisch: #FZF_DEFAULT_OPTS="--no-info --color 16 --layout=reverse --height 25%" #FZF_CTRL_R_OPTS="--no-info --color 16 --no-sort"
# colored man, less + termcap vars______________________________________________
  MANPAGER="less -R --use-color -Dd+r -Du+b"; # colored man pages   
  LESS="R --use-color -Dd+r -Du+b";
  LESS_TERMCAP_mb="$(printf '%b' '[1;31m')";  # blinking - red
  LESS_TERMCAP_md="$(printf '%b' '[1;36m')";  # bold - cyan
  LESS_TERMCAP_me="$(printf '%b' '[0m')";     # end mode
  LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"; # standout - yellow on blue
  LESS_TERMCAP_se="$(printf '%b' '[0m')";     # end standout
  LESS_TERMCAP_us="$(printf '%b' '[1;32m')";  # underline - green
  LESS_TERMCAP_ue="$(printf '%b' '[0m')";     # end underline

 # eza / ls w/colora
  COLUMNS=78;
  EZA_ICONS_AUTO="auto";
  EZA_ICON_SPACING=2;
  EZA_GRID_ROWS=3;
  EZA_GRID_COLUMNS=3;
  EZA_MIN_LUMINANCE=50;
  EZA_COLORS="$LS_COLORS:hd=38;5;226:uu=38;5;202:gu=38;5;208:da=38;5;111:uR=38;5;197:uG=38;5;198";
# zsh   
  HISTIGNORE="ls:cd:pwd:exit:tldr:cheat:printf:micro:man:eza:lsd:cp:echo:z:bap:bat:git:sudo:grep";
  HISTTIMEFORMAT="%D{%Y-%m-%d %H:%M} ";
  DIRSTACKSIZE=9;
  REPORTTIME=3;     # display cpu usage, if command taking more than 3s   
# bash
  # HISTFILE="$XDG_STATE_HOME/bash/history"
 
# xamxams  color attributesas static ENV______________________________
  RESET= lib.mkDefault "\\033[0m";
  NC="\\033[0m";
  BOLD="\\033[1m";
  LILA="\\033[38;2;0;255;0m\\033[48;2;0;25;2m";
GELB="\\033[38;2;240;138;100m\\033[48;2;147;18;61m"; 
  GREEN= lib.mkDefault "\\033[38;2;0;255;0m\\033[48;2;0;100;0m";
  RED= lib.mkDefault "\\033[38;2;240;128;128m\\033[48;2;139;0;0m";
  YELLOW= lib.mkDefault "\\033[38;2;255;255;0m\\033[48;2;128;128;0m";
  NIGHT="\\033[38;2;252;222;90m\\033[48;2;0;0;139m";
  LAV="\\033[38;2;204;153;255m\\033[48;2;102;51;153m";
  PUNK="\\033[38;2;0;17;204m\\033[48;2;147;112;219m";
  RASP="\\033[38;2;32;0;21m\\033[48;2;163;64;217m";
  PINK="\\033[38;2;255;105;180m\\033[48;2;75;0;130m";
  FUCHSIA="\\033[38;2;239;217;129m\\033[48;2;59;14;122m";
  VIOLET="\033[38;2;255;0;53m\\033[48;2;34;0;82m";
  BROWN="\\033[38;2;239;217;129m\\033[48;2;210;105;30m";
  LEMON="\\033[38;2;216;101;39m\\033[48;2;218;165;32m";
  CORAL="\\033[38;2;252;222;90m\\033[48;2;240;128;128m";
  GOLD="\\033[38;2;255;0;53m\\033[48;2;218;165;32m";
  ORANGE="\\033[38;2;0;17;204m\\033[48;2;255;140;0m";
  GREY="\\033[38;2;252;222;90m\\033[48;2;192;192;192m";
  MINT="\\033[38;2;6;88;96m\\033[48;2;144;238;144m";
  SKY="\\033[38;2;62;36;129m\\033[48;2;135;206;235m";
  LIME="\\033[38;2;6;88;96m\\033[48;2;0;255;255m";
  PETROL="\\033[38;2;0;17;204m\\033[48;2;32;178;170m";
  CYAN="\\033[38;2;64;224;208m\\033[48;2;0;128;128m";
  OLIVE="\\033[38;2;0;74;40m\\033[48;2;107;142;35m";
  #--------------------------------------------------------
};
# globale aliase fuer zsh, bash, ...
environment.shellAliases = {
 	grep = "grep --color=always";
 	fd = "echo \"\\t fd mit --color=auto\" && fd --color=auto";
 	ncdu = "echo -e \"\\t ncdu mit --color dark\" && ncdu --color dark";
 	# --verbose
 	cp = "cp -v";
 	rm = "rm -v";
 	mv = "mv -v";
};

  environment.etc."xdg/user-dirs.defaults".text = ''
  	DESKTOP=desktop
   	DOCUMENTS=dokumente
   	DOWNLOAD=downloads
   	MUSIC=music
   	PICTURES=bilder
   	PUBLICSHARE=public
   	TEMPLATES=vorlagen
 	VIDEOS=videos
  '';

  # Weitere Pfade und Optionen
  environment.homeBinInPath = true;   # Fügt ~/bin/ dem $PATH hinzu
  environment.pathsToLink = [
    "/share/icons"   # Verlinkt das Icon-Verzeichnis im System List of directories to be symlinked in /run/current-system/sw.
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
 #     name="finja"
  #    for dir in Bilder Dokumente Video Vorlagen Musik; do
   #     if [ -d "/home/amxamxa/$dir" ] && [ ! -e "/home/$name/$dir" ]; then
    #      ln -s "/home/amxamxa/$dir" "/home/$name/$dir" && echo "Symbolischer Link von /home/amxamxa/$dir zu /home/$name/$dir erstellt" >> $LOG_FILE
     #   else
      #    echo "Symbolischer Link von /home/amxamxa/$dir zu /home/$name/$dir NICHT erstellt" >> $LOG_FILE
      #  fi
    # done
 
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
  	members = [ "amxamxa" "finja" ];  # Gruppenmitglieder
  };
  users.mutableUsers = false;   # Wenn true, können "useradd" und "groupadd"-Befehle verwendet werden
  # ACHTUNG: Bei VM: enthält keine Daten des Hosts, daher werden vorhandene Benutzer nicht automatisch übernommen, außer mutableUsers = false wird gesetzt. ODER "InitialHashedPassword" kann ebenfalls verwendet werden.

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

# Sudo-Konfiguration
security.sudo = {
  extraRules = [
    { 
      groups = ["mxx"];
      commands = [
        { command = "${pkgs.eza}/bin/eza"; options = ["NOPASSWD"]; } 
        { command = "${pkgs.coreutils}/bin/dd"; options = ["NOPASSWD"]; } 
        { command = "${pkgs.coreutils}/bin/df"; options = ["NOPASSWD"]; } # Dateisystemnutzung anzeigen
        { command = "${pkgs.toybox}/bin/reboot"; options = ["NOPASSWD"]; } 
        { command = "${pkgs.toybox}/bin/shutdown"; options = ["NOPASSWD"]; }
      ]; 
    }
  ];
  # 1.   # Sicherheitsmaßnahme zum Zurücksetzen ENV 2. # E-Mail bei fehlgeschlagenem Passwort 3. # Protokolliert Sudo-Aktionen 4.  # Immer das Lecture-Skript anzeigen
  extraConfig = ''
    Defaults env_reset          
    Defaults pwfeedback  	   
    Defaults mail_badpass       
    Defaults mailto="9xffjgjob@mozmail.com" 
    Defaults timestamp_timeout = 50
    Defaults logfile = /var/log/sudo.log 
    Defaults lecture = always
  '';
  };

}

