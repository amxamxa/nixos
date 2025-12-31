# zsh.nix
        /* services.xserver.excludePackages
        environment.xfce.excludePackages
        environment.plasma6.excludePackages
        environment.pantheon.excludePackages
        environment.mate.excludePackages
        environment.lxqt.excludePackages
        environment.gnome.excludePackages
        environment.enlightenment.excludePackages
        environment.cosmic.excludePackages
        environment.cinnamon.excludePackages
        environment.budgie.excludePackages */
{ config, pkgs, ... }:
{  
#  ----------------------
#       Z  S  H
# """"""""""""""""""""""
 programs.command-not-found.enable = false;
 # programs.zsh.interactiveShellInit = ''
 #	source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh '';
 programs.bash.interactiveShellInit = ''
 	source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh '';

 programs.nix-index = {  # damit command: nix-locate pattern
        enable = true; # a file database for nixpkgs for "cmd-not-found".
    	package = pkgs.nix-index;
    	enableBashIntegration = true;
    	enableZshIntegration = true;    
    	};
    	
 programs.bash.completion.enable = true;
 programs.bash.enableLsColors = true; 
 
 programs.fzf.fuzzyCompletion = true; 
 programs.fzf.keybindings = false; # Whether to enable fzf keybindings.
 
 
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
                autosuggestions.enable = true; 
#	autosuggestions.strategy = "history"; 	# "match_prev_cmd"; OneOf: "history" "completion"
#    match_prev_cmd: won’t work as expected with  HIST_IGNORE_ALL_DUPS or HIST_EXPIRE_DUPS_FIRST. 

# man eza_colors
# The codes accepted by eza are:       38;5;nnn  for a colour from 0 to  255
#   for i in {0..255}; do echo -e "\033[38;5;${i}m das ist TTTTEEEEXXT in Farbe ${i} \033[0m"; done
#   for index ({1..14}) alias "$index"="cd -${index}"; unset index
  	interactiveShellInit = ''
 ##### Shell script code called during interactive zsh shell initialisation.  

# Füge den Pfad für Custom- u Autoload-Funktionen hinzu. When we run a 
# command that corresponds to an autoloaded function, ZSH searches for 
# it in the “fpath” and loads it into the memory if located.
fpath=($ZDOTDIR:$ZDOTDIR/functions:$ZDOTDIR/plugins:$ZDOTDIR/prompts $fpath)
    
 source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh

# Initialize fzf
if [[ -x "$(command -v fzf)" ]]; then
	source <(fzf --zsh)
    #export FZF_DEFAULT_COMMAND='ag -g ""'
    #export FZF_DEFAULT_OPTS='-m --preview-window=up:40%:wrap'
fi

# 		Initialisiere Autocompletion
# 	----------------------------- 
 # autoload command load a file containing shell commands
 # autoload looks in directories of the "_Zsh file search path_", defined in the 
 # variable `$fpath`, and search a file called `compinit`.
  autoload -Uz compinit; compinit
  _comp_options+=(globdots) 	# With hidden files

##  ZSH DIRECTORY STACK - DS
   alias -g D='dirs -v'
        
        # das ist hier aber nicht nötig, da alles über die $ZDOTDIR/zshrc.zsh gesourct wird!
        # test -f $ZDOTDIR/zshrc.zsh && source $ZDOTDIR/zshrc.zsh
   #    _________________________________________
  '';

   
promptInit = ''
        # Shell script code used to initialise the zsh prompt.
#        [[ ! -f "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme" ]] || source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
         [[ ! -f "($ZDOTDIR)/plugins/p10k-fancy-v01.zsh") ]] || "($ZDOTDIR)/plugins/p10k-fancy-v01.zsh"
         '';
 histSize = 30000;
 histFile = "$ZDOTDIR/history/zhistory";
 setOptions = [  # see man 1 zshoptions
 "AUTO_CD"              # ..' statt 'cd ..' Automatically change directory 
 "AUTO_PUSHD"           # Push the current directory visited on the stack.
 "ALIAS_FUNC_DEF"       # Allow aliases to be used in function definitions.
 "BANG_HIST"            # Treat the '!' character specially during expansion.
 "CORRECT"              # Attempt to correct spelling errors in commands.
 "EXTENDED_HISTORY"          # Write the history file in the ':start:elapsed;command' format.
 "EXTENDEDGLOB"            # for superglob for ls **/*.txt oder ls -d *(D)
 "HIST_EXPIRE_DUPS_FIRST"    # Expire duplicate entries first when trimming history.
 "HIST_IGNORE_DUPS"          # Don't record an entry that was just recorded again.
 "HIST_IGNORE_ALL_DUPS"      # Delete old recorded entry if new entry is a duplicate.
 "HIST_FIND_NO_DUPS"         # Do not display a line previously found.
 "HIST_IGNORE_SPACE"         # Don't record an entry starting with a space.
 "HIST_SAVE_NO_DUPS"         # Don't write duplicate entries in the history file.
 "HIST_REDUCE_BLANKS"        # Remove superfluous blanks before recording entry.
 "HIST_VERIFY"               # Do not execute immediately upon history expansian
 "INTERACTIVE_COMMENTS"    # Allow comments (#) in interactive shells.
 "INC_APPEND_HISTORY"        # Write to the history file immediately, not when the shell exits.
 "NOTIFY"                  # Report immediately when background jobs complete.
 "NOMATCH"                 # Print an error if no matches are found for a pattern 
 #   "no_global_rcs"	#  # Prevent reading of the global strtup files (~/.zshrc, /etc/zshrc, etc.) for non-login shells.
 "RM_STAR_WAIT"           	# beware of rm errors
 "SHARE_HISTORY"             # Share history between all sessions.
 "PRINT_EXIT_VALUE"        # Print the exit value of programs that return a non-zero status.
 "PUSHD_IGNORE_DUPS"    # Do not store duplicates in the stack.
 "PUSHD_SILENT"         # Do not print the directory stack after pushd or popd.
 "SH_WORD_SPLIT"           # Perform word splitting on unquoted parameters (similar to Bourne shell behavior).
	
			        ]; 
        };
  
