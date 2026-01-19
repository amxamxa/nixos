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
# 
# This module manages:
# - System-wide environment variables
# - User session variables (via PAM)
# - XDG Base Directory compliance
# - User/group configuration
# - Activation scripts for permissions
## nix-env -qaP '*' --description # You can get a list of the available packages as follows:
# lsblk -f --topology --ascii --all --list 
# setxkbmap -query -v

# https://github.com/Misterio77/flavours
# https://www.youtube.com/watch?v=AGVXJ-TIv3Y

{ config, pkgs, lib, ... }:
{
  # ============================================================================
  # ACTIVATION SCRIPTS
  # Display system changes on rebuild
  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = '' 
      ${pkgs.nvd}/bin/nvd --color auto --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
    '';
  };

  # ============================================================================
  # SYSTEM-WIDE ENVIRONMENT VARIABLES (environment.variables)
  # Used by: CLI tools, systemd services, non-GUI applications
  # Context: Available to all processes, set during shell initialization
  environment.variables = {
    # --- Core System Tools ---
    EDITOR = "${pkgs.micro}/bin/micro";
    VISUAL = "${pkgs.micro}/bin/micro";
    SYSTEMD_EDITOR = "${pkgs.micro}/bin/micro";
  # in .zshrc:
  /*
    # --- Man Page Rendering ---
    # Use bat for syntax-highlighted man pages
    # Note: 'col -bx' strips backspaces for clean text processing
    MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
    # --- Pager Configuration ---
    PAGER = "${pkgs.less}/bin/less -R";
    LESS = "R --use-color -Dd+r -Du+b";
 */   
    # --- Nix-Specific ---
    NIX_INDEX_DATABASE = "/share/nix-index";
    
    # --- Build Tools ---
    # Rust cargo home directory
    CARGO_HOME = "\${HOME}/.config/cargo";
    
    # Go language paths
    GOPATH = "\${XDG_DATA_HOME}/go";
    GOBIN = "\${XDG_DATA_HOME}/go/bin";
    GOMODCACHE = "\${XDG_CACHE_HOME}/go/mod";
  };
  # ============================================================================
  
  # ============================================================================
  # SESSION VARIABLES (environment.sessionVariables)
  # 
  # Used by: Graphical sessions, desktop environments, GUI applications
  # Context: Set via PAM during login, available to user sessions
  # 
  # CRITICAL PAM LIMITATIONS:
  # - Cannot use command substitutions: $(command)
  # - Cannot use unquoted dollar signs: use \${VAR} instead
  # - Cannot contain double quotes
  # - Cannot span multiple lines
  # - Complex values must go in shell init files
  
  environment.sessionVariables = {
    # --- XDG Base Directory Specification ---
    # Standard directories for user data/config
    # Using \${HOME} syntax for PAM compatibility
    XDG_CACHE_HOME = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_DATA_HOME = "\${HOME}/.local/share";
    XDG_STATE_HOME = "\${HOME}/.local/state";
    XDG_RUNTIME_DIR = "/run/user/\${UID}";
    
    # ────────────────────────────────────────────────────────────────────────
    # COSMIC Desktop Environment + Wayland Session Configuration
    # ────────────────────────────────────────────────────────────────────────
    
    # --- Session Type ---
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "COSMIC";
    XDG_SESSION_DESKTOP = "COSMIC";
    
    # --- GTK Toolkit (GTK3/GTK4) ---
    GDK_BACKEND = "wayland,x11";  # Prefer Wayland, fallback to X11
    GDK_SCALE = "1";              # UI scaling factor
    GDK_DPI_SCALE = "1.0";        # DPI scaling
    GTK2_RC_FILES = "\${XDG_CONFIG_HOME}/gtk-2.0/gtkrc-2.0";
    
    # --- Qt Toolkit (Qt5/Qt6) ---
    QT_QPA_PLATFORM = "wayland;xcb";           # Platform plugin order
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # Let compositor handle decorations
    QT_AUTO_SCREEN_SCALE_FACTOR = "0";         # Disable auto-scaling
    
    # --- SDL (Games/Emulators) ---
    SDL_VIDEODRIVER = "wayland,x11";  # Video driver preference
    SDL_JOYSTICK_HIDAPI = "1";        # Enable modern joystick support
    
    # --- Mozilla Firefox ---
    MOZ_ENABLE_WAYLAND = "1";  # Enable Wayland backend
    MOZ_USE_XINPUT2 = "1";     # Better input handling
    
    # --- Electron/Chromium Applications ---
    NIXOS_OZONE_WL = "1";      # NixOS-specific Wayland enabler
    OZONE_PLATFORM = "wayland"; # Force Wayland platform
    
    # --- Legacy Toolkits ---
    CLUTTER_BACKEND = "wayland";
    ELM_ENGINE = "wayland_egl";
    
    # --- Display/Color Management ---
    WLR_DRM_NO_ATOMIC = "0";   # Use atomic modesetting (better performance)
    COLOR_MANAGEMENT = "0";     # Disable color management (COSMIC limitation)
    
    # ────────────────────────────────────────────────────────────────────────
    # XDG-Compliant Application Configurations
    # Moving configs from home directory to XDG standard locations
    # ────────────────────────────────────────────────────────────────────────
    
    # --- History Files ---
    LESSHISTFILE = "\${XDG_CACHE_HOME}/less_history";
    PYTHON_HISTORY = "\${XDG_DATA_HOME}/python/history";
    
    # --- X11 Configuration (if needed for compatibility) ---
    XINITRC = "\${XDG_CONFIG_HOME}/x11/xinitrc";
    XPROFILE = "\${XDG_CONFIG_HOME}/x11/xprofile";
    XRESOURCES = "\${XDG_CONFIG_HOME}/x11/xresources";
    XAUTHORITY = "\${XDG_RUNTIME_DIR}/Xauthority";
    
    # --- Development Tools ---
    WGETRC = "\${XDG_CONFIG_HOME}/wget/wgetrc";
    PYTHONSTARTUP = "\${XDG_CONFIG_HOME}/python/pythonrc";
    GNUPGHOME = "\${XDG_DATA_HOME}/gnupg";
    
    # --- Build Systems & Package Managers ---
# -> npm.nix
    GRADLE_USER_HOME = "\${XDG_DATA_HOME}/gradle";
    NUGET_PACKAGES = "\${XDG_CACHE_HOME}/NuGetPackages";
    
    # --- Miscellaneous ---
    PARALLEL_HOME = "\${XDG_CONFIG_HOME}/parallel";
    FFMPEG_DATADIR = "\${XDG_CONFIG_HOME}/ffmpeg";
    ANDROID_SDK_HOME = "\${XDG_DATA_HOME}/android";
    VAGRANT_HOME = "\${XDG_DATA_HOME}/vagrant";
    W3M_DIR = "\${XDG_DATA_HOME}/w3m";
    WWW_HOME = "\${HOME}/.config/w3m";
    
    # --- Custom Application Configs ---
    # These are specific to your setup
    TEALDEER_CONFIG_DIR = "/share/zsh/tldr";
    NAVI_CONFIG = "/share/zsh/navi/config.yaml";
    GIT_CONFIG = "/share/zsh/git/config";
    BAT_CONFIG_FILE = "/share/bat/config.toml";
    KITTY_CONFIG_DIRECTORY = "/share/kitty";
  };

  # ============================================================================
  # SHELL CONFIGURATION FILES
  # Complex variables that cannot be set via PAM go here
  
  # --- Less Termcap Colors for Colored Man Pages ---
  environment.etc."zsh/less-termcap.sh".text = ''
    # Colored man pages via less termcap
    export LESS_TERMCAP_mb=$(printf '\033[1;31m')      # blinking - red
    export LESS_TERMCAP_md=$(printf '\033[1;36m')      # bold - cyan
    export LESS_TERMCAP_me=$(printf '\033[0m')         # end mode
    export LESS_TERMCAP_so=$(printf '\033[01;44;33m')  # standout - yellow on blue
    export LESS_TERMCAP_se=$(printf '\033[0m')         # end standout
    export LESS_TERMCAP_us=$(printf '\033[1;32m')      # underline - green
    export LESS_TERMCAP_ue=$(printf '\033[0m')         # end underline
  '';

  # ============================================================================
  # XDG USER DIRECTORIES
  # German directory names
    environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=desktop
    DOCUMENTS=dokumente
    DOWNLOAD=downloads
    MUSIC=music
    PICTURES=bilder
    PUBLICSHARE=public
    TEMPLATES=dokumente/vorlagen
    VIDEOS=videos
  '';
