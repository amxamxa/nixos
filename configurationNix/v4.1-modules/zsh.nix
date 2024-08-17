# zsh.nix
{ config, pkgs, ... }:
			
{
############################# ZSH
programs.command-not-found.enable = false;
# programs.zsh.interactiveShellInit = '' source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh '';
 programs.bash.interactiveShellInit = ''  	source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh '';
programs.nix-index = 		{ #damit command: nix-locate pattern 
 enable = true;   # whether to enable nix-index, a file database for nixpkgs.  
 package = pkgs.nix-index;
 enableBashIntegration = true;  
 enableZshIntegration = true;    };
 

#enable zsh system-wide use 
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

  source /share/zsh/zshrc

		source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh '';        

		promptInit = ''
#source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
#source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/internal/p10k.zsh
					'';
#	  	  shellAliases = "$ZDOTDIR/aliases.zsh";
		  histSize = 10000;
		  histFile = "$ZDOTDIR/history/zhistory";

		  setOptions = [		# see man 1 zshoptions
			"APPEND_HISTORY" 		"INC_APPEND_HISTORY"
			"SHARE_HISTORY" 		"EXTENDED_HISTORY"
			"HIST_IGNORE_DUPS" 	  	"HIST_IGNORE_ALL_DUPS"
			"HIST_FIND_NO_DUPS" 	"HIST_SAVE_NO_DUPS"
			"RM_STAR_WAIT"			"PRINT_EXIT_VALUE"
			"SH_WORD_SPLIT" 		"CORRECT"
			"NOTIFY" 				"INTERACTIVE_COMMENTS"
			"ALIAS_FUNC_DEF"		"EXTENDEDGLOB"
			"AUTO_CD"				"NOMATCH"		#	"no_global_rcs"
				        ]; };

	}