environment.etc = { "aliases.zsh".source = "/share/zsh/aliases.zsh";   };

environment.systemPackages = with pkgs; [
 bar # cli progress
 spotdl # Download your Spotify playlists and songs along with album art and metadata
 ncdu # Disk usage analyzer with an ncurses interface
### Terminal and Shell Utilities
  kitty # Terminal emulator
  lsd # Modern ls command
  eza # Improved ls replacement
  colordiff # Colored diff tool
  lscolors # Colorize paths using LS_COLORS
  lcms # Color management engine
  terminal-colors # Display terminal colors
  colorpanes # Terminal pane colors
  sanctity # Terminal color combinations
  notcurses # c compile , TUIs and character graphics
  terminal-parrot # Shows colorful, animated party parrot in your terminial
  bat-extras.batman # scripts: batgrep, batman, batpipe (less), batwatch, batdiff, prettybat 
### Miscellaneous
  #thefuck # Corrects previous console commands
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
 colorless # colorise cmd output and pipe it to less $ eval "$(colorless -as)"
# dumm:	colorstorm # cmd line tool to generate color themes for editors (Vim, VSCode, Sublime, Atom) and terminal emulators (iTerm2, Hyper).
  colord-gtk4 # Color Manager
  gcolor3 #colorsanctity picker
  shunit2 # xUnit based unit test framework for bash scripts
  fd # find in go = find 2.0
  curl wget openssl inetutils
  gnupg
  unzip zip zlib
 # unrar #unfree
  file # specifies that a series of tests are performed on the file
  fff # file mgr
###SHELL
  zsh # Shell
  zsh-autosuggestions # Command line suggestions
  zsh-autocomplete # Autocomplete for Zsh
  zsh-syntax-highlighting # Syntax highlighting
  zsh-completions # Additional completions
#  zsh-powerlevel9k # Zsh theme
# zsh-powerlevel10k # Enhanced Zsh theme
 starship #minimal, blazing-fast, and infinitely customizable prompt
 zsh-nix-shell # Use Zsh in nix-shell
 nix-zsh-completions # Nix completions for Zsh
 navi cheat
 fzf # Command-line fuzzy finder
 fzf-zsh # Fzf integration for Zsh
 fzf-git-sh # Git utilities powered by fzf
	 ################### 
 # mcfly # An upgraded ctrl-r where history results make sense
 #  mcfly-fzf # Integrate Mcfly with fzf to combine a solid command history database with a widely-loved fuzzy search UI
  bat
  zoxide
  figlet   banner # Print large banners to ASCII terminals
  calligraphy # GTK tool turning text into ASCII banners
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
  htop # Interactive process viewer
  toybox # ascii bblkid blockdev bunzip2 ... uvm
  jq # lightweight and flexible command-line JSON processo
  neofetch hyfetch
  dotacat # Like lolcat, but fast
  graphviz #graph visualization tools
  theme-sh
	 
### ASCII pictures
  asciiquarium-transparent #  Aquarium/sea animation in ASCII art 
  ascii-image-converter # Convert images into ASCII art on the console
  pablodraw # Ansi/Ascii text and RIPscrip vector editor/viewer
  ascii-draw #
  uni2ascii # UTF-8 to ASCII conversion
  jp2a # small utility that converts JPG images to ASCII
  artem # Small CLI program to convert images to ASCII art
  gifsicle
  gif-for-cli # Render gifs as ASCII art in your cli

 # jupyter # webbasierte interaktive Entwicklungsumgebung. Sie eignet sich hervorragend für explorative Datenanalyse und prototypisches Coden, was für die Entwicklung von Phytom-Anwendungen
	 # Version Control
#	  git-hub # Interface to GitHub from the command line 
#        github-desktop # GUI for managing Git and GitHub. 
 gitFull # Distributed version control system	  
 gitnr # Create `.gitignore` files using templates
	#  gitlab # GitLab Community Edition 	 	 
 git-doc # Git documentation 	  
 gitstats # Generate statistics from Git repositories  g
 gitleaks # Scan git repos for secrets	 
 gitlint # Linting for git commit messages
	 ];


#   STARSHIP PROMPT:
# """"""""""""""""""""""
 #   programs.starship = {      enable = true;      settings = {        add_newline = true;        format = "$line_break$package$character"; # CLI-Anzeigeformat       scan_timeout = 20;      };      interactiveOnly = true;      # presets = ./path/to starship.toml; # Optional: Externe Preset-Datei    };
	 
}

