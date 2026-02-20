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

#    ▄▄▄▄▀ ▄███▄   █▄▄▄▄ █▀▄▀█     
# ▀▀▀ █    █▀   ▀  █  ▄▀ █ █ █     
#     █    ██▄▄    █▀▀▌  █ ▄ █     
#    █     █▄   ▄▀ █  █  █   █     
#   ▀      ▀███▀     █      █      
#                   ▀      ▀                                      
# ▄█▄    ████▄ █    ████▄ █▄▄▄▄   ▄▄▄▄▄   
# █▀ ▀▄  █   █ █    █   █ █  ▄▀  █     ▀▄ 
# █   ▀  █   █ █    █   █ █▀▀▌ ▄  ▀▀▀▀▄   
# █▄  ▄▀ ▀████ ███▄ ▀████ █  █  ▀▄▄▄▄▀    
# ▀███▀            ▀        █             
#                          ▀       
# export cols for echo, printf                                                   
environment.etc."colorEnvExport.sh" = {
      text = ''
      #!/usr/bin/env bash
        # kitty term supports 24-bit RGB colors 
        export RED=$'\033[38;2;240;128;128m\033[48;2;139;0;0m'
        export GELB=$'\e[33m'
        export GREEN=$'\033[38;2;0;255;0m\033[48;2;0;100;0m'
        export PINK=$'\033[38;2;255;0;53m\033[48;2;34;0;82m'
        export LILA=$'\033[38;2;255;105;180m\033[48;2;75;0;130m'
        export LIL2=$'\033[38;2;239;217;129m\033[48;2;59;14;122m'
        export VIO=$'\033[38;2;255;0;53m\033[48;2;34;0;82m'
        export BLUE=$'\033[38;2;252;222;90m\033[48;2;0;0;139m'
        export NIGHT=$'\033[38;2;150;180;220m\033[48;2;10;15;30m'
        export LIME=$'\033[38;2;6;88;96m\033[48;2;0;255;255m'
        export YELLO=$'\033[38;2;255;215;0m\033[48;2;60;50;0m'
        export LAVEN=$'\033[38;2;200;170;255m\033[48;2;40;30;70m'
        export PINK2=$'\033[38;2;255;105;180m\033[48;2;60;20;40m'
        export RASPB=$'\033[38;2;190;30;90m\033[48;2;50;10;30m'
        export VIOLE=$'\033[38;2;170;0;255m\033[48;2;30;0;60m'
        export ORANG=$'\033[38;2;255;140;0m\033[48;2;60;30;0m'
        export CORAL=$'\033[38;2;255;110;90m\033[48;2;70;30;20m'
        export GOLD=$'\033[38;2;255;200;60m\033[48;2;80;60;10m'
        export OLIVE=$'\033[38;2;120;140;40m\033[48;2;40;50;20m'
        export PETRO=$'\033[38;2;0;160;160m\033[48;2;0;40;40m'
        export CYAN=$'\033[38;2;80;220;220m\033[48;2;0;50;50m'
        export GREY=$'\033[38;2;200;200;200m\033[48;2;60;60;60m'
        export TEAL=$'\033[38;2;0;180;140m\033[48;2;0;60;50m'
        export MINT=$'\033[38;2;150;255;200m\033[48;2;20;60;40m'
        export SKY=$'\033[38;2;120;200;255m\033[48;2;30;60;80m'
        export PLUM=$'\033[38;2;180;80;200m\033[48;2;50;20;60m'
        export BROWN=$'\033[38;2;160;110;60m\033[48;2;50;30;10m'
        export IVORY=$'\033[38;2;255;250;220m\033[48;2;80;70;50m'
        export SLATE=$'\033[38;2;150;160;170m\033[48;2;40;50;60m'
        export INDIG=$'\033[38;2;90;0;130m\033[48;2;30;0;50m'
        export EMBER=$'\033[38;2;255;80;40m\033[48;2;60;20;10m'
        export BOLD=$'\033[1m'
        export BLINK=$'\033[5m'
        export UNDER=$'\033[4m'
        export RESET=$'\033[0m'
   
      '';
      mode = "0444"; # read-only
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
    MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
    PAGER = "${pkgs.less}/bin/less -R";
    
    # Static configuration values
    LESS = "R --use-color -Dd+r -Du+b";
    NIX_INDEX_DATABASE = "/share/nix-index";
    
    # Shared system-wide paths (not user-dependent)
    TEALDEER_CONFIG_DIR = "/share/zsh/tldr";
    NAVI_CONFIG = "/share/zsh/navi/config.yaml";
    GIT_CONFIG = "/share/zsh/git/config";
    BAT_CONFIG_FILE = "/share/bat/config.toml";
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
    
    # Default applications
    VISUAL = "${pkgs.gnome-text-editor}/bin/gnome-text-editor";
    
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
    
    LESSHISTFILE = "$HOME/.cache/less_history";
    
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
    ANDROID_HOME = "$HOME/.local/share/android";
  FFMPEG_DATADIR = "$HOME/.config/ffmpeg";
  GNUPGHOME = "$HOME/.local/share/gnupg";
  GRADLE_USER_HOME = "$HOME/.local/share/gradle";
#  GTK2_RC_FILES = "$HOME/.config/gtk-2.0/gtkrc-2.0";
  NUGET_PACKAGES = "$HOME/.cache/NuGetPackages";
  PARALLEL_HOME = "$HOME/.config/parallel";
  VAGRANT_HOME = "$HOME/.local/share/vagrant";
  W3M_DIR = "$HOME/.local/share/w3m";
  WGETRC = "$HOME/.config/wget/wgetrc";
  
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
####
  systemd.user.tmpfiles.rules = [
    "d %h/desktop 0755 - - -"
    "d %h/downloads 0755 - - -"
    "d %h/dokumente 0755 - - -"
    "d %h/dokumente/vorlagen 0755 - - -"
    "d %h/music 0755 - - -"
    "d %h/bilder 0755 - - -"
    "d %h/videos 0755 - - -"
    "d %h/public 0755 - - -"

    "L+ %h/bin/WO - - - - %h/bin/NIXwo.sh"
    "L+ %h/desktop/pix.desktop - - - - /run/current-system/sw/share/applications/pix.desktop"
  ];

##########################################################
   # SECTION SCHEMA: XDG user-dirs configuration
  # Purpose:
  #   - Define localized directory names
  # Constraints:
  #   - Must match tmpfiles layout
  ########################################################
  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=desktop
    DOWNLOAD=downloads
    TEMPLATES=dokumente/vorlagen
    PUBLICSHARE=public
    DOCUMENTS=dokumente
    MUSIC=music
    PICTURES=bilder
    VIDEOS=videos
  '';

  environment.etc."xdg/user-dirs.conf".text = ''
    enabled=False
    filename_encoding=UTF-8
  '';

 ##########################################################
    # SECTION SCHEMA: documentation
  # Purpose:
  #   - Provide offline documentation and man pages
  # Constraints:
  #   - Cache generation must be deterministic
  ############################################################
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
  environment.localBinInPath = true;

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

