{ config, pkgs, lib, ... }:
{
  services.fwupd.enable = true;
  
  nix.settings = {
    download-buffer-size = 268435456;  # 256 MB
    #134217728;
    http-connections = 25;        # Max parallel HTTP connections
    max-jobs = "auto";            # Parallel builds
    cores = 3;                    # 0=Use all available cores
    experimental-features = [ "nix-command" ]; #Aktiviert Cmds: nix search, nix run, nix shell
#    extra-sandbox-paths = [ "/dev/nvidiactl" "/dev/nvidia0" "/dev/nvidia-uvm" ];
  };
  
  gtk.iconCache.enable = true; #   Improve GTK icon cache generation to ensure immediate visibility
# Enable automount for removable media
 services.udisks2.enable = true;

   boot.supportedFilesystems = [ "ntfs" ];
  # programs.pay-respects = true; #  This usually happens if `programs.pay-respects' has option        definitions inside that are not matched. Please check how to properly define       this option by e.g. referring to `man 5 configuration.nix'!insteadt  programs.thefuck
programs.pay-respects.enable = true;

  environment.variables = {
    EDITOR = "${pkgs.micro}/bin/micro";
       VISUAL =  "${pkgs.micro}/bin/micro";
       SYSTEMD_EDITOR =  "${pkgs.micro}/bin/micro";
       
   #Wayland-spezifische Umgebungsvariablen
    GDK_BACKEND = "x11,wayland";
    QT_QPA_PLATFORM = "xcb";
    SDL_VIDEODRIVER = "x11";
    CLUTTER_BACKEND = "x11";
    MOZ_ENABLE_WAYLAND = "0";
  
  XDG_DATA_HOME="$HOME/.local/share";
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
 #  HISTFILE="$XDG_STATE_HOME/bash/history"
   # WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
   #DATE="$(date "+%A, %B %e  %_I:%M%P")";

   FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 30% --preview='bat -p --color=always {}'";
   FZF_CTRL_R_OPTS="--style minimal --color 16 --info inline --no-sort --no-preview"; # separate opts for history widget
   MANPAGER="less -R --use-color -Dd+r -Du+b"; # colored man pages

# colored less + termcap vars
  
  LESS="R --use-color -Dd+r -Du+b";
  LESS_TERMCAP_mb="$(printf '%b' '[1;31m')";  # blinking - red
  LESS_TERMCAP_md="$(printf '%b' '[1;36m')";  # bold - cyan
  LESS_TERMCAP_me="$(printf '%b' '[0m')";     # end mode
  LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"; # standout - yellow on blue
  LESS_TERMCAP_se="$(printf '%b' '[0m')";     # end standout
  LESS_TERMCAP_us="$(printf '%b' '[1;32m')";  # underline - green
  LESS_TERMCAP_ue="$(printf '%b' '[0m')";     # end underline

     BOLD="\033[1m";
     GRE2="\033[38;2;0;255;0m\033[48;2;0;25;2m";
     RED2="\033[38;2;240;138;100m\033[48;2;147;18;61m"; 
    # Farben für UI-Konfiguration (.zshenv)
    RESET= lib.mkDefault "\\033[0m";
    GREEN= lib.mkDefault "\\033[38;2;0;255;0m\033[48;2;0;100;0m";
    RED= lib.mkDefault "\\033[38;2;240;128;128m\033[48;2;139;0;0m";
    YELLOW= lib.mkDefault "\\033[38;2;255;255;0m\033[48;2;128;128;0m";
    NIGHT="\\033[38;2;252;222;90m\033[48;2;0;0;139m";
    
    LAV="\\033[38;2;204;153;255m\033[48;2;102;51;153m";
    PUNK="\\033[38;2;0;17;204m\033[48;2;147;112;219m";
    RASP="\\033[38;2;32;0;21m\033[48;2;163;64;217m";
    PINK="\\033[38;2;255;105;180m\033[48;2;75;0;130m";
    FUCHSIA="\\033[38;2;239;217;129m\033[48;2;59;14;122m";
    VIOLET="\033[38;2;255;0;53m\033[48;2;34;0;82m";
    
    BROWN="\\033[38;2;239;217;129m\033[48;2;210;105;30m";
    LEMON="\\033[38;2;216;101;39m\033[48;2;218;165;32m";
    CORAL="\\033[38;2;252;222;90m\033[48;2;240;128;128m";
    GOLD="\\033[38;2;255;0;53m\033[48;2;218;165;32m";
    ORANGE="\\033[38;2;0;17;204m\033[48;2;255;140;0m";
    GREY="\\033[38;2;252;222;90m\033[48;2;192;192;192m";
    MINT="\\033[38;2;6;88;96m\033[48;2;144;238;144m";
    SKY="\\033[38;2;62;36;129m\033[48;2;135;206;235m";
    LIME="\\033[38;2;6;88;96m\033[48;2;0;255;255m";
    PETROL="\\033[38;2;0;17;204m\033[48;2;32;178;170m";
    CYAN="\\033[38;2;64;224;208m\033[48;2;0;128;128m";
    OLIVE="\\033[38;2;0;74;40m\033[48;2;107;142;35m";
};

environment.systemPackages = with pkgs; [
  linux-firmware
  gpaste
  zenity # Tool to display dialogs from the commandline and shell scripts
     libnotify # notify-send
  file-roller
  # Theming and Appearance 
  ## tshoot: /run/current-system/sw/share/icons
  #pop-icon-theme # Pop!_OS icon theme
  fluent-icon-theme
  #flat-remix-icon-theme
  # lomiri.suru-icon-theme
  # numix-icon-theme
  # faba-mono-icons
  oranchelo-icon-theme # Oranchelo icon theme
  papirus-icon-theme # Pixel perfect icon theme for Linux
  papirus-folders # Tool to change papirus icon theme color
   
  whitesur-gtk-theme # MacOS Big Sur theme for GNOME
  andromeda-gtk-theme # elegant dark theme for gnome, cinnamon
  #greetd
  #regreet # Clean and customizable greeter for greetd
  #cage #   Wayland kiosk that runs a single, maximized application
  # cagebreak # Wayland tiling compositor inspired by ratpoison
  
  #  mint-cursor-themes
  xwayland # X server for interfacing X11 apps with the Wayland protocol


#  wayback-x11 # X11 compatibility layer leveraging wlroots and Xwayland
  afterglow-cursors-recolored #Recoloring of the Afterglow Cursors x-cursor theme
xorg.xcursorthemes
  #xcursor-themes # Default set of cursor themes for use with libXcursor.
  themechanger # Theme changing utility for Linux statt # themix-gui
 pay-respects # Terminal command correction, alternative to thefuck, written in Rust
  
 ];

}
