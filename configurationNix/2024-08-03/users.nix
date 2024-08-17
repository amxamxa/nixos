# You can get a list of the available packages as follows:
# nix-env -qaP '*' --description
#lslbk -f 
#lsblk -f --topology --ascii --all --list 
# setxkbmap -query -v

#https://github.com/Misterio77/flavours
# https://www.youtube.com/watch?v=AGVXJ-TIv3Y



{ config, pkgs, ... }:
{

  environment.variables = { #globale env
  		EDITOR = "micro";
  		ZDOTDIR = "/share/zsh";
#  		CHEAT_USE_FZF = true;
  		CHEAT_CONFIG_PATH = "$(ZDOTDIR/cheat/conf4cheat.yml)";
  		
# SPACESHIP_CONFIG="$ZDOTDIR/prompt/spaceship.zsh" # Spaceship Prompt
  		CLICOLOR_FORCE = 1;
  		TERM = "rxvt-256color";
  		VISUAL = "$EDITOR";
  		COLORTERM = "truecolor";
  		MICRO_TRUECOLOR = 1;
  		BAT_WRAP_AT = 100;
		 
		 INVERT  = "\e[7m";          
		 BOLD  = "\033[1m";          
		 UNDER  = "\033[4m";         
		 BLINK  = "\033[5m";          
		 RESET = "\e[0m";       
		 PINK  = "\033[38;2;219;41;200m\033[48;2;59;0;69m";       
		 LILA  = "\033[38;2;85;85;255m\033[48;2;21;16;46m";         
		 GREEN  = "\033[38;2;0;255;0m\033[48;2;0;25;2m";        
		 RED  = "\033[38;2;240;138;100m\033[48;2;147;18;61m";         
		 GELB  = "\033[38;2;232;197;54m\033[48;2;128;87;0m";        
		 LIL2  = "\x1b[1m\x1b[38;5;162m\x1b[48;5;62m";
  };
 environment.homeBinInPath = true; #    Include ~/bin/ in $PATH.
 
     environment.sessionVariables =  {
            XDG_CACHE_HOME  = "$HOME/.cache";
            XDG_CONFIG_HOME = "$HOME/.config";
            XDG_DATA_HOME   = "$HOME/.local/share";
            XDG_STATE_HOME  = "$HOME/.local/state";
            	
            	 XAUTHORITY = "$XDG_CONFIG_HOME/Xauthority";
            	 GIT_CONFIG = "$XDG_CONFIG_HOME/git/config";
        	   WWW_HOME = "$XDG_CONFIG_HOME/w3m";       # w3m config path
     KITTY_CONFIG_DIRECTORY = "$XDG_CONFIG_HOME/kitty";  # kitty, nur PATH angeben
     CARGO_HOME="$XDG_CONFIG_HOME/cargo";
                      }; 
	# ------------------------------------------------------------------
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # ----------------------------------------------------------------------

users.users.manix = {
    isNormalUser = true;
    description = "nix";
    extraGroups = [ "networkmanager" "wheel" "mxx" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };



  users.users.alice = {
    isNormalUser = true;
    description = "nix";
    extraGroups = [ "networkmanager" "wheel" "mxx" ];
    packages = with pkgs; [
    ];
  };
  
 # Sudo-Version 1.9.15p2 -Policy-Plugin Ver 1.9.15p2 Sudooers-Datei-Grammatik-Version 50
   # Sudoers - I/O plugin version 1.9.15p2  Sudoers - audit plugin version 1.9.15p2
   	security.sudo = {
   	  extraRules = [
   	  	{ groups = ["wheel"];
   	      commands = [
   	        { command = "${pkgs.coreutils}/sbin/df"; 	 options = ["NOPASSWD"]; } 
   	        { command = "${pkgs.systemd}/bin/systemctl suspend"; options = ["NOPASSWD"]; }
   	        { command = "${pkgs.systemd}/bin/reboot";	 options = ["NOPASSWD"]; }
   	        { command = "${pkgs.systemd}/bin/poweroff";	 options = ["NOPASSWD"]; }
   	        { command = "${pkgs.systemd}/sbin/shutdown";	 options = ["NOPASSWD"]; }
   	      ];   	    }    	  ];
   	   extraConfig = ''
   			Defaults env_reset 		# safety measure used to clear potentially harmful environmental variables 
   	  	 	Defaults mail_badpass   # Mail bei fehlgeschlagenem Passwort
   	 #    	Defaults mailto="admin@example.com"   	 # Mail an diese Adresse senden
   			Defaults timestamp_timeout = 50
   			Defaults logfile = /var/log/sudo.log 	# Speichert Sudo-Aktionen in  Logdatei
   			Defaults lecture = always 				# script=/etc/sudoers.lecture.sh
     					'';	
   	};
        
}
 