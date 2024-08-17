# zsh.nix
{ config, pkgs, ... }:
			
{
#	-----------------------------------------------------------------
#	    Z  S  H 
programs.command-not-found.enable = false;
# programs.zsh.interactiveShellInit = '' source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh '';
 programs.bash.interactiveShellInit = ''  	
 source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh '';
programs.nix-index = 		{ #damit command: nix-locate pattern 
 		enable = true;   # whether to enable nix-index, a file database for nixpkgs.  
 	package = pkgs.nix-index;
 	enableBashIntegration = true;  
 	enableZshIntegration = true;    };
 
# enable zsh system-wide use 
programs.bash.enableCompletion = true;
programs.bash.enableLsColors =true; 
programs.fzf.fuzzyCompletion = true;

programs.thefuck.enable = true;
programs.thefuck.alias = "F0";

users.defaultUserShell = pkgs.zsh;
# add a shell to /etc/shells
environment.shells = with pkgs; [ zsh ];
	programs.zsh = {
		enable	= true;
		enableCompletion = true; #Enable zsh completion for all interactive zsh shells.
		enableBashCompletion = true;
		enableLsColors = true;
		autosuggestions.enable = true; # enable zsh-autosuggestions.
		syntaxHighlighting.enable = true; #enable zsh-syntax-highlighting.
		interactiveShellInit = '' 
# wird bei Initialisierung einer interaktiven Zsh-Shell ausgeführt. (Interaktive Shells sind die Shells, mit denen Benutzer direkt interagieren.)
		source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh         
  		test -f $ZDOTDIR/zshrc.zsh && source $ZDOTDIR/zshrc.zsh
 '';

		promptInit = ''
	# dieser Code wird verwendet, um den Zsh-Prompt zu initialisieren. 
	# das ist hier aber nicht nötig, da alles über die $ZDOTDIR/zshrc.zsh gesourct wird!
                source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
                [[ ! -f $ZDOTDIR/prompt/p10k-fancy.zsh ]] || source $ZDOTDIR/prompt/p10k-fancy.zsh
                # /share/zsh/prompt/basic-prompt.zsh                  
                # source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/internal/p10k.zsh
					'';
#	  	  shellAliases = "$ZDOTDIR/aliases.zsh";
		  histSize = 10000;
		  histFile = "$ZDOTDIR/history/zhistory";

		  setOptions = [		# see man 1 zshoptions
			"APPEND_HISTORY" 		"INC_APPEND_HISTORY"
			"SHARE_HISTORY" 		"EXTENDED_HISTORY"
			"HIST_IGNORE_DUPS" 	  	"HIST_IGNORE_ALL_DUPS"
			"HIST_FIND_NO_DUPS" 		"HIST_SAVE_NO_DUPS"
			"RM_STAR_WAIT"			"PRINT_EXIT_VALUE"
			"SH_WORD_SPLIT" 		"CORRECT"
			"NOTIFY" 			"INTERACTIVE_COMMENTS"
			"ALIAS_FUNC_DEF"		"EXTENDEDGLOB"
			"AUTO_CD"			"NOMATCH"		#	"no_global_rcs"
				        ]; };
#	-----------------------------------------------------------------


	}
	