# Enable NixOS-specific documentation, including the NixOS manual
  documentation.nixos.enable = true;
  # Enable system-wide man pages. This uses man-db by default.
  documentation.man.enable = true;
  # Crucially, enable the generation of the 'whatis' database cache.
  # This is required for search functionality like 'man -k' and our fzf widget.
  documentation.man.generateCaches = true;
  documentation.man.man-db.enable = true;
  # documentation.man.mandoc.manPath [ "share/man" "share/man/de" ]

  # ============================================================================
  # ADDITIONAL SYSTEM SETTINGS
  environment.extraOutputsToInstall = [
       "info"        "man"
  ];   
  # Add ~/bin to PATH
  environment.homeBinInPath = true;
  # Add ~/.local/bin/ to $PATH
  environment.localBinInPath = true;
  
 # environment.extraSetup 
  # Create symlinks to share directories # /run/current-system/sw/share/applications...
#
## tshoot: /run/current-system/sw/ ...  (share/icons)
    environment.pathsToLink = [
  "/share/icons"  # Alle Icon-Themes zusammenführen     
  "/share/zsh"    # Alle Zsh-Themes/Plugins zusammenführen
  "/share/wallpaper"
  "/bin"
  "/etc/xdg"
 "/sbin"
  "/share/themes"
  "/share/thumbnailers"
  "/share/systemd"
];
/*
**`/share/icons`** → Dein Desktop (COSMIC) findet:
   - Papirus Icons
   - Kora Icons  
   - Alle anderen installierten Icon-Themes
   - **Ohne dies:** Broken Icons in Apps!

2. **`/share/zsh`** → Deine Zsh-Shell findet:
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
}

