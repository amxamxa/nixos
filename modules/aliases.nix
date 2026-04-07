# aliases.nix
{ config, lib, pkgs, ... }:
# globale aliase fuer zsh, bash, ...
/* NIX-spezific:
- Maskierung von Sonderzeichen (Escaping) beachten \"
- semikolon und kein leerzeichen
- FIX: Shell-Variablen ${VAR} in ''...'' als ''${VAR} escapen


Mehrzeilige Strings: In Nix werden mehrzeilige Strings mit zwei einfachen Anführungszeichen ('') umschlossen.
{ config, lib, pkgs, ... }:
# globale aliase fuer zsh, bash, ...
/* NIX-spezific:
- Maskierung von Sonderzeichen (Escaping) beachten \"
- semikolon und kein leerzeichen
- FIX: Shell-Variablen ${VAR} in ''...'' als ''${VAR} escapen

Mehrzeilige Strings: In Nix werden mehrzeilige Strings mit zwei einfachen Anführungszeichen ('') umschlossen.
Escaping: Sonderzeichen wie ", $, und \ müssen ggf. escaped werden, falls sie in der Shell-Interpretation zu Konflikten führen.
---------------------------------------------------------
*/

let
  inherit (lib) mkIf mkMerge;

  # Shared eza base flags — included permutatively in every eza listing alias.
  # NOTE: --no-permissions hides the permission column entirely;
  #       --octal-permissions replaces it with octal notation.
  #       Both flags are included as requested — eza resolves the conflict
  #       by letting the last flag win (behaviour may vary by version).
  eza-flags = " --long  --group  --header "
  +           " --smart-group  -@  --group-directories-first "
  +           " --octal-permissions   --no-permissions  "
  +           " --icons auto   --links  ";

