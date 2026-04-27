# /etc/nixos/modules/environment.nix
/*-----------------------------------------------------------------
▄███▄      ▄       ▄   ▄█ █▄▄▄▄ ████▄ █▀▄▀█ ▄███▄      ▄     ▄▄▄▄▀
█▀   ▀      █       █  ██ █  ▄▀ █   █ █ █ █ █▀   ▀      █ ▀▀▀ █
██▄▄    ██   █ █     █ ██ █▀▀▌  █   █ █ ▄ █ ██▄▄    ██   █    █
█▄   ▄▀ █ █  █  █    █ ▐█ █  █  ▀████ █   █ █▄   ▄▀ █ █  █   █
▀███▀   █  █ █   █  █   ▐   █            █  ▀███▀   █  █ █  ▀
        █   ██    █▐       ▀            ▀           █   ██
#---------------   ▐   ------------------------------------------ */
# System-wide environment configuration for NixOS
# This module manages:
# - System-wide environment variables
# - User session variables (via PAM)
# - XDG Base Directory compliance
# - User/group configuration
# - Activation scripts for permissions

{ config, pkgs, lib, ... }:
{
#####################################################
# SECTION SCHEMA: system.activationScripts
# Purpose:
#   Declarative system activation helpers executed during rebuild.
# Constraints:
#   - Must be idempotent
#   - Must not mutate persistent state
#   - Must not rely on user input
  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      ${pkgs.nvd}/bin/nvd \
        --color auto \
        --nix-bin-dir=${pkgs.nix}/bin \
        diff /run/current-system "$systemConfig"
    '';
  };

  ###################################################
  # SECTION SCHEMA: environment.variables
  # Scope:
  #   - Global (system-wide)
  # Purpose:
  #   - Non-session-specific environment variables
  #   - Package paths resolved at build-time
  # Constraints:
  #   - No $HOME or user-specific variables
  #   - Only absolute paths or Nix store references
  environment.variables = {
  # Absolute Pfade ohne User-Abhängigkeit gehören in variables.

    # Build-time package path interpolation
    EDITOR = "${pkgs.micro}/bin/micro";
    SYSTEMD_EDITOR = "${pkgs.micro}/bin/micro";
    PAGER = "${pkgs.less}/bin/less -R";
#    MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat --paging=always --style=changes -l man'";

    MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat --paging=auto --style=changes -l man'";
    MANROFFOPT="-c";
    MANWIDTH="60";
    BROWSWER="${pkgs.firefox}/bin/firefox";

  # Default applications
    VISUAL = "${pkgs.gnome-text-editor}/bin/gnome-text-editor";
    # Static configuration values
    # Keep LESS options on one line to avoid stray control chars in the env value.
    LESS="--RAW-CONTROL-CHARS --long-prompt --squeeze-blank --QUIT-AT-EOF --quit-if-one-screen --quit-on-intr --status-column --quiet --ignore-case --mouse --use-color -Dd+r -Du+b";



    NIX_INDEX_DATABASE = "/share/nix-index";

    # Shared system-wide paths (not user-dependent)
    TEALDEER_CONFIG_DIR = "/share/zsh/tldr";
    NAVI_CONFIG = "/share/zsh/navi/config.yaml";
    GIT_CONFIG = "/share/zsh/git/config";
    BAT_CONFIG_FILE = "/etc/bat/config.toml";
    KITTY_CONFIG_DIRECTORY = "/share/kitty";
  };

  ###################################################
  # SECTION SCHEMA: environment.sessionVariables
  # Scope:
  #   - Session-local (per-user login scope)
  # Purpose:
  #   - XDG base directories
  #   - Wayland/COSMIC configuration
  #   - User-specific application paths
  # Expansion:
  #   - Shell expands variables at runtime
  # Tests:
  #   - env | grep XDG
  #   - echo $XDG_CONFIG_HOME (after login)

  environment.sessionVariables = {
    # XDG Base Directory Specification
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_RUNTIME_DIR = "/run/user/$UID";

    # Wayland/COSMIC session configuration
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "COSMIC";
    XDG_SESSION_DESKTOP = "COSMIC";

    # GTK configuration
    GDK_BACKEND = "wayland,x11";
    GDK_SCALE = "1";
    GDK_DPI_SCALE = "1.0";
    GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0";

    # Qt configuration
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "0";

    # SDL configuration
    SDL_VIDEODRIVER = "wayland,x11";
    SDL_JOYSTICK_HIDAPI = "1";

    # Mozilla applications
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";

    # Chromium/Electron Wayland support
    NIXOS_OZONE_WL = "1";
    OZONE_PLATFORM = "wayland";

    # Additional Wayland backends
    CLUTTER_BACKEND = "wayland";
    ELM_ENGINE = "wayland_egl";

    PYTHONSTARTUP = "$HOME/.config/python/pythonrc";
    PYTHON_HISTORY = "$HOME/.local/share/python/history";
    # X11 configuration files (XDGWayland-Compositor initialisiert direkt ohne
    # .xinitrc. XWayland wird automatisch vom Compositor gestartet)
    XINITRC =  "$HOME/.config/x11/xinitrc";
    # .xprofile wird nur bei X11-Sessions durch Display-Manager geparst.
    # Wayland-Sessions nutzen andere Mechanismen (systemd user services, compositor configs)
    XPROFILE = "$HOME/.config/x11/xprofile";
    # Native Wayland-Apps: Ignorieren .Xresources komplett.
    # XWayland-Apps: Können .Xresources lesen, wenn xrdb geladen wurde
    XRESOURCES = "$HOME/.config/x11/xresources";
    # XWayland benötigt dies: Authentifizierung zwischen Wayland-Compositor und XWayland-Server
#    XAUTHORITY = "${XDG_RUNTIME_DIR}/Xauthority";
    XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
    # Development tools (XDG compliance)
  CARGO_HOME = "$HOME/.local/share/cargo";
  GOBIN = "$HOME/.local/share/go/bin";
  GOMODCACHE = "$HOME/.cache/go/mod";
  GOPATH = "$HOME/.local/share/go";

    # Application-specific XDG paths
  ANDROID_HOME =        "$HOME/.local/share/android";
  FFMPEG_DATADIR =      "$HOME/.config/ffmpeg";
  GNUPGHOME =           "$HOME/.local/share/gnupg";
  GRADLE_USER_HOME = "$HOME/.local/share/gradle";
  NUGET_PACKAGES = "$HOME/.cache/NuGetPackages";
  PARALLEL_HOME = "$HOME/.config/parallel";
  VAGRANT_HOME = "$HOME/.local/share/vagrant";
  W3M_DIR = "$HOME/.local/share/w3m";
  WGETRC = "$HOME/.config/wget/wgetrc";
  LESSHISTFILE = "$HOME/.cache/less_history";
  };
  ##########################################################
  # SECTION SCHEMA: environment.etc
  # Purpose:
  #   - Declarative, read-only configuration files
  # Constraints:
  #   - No secrets
  #   - Deterministic content only
  # Security:
  #   - Read-only in /etc
  environment.etc."ccze/cczerc".source = ../assets/cczerc;
  environment.etc."bat/config.toml".source = ../assets/batrc.toml;
  environment.etc."zsh/less-termcap.sh".text = ''
    export LESS_TERMCAP_mb=$(printf '\033[1;31m')
    export LESS_TERMCAP_md=$(printf '\033[1;36m')
    export LESS_TERMCAP_me=$(printf '\033[0m')
    export LESS_TERMCAP_so=$(printf '\033[01;44;33m')
    export LESS_TERMCAP_se=$(printf '\033[0m')
    export LESS_TERMCAP_us=$(printf '\033[1;32m')
    export LESS_TERMCAP_ue=$(printf '\033[0m')
  '';

  ##########################################################
  # SECTION SCHEMA: systemd.user.tmpfiles.rules
  # Purpose:
  #   - Ensure standard user directories exist
  # Constraints:
  #   - Must be idempotent
  #   - Must not delete user data
  # Tests:
  #   - systemd-tmpfiles --user --create
  /*
  # tmpfiles-Typen im Überblick
Typ	Bedeutung
d	Verzeichnis erstellen, falls nicht vorhanden
D	Verzeichnis erstellen + bei Boot leeren
Z	Rekursiv Permissions/Ownership setzen
z	Permissions/Ownership setzen (nicht rekursiv)
"*", wenn alle User Zugriff bekommen sollen.*/
####
/*
systemd.user.tmpfiles.rules = [
  # Type  Path Mode User Group Age Argument
  "d %h/schreibtisch 0755 - - -"             # DESKTOP=schreibtsch
  "L+ %h/schreibtisch/pix.desktop - - - - /run/current-system/sw/share/applications/pix.desktop"
  "d %h/downloads 0755 - - -"               # DOWNLOAD=downloads
  "d %h/dokumente 0755 - - -"               # DOCUMENTS=dokumente
  "d %h/dokumente/templates 0755 - - -"     # TEMPLATES=dokumente/templates
  "d %h/public 0777 - - /share"                  # PUBLICSHARE=public
  "d %h/media 0755 - - -"                   # parent for media subdirs
  "d %h/media/music 0755 - - -"             # MUSIC=media/music
  "d %h/media/bilder 0755 - - -"            # PICTURES=media/bilder
  #"L+ %h/media/videos 0755 - - /home/video"
  # VIDEOS=/home/video  → absolute path, managed by fileSystems
  "d %h/bin 0755 - - -"                     # custom bin dir
  "L+ %h/bin/batNoComment - - - - %h/bin/batNoComment.sh"
  "L+ %h/bin/bNC - - - - %h/bin/batNoComment.sh"
  "L+ %h/bin/WO - - - - %h/bin/NIXwo.sh"
  ];
*/
# Shared absolute path outside $HOME — runs as root at system level
# Group 'video' — adjust if needed
systemd.tmpfiles.rules = [
  "d /home/video  0775  root  video  -  -"
];
 ##########################################################
   # SECTION SCHEMA: XDG user-dirs configuration
  # Purpose:
  #   - Define localized directory names
  # Constraints:
  #   - Must match tmpfiles layout
  ########################################################
  # Writes to /etc/xdg/user-dirs.dirs (system-wide default for all users)
  environment.etc = {
  # System-wide XDG user directory defaults
  # Read by: xdg-user-dirs-update on first login
  "xdg/user-dirs.defaults".text = ''
    DESKTOP=schreibtisch
    DOWNLOAD=downloads
    TEMPLATES=dokumente/templates
    PUBLICSHARE=public
    DOCUMENTS=dokumente
    MUSIC=media/music
    PICTURES=media/bilder
    VIDEOS=/home/video
  '';
};

  #######################################################
  # SECTION SCHEMA: documentation
  # Purpose:
  #   - Provide offline documentation and man pages
  # Constraints:
  #   - Cache generation must be deterministic
  #######################################################
  documentation.nixos.enable = true;
  documentation.man.enable = true;
  documentation.man.generateCaches = true;
  documentation.man.man-db.enable = true;

  environment.extraOutputsToInstall = [
    "info"
    "man"
  ];

 ##########################################################
  # SECTION SCHEMA: PATH handling
  # Purpose:
  #   - Ensure standard binary locations are reachable
  # Constraints:
  #   - Linked paths must be immutable or store-backed
 ##########################################################

  environment.homeBinInPath = true;
#  environment.localBinInPath = true;

  environment.pathsToLink = [
    "/share/icons"
    "/share/zsh"
    "/share/wallpaper"
    "/bin"
    "/etc/xdg"
    "/sbin"
    "/share/themes"
    "/share/thumbnailers"
    "/share/systemd"
  ];
}
/*


 # environment.extraSetup

/*
**`/share/icons`** → Dein Desktop (COSMIC) findet:
   - Papirus Icons
   - Kora Icons
   - Alle anderen installierten Icon-Themes
   - **Ohne dies:** Broken Icons in Apps!

**`/share/zsh`** → Deine Zsh-Shell findet:
   - Powerlevel10k Theme
   - Syntax-Highlighting Plugin
   - Autosuggestions Plugin
   - **Ohne dies:** Theme nicht gefunden!

### Visuelles Beispiel:
```
Nix-Store (verstreut):
/nix/store/abc-papirus/share/icons/Papirus/
/nix/store/def-kora/share/icons/Kora/
        ↓ pathsToLink erstellt Symlinks ↓
System-Profil (vereint):
-icons/
  ├── Papirus/ → zeigt auf /nix/store/abc-papirus/...
  └── Kora/ → zeigt auf /nix/store/def-kora/...
*/
