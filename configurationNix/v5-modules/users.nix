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
#  		
		 
		
  };

     environment.sessionVariables =  {
            XDG_CACHE_HOME  = "$HOME/.cache";
            XDG_CONFIG_HOME = "$HOMEnixos/configurationNix/v4.2-modules /.config";
            XDG_DATA_HOME   = "$HOME/.local/share";
            XDG_STATE_HOME  = "$HOME/.local/state";
            	
            #	 XAUTHORITY = "$XDG_CONFIG_HOME/Xauthority";
            	 GIT_CONFIG = "@{HOME}/.config/git/config";
        	   WWW_HOME = "@{HOME}/.config/w3m";       # w3m config path
     KITTY_CONFIG_DIRECTORY = "$XDG_CONFIG_HOME/kitty";  # kitty, nur PATH angeben
     CARGO_HOME="$XDG_CONFIG_HOME/cargo";
                      }; 
                      
environment.homeBinInPath = true; #    Include ~/bin/ in $PATH.

	# ------------------------------------------------------------------
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # ----------------------------------------------------------------------

users.users.mxxkee = {
    isNormalUser = true;
    initialHashedPassword = "as"; # oder mutableUsers = false
    description = "nix";
    extraGroups = [ "networkmanager" "wheel" "mxx" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };



  users.users.alice = {
      isNormalUser = true;
    description = "nix";
    initialHashedPassword = "test";
    extraGroups = [ "networkmanager" "wheel" "mxx" ];
    packages = with pkgs; [
    ];
  };
 # Systemweite Aktivierungsskripte
  system.activationScripts = {
    sharePermissions = ''
      chown :mxx /share
      chmod 770 /share
    '';

    createSymlinks = ''
     for user in alice mxxkee; do
        ln -sf /share /home/$user/share
      done
    '';
  };
 users.groups.mxx = {
    name = "mxx";
    gid = 1234;  # spezifische GID setzen, eindeutige Nr.
    members = [ "alice" "mxxkee" ];  # Benutzer, die zur Gruppe gehören sollen
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