in
{
 /* ---------------------------------------------------------
 Aliases alphabetisch sortiert + mkIf pro Programm
          ██   █    ▄█ ██      ▄▄▄▄▄
        █ █  █    ██ █ █    █     ▀▄
        █▄▄█ █    ██ █▄▄█ ▄  ▀▀▀▀▄
        █  █ ███▄ ▐█ █  █  ▀▄▄▄▄▀
           █     ▀ ▐    █
          ▀            ▀
#       e x a / e z a .. ls  ll  lh  ld ...
alias eweb='echo -e "\t''${EMBER}eza-Ansicht für Web-Projekte (z.B. Hugo)''${RESET}" && eza --no-git --total-size --git-ignore -A -tree'
alias e-hugo='eweb'
alias lp='echo -e "\t''${EMBER}eza-Auflistung mit Fokus auf Git-Status''${RESET}" && eza --octal-permissions --git -Al --git-repos --no-permissions --time-style=relative --group-directories-first --smart-group'
alias ep=lp
*/

environment.shellAliases = mkMerge [
  {
    # --- Always available aliases ---
    h       = "history";
    q      = "exit";
    c       = "clear";
    env2g   = "g2env";
    ali2g   = "g2ali";
    g2lol   = "g2ali";
    lol2g   = "g2ali";
    ".."    = "cd ..";
    AUS     = "shutdown now";
    EIN     = "shutdown -r now";
    Reboot  = "shutdown -r now";
    lol     = "alias | sort | blahaj -c bi -b";

    NIXoi = ''
      echo -e "\t''${NIGHT}sudo nixos-rebuild switch --profile-name xam4boom --upgrade -I nixos-config=/etc/nixos/configuration.nix ''${EMBER}" && \
      sudo nixos-rebuild switch \
        --show-trace --upgrade --profile-name "xam4boom" \
        -I nixos-config=/etc/nixos/configuration.nix && \
      echo -e "__________end ''${RESET}"
    '';

    NIXboom = ''
      echo -e "\t''${NIGHT}sudo nixos-rebuild boot --profile-name \"xam4boot\" --upgrade -I nixos-config=/etc/nixos/configuration.nix ''${EMBER}" && \
      sudo nixos-rebuild boot \
        --show-trace --upgrade --profile-name "xam4boot" \
        -I nixos-config=/etc/nixos/configuration.nix && \
      echo -e "__________end ''${RESET}"
    '';

    # NIXcmd = ''      echo -e "\t''${NIGHT}Active system-generation binaries → Nix store symlinks''${RESET}" &&       eza -A --long --no-permissions --no-user --no-time --no-filesize --icons auto /run/current-system/sw/bin ||      command ls -l --color=always /run/current-system/sw/bin | awk 'NR>1 {print ''$9, ''$10, ''$11}'    '';
        NIXpkgs = ''echo -e "\t''${EMBER}Active system-generation binaries → Nix store symlinks''${RESET}" && eza -1 --classify /run/current-system/sw/bin || command ls -1 /run/current-system/sw/bin'';
    NIXbin = "NIXpkgs";

    NIXinfo = "nix-info --host-os --sandbox --markdown";

    NIXboot = ''
      echo -e "\t ''${EMBER}NixOS - Bootbare Konfigurationen ''${RESET}" && \
      cd /nix/var/nix/profiles/ && \
      eza --octal-permissions -U --header --long --tree --almost-all /nix/var/nix/profiles/
    '';
    NIXref = ''
      echo -e "\t''${EMBER}Z Alias accepts the store path as an argument: NIXref       nix-store -q --references /nix/store/<hash>''${RESET}" && \
      nix-store -q --references
    '';
    DIFF = ''
      echo -e "\t''${NIGHT}colordiff mit erweiterten Ignore-Optionen''${RESET}" && \
      colordiff --ignore-case --ignore-tab-expansion \
        --ignore-trailing-space --ignore-space-change \
        --ignore-all-space --ignore-blank-lines
    '';
    COL256 = ''
      for i in {0..255}; do
        printf "\e[38;5;''${i}mcolor%-5i\e[0m" "$i"
        if (( ($i + 1) % 8 == 0 )); then echo; fi
      done
      echo -e "\n\tSYNTAX: 38;5;<colorXYZ>:\n\tz.B.: 38;5;125"
    '';
    FClist = "FClist.sh || $HOME/bin/FClist.sh";
    FARBE  = ''echo -e "\t''${EMBER}Lade Farbskript''${RESET}" && source "$ZDOTDIR/functions/colors.sh"'';
e = ''
    echo -e "\t ''${EMBER} eza (´FILE*´ for execute perm. ´DIR/´ for directory)''${RESET}" && \
    eza --all --classify
  '';
  ee = ''
    echo -e "\t ''${EMBER} eza (´FILE*´ for execute perm. ´DIR/´ for directory)''${RESET}" && \
    eza --long -A --classify
  '';
  # One entry per line (--oneline overrides --long from eza-flags, harmless)
  eee = ''
    echo -e "\t ''${EMBER} ''${BLINK} eza — one entry per line''${RESET}" && \
    sleep 2 && \
    eza --all --oneline
  '';


  }


(mkIf (builtins.hasAttr "eza" pkgs) (let
  eza-git = ''echo -e "''${EMBER}eza (git status)''${RESET}" && eza --all --classify --git ${eza-flags}'';

  eza-ext = ''echo -e "''${EMBER}eza (sorted by extension)''${RESET}" && eza --all --classify --sort extension ${eza-flags}'';

  eza-size = ''echo -e "''${EMBER}eza (sorted by size)''${RESET}" && eza --all --classify --total-size --sort size ${eza-flags}'';

  eza-size-warn = eza-size + '' && echo -e "''${ORANG}WARNING: ls shadows POSIX ls — rename to 'el' if scripts break''${RESET}"'';

  eza-files = ''echo -e "''${EMBER}eza (only files)''${RESET}" && eza --all --classify --only-files ${eza-flags}'';

  eza-dirs = ''echo -e "''${EMBER}eza (only dirs)''${RESET}" && eza --all --classify --only-dirs ${eza-flags}'';

  eza-time = ''echo -e "''${EMBER}eza (sorted by time)''${RESET}" && eza --all --classify --sort time ${eza-flags}'';
in {


 # --- Basic views ---
  # All aliases include the shared base flags from the 'eza-flags' let-binding above.
  # Default: all entries with type indicators
  # --- Long/detail views ---
  # Git-status view
  Eg = eza-git;
  lg = eza-git;
  eg = eza-git;
  # Sorted by extension
  Ex = eza-ext;
  lx = eza-ext;
  ex = eza-ext;
  # Sorted by size (with recursive total-size)
  Es = eza-size;
  ls = eza-size-warn;
  es = eza-size;
  # Only files (no directories)
  Ef = eza-files;
  lf = eza-files;
  ef = eza-files;
  # Only directories)
  Ed = eza-dirs;
  ld = eza-dirs;
  ed = eza-dirs;
  # Sorted by modification time
  Et = eza-time;
  lt = eza-time;
  et = eza-time;
  # --- Tree views ---
  # Shallow overview (level 1)
  e1 = ''
    echo -e "\t''${VIOLE} eza --tree --level 1''${RESET}\n" && \
    eza --all --tree --level 1 --group-directories-first --width 76 ${eza-flags}
  '';
  # Standard project view (level 2)
  e2 = ''
    echo -e "\t''${VIOLE} eza --tree --level 2''${RESET}\n" && \
    eza --all --tree --level 2 --group-directories-first --width 76 ${eza-flags}
  '';
  # Medium depth (level 3)
  e3 = ''
    echo -e "\t''${VIOLE} eza --tree --level 3''${RESET}\n" && \
    sleep 2 &&  \
    eza --all --tree --level 3 --group-directories-first --width 76 ${eza-flags}
  '';
  # Full recursive tree with git status (level 77 = effectively unlimited)
  e4 = ''
  echo -e "\t''${VIOLE} eza --tree --level unlimited (77) --git''${RESET}\n" && \
    sleep 2 && \
    eza --all --tree --level 77 --group-directories-first --width 76 --git ${eza-flags}
  '';
  }))

  # --- fd ---
  (mkIf (builtins.hasAttr "fd" pkgs) {
    fd = ''
      fd  --exclude "/dev" --exclude "/nix/var" \
          --exclude "/proc" --exclude "/sys"    \
          --exclude "/run" --exclude "/var/lib"
    '';
  })

  # --- glow → markdown ---
  (mkIf (builtins.hasAttr "mdcat" pkgs) {
    MD = "mdless README.md";
  })

  # --- bat ---
  (mkIf (builtins.hasAttr "bat" pkgs) {
    bat     = "bat6";
    bap     = "bat -pp";
    bat6    = "command bat --wrap=auto --decorations=always --theme=gruvbox-dark";
    bat1    = "command bat --wrap=auto --plain --terminal-width 76 --theme=ansi";
    bat2    = "command bat --wrap=auto --plain --terminal-width 80 --theme=Dracula";
    bat3    = "command bat --wrap=auto --decorations=always --theme=Coldark-Dark";
    bat4    = "command bat --wrap=auto --number --decorations=always --theme=OneHalfDark";
    bat5    = "command bat --wrap=never --number --decorations=always --theme=base16";
    BATconf = ''echo -e "\t''${EMBER}Öffne bat Konfigurationsdatei''${RESET}" && micro /etc/bat/config.toml'';
    Bconf   = "BATconf";
  })

  # --- git ---
  (mkIf (builtins.hasAttr "git" pkgs) {
    ga    = ''echo -e "''${VIOLE}\nFügt Änderungen hinzu''${RESET}\n" && git add'';
    gc    = ''echo -e "''${VIOLE}\ncommit''${RESET}\n" && git commit'';
    gb    = ''echo -e "''${VIOLE}\nZeigt Branches''${RESET}\n" && git branch'';
    gblog = ''git for-each-ref --sort=committerdate refs/heads/ --format="%(HEAD) %(refname:short) - %(objectname:short) - %(contents:subject) - %(authorname) (%(committerdate:relative))"'';
    glol  = ''echo -e "''${VIOLE}\nCommit-Historie''${RESET}\n" && git log --graph --abbrev-commit --oneline --decorate'';
    gp    = ''echo -e "''${VIOLE}\nPush''${RESET}\n" && git push'';
    gr    = ''echo -e "''${VIOLE}\nRemote Repos''${RESET}\n" && git remote'';
    grb   = ''echo -e "''${VIOLE}\nRemote Branches''${RESET}\n" && git branch -r'';
    grs   = ''echo -e "''${VIOLE}\nRemote Info''${RESET}\n" && git remote show'';
    gll   = ''
  echo -e "''${VIOLE}\nFarbig formatierte Ausgabe der Commit-Historie in Graph-Darstellung''${RESET}\n" && \
  git log --graph --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)" --all
    '';
    gss   = ''cowsay -nW 60 "$(echo -e "''${NIGHT}[Git Status]''${RESET}\n$(git status -s)")" && echo -e "\n''${EMBER}Legende:''${RESET}\nM Modified A Staged\nD Deleted R Renamed\nC Copied\n? Untracked"'';
    gs    = ''echo -e "''${EMBER}\n git status --short ''${RESET}" && git status -s'';
  })

  # --- btop ---
  (mkIf (builtins.hasAttr "btop" pkgs) {
    top = "btop";
  })

  # --- duf ---
  (mkIf (builtins.hasAttr "duf" pkgs) {
    df = ''echo -e "\t''${EMBER} duf''${RESET}" && duf'';
  })

  # --- ccze ---
  (mkIf (builtins.hasAttr "ccze" pkgs) {
    ccze = "command ccze -F /etc/ccze/cczerc";
  })

  # --- kitty ---
  (mkIf (builtins.hasAttr "kitty" pkgs) {
    KITTYconf = ''echo -e "\t''${EMBER}Öffne kitty.conf''${RESET}" && gnome-text-editor "$XDG_CONFIG_HOME/kitty/kitty.conf" 2>/dev/null || micro "$KITTY_CONFIG_DIRECTORY/kitty.conf"'';
    Kconf     = "KITTYconf";
    KITTYmap  = ''echo -e "\t''${EMBER}Zeige Tastaturbelegungen''${RESET}" && batNoComment "$KITTY_CONFIG_DIRECTORY/kitty.conf" || grep "map"'';
    Kbind     = "KITTYmap";
    Kmap      = "KITTYmap";
  })

  # --- zoxide ---
  (mkIf (builtins.hasAttr "zoxide" pkgs) {
    za  = ''echo -e "\t''${EMBER}Add to zoxide''${RESET}" && zoxide add'';
    zq  = ''echo -e "\t''${EMBER}Query zoxide''${RESET}" && zoxide query'';
    zqi = ''echo -e "\t''${EMBER}Interactive query''${RESET}" && zoxide query -i'';
    zr  = ''echo -e "\t''${EMBER}Remove from zoxide''${RESET}" && zoxide remove'';
  })

  # --- broot ---
  (mkIf (builtins.hasAttr "broot" pkgs) {
    BR    = "broot";
    BRd   = "broot --sizes";
    BRg   = "broot --gitignore yes";
    BRh   = "broot --hidden";
    BRhs  = "broot --hidden --sizes";
    BRi   = "broot --show-root-fs";
    BRgs  = "broot --git-status";
    BRgl  = "broot --gitignore no";
    BRp   = "broot --permissions";
  })

  # --- neofetch ---
  (mkIf (builtins.hasAttr "neofetch" pkgs) {
    neo  = ''echo -e "\t''${EMBER} neofetch w/ ''${LILA}\t$ZDOTDIR/neofetch/spaceinv.conf\t''${RESET}" && neofetch --config "$ZDOTDIR/neofetch/spaceinv.conf"'';
    neo0 = "neo";
    neo1 = ''echo -e "\t  ''${EMBER}neofetch w/ ''${LILA}\t$ZDOTDIR/neofetch/neofetch-short.conf\t''${RESET}" && neofetch --config "$ZDOTDIR/neofetch/neofetch-short.conf"'';
    neo2 = ''echo -e "\t''${EMBER} neofetch w/ ''${LILA}\t$ZDOTDIR/neofetch/config2.conf\t''${RESET}" && neofetch --config "$ZDOTDIR/neofetch/config2.conf"'';
    neo3 = ''
      echo -e "\t''${LIME}   -  󱚡  --   --  🙼 🙼 🙼      󱢇     🙽 🙽 🙽   --    --  󱚡  --    -" && \
      echo -e "\t''${EMBER}  neofetch w/ ''${LILA}\t$ZDOTDIR/neofetch/neofetch-long.conf\t''${RESET}" && \
      echo -e "\t''${CYAN}   -  󱚡  --   --  🙼 🙼 🙼   󱢇     󱢇  🙽 🙽 🙽   --    --  󱚡  --    -" && \
      neofetch --config "$ZDOTDIR/neofetch/neofetch-long.conf"
    '';
    neo4 = ''echo -e "\t''${EMBER} neofetch w/ ''${LILA}\ta for loop of themes\t/home/project/neofetch-themes''${RESET}" && bash -c /home/project/neofetch-themes/for-loop.sh'';
  })

  # --- pandoc ---
  (mkIf (builtins.hasAttr "pandoc" pkgs) {
    MD2pdf = ''pandoc "$1" -o "''${1%.md}.pdf" --template=''$HOME/dokumente/vorlagen/MDtoPDF.tex'';
  })
];

