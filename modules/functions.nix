{ config, pkgs, ... }:

# globale aliase fuer zsh, bash, ...
/* NIX-spezific:
- Maskierung von Sonderzeichen (Escaping) beachten \"
- semikolon und kein leerzeichen
- FIX: Shell-Variablen ${VAR} in ''...'' als ''${VAR} escapen

Mehrzeilige Strings: In Nix werden mehrzeilige Strings mit zwei einfachen Anführungszeichen ('') umschlossen.


# Funktionen (alphabetisch sortiert)
#  ▄████ ▄      ▄   ▄█▄      ▄▄▄▄▀ ▄█ ████▄    ▄      ▄▄▄▄▄
#  █▀   ▀ █      █  █▀ ▀▄ ▀▀▀ █    ██ █   █     █    █     ▀▄
#  █▀▀ █   █ ██   █ █   ▀     █    ██ █   █ ██   █ ▄  ▀▀▀▀▄
#  █   █   █ █ █  █ █▄  ▄▀   █     ▐█ ▀████ █ █  █  ▀▄▄▄▄▀
#  █  █▄ ▄█ █  █ █ ▀███▀   ▀       ▐       █  █ █
#   ▀  ▀▀▀  █   ██                         █   ██
# --------------------------------------------------------*/
{
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
            echo -e "''${BROWN}Usage: Terminal Color Theme w/ theme.sh [select|switch]''${RESET}"
            ;;
    esac
}
#-------- LS BLK /MOD -----------#
lsblk_enhanced() {
  echo -e "\t''${PINK2}enhanced lsblk — --merge --zoned --ascii --topology ''${RESET}"
  echo -e "\t ''${PINK2} Model\t\tMountpoint\tPATH\tTran\tType ''${RESET}"
  lsblk --width 80 --merge --zoned --ascii --topology \
        --output MODEL,TYPE,TRAN,FSTYPE,MOUNTPOINTS,PATH,SIZE
}
      
lsmod_enhanced() {
  if ! command -v sudo &>/dev/null; then
    echo "Fehler: sudo ist nicht installiert oder nicht verfügbar."
    return 1
  fi
  echo -e "\t ''${ORANG}enhanced lsmod — Kernel modules with descriptions ''${RESET}"
  echo -e " ''${PINK2} Name\t\t ''${VIOLE}Description ''${RESET}"
  lsmod | awk 'NR>1 {print $1}' | while read -r name; do
    printf "%s\t\t%s\n" "''${name}" "$(sudo modinfo "''${name}" 2>/dev/null \
      | awk '/description:/ {sub(/^description:[[:space:]]*/, ""); print}')"
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

  # --- logging helper ---
  _log() {
    # $1 = level, , $2 = filename $3 = message
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
  printf "''${MINT}󰞷 src pass: ''${CYAN} ''$file : ''${PINK2} ✔ ''${RESET}\n"
#  printf "''${GREEN}󰞷 src pass: ''${NIGHT} ''$file : ''${GREEN} ✔ ''${RESET}\n"
  return 0
}
#########################################

mkcd() {
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

