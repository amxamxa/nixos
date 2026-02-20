# zsh.nix
# DEBUG:    nix-instantiate --parse /etc/nixos/modules/zsh.nix
#  ------Z-S-H-------------------------                               
/*              .x+=:.               
             z`    ^%    .uef^"    
     ..         .   <k :d88E       
   .@88i      .@8Ned8" `888E       
  ""%888>   .@^%8888"   888E .z8k  
    '88%   x88:  `)8b.  888E~?888L 
  ..dILr~` 8888N=*8888  888E  888E 
 '".-%88b   %8"    R88  888E  888E 
  @  '888k   @8Wou 9%   888E  888E 
 8F   8888 .888888P`    888E  888E 
'8    8888 `   ^"F     m888N= 888> 
'8    888F              `Y"   888  
 %k  <88F                    J88"  
  "+:*%`                     @%    
                           :"      */
#  """""""""""""""""""""""""""""""""""""" 
# Purpose: # - Deploy shared zsh files under /share/zsh 
# - Configure system-wide zsh features: fzf, history, prompt, completions 
# - Install useful CLI utilities for interactive shells 
#
{ config, pkgs, ... }:
let
  # Define paths as Nix strings (build-time constants).
  # If you prefer runtime-determined values, export them as env vars
  # and avoid interpolating them at build time.
  ZDOTDIR = "/share/zsh";
  ZFUNC = "/share/zsh/functions";
  SHARE   = "/share";
  PRO = "/home/project/";
  NDIR = "/etc/nixos";
  here = builtins.toString ./.;