# Funktionen (alphabetisch sortiert)
#  ▄████ ▄      ▄   ▄█▄      ▄▄▄▄▀ ▄█ ████▄    ▄      ▄▄▄▄▄
#  █▀   ▀ █      █  █▀ ▀▄ ▀▀▀ █    ██ █   █     █    █     ▀▄
#  █▀▀ █   █ ██   █ █   ▀     █    ██ █   █ ██   █ ▄  ▀▀▀▀▄
#  █   █   █ █ █  █ █▄  ▄▀   █     ▐█ ▀████ █ █  █  ▀▄▄▄▄▀
#  █  █▄ ▄█ █  █ █ ▀███▀   ▀       ▐       █  █ █
#   ▀  ▀▀▀  █   ██                         █   ██
# --------------------------------------------------------
environment.interactiveShellInit = ''
 /*   # --- ANSI color constants (exported for all interactive shells) ---
    export RED=$'\033[38;2;240;128;128m\033[48;2;139;0;0m'
    export BOLD=$'\033[1m'
    export BLINK=$'\033[5m'
    export UNDER=$'\033[4m'
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
    export RESET=$'\033[0m'
*/
    CHmod() {
      local dir="''${1:-.}"
      if [[ ! -d "$dir" ]]; then
        # FIX: ''${RED}, ''${RESET}
        echo -e "\t''${RED}Error: Directory '$dir' not found''${RESET}"
        return 1
      fi
      find "$dir" -maxdepth 1 -type f \( -name "*.sh" -o -name "*.zsh" -o -name "*.py" \) -exec chmod -v u+x {} +
    }

    CHmod-() {
      local dir="''${1:-.}"
      if [[ ! -d "$dir" ]]; then
        echo -e "\t''${RED}Error: Directory '$dir' not found''${RESET}"
        return 1
      fi
      find "$dir" -maxdepth 1 -type f \( -name "*.sh" -o -name "*.zsh" -o -name "*.py" \) -exec chmod -v u-x {} +
    }

    g2ali() {
        if [[ -z "$1" ]]; then
        echo -e "\t''${RED}Fehler: Kein Suchbegriff angegeben.''${RESET}"
        return 1312
      fi
      if command -v bat &>/dev/null; then
        alias | grep -i --color=always "$1" | command bat -l toml
      else
        alias | grep -i --color=always "$1"
      fi
    }

    g2env() {
      if [[ -z "$1" ]]; then
        echo -e "\t''${RED}Fehler: Kein Suchbegriff angegeben.''${RESET}"
        return 1312
      fi
      if command -v bat &>/dev/null; then
        printenv | grep -i --color=always "$1" | command bat -l toml
      else
        printenv | grep -i --color=always "$1"
      fi
    }



