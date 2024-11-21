# zsh.nix
{ config, pkgs, ... }:
{

 #   programs.starship = {      enable = true;      settings = {        add_newline = true;        format = "$line_break$package$character"; # CLI-Anzeigeformat       scan_timeout = 20;      };      interactiveOnly = true;      # presets = ./path/to starship.toml; # Optional: Externe Preset-Datei    };
#   -----------------------------------------------------------------
#       Z  S  H
 programs.command-not-found.enable = false;
 # programs.zsh.interactiveShellInit = ''
 #	source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh '';
 programs.bash.interactiveShellInit = ''
 	source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh '';

 programs.nix-index =        { #damit command: nix-locate pattern
        enable = true;   # whether to enable nix-index, a file database for nixpkgs.
    	package = pkgs.nix-index;
    	enableBashIntegration = true;
    	enableZshIntegration = true;    
    	};
    	
 programs.bash.enableCompletion = true; 
 programs.bash.enableLsColors = true; 
 programs.fzf.fuzzyCompletion = true; 
 programs.thefuck.enable = true; 
 programs.thefuck.alias = "F0";
 
# enable zsh system-wide use
users.defaultUserShell = pkgs.zsh;
# add a shell to /etc/shells
environment.shells = with pkgs; [ zsh ];
    programs.zsh = {
        enable  = true;
        enableCompletion = true;        		# enable zsh completion for all interactive zsh shells.
        enableBashCompletion = true;
        enableLsColors = true;
        syntaxHighlighting.enable = true;   # enable zsh-syntax-highlighting.

        autosuggestions.enable = true;      	# enable zsh-autosuggestions.
#        autosuggestions.strategy = "history"; 	# "match_prev_cmd"; OneOf: "history" "completion"

#   history: Chooses the most recent match from history.
#    completion: Chooses a suggestion based on what tab-completion would suggest. (requires zpty module)
#    match_prev_cmd: Like history, but chooses the most recent match whose preceding history item matches the most recently executed command. Note that this strategy won’t work as expected with ZSH options that don’t preserve the history order such as HIST_IGNORE_ALL_DUPS or HIST_EXPIRE_DUPS_FIRST. 
    interactiveShellInit = ''
        # wird bei Initialisierung einer interaktiven Zsh-Shell ausgeführt.
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
        # ?? das ist hier aber nicht nötig, da alles über die $ZDOTDIR/zshrc.zsh gesourct wird!
        # test -f $ZDOTDIR/zshrc.zsh && source $ZDOTDIR/zshrc.zsh
                           '';
      promptInit = ''
￼ # [[ ! -f "$ZDOTDIR/prompt/p10k-fancy-v02.zsh" ]] || source "$ZDOTDIR/prompt/p10k-fancy-v02.zsh"
            # /share/zsh/prompt/basic-prompt.zsh
          #   source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/internal/p10k.zsh
                    '';
#         shellAliases = "$ZDOTDIR/aliases.zsh";
         histSize = 10000;
          histFile = "$ZDOTDIR/history/zhistory";
          setOptions = [        # see man 1 zshoptions
            "APPEND_HISTORY"        "INC_APPEND_HISTORY"
            "SHARE_HISTORY"         "EXTENDED_HISTORY"
            "HIST_IGNORE_DUPS"      "HIST_IGNORE_ALL_DUPS"
            "HIST_FIND_NO_DUPS"         "HIST_SAVE_NO_DUPS"
            "RM_STAR_WAIT"          "PRINT_EXIT_VALUE"
            "SH_WORD_SPLIT"         "CORRECT"
            "NOTIFY"            "INTERACTIVE_COMMENTS"
            "ALIAS_FUNC_DEF"        "EXTENDEDGLOB"
            "AUTO_CD"           "NOMATCH"       #   "no_global_rcs"
                        ]; };
}


