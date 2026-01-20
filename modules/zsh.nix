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
  here = builtins.toString ./.;
in
{
#### ZDOTDIR global setzen ####
# ACHTUNG: NICHT in "s" setzten! DENN DANN IST ES EIN STRING UND KEINE ZUORDNUNG zu einer Variablen!!
environment.variables.ZDOTDIR = ZDOTDIR;
environment.variables.ZFUNC = ZFUNC;
environment.variables.SHARE = SHARE; 
environment.variables.PRO = PRO; 

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

# export cols for echo, printf
 environment.etc."colorEnvExport.sh" = {
      text = ''
        # Use 24-bit RGB colors (modern terminals like kitty)
        readonly RED=$'\033[38;2;240;128;128m\033[48;2;139;0;0m'
        readonly GELB=$'\e[33m'
        readonly GREEN=$'\033[38;2;0;255;0m\033[48;2;0;100;0m'
        readonly PINK=$'\033[38;2;255;0;53m\033[48;2;34;0;82m'
        readonly LILA=$'\033[38;2;255;105;180m\033[48;2;75;0;130m'
        readonly LIL2=$'\033[38;2;239;217;129m\033[48;2;59;14;122m'
        readonly VIO=$'\033[38;2;255;0;53m\033[48;2;34;0;82m'
        readonly BLUE=$'\033[38;2;252;222;90m\033[48;2;0;0;139m'
        readonly LIME=$'\033[38;2;6;88;96m\033[48;2;0;255;255m'
        readonly YELLO=$'\033[38;2;255;215;0m\033[48;2;60;50;0m'
        readonly LAVEN=$'\033[38;2;200;170;255m\033[48;2;40;30;70m'
        readonly PINK2=$'\033[38;2;255;105;180m\033[48;2;60;20;40m'
        readonly RASPB=$'\033[38;2;190;30;90m\033[48;2;50;10;30m'
        readonly VIOLE=$'\033[38;2;170;0;255m\033[48;2;30;0;60m'
        readonly ORANG=$'\033[38;2;255;140;0m\033[48;2;60;30;0m'
        readonly CORAL=$'\033[38;2;255;110;90m\033[48;2;70;30;20m'
        readonly GOLD=$'\033[38;2;255;200;60m\033[48;2;80;60;10m'
        readonly OLIVE=$'\033[38;2;120;140;40m\033[48;2;40;50;20m'
        readonly PETRO=$'\033[38;2;0;160;160m\033[48;2;0;40;40m'
        readonly CYAN=$'\033[38;2;80;220;220m\033[48;2;0;50;50m'
        readonly GREY=$'\033[38;2;200;200;200m\033[48;2;60;60;60m'
        readonly TEAL=$'\033[38;2;0;180;140m\033[48;2;0;60;50m'
        readonly MINT=$'\033[38;2;150;255;200m\033[48;2;20;60;40m'
        readonly SKY=$'\033[38;2;120;200;255m\033[48;2;30;60;80m'
        readonly PLUM=$'\033[38;2;180;80;200m\033[48;2;50;20;60m'
        readonly BROWN=$'\033[38;2;160;110;60m\033[48;2;50;30;10m'
        readonly IVORY=$'\033[38;2;255;250;220m\033[48;2;80;70;50m'
        readonly SLATE=$'\033[38;2;150;160;170m\033[48;2;40;50;60m'
        readonly INDIG=$'\033[38;2;90;0;130m\033[48;2;30;0;50m'
        readonly EMBER=$'\033[38;2;255;80;40m\033[48;2;60;20;10m'
        readonly BOLD=$'\033[1m'
        readonly BLINK=$'\033[5m'
        readonly UNDER=$'\033[4m'
        readonly RESET=$'\033[0m'
      '';
      mode = "0444"; # read-only
    };
# globale aliase fuer zsh, bash, ...
/* NIX-spezific:
- Maskierung von Sonderzeichen (Escaping) beachten \"
- semikolon und kein leerzeichen */
environment.shellAliases = {
# wird auto. gesourct
	grep="grep --color=always";
  	fd="echo \"fd mit --color=auto\" && fd --color=auto";
  	ncdu="echo \"ncdu mit --color dark\" && ncdu --color dark";
  # --verbose
 	cp="cp -v";
  	rm="rm -v";
  	mv="mv -v";
};

# Disable command-not-found in favor of nix-index    
 programs.command-not-found.enable = false; # -> nix-index 
 programs.nix-index = {  # damit command: nix-locate pattern
        enable = true; # a file database for nixpkgs for "cmd-not-found".
    	package = pkgs.nix-index;
    	enableZshIntegration = true;    
    	};
  # programs.pay-respects = true; #  This usually happens if `programs.pay-respects' has option        definitions inside that are not matched. Please check how to properly define       this option by e.g. referring to `man 5 configuration.nix'!insteadt  programs.thefuck
  programs.pay-respects.enable = true;
  # You can also set a custom API endpoint, large language model and locale for command corrections. Simply access the aiIntegration.url, aiIntegration.model and aiIntegration.locale options, as described in the example.
  #    Take a look at the services.ollama NixOS module if you wish to host a local large language model for pay-respects.
   programs.pay-respects.aiIntegration = true;
#===============================================
  # FZF CONFIGURATION
  # Fuzzy Finder für interaktive Shell-Nutzung
programs.fzf.fuzzyCompletion = false;
# Whether to enable fzf keybindings. 
programs.fzf.keybindings = false; 

# FZF configuration via environment file
  environment.etc."zsh/fzf-confg.sh".text = ''
  #----- FZF default option--------------------------------------------
    # with Dracula theme
    export FZF_DEFAULT_OPTS="--border rounded \
      --color=dark \
      --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 \
      --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 \
      --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 \
      --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 \
      --layout=reverse --height 40% --preview-window=right:60% \
      --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} ist eine Binärdatei || (bat --style=numbers --color=always {} || cat {}) 2>/dev/null | head -300'"
      
 #----- FZF CTRL-R options ----------------------------------------------------
    #  for history search
    export FZF_CTRL_R_OPTS="--border rounded \
      --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 \
      --info inline --no-sort --no-preview \
      --header '󰅍 Befehlshistory (Enter: Ausführen | CTRL-Y: Kopieren)'"
      
 ### History Widget
      fzfh() {
      print -z "$(fc -rl 1 | fzf | sed 's/^[[:space:]]*[0-9]\+[[:space:]]*//')"
      }
      # keybinding
      bindkey -s '^F' 'fh\n'
      #--------------------
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

# Shell variables (werden in .zshrc gesetzt)
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
        $ZDOTDIR/functions(N)
        $ZDOTDIR/prompt(N)
        $ZDOTDIR(N)
        $fpath
      )
     
      ########################################################
      # Zsh‑spezifische Variablen
      export HISTIGNORE="ls:cd:pwd:exit:tldr:cheat::cat:man:eza:lsd:cp:echo:z:bap:bat:git:"
      export HISTTIMEFORMAT="%Y-%m-%d %H:%M "
      export DIRSTACKSIZE=9
      export REPORTTIME=3
      export COLUMNS=60

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
 promptInit = ''
 source ${pkgs.zsh-powerlevel10k}/share/zsh/themes/zsh-powerlevel10k/powerlevel10k.zsh-theme";
   '';
# entspricht der .zshrc ------
interactiveShellInit = ''
# Load FZF configuration
    [[ -f /etc/zsh/fzf-config.sh ]] && source /etc/zsh/fzf-config.sh

# if [[ -f "${pkgs.nix-index}/etc/profile.d/command-not-found.sh"  ]]; then 
# source "${pkgs.nix-index}/etc/profile.d/command-not-found.sh"
 
  ##  ZSH DIRECTORY STACK - DS
     alias -g D='dirs -v'
     for index ({1..9}) alias "$index"="cd -$index"

# not needed, because sourcing zshrc (normally automatic)
#if [[ -f "$ZDOTDIR/.zshrc" ]]; then 
#       source "$ZDOTDIR/.zshrc" 
# fi    
      source /etc/shell-colors.sh
      
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
### Terminal and Shell Utilities
micro-with-wl-clipboard # Modern and intuitive terminal-based text editor
  kitty # Terminal emulator
  lsd # Modern ls command
  colordiff # Colored diff tool
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
  fzf-zsh # Fzf integration for Zsh
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