# ">/dev/null 2>&1° leitet alle Ausgaben (stdout und stderr) ins Nirvana u Terminal bleibt sauber
open_pdf() {
    if command -v okular >/dev/null 2>&1; then
        okular "$@" >/dev/null 2>&1 &
    elif command -v xreader >/dev/null 2>&1; then
        xreader -w "$@" >/dev/null 2>&1 &
    elif command -v evince >/dev/null 2>&1; then
        evince "$@" >/dev/null 2>&1 &
    else
        echo "Kein PDF-Viewer gefunden" >&2
        return 1
    fi
}
#-------- ASCIINEMA -----------#
    PLAY() {
      local title="$(basename "$(dirname "$(pwd)")")@$(date +%F)"
      asciinema play "asciinema/$title.cast"
    }

    REC() {
      local title="$(basename "$(dirname "$(pwd)")")@$(date +%F)"
      mkdir -p asciinema
      asciinema rec --overwrite --idle-time-limit=1 --title="$title" "asciinema/$title.cast"
    }

#-------- YT-DLP -----------#
    # Download YouTube audio as MP3 (192k), removes SponsorBlock segments
    YTA() {
      yt-dlp --audio-quality 192k --audio-format mp3 \
        --progress --sponsorblock-remove all \
        -x --embed-metadata --embed-thumbnail --no-mtime --console-title \
        --restrict-filenames --output "%(title).48s.%(ext)s" \
        --progress-template "%(progress._percent_str)s of 100% \
        | with %(progress._speed_str)s | %(progress._eta_str)s remaining" \
        "$1"
    }
    # Download YouTube video as MP4, removes SponsorBlock segments
    YTV() {
      yt-dlp --audio-quality 192k --remux-video mp4 \
        --progress --sponsorblock-remove all \
        --embed-metadata --embed-thumbnail --no-mtime --console-title \
        --restrict-filenames --output "%(title).48s.%(ext)s" \
        --progress-template "%(progress._percent_str)s of 100% \
        | with %(progress._speed_str)s | %(progress._eta_str)s remaining" \
        "$1"
    }