in
{
#### ZDOTDIR global setzen ####
# ACHTUNG: NICHT in "s" setzten! DENN DANN IST ES EIN STRING UND KEINE ZUORDNUNG zu einer Variablen!!
environment.variables.ZDOTDIR = ZDOTDIR;
environment.variables.ZFUNC = ZFUNC;
environment.variables.SHARE = SHARE; 
environment.variables.PRO = PRO; 
environment.variables.NDIR = NDIR; 

# B: CustomRC = builtins.readFile ../includes/init.vim;

 #### Dateien nach /share/zsh deployen ####
 # environment.etc wird verwendet, um Dateien in /etc zu platzieren 
 # und damit systemweit verfügbar  
 
# Activation Scripts legt Ordner uind Permissions an:
environment.etc."zsh/zshActiveDirExist.sh".source = "${here}/../assets/shell/zshActiveDirExist.sh";
#environment.etc."zsh/zshrc".source = "${here}/../assets/shell/zshrc";
# Zsh-Aliase systemweit verfügbar machen
#environment.etc."zsh/aliases.zsh".source = "${here}/../assets/shell/aliases.zsh";
# environment.shell sourct bereits: environment.etc."zsh/aliases.sh".source = "${here}/../assets/shell/aliases.sh";

#environment.etc."zsh/truecolor.sh".source = "${here}/../assets/shell/truecolor.sh";
environment.etc."zsh/zsh-highlight-styles.zsh".source = "${here}/../assets/shell/zsh-highlight-styles.zsh";


# Disable command-not-found in favor of nix-index    
 programs.command-not-found.enable = false; # -> nix-index 
 programs.nix-index = {  # damit command: nix-locate pattern
        enable = true; # a file database for nixpkgs for "cmd-not-found".
    	package = pkgs.nix-index;
    	enableZshIntegration = true;    
    	};
#-------------------
#  pay-respects insteadt  programs.thefuck
#-------------------

  programs.pay-respects.enable = true;
  # You can also set a custom API endpoint, large language model and locale for command corrections. Simply access the aiIntegration.url, aiIntegration.model and aiIntegration.locale options, as described in the example.
  #    Take a look at the services.ollama NixOS module if you wish to host a local large language model for pay-respects.
   programs.pay-respects.aiIntegration = true;

#-------------------
# FZF CONFIGURATION
#-------------------
# Fuzzy Finder für interaktive Shell-Nutzung
programs.fzf.fuzzyCompletion = true;
# Whether to enable fzf keybindings. 
programs.fzf.keybindings = true; 
/*
# Tests:
fbrowse          # Datei-Browser
fcode "TODO"     # Code suchen
fgit             # Git-Dateien
fcd              # Verzeichnis-Wechsel

# Eingebaute Keybindings:
# CTRL-T  → Datei suchen
# ALT-C   → Verzeichnis wechseln
# CTRL-R  → History
# Beispiele:
vim **<TAB>        # Datei-Suche mit FZF-Preview
cd **<TAB>         # Verzeichnis-Suche mit FZF-Preview
kill -9 **<TAB>    # Prozess-Auswahl mit FZF
ssh **<TAB>        # Host-Auswahl
*/
# Umgebungsvariablen für FZF
environment.etc."zsh/fzf-config.sh".text = ''
  #----- FZF Base Configuration ------------------------------------
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  
  export FZF_DEFAULT_OPTS="
    --border rounded
    --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
    --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
    --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
    --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
    --layout=reverse
    --height=40%
    --preview-window=right:60%:wrap
    --preview='fzf-preview {}'
    --bind='ctrl-/:change-preview-window(down|hidden|)'
    --bind='ctrl-e:execute($EDITOR {})'
    --bind='ctrl-y:execute-silent(echo {} | wl-copy)'
  "
  
  #----- CTRL-T (File search) --------------------------------------
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_CTRL_T_OPTS="
    --preview='fzf-preview {}'
    --header='CTRL-E: Edit | CTRL-Y: Copy path | CTRL-/: Toggle preview'
  "
  
  #----- ALT-C (Directory navigation) ------------------------------
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_ALT_C_OPTS="
    --preview='eza --tree --level=2 --color=always --icons {} 2>/dev/null || tree -C -L 2 {}'
    --header='Select directory to cd into'
  "
  
  #----- CTRL-R (History) ------------------------------------------
  export FZF_CTRL_R_OPTS="
    --no-preview
    --info=inline
    --no-sort
    --header='󰅍 Command history (CTRL-Y: Copy)'
    --bind='ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
  "
  
  #----- TAB Completion Settings -----------------------------------
  # Trigger für ** (wird durch programs.fzf.fuzzyCompletion aktiviert)
  export FZF_COMPLETION_TRIGGER='**'
  
  # Preview für verschiedene Completion-Kontexte
  export FZF_COMPLETION_OPTS="
    --preview='
      if [[ -f {} ]]; then
        fzf-preview {}
      elif [[ -d {} ]]; then
        eza --tree --level=2 --color=always --icons {} 2>/dev/null || ls -lah {}
      fi
    '
    --preview-window=right:50%:wrap
  "
  
  #----- Custom Functions ------------------------------------------
  
  # Datei-Browser mit fzf-preview
  ff() {
    local file
    file=$(fd --type f --hidden --follow --exclude .git | \
           fzf --preview='fzf-preview {}' \
               --header='Select file to edit')
    [[ -n "$file" ]] && $EDITOR "$file"
  }
  
  # Code-Suche mit fzf-preview
  fcode() {
    [[ $# -eq 0 ]] && echo "Usage: fcode <search-pattern>" && return 1
    local result file line
    result=$(rg --line-number --no-heading --color=always "$@" | \
             fzf --ansi \
                 --delimiter=':' \
                 --preview='fzf-preview {1}' \
                 --preview-window='+{2}-/2' \
                 --header='Select match to edit')
    
    if [[ -n "$result" ]]; then
      file=$(echo "$result" | cut -d: -f1)
      line=$(echo "$result" | cut -d: -f2)
      $EDITOR "$file" "+$line"
    fi
  }
  
  # Git-Dateien durchsuchen
  fgit() {
    local file
    file=$(git ls-files | \
           fzf --preview='fzf-preview {}' \
               --header='Git-tracked files')
    [[ -n "$file" ]] && $EDITOR "$file"
  }
'';


# enable zsh system-wide use
 users.defaultUserShell = pkgs.zsh;
# add a shell to /etc/shells
 environment.shells = with pkgs; [ zsh ];
 programs.zsh = {
     enable  = true;
	 histSize = 30000;
	 histFile = "$ZDOTDIR/history/zhistory";     
     # enable zsh completion for all interactive zsh shells.
     enableCompletion = true;       	
     enableBashCompletion = true;
     enableLsColors = true;
     syntaxHighlighting.enable = true;  
     # enable integr for VTE terminals, preserve the current directory of the shell across terminals. aka Verzeichnisverfolgung        
     vteIntegration = true; 
     autosuggestions.enable = true; 
     #autosuggestions.strategy = "history";  

# Shell variables (werden in .zshenv gesetzt)
    shellInit = ''
 # --- Completion setup ---
 # Ensure compinit is loaded safely. Use -u to avoid insecure directories warning.
 # autoload looks in directories of the "_Zsh file search path_", defined in # the variable `$fpath`, and search a file called `compinit`.
# with hidden files
       autoload -Uz compinit
       _comp_options+=(globdots)
      
 # If compinit fails due to insecure permissions, do not silently continue.
      if ! compinit -u 2>/dev/null; then
        printf "Warning: compinit failed. Check permissions of fpath directories.\n" >&2
      fi
      fpath=(
        $ZDOTDIR(N)
        $fpath
      )
     
      ########################################################
      # Zsh‑spezifische Variablen
      export HISTIGNORE="ls:cd:pwd:exit:tldr:cheat::cat:man:eza:lsd:cp:echo:z:bap:bat:git:"
      export HISTTIMEFORMAT="%Y-%m-%d %H:%M "
      export DIRSTACKSIZE=9
      export REPORTTIME=3
      export COLUMNS=80
      ########################################################
      # EZA Konfiguration
      export EZA_ICONS_AUTO="auto"
      export EZA_ICON_SPACING=1
      export EZA_GRID_ROWS=3
      export EZA_GRID_COLUMNS=4
      export EZA_MIN_LUMINANCE=50
      
      export EZA_COLORS="$LS_COLORS:hd=38;5;226:\
      uu=38;5;202:gu=38;5;208:da=38;5;111:\
      uR=38;5;197:uG=38;5;198"
    '';
 
# ----------------------------------
#          - - - PROMPT - - - 
# promptInit = builtins.readFile /share/zsh/prompt.zsh; # Dies vermeidet Escape-Probleme vollständig, da File direkt eingelesen wird ohne Nix-Interpolation.
 # Prompt initialization (executed at build-time into the generated file) 
 # Enable Powerlevel10k prompt with fallback
  ##### ZSH-PROMPT: #####################################
  # promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  # ... .zshrc
 promptInit = '' 
  [[ -f ${pkgs.zsh-powerlevel10k}/share/zsh/themes/zsh-powerlevel10k/powerlevel10k.zsh-theme ]] && \
  source ${pkgs.zsh-powerlevel10k}/share/zsh/themes/zsh-powerlevel10k/powerlevel10k.zsh-theme && echo "nr. 1"
   
  [[ -f ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme ]] && \
  source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
     '';

# entspricht der .zshrc ------
interactiveShellInit = ''
# Load FZF configuration
    [[ -f /etc/zsh/fzf-config.sh ]] && source /etc/zsh/fzf-config.sh
      
# Load colors
[[ -f /etc/colorEnvExport.sh ]] && source /etc/colorEnvExport.sh

# if [[ -f "${pkgs.nix-index}/etc/profile.d/command-not-found.sh"  ]]; then 
# source "${pkgs.nix-index}/etc/profile.d/command-not-found.sh"
 
##  ZSH DIRECTORY STACK - DS
     alias -g D='dirs -v'
     for index ({1..9}) alias "$index"="cd -$index"

# not needed, because sourcing zshrc (normally automatic)
#if [[ -f "$ZDOTDIR/.zshrc" ]]; then 
#       source "$ZDOTDIR/.zshrc" 
# fi         
'';

 setOptions = [  # see man 1 zshoptions
 "AUTO_CD"              # ..' statt 'cd ..' Automatically change directory 
 "AUTO_PUSHD"           # Push the current directory visited on the stack.
 "ALIAS_FUNC_DEF"       # Allow aliases to be used in function definitions.
 "BANG_HIST"            # Treat the '!' character specially during expansion.
 "CORRECT"              # Attempt to correct spelling errors in commands.
 "EXTENDED_HISTORY"          # Write the history file in the ':start:elapsed;command' format.
 "EXTENDEDGLOB"         # for superglob for ls **/*.txt oder ls -d *(D)
 # "HIST_IGNORE_DUPS"     # Don't record an entry that was just recorded again.
 # "HIST_IGNORE_ALL_DUPS" # Delete old recorded entry if new entry is a duplicate.
 "HIST_FIND_NO_DUPS"    # Do not display a line previously found.
 "HIST_IGNORE_SPACE"    # Don't record an entry starting with a space.
 "HIST_SAVE_NO_DUPS"    # Don't write duplicate entries in the history file.
 "HIST_REDUCE_BLANKS"   # Remove superfluous blanks before recording entry.
 "HIST_VERIFY"          # Do not execute immediately upon history expansian
 "HIST_EXPIRE_DUPS_FIRST"  # Expire duplicate entries first when trimming history.
 "INTERACTIVE_COMMENTS" # Allow comments (#) in interactive shells.
 "INC_APPEND_HISTORY"   # Write to the history file immediately, not when the shell exits.
 "NOTIFY"               # Report immediately when background jobs complete.
 "NOMATCH"              # Print an error if no matches are found for a pattern 
 # "no_global_rcs"	# Prevent global startup files (~/.zshrc, /etc/zshrc, etc.)
 "RM_STAR_WAIT"       	# beware of rm errors
 "SHARE_HISTORY"        # Share history between all sessions.
 "PRINT_EXIT_VALUE"     # Print the exit value of programs that return a non-zero status.
 "PUSHD_IGNORE_DUPS"    # Do not store duplicates in the stack.
 "PUSHD_SILENT"         # Do not print the directory stack after pushd or popd.
 "SH_WORD_SPLIT"        # Perform word splitting on unquoted parameters (similar to Bourne shell behavior).
	    ]; 
   };
  
environment.systemPackages = with pkgs; [
# ---- --> ZSH <-- ----
  zsh # Shell
  zsh-autosuggestions # Command line suggestions
  zsh-autocomplete # Autocomplete for Zsh
  zsh-syntax-highlighting # Syntax highlighting
  zsh-completions # Additional completions
  # zsh-powerlevel9k # Zsh theme
  zsh-powerlevel10k # Enhanced Zsh theme
  starship # minimal, blazing-fast, and infinitely customizable prompt
  zsh-nix-shell # Use Zsh in nix-shell
  nix-zsh-completions # Nix completions for Zsh

# --- --> 4 either Shell <-- ----
    bat-extras.batgrep          # Grep with bat
    bat-extras.batman # batgrep, batman, batpipe (less), batwatch, batdiff, prettybat 
    bat-extras.batdiff          # Diff with bat
    sd                          # Modern sed replacement
    broot                       # Directory tree navigator
    httpie                      # User-friendly HTTP client
    delta                       # Syntax-highlighting pager for git
    shellcheck                  # Shell script analysis tool
    shfmt                       # Shell script formatter
    duf                         # Modern df replacement
    dust                        # Modern du replacement
    procs                       # Modern ps replacement
    bar # cli progress
    ncdu # Disk usage analyzer with an ncurses interface
    mupdf # Lightweight PDF, XPS, and E-book viewer and toolkit written in portable C
pdfgrep # Commandline utility to search text in PDF files
### Terminal and Shell Utilities
micro-with-wl-clipboard # Modern and intuitive terminal-based text editor
  kitty # Terminal emulator
  lsd # Modern ls command
  colordiff # Colored diff toolsource /etc/zsh/colorEnvExport.sh
 
  lscolors # Colorize paths using LS_COLORS
  lcms # Color management engine
  terminal-colors # Display terminal colors
  colorpanes # Terminal pane colors
  sanctity # Terminal color combinations
  notcurses # c compile , TUIs and character graphics
  terminal-parrot # Shows colorful, animated party parrot in your terminial
### Miscellaneous
  # thefuck # Corrects previous console commands
  ripgrep # Fast search tool
  banner # Text banner tool
  toilet # Text banner tool
  tealdeer # Simplified man pages
  neo-cowsay # ASCII art tool
  xcowsay # Customize cowsay with images
  zsh-completions # Additional completions
  fortune # Display random quotes
  clolcat # Colorize output
  blahaj # Fun terminal tool
  xcp	# cp 2.0
  colorized-logs # Tools for logs with ANSI color
  colorz # color scheme generator. $ colorz image -n 12
 colorless # colorise cmd output and pipe it to less -->  eval $(colorless -as)
# dumm:	colorstorm # cmd line tool to generate color themes for editors (Vim, VSCode, Sublime, Atom) and terminal emulators (iTerm2, Hyper).
  colord-gtk4 # Color Manager
  gcolor3 # colorsanctity picker
  shunit2 # xUnit based unit test framework for bash scripts
  fd # find in go = find 2.0
  curl wget openssl inetutils
  gnupg
  unzip zip zlib
 # unrar #unfree
  file # specifies that a series of tests are performed on the file
  fff # file mgr
  navi cheat
  fzf # Command-line fuzzy finder
  fzf-preview # Simple fzf preview script for previewing any filetype in fzf's preview window
  fzf-git-sh # Git utilities powered by fzf
 # mcfly # An upgraded ctrl-r where history results make sense
 #  mcfly-fzf # Integrate fzf to mcfly
  bat
  zoxide
  banner # Print large banners to ASCII terminals
  figlet # Program for making large letters out of ordinary text
  zsh-forgit # Git utility tool
  # tmux # Terminal multiplexer
  coreutils # Core utilities expected on every OS
  logrotate # Rotate and compress system logs
  tree # Display directories as trees
  inxi # System information tool
  lshw # Detailed hardware information
  btop # Resource monitor
  duf # Disk usage/free utility
  neofetch hyfetch
  dotacat # Like lolcat, but fast
  graphviz #graph visualization tools
  theme-sh
### ASCII pictures
  asciiquarium-transparent #  Aquarium/sea animation in ASCII art 
  ascii-image-converter # Convert images into ASCII art on the console
  uni2ascii # UTF-8 to ASCII conversion
  jp2a # small utility that converts JPG images to ASCII
  artem # Small CLI program to convert images to ASCII art
  gifsicle
  gif-for-cli # Render gifs as ASCII art in your cli

 github-desktop # GUI for managing Git and GitHub. 
 gitFull # Distributed version control system	  
 gitnr # Create `.gitignore` files using templates
 #  gitlab # GitLab Community Edition 	 	 
 git-doc # Git documentation 	  
 gitstats # Generate statistics from Git repositories 
 gitleaks # Scan git repos for secrets	 
 gitlint # Linting for git commit messages
	 ];
 }
