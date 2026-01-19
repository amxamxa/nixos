{ config, pkgs, ... }: {
  #______________________________________________________
  # 		888                     888      
  # 		888                     888      
  #  		888                     888      
  #  		88888b.  8888b. .d8888b 88888b.  
  #  		888 "88b    "88b88K     888 "88b 
  #  		888  888.d888888"Y8888b.888  888 
  #  		888 d88P888  888     X88888  888 
  #	  	88888P" "Y888888 88888P'888  888
  #______________________________________________________                              

  # Enable nix-index integration for bash
  programs.nix-index.enableBashIntegration = true;

  # Main Bash configuration
  programs.bash = {
    enable = true;
    completion.enable= true;
    enableLsColors = true;

    interactiveShellInit = ''
      ##### Interactive Bash Shell Initialization
      # Source nix-index for command-not-found
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh

   # Source fzf keybindings and completion
      if command -v fzf-share >/dev/null; then
        source "$(fzf-share)/key-bindings.bash"
        source "$(fzf-share)/completion.bash"
      fi

  # Load custom aliases if they exist
      if [ -f /etc/bash/aliases.bash ]; then
        source /etc/bash/aliases.bash
      fi

   # History search with arrow keys
      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'

   # Ctrl+arrow word navigation
      bind '"\e[1;5C": forward-word'
      bind '"\e[1;5D": backward-word'

   # Set up directory colors
      if [ -f ~/.dir_colors ]; then
        eval "$(dircolors -b ~/.dir_colors)"
      else
        eval "$(dircolors -b)"
      fi

  # Zoxide (smart cd) integration
      if command -v zoxide &> /dev/null; then
        eval "$(zoxide init bash)"
      fi

  # Starship prompt integration (if not using custom PS1)
  #    if command -v starship &> /dev/null; then
  #      eval "$(starship init bash)"
  #    fi

  # Custom functions
      # Create directory and cd into it
      mcd() {
        mkdir -p "$1" && cd "$1"
      }

      # Disk usage helpers
      du1() {
        du -h --max-depth=1 "$@"
      }

      du2() {
        du -h --max-depth=2 "$@"
      }

   # Extract various archive formats
      extract() {
        if [ -f "$1" ]; then
          case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }
    '';

    # Bash prompt (fallback if starship is not used)
    promptInit = ''
      # Git prompt function
      parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
      }

      # Custom PS1 (only if starship is not available)
      if ! command -v starship &> /dev/null; then
        # Two-line prompt with git integration
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[\033[01;33m\]$(parse_git_branch)\[\033[00m\]\n\$ '
      fi
    '';

    # Shell init (for both interactive and non-interactive shells)
    shellInit = ''
      # History configuration
      export HISTSIZE=10000
      export HISTFILESIZE=20000
      export HISTCONTROL=ignoreboth:erasedups
      export HISTIGNORE="ls:ll:cd:pwd:exit:clear:history"
      export HISTTIMEFORMAT="%F %T "
    '';
  };


  # Required packages for full bash functionality
  environment.systemPackages = with pkgs; [
    bash-completion # Bash completions
    nix-index # Command-not-found database
    nix-bash-completions # Nix-specific bash completions
    fzf # Fuzzy finder
    bat # Better cat
    eza # Modern ls (alternative: lsd)
    zoxide # Smart cd
    starship # Modern prompt
  ];
}