#-------- ---------------#
# Manage color themes: select dark theme or switch theme
TERMcolors() {
    case "$1" in
        select)
            theme.sh --dark -i2 >> color-theme.md && \
                echo -e "''${BROWN}theme.sh --dark -i2 >> color-theme.md ''${RESET}"
            ;;
        sw)
            color-theme-switch && \
                echo -e "''${BROWN}color-theme-switch aus my-function.zsh''${RESET}"
            ;;
        *)
            echo -e "''${BROWN}Usage: Terminal Color Theme w/ "theme.sh" [select|switch]''${RESET}"
            ;;
    esac
}
#-------- LS BLK /MOD -----------#
        # Funktion für enhanced lsblk
        lsblk_enhanced() {
            echo -e "\t''${NIGHT}enhanced lsblk .. als Tabelle mit \
            --merge --zoned --ascii --topology''${RESET}" && \
            lsblk --width 80 --merge --zoned --ascii --topology \
                  --output MODEL,MOUNTPOINTS,PATH,SIZE,TRAN,LABEL,FSTYPE,TYPE
        }

        # Funktion für enhanced lsmod
        lsmod_enhanced() {
            if ! command -v sudo &> /dev/null; then
                echo "Fehler: sudo ist nicht installiert oder nicht verfügbar."
                return 1
            fi
            echo -e "\t''${NIGHT}enhanced ls mod w/ Kernel-Modul \
            -Name and -description''${RESET}"
            lsmod | awk 'NR>1 {print $1}' | while read -r name; do
            printf "%s\t\t%s\n" "''${name}" "$(sudo modinfo "''${name}" 2>/dev/null \
                | awk '/description:/ {sub(/^description:\s*/, ""); print}')"
            done
}

