# aliases.nix
{ config, lib, pkgs, ... }:
# globale aliase fuer zsh, bash, ...
/* NIX-spezific:
- Maskierung von Sonderzeichen (Escaping) beachten \"
- semikolon und kein leerzeichen
- FIX: Shell-Variablen ${VAR} in ''...'' als ''${VAR} escapen
*/

let
  inherit (lib) mkIf mkMerge;
in
{
 /* ---------------------------------------------------------
 Aliases alphabetisch sortiert + mkIf pro Programm
          ██   █    ▄█ ██      ▄▄▄▄▄   
        █ █  █    ██ █ █    █     ▀▄ 
        █▄▄█ █    ██ █▄▄█ ▄  ▀▀▀▀▄   
        █  █ ███▄ ▐█ █  █  ▀▄▄▄▄▀    
           █     ▀ ▐    █            
          ▀            ▀            
Mehrzeilige Strings: In Nix werden mehrzeilige Strings mit zwei einfachen Anführungszeichen ('') umschlossen.
Escaping: Sonderzeichen wie ", $, und \ müssen ggf. escaped werden, falls sie in der Shell-Interpretation zu Konflikten führen.
---------------------------------------------------------


alias nano='echo -e "\t${PINK}Verwende micro anstelle von nano${RESET}" && micro || nano'
alias edit='echo -e "\t${PINK}Verwende micro als Standard-Editor${RESET}" && micro'
alias DATE='echo -e "\t${PINK}Zeige das aktuelle Datum  $(date "+%A, %-d. %B %Y"):{$RESET}" && echo -e "${GELB} $(date "+%A, %-d. %B %Y")${RESET} \n "&& echo -e "${PINK} oder $ (date +%F_%H-%M)\t ${RESET}" 	&& echo -e "${GELB} $(date "+%F_%H-%M") ${RESET}"'

alias COL='terminal-colors -n && echo -e "${NIGHT}\n...für Hex-Codes der Farben:${RED}%${LILA} terminal-colors -l ${RESET}\n"'
alias Col='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'"'"'\n'"'"';}; done'
alias hack='echo -e "\t${PINK}Starte Hackertyper${RESET}" && hackertyper'
#	_______________________________neofetch_______________________________
alias neo='echo -e "\t${PINK} neofetch w/ ${LILA} \t $ZDOTDIR/neofetch/spaceinv.conf\t${RESET}" && neofetch --config "$ZDOTDIR/neofetch/spaceinv.conf"'
alias neo0='neo'
alias neo1='echo -e "\t  ${PINK}neofetch w/ ${LILA} \t 	$ZDOTDIR/neofetch/neofetch-short.conf\t${RESET}" && neofetch --config "$ZDOTDIR/neofetch/neofetch-short.conf"'
alias neo2='echo -e "\t${PINK} neofetch w/ ${LILA} \t	$ZDOTDIR/neofetch/config2.conf\t${RESET}" && neofetch --config "$ZDOTDIR/neofetch/config2.conf"'
alias neo3='echo -e "\t${LIME}   -  󱚡  --   --  🙼 🙼 🙼      󱢇     🙽 🙽 🙽   --    --  󱚡  --    -" && echo -e "\t${PINK}  neofetch w/ ${LILA} \t	$ZDOTDIR/neofetch/neofetch-long.conf\t${RESET}" && echo -e "\t${CYAN}   -  󱚡  --   --  🙼 🙼 🙼   󱢇     󱢇  🙽 🙽 🙽   --    --  󱚡  --    -" &&  neofetch --config "$ZDOTDIR/neofetch/neofetch-long.conf"'
alias neo4='echo -e "\t${PINK} neofetch w/ ${LILA} \t  a for loop of themes	/home/project/neofetch-themes${RESET}" && bash -c /home/project/neofetch-themes/for-loop.sh'

alias h='history'
alias history='history -t "%H:%MUhr am %d.%b: "'
alias g2history='cat "$HISTFILE" | grep -i --colour=always'
alias g2h=g2history
alias h2g=g2history

#	____________________________________________________________________

alias WMinfo='echo -e "\n\t${PINK}...2xklicken! mittels${GELB} cmd xprop und xwininfo${PINK}, zeigt Parameter des Windows an!${RESET}\n" && \
    xprop | grep --color=auto -E WM_CLASS && \
    xwininfo | grep --color=auto geometry'
alias WMverbose='echo -e "\n\t${PINK}\n 2xklicken! mittels${GELB} cmd xprop und xwininfo${PINK}... zeigt Parameter des Windows an!${RESET}\n" && \
    xprop | grep --color=auto -e "WM_CLASS(STRING)" -e "*SIZE*" -e "WM_PROTOCOLS(ATOM):" -e "geometry" -e "_NET_WM_ALLOWED_ACTIONS(ATOM)" && \
    xwininfo | grep --color=auto geometry'
# --- Diverse Werkzeuge & Helfer ---
# alias MD2html='pandoc $1 -s --to html --css=$HOME/.templates/cyberpunk-DM.css | w3m -T text/html'alias mangconf='echo -e "\t${PINK}Öffne MangoHud Konfigurationsdatei${RESET}" && micro -filetype bash "$XDG_CONFIG_HOME/MangoHud/MangoHud.conf"'
alias MD2pdf='pandoc $1 -o ${1%.md}.pdf --template=$HOME/dokumente/vorlagen/MDtoPDF.tex'
alias bat1='bat --wrap=auto --plain --terminal-width 76 --theme=ansi'
alias bat2='bat --wrap=auto --plain --terminal-width 80 --theme=Dracula'
alias bat3='bat --wrap=auto --decorations=always --theme=Coldark-Dark'
alias bat4='bat --wrap=auto --number --decorations=always --theme=OneHalfDark'
alias bat5='bat --wrap=never --number --decorations=always --theme=base16'
alias BATconf='echo -e "\t${PINK}Öffne bat Konfigurationsdatei${RESET}" && edit /share/bat/config.toml'
alias Bconf='BATconf'
alias free='echo -e "\t${PINK}free -gt {RESET}\n" && free -gt'
alias gll='echo -e "${GELB}\nFarbig formatierte Ausgabe der Commit-Historie in Graph-Darstellung${RESET}\n" && git log --graph --format=format:"%C(bold blue)%h%C(reset) - %C(bold NIGHT)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)" --all'
# ### ---------------------------  ####
# Lädt Audio von YouTube als MP3 (192k), entfernt Sponsorblock-Segmente, bettet Metadaten/Thumbnail ein, begrenzt Dateinamen auf 48 Zeichen, zeigt benutzerdefinierten Download-Fortschritt.
alias -g YTA='yt-dlp --audio-quality 192k  --audio-format mp3 \ 
                 --progress --sponsorblock-remove all \
                 -x --embed-metadata --embed-thumbnail --no-mtime --console-title  \ 
                 --restrict-filenames --output "%(title).48s.%(ext)s" \
                 --progress-template "%(progress._percent_str)s of 100% | with %(progress._speed_str)s | %(progress._eta_str)s remaining" "$1"'

# Lädt Video von YouTube als MP4, entfernt Sponsorblock-Segmente, bettet Metadaten/Thumbnail ein, begrenzt Dateinamen auf 48 Zeichen, zeigt benutzerdefinierten Download-Fortschritt.
alias -g YTV='yt-dlp --audio-quality 192k --remux-video mp4 \ 
                 --progress --sponsorblock-remove all \
                 -x --embed-metadata --embed-thumbnail --no-mtime --console-title  \ 
                 --restrict-filenames --output "%(title).48s.%(ext)s" \
                 --progress-template "%(progress._percent_str)s of 100% | with %(progress._speed_str)s | %(progress._eta_str)s remaining" "$1"'


#       e x a / e z a .. ls  ll  lh  ld ...
alias eweb='echo -e "\t${PINK}eza-Ansicht für Web-Projekte (z.B. Hugo)${RESET}" && eza --no-git --total-size --git-ignore -A -tree'
alias e-hugo='eweb'

alias lp='echo -e "\t${PINK}eza-Auflistung mit Fokus auf Git-Status${RESET}" && eza --octal-permissions --git -Al --git-repos --no-permissions --time-style=relative --group-directories-first --smart-group'
alias ep=lp

alias e1='echo -e "\t${GELB} eza --tree -level 1 ${RESET}\n" && \
    eza --all --long --group-directories-first \
        --color-scale --no-time --octal-permissions --width 76 \
        --tree --level 1 --color-scale-mode gradient'
alias e2='echo -e "\t${GELB} eza --tree -level 2${RESET}\n" && \
    eza --all --long --group-directories-first \
        --color-scale --no-time --octal-permissions --width 76 \
        --tree --level 2  --color-scale-mode gradient'
alias e3='echo -e "\t${GELB} eza --tree -level 3  ${RESET}\n" && \
    eza --all --long --group-directories-first \
        --color-scale --no-time --octal-permissions --width 76 \
        --tree --level 3 --color-scale-mode gradient'
alias e4='echo -e "\t${GELB} eza --tree -level 4 --git ${RESET}\n" && \
    eza --all --long --group-directories-first \
        --no-time --octal-permissions --width 76 \
        --color-scale age --color-scale-mode gradient \
        --tree --level 4 --git -color-scale-mode gradient'
alias eee='echo -e "\t${GELB} eza --tree -level 99 --git ${RESET}\n" && \
    eza --all --long --group-directories-first \
        --colour-scale all --color-scale-mode gradient --no-time \
        --octal-permissions --tree --level 99 --git --width 76'
alias ee='echo -e "eza  ... läuft"  && \
    eza --git --almost-all --long --group-directories-first \
        --colour-scale all --color-scale-mode gradient --octal-permissions'

*/

  environment.shellAliases = mkMerge [

    # --- Always available aliases (alphabetisch) ---
    {

NIXoi = ''
      echo -e "\t''${NIGHT}sudo nixos-rebuild switch --profile-name xam4boom --upgrade -I nixos-config=/etc/nixos/configuration.nix ''${PINK}" && \
      sudo nixos-rebuild switch --show-trace --upgrade --profile-name "xam4boom" -I nixos-config=/etc/nixos/configuration.nix && \
      echo -e "__________end ''${RESET}"
    '';
    NIXboom = ''
      echo -e "\t''${NIGHT}sudo nixos-rebuild boot --profile-name \"xam4boot\" --upgrade -I nixos-config=/etc/nixos/configuration.nix ''${PINK}" && \
      sudo nixos-rebuild boot --show-trace --upgrade --profile-name "xam4boot" -I nixos-config=/etc/nixos/configuration.nix && \
      echo -e "__________end ''${RESET}"
    '';
    
    diff = ''
      echo -e "\t''${NIGHT}colordiff mit erweiterten Ignore-Optionen''${RESET}" && \
      colordiff --ignore-case --ignore-tab-expansion \
        --ignore-trailing-space --ignore-space-change \
        --ignore-all-space --ignore-blank-lines
    '';
    LSblk = ''
      echo -e "\t''${NIGHT}enhanced lsblk .. als Tabelle mit --merge --zoned --ascii --topology ''${RESET}" && \
      lsblk --width 80 --merge --zoned --ascii --topology \
            --output MODEL,MOUNTPOINTS,PATH,SIZE,TRAN,LABEL,FSTYPE,TYPE
    '';
    
    LSmod = ''
      echo -e "\t''${NIGHT}enhanced ls mod w/ Kernel-Modul -Name and -description ''${RESET}" && \
      while IFS= read -r name; do printf "%s\t\t%s\n" "''${name}" "''$(sudo modinfo "''$name" | grep "description" | cut -c17-)"; done <<< "$(lsmod | cut -d " " -f1 | tail -n +2)"
    '';
    
  NIXboot = ''echo -e "\t''${PINK}Bootbare Konfigurationen ''${RESET}" && eza -U --header --long --tree --almost-all /nix/var/nix/profiles/'';
  
  NIXrun  = ''eza --tree --only-dirs /run/current-system/sw/share'';
 
  NIXref = ''
 	echo -e "\t''${PINK}Zeige die direkten Abhängigkeiten eines Nix-Store-Pfades an''${RESET}" 
 	&& \nix-store -q --references /nix/store/'
'';
      ".." = "cd ..";

        "COL+" = ''theme.sh --dark -i2 >> color-theme.md && echo -e "''${BROWN}theme.sh --dark -i2 >> color-theme.md ''${RESET}"'';

       COL256 = ''
        for i in {0..255}; do
          printf "\e[38;5;''${i}mcolor%-5i\e[0m" "$i"
          if (( ($i + 1) % 8 == 0 )); then echo; fi
        done
        echo -e "\n\tSYNTAX: 38;5;<colorXYZ>:\n\tz.B.: 38;5;125"
      '';
      COLsw = ''color-theme-switch && echo -e "''${BROWN}color-theme-switch aus my-function.zsh''${RESET}"'';
      "FC-list" = ''FClist.sh || $HOME/bin/FClist.sh'';
      FARBE = ''echo -e "\t''${PINK}Lade Farbskript''${RESET}" && source "$ZDOTDIR/functions/colors.sh"'';
      EIN    = "shutdown -r now";
      Reboot = "shutdown -r now";
      AUS    = "shutdown now";
      RM = ''echo -e "\t''${PINK}Lösche *~ Dateien''${RESET}" && find . -type f -name "*~" -delete'';
    }


    # --- bat ---

    (mkIf (builtins.hasAttr "bat" pkgs) {
      bap  = "bat -p";
      bat  = "bat6";
      bat6 = "command bat --wrap=auto --decorations=always --theme=gruvbox-dark";
    })

    # --- btop ---
    (mkIf (builtins.hasAttr "btop" pkgs) {
      top = "btop";
    })

   
    # --- duf ---
    (mkIf (builtins.hasAttr "duf" pkgs) {
      df = ''echo -e "\t''${PINK} duf''${RESET}" && duf'';
    })

    # --- eza ---
    (mkIf (builtins.hasAttr "eza" pkgs) {
      e=''echo "eza (´FILE*´ for execute perm. ´DIR/´ for directory)" && eza --all --classify'';
    ed=''echo "eza (only directories)" && eza --all --classify --only-dirs'';
    ld = "ed --long";
    ef=''echo "eza (only files)" && eza --all --classify --only-files'';
    lf = "ef --long";
    et=''echo "eza (sorted by time)" && eza --all --classify --sort time'';
    lt = "et --long";    
    ex=''echo "eza (sorted by extension)" && eza --all --classify --sort extension'';
    lx = "ex --long";
    es=''echo "eza (sorted by size)" && eza --all --classify --sort size'';
    ls = "es --long";
    el=''echo "eza (long format)" && eza --all --classify --long'';
    le=''echo "eza (tree view)" && eza --all --classify --tree --level=2'';
    eg=''echo "eza (git status)" && eza --all --classify --git'';
    lg = "eg --long";
    })

    # --- git ---
    (mkIf (builtins.hasAttr "git" pkgs) {
      # FIX: ''${GELB}, ''${RESET} in allen git-Aliases
      ga   = ''echo -e "''${GELB}\nFügt Änderungen hinzu''${RESET}\n" && git add'';
      gb   = ''echo -e "''${GELB}\nZeigt Branches''${RESET}\n" && git branch'';
      gblog = ''git for-each-ref --sort=committerdate refs/heads/ --format="%(HEAD) %(refname:short) - %(objectname:short) - %(contents:subject) - %(authorname) (%(committerdate:relative))"'';
      glol = ''echo -e "''${GELB}\nCommit-Historie''${RESET}\n" && git log --graph --abbrev-commit --oneline --decorate'';
      gp   = ''echo -e "''${GELB}\nPush''${RESET}\n" && git push'';
      gr   = ''echo -e "''${GELB}\nRemote Repos''${RESET}\n" && git remote'';
      grb  = ''echo -e "''${GELB}\nRemote Branches''${RESET}\n" && git branch -r'';
      grs  = ''echo -e "''${GELB}\nRemote Info''${RESET}\n" && git remote show'';

      gss  = ''cowsay -nW 60 "$(echo -e "''${NIGHT}[Git Status]''${RESET}\n$(git status -s)")" && echo -e "\n''${PINK}Legende:''${RESET}\nM Modified\nA Staged\nD Deleted\nR Renamed\nC Copied\n? Untracked"'';
      gsss = ''echo -e "''${PINK}\n git status --short ''${RESET}" && git status -s'';
    })

    # --- kitty ---
    (mkIf (builtins.hasAttr "kitty" pkgs) {
      # FIX: ''${PINK}, ''${RESET}
      # HINWEIS: gnome-text-editor ist nicht in systemPackages → Fallback auf micro greift
      KITTYconf = ''echo -e "\t''${PINK}Öffne kitty.conf''${RESET}" && gnome-text-editor "$XDG_CONFIG_HOME/kitty/kitty.conf" 2>/dev/null || micro "$KITTY_CONFIG_DIRECTORY/kitty.conf"'';
      Kconf     = "KITTYconf";
      KITTYmap  = ''echo -e "\t''${PINK}Zeige Tastaturbelegungen''${RESET}" && bapNoComment "$KITTY_CONFIG_DIRECTORY/kitty.conf" || grep "map"'';
      Kbind     = "KITTYmap";
      Kmap      = "KITTYmap";
    })

    # --- lsd ---
    (mkIf (builtins.hasAttr "lsd" pkgs) {
      NIXpkgs = ''echo -e "\t''${PINK}Liste installierte Pakete''${RESET}" && lsd --oneline --classify --no-symlink /run/current-system/sw/bin/'';
    })

    # --- wget ---
    (mkIf (builtins.hasAttr "wget" pkgs) {
      wget = "wget -c";
    })

    # --- zoxide ---
    (mkIf (builtins.hasAttr "zoxide" pkgs) {
      za  = ''echo -e "\t''${PINK}Add to zoxide''${RESET}" && zoxide add'';
      zq  = ''echo -e "\t''${PINK}Query zoxide''${RESET}" && zoxide query'';
      zqi = ''echo -e "\t''${PINK}Interactive query''${RESET}" && zoxide query -i'';
      zr  = ''echo -e "\t''${PINK}Remove from zoxide''${RESET}" && zoxide remove'';
    })
   
       
    # --- broot ---
(mkIf (builtins.hasAttr "broot" pkgs) {

  # --- launch ---
  br    = "broot";                             # standard launch (installs shell func on first run)
  brd   = "broot --sizes";                     # show directory sizes
  brg   = "broot --gitignore yes";             # respect .gitignore
  brh   = "broot --hidden";                    # show hidden files
  brhs  = "broot --hidden --sizes";            # hidden + sizes
  bri   = "broot --show-root-fs";              # show filesystem info at root
  # --- git integration ---
  brgs  = "broot --git-status";               # show git status flags
  brgl  = "broot --gitignore no";             # ignore .gitignore (show all)
  # --- permissions / ownership ---
  brp   = "broot --permissions";              # show permissions column
  bro   = "broot --show-permissions";         # alias variant
  # --- sorting ---
  brsd  = "broot --sort-by-date";             # sort by modification date
  brss  = "broot --sort-by-size";             # sort by size
  brsn  = "broot --sort-by-name";             # sort by name (default)
  brsc  = "broot --sort-by-count";            # sort by file count (dirs)
  # --- specific start paths ---
  brhome  = "broot $HOME";
  brnix   = "broot /etc/nixos";
  brlog   = "broot /var/log";
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
      # FIX: ''${RED}, ''${RESET} — Farb-Variablen zur Laufzeit aus colorEnvExport.sh
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

      NIXinfo() {
      nix-shell -p nix-info --run "nix-info -m"
    }

    PLAY() {
      local title="$(basename "$(dirname "$(pwd)")")@$(date +%F)"
      asciinema play "asciinema/$title.cast"
    }

    REC() {
      local title="$(basename "$(dirname "$(pwd)")")@$(date +%F)"
      mkdir -p asciinema
      asciinema rec --overwrite --idle-time-limit=1 --title="$title" "asciinema/$title.cast"
    }
  '';

}

