# zsh.nix
#DEBUG:    nix-instantiate --parse /etc/nixos/modules/zsh.nix

{ config, pkgs, ... }:
{  
#  ------Z-S-H---------------------------
#	▄███████▄     ▄████████    ▄█    █▄    
#	██▀     ▄██   ███    ███   ███    ███   
#	       ▄███▀   ███    █▀    ███    ███   
#	  ▀█▀▄███▀▄▄   ███         ▄███▄▄▄▄███▄▄ 
#	   ▄███▀   ▀ ▀███████████ ▀▀███▀▀▀▀███▀  
#	 ▄███▀                ███   ███    ███   
#	███▄     ▄█    ▄█    ███   ███    ███   
#	▀████████▀  ▄████████▀    ███    █▀ 
#  """"""""""""""""""""""""""""""""""""""                         
 # enable zsh system-wide use
 users.defaultUserShell = pkgs.zsh;
# add a shell to /etc/shells
 environment.shells = with pkgs; [ zsh ];
    programs.zsh = {
        enable  = true;
        enableCompletion = true;       	# enable zsh completion for all interactive zsh shells.
        enableBashCompletion = true;
        enableLsColors = true;
        syntaxHighlighting.enable = true;  
	vteIntegration = true; # enable integr for VTE terminals, preserve the 
	#current directory of the shell across terminals. aka Verzeichnisverfolgung        
        autosuggestions.enable = true; 
#	autosuggestions.strategy = "history"; 	# "match_prev_cmd"; OneOf: "history" "completion"
#    match_prev_cmd: won’t work as expected with  HIST_IGNORE_ALL_DUPS or HIST_EXPIRE_DUPS_FIRST.                                                         
#_______z-s-h------
#  ___      __      ___      _   __      ___    __  ___ 
#  //   ) ) //  ) ) //   ) ) // ) )  ) ) //   ) )  / /    
# //___/ / //      //   / / // / /  / / //___/ /  / /     
#//       //      ((___/ / // / /  / / //        / /      

# Dies vermeidet Escape-Probleme vollständig, da die Datei direkt eingelesen wird ohne Nix-Interpolation.
# promptInit = builtins.readFile /share/zsh/prompt-init.zsh;  
# To customize prompt, run `p10k configure` or edit /share/zsh/prompt/p10k.zsh.
# [[ ! -f /share/zsh/prompt/p10k.zsh ]] || source /share/zsh/prompt/p10k.zsh
 # Enable Powerlevel10k instant prompt. Should stay close to the top of /share/zsh/.zshrc.
 # Initialization code that may require console input (password prompts, [y/n]
 # confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
#  source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
# fi
# 
# if [[ -r"''${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme" ]]; then 

 # source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
promptInit = ''
PROMPT='%F{184}%n%f@%F{013}%m%f%F{025}%K{118} in %k%f%F{225}%K{055}%~%f%k%F{063}%K{045} --> %k%f'
RPROMPT="|%F{#FFCA5B}ERR:%?||%F{#CF36E8}%K{#39257D}%f%k%K{#3B0045}%F{#518EA9}%D{%e.%b.}%f%k%F{#FFEAA0}%K{#1E202C}%f%k||%F{#FFEAA0}%K{#95235F}%D{%R}%f%k%F{#FFCA5B}|"

source  ''${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10.zsh-theme
'';
   
 histSize = 30000;
 histFile = "''$ZDOTDIR/history/zhistory";
/*
 ##### Shell script code called during interactive zsh shell initialisation.  
      
#     	Initialisiere Autocompletion
# 	----------------------------- 
 source <(fzf --zsh)
 # Define syntax highlighting styles
#   _________________________________________________________
#	╔═╗╔═╗╦ ╦    ╦ ╦╦╔═╗╦ ╦╦  ╦╔═╗╦ ╦╔╦╗╦╔╗╔╔═╗
#	╔═╝╚═╗╠═╣    ╠═╣║║ ╦╠═╣║  ║║ ╦╠═╣ ║ ║║║║║ ╦
#	╚═╝╚═╝╩ ╩────╩ ╩╩╚═╝╩ ╩╩═╝╩╚═╝╩ ╩ ╩ ╩╝╚╝╚═╝
#   _________________________________________________________
#	[  "main" "brackets" "pattern" "cursor" "regexp" "root" "line" ]
 source_or_error "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Using typeset -A to ensure it's treated as an associative array
typeset -A ZSH_HIGHLIGHT_STYLES
# FFD75D gelb
 ZSH_HIGHLIGHT_STYLES[command]='fg=#DC8DF5' ##
 ZSH_HIGHLIGHT_STYLES[precommand]='fg=#DC8DF5'
 ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#FFD75D'
 ZSH_HIGHLIGHT_STYLES[alias]='fg=#DC8DF5'
 ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#DC8DF5'
 ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#DC8DF5'
 ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#FFD75D'
 ZSH_HIGHLIGHT_STYLES[builtin]='fg=#DC8DF5'
 ZSH_HIGHLIGHT_STYLES[function]='fg=#DC8DF5'
 ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#726D8F'
 ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#726D8F'
 ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=#DC8DF5'
 ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#FFD75D'
 ZSH_HIGHLIGHT_STYLES[path]='fg=#DC8DF5'
 ZSH_HIGHLIGHT_STYLES[default]='none'
 ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#33E5E5'
 ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#33E5E5'
 ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#33E5E5'
 ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#33E5E5'
 ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#3AEB94'
 ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#3AEB94'
 ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#3AEB94'
 ZSH_HIGHLIGHT_STYLES[assign]='fg=#FFD75D'
 ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#FFD75D'
 ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#FFD75D'
 ZSH_HIGHLIGHT_STYLES[comment]='fg=#3AEB94'
 ZSH_HIGHLIGHT_STYLES[redirection]='fg=#786EC9'
 ZSH_HIGHLIGHT_STYLES[arg0]='fg=#3AEB94' # gruen tuerki
# avoid partial path lookups on a path		# ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/mnt/slow_share)

 typeset -A ZSH_HIGHLIGHT_REGEXP
 ZSH_HIGHLIGHT_REGEXP+=('^rm .*' fg=red,bold)
 ZSH_HIGHLIGHT_REGEXP+=('\<sudo\>' fg=123,bold)
 ZSH_HIGHLIGHT_REGEXP+=('[[:<:]]sudo[[:>:]]' fg=123,bold)

  if [ -f /share/zsh/aliases.zsh ]; then
      source /share/zsh/aliases.zsh
   fi

*/
# autoload command load a file containing shell commands
# autoload looks in directories of the "_Zsh file search path_", defined in the 
# variable `$fpath`, and search a file called `compinit`.


  	interactiveShellInit = ''
  autoload -Uz compinit; compinit
  _comp_options+=(globdots) 	# With hidden files

  fpath=(''${ZDOTDIR}:''${ZDOTDIR}/functions ''${fpath})

 source ''${pkgs.nix-index}/etc/profile.d/command-not-found.sh

 #  Explicitly sourcing a file under ZDOTDIR if needed
 # Zsh normally looks for .zshrc in ZDOTDIR automatically.
 # if [[ -f "$ZDOTDIR/.zshrc" ]]; then source "$ZDOTDIR/.zshrc" fi     
 
 ##  ZSH DIRECTORY STACK - DS
   alias -g D='dirs -v'
   for index ({1..14}) alias ''$index="cd -''${index}"; unset index       
 '';

# zsh aliase:  environment.etc = { "aliases.zsh".source = "/share/zsh/aliases.zsh";   };

 setOptions = [  # see man 1 zshoptions
 "AUTO_CD"              # ..' statt 'cd ..' Automatically change directory 
 "AUTO_PUSHD"           # Push the current directory visited on the stack.
 "ALIAS_FUNC_DEF"       # Allow aliases to be used in function definitions.
 "BANG_HIST"            # Treat the '!' character specially during expansion.
 "CORRECT"              # Attempt to correct spelling errors in commands.
 "EXTENDED_HISTORY"          # Write the history file in the ':start:elapsed;command' format.
 "EXTENDEDGLOB"         # for superglob for ls **/*.txt oder ls -d *(D)
 "HIST_IGNORE_DUPS"     # Don't record an entry that was just recorded again.
 "HIST_IGNORE_ALL_DUPS" # Delete old recorded entry if new entry is a duplicate.
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
 
# Disable command-not-found in favor of nix-index    
 programs.command-not-found.enable = false; # -> nix-index 
 programs.nix-index = {  # damit command: nix-locate pattern
        enable = true; # a file database for nixpkgs for "cmd-not-found".
    	package = pkgs.nix-index;
    	enableZshIntegration = true;    
    	};

 programs.fzf.fuzzyCompletion = true; # die source ich selber unter 
 programs.fzf.keybindings = true; # Whether to enable fzf keybindings.

  
environment.systemPackages = with pkgs; [
# ---- --> BASH <-- ----
    bash                          # GNU Bourne-Again Shell
    bash-completion              # Programmable completion for Bash
    bashInteractive              # Interactive Bash with readline  
    
# ---- --> ZSH <-- ----
### SHELL
  zsh # Shell
  zsh-autosuggestions # Command line suggestions
  zsh-autocomplete # Autocomplete for Zsh
  zsh-syntax-highlighting # Syntax highlighting
  zsh-completions # Additional completions
#  zsh-powerlevel9k # Zsh theme
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

 # jupyter # webbasierte interaktive Entwicklungsumgebung. Sie eignet sich hervorragend für explorative Datenanalyse und prototypisches Coden, was für die Entwicklung von Phytom-Anwendungen

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