#______________________________________________________
#   ███████╗ ██████╗ ██╗   ██╗██████╗  ██████╗███████╗
#   ██╔════╝██╔═══██╗██║   ██║██╔══██╗██╔════╝██╔════╝
#   ███████╗██║   ██║██║   ██║██████╔╝██║     █████╗
#   ╚════██║██║   ██║██║   ██║██╔══██╗██║     ██╔══╝
#   ███████║╚██████╔╝╚██████╔╝██║  ██║╚██████╗███████╗
#   ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝
# Function: source_or_error .sh / .zsh files with extensive validation
# Usage   : source_or_error file.sh|file.zsh

source_or_error() {
  # --- UI colors (ANSI) ---
  local RED="\033[38;2;240;128;128m\033[48;2;139;0;0m"
  local GELB="\e[33m"
  local GREEN="\033[38;2;0;255;0m\033[48;2;0;100;0m"
  local RESET="\e[0m"

  # --- logging helper ---
  _log() {
    # ''$1 = level, , ''$2 = filename ''$3 = message
   printf "[%s] %-12s %-5s %s\n" "''$(date '+%c')" "''$1" "''$2" "''$3"  >> "''$ZDOTDIR/zsh.log" 1> /dev/null
    }

  local file="''$1"
  # Validation checks
    # --- argument sanity ---
  [[ -z "''$file" ]] && { _log ERROR "" "No file argument provided"; return 2; }
    # --- existence (any type) ---
  [[ ! -e "''$file" ]] && { _log ERROR "" "File does not exist: ''$file"; return 3; }
    # --- empty file check ---
  [[ ! -s "''$file" ]] && { _log ERROR "" "File is empty: ''$file"; return 4; }
    # is file?
  [[ ! -f "''$file" ]] && { _log ERROR "" "Not a regular file: ''$file"; return 5; }
    # is readable?
  [[ ! -r "''$file" ]] && { _log ERROR "" "File not readable: ''$file"; return 6; }

  # --- symlink handling ---
  if [[ -L "''$file" ]]; then
    local real_file="''${file:A}"
    _log INFO "" "Symlink resolved: ''$file -> ''$real_file"
    printf "\t''${GELB}→ Symlink resolved: ''$real_file''${RESET}\n"
    file="''$real_file"
  fi
 # --- extension whitelist ---
  case "''$file" in
    (*.sh|*.zsh|*.zsh-theme)
      _log INFO "" "Accepted extension"
      ;;
    (*)
      _log ERROR "" "Unsupported extension: ''$file"
      printf "\t''${RED}✖ Unsupported file type (only .sh/.zsh allowed): ''$file''${RESET}\n"
      return 7
      ;;
  esac
  # --- basic plausibility (optional syntax probe) ---
  # Note: zsh has no true "lint"; this catches gross parser errors
 # if ! zsh -n "''$file" 2>/dev/null; then
 #   _log ERROR "" "Syntax check failed: ''$file"
 #   printf "\t''${RED}✖ Syntax check failed: ''$file''${RESET}\n"
 #   return 8
  # fi
  # --- source ---
  _log INFO "" "Sourcing file: ''$file"
  source "''$file"

  local rc=''$?
  if (( rc != 0 )); then
    _log ERROR "" "Sourcing returned non-zero exit code (''$rc): ''$file"
    printf "\t''${RED}✖ Error while sourcing: ''$file''${RESET}\n"
    return ''$rc
  fi
  printf "''${MINT}󰞷 src pass: ''${CYAN} ''$file :''${PINK2} ✔ ''${RESET}\n"
#  printf "''${GREEN}󰞷 src pass: ''${NIGHT} ''$file :''${GREEN} ✔ ''${RESET}\n"
  return 0
}
mkcd() {
    local MINT='\033[38;5;121m'
    local CYAN='\033[38;5;87m'
    local SLATE='\033[38;5;245m'
    local RED='\033[38;5;203m'
    local RESET='\033[0m'

    if [[ $# -eq 0 ]]; then
      printf "''${SLATE}Usage: ''${CYAN}mkcd ''${MINT}<dir> [dir2 ...]''${RESET}\n"
      return 1
    fi

    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
      printf "''${MINT}mkcd''${SLATE} – Create directories and cd into the last one''${RESET}\n\n"
      printf "''${SLATE}Usage: ''${CYAN}mkcd ''${MINT}<dir> [dir2 dir3 ...]''${RESET}\n"
      return 0
    fi

    local last_dir=""
    for dir in "$@"; do
      if mkdir -p "$dir" 2>/dev/null; then
        printf "''${MINT}󰞷 Created: ''${CYAN}$dir ''${SLATE}✔''${RESET}\n"
        last_dir="$dir"
      else
        printf "''${RED}✘ Failed:  ''${CYAN}$dir''${RESET}\n" >&2
        return 1
      fi
    done

    cd "$last_dir" && printf "''${MINT}󰞷 Now in: ''${CYAN}$(pwd) ''${SLATE}✔''${RESET}\n"
  }
'';

}

