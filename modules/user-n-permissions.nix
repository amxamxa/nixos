# user-n-permissions.nix
{ config, pkgs, ... }:
   # USER AND GROUP CONFIGURATION
 /* ________________________  _  ___  _   __________________
                             ( )     ( )
    _   _ ___  ___ _ __ ___  |/ _ __ |/
  | | | / __|/ _ \ '__/ __|   | '_ \
  | |_| \__ \  __/ |  \__ \   | | | |
   \__,_|___/\___|_|  |___/   |_| |_|
        __ _ _ __ ___  _   _ _ __  ___
       / _` | '__/ _ \| | | | '_ \/ __|
      | (_| | | | (_) | |_| | |_) \__ \
       \__, |_|  \___/ \__,_| .__/|___/
        __/ |               | |
       |___/                |_|   big________ */

  {
  # Grant trusted access to Nix daemon for specified users
   nix.settings.trusted-users = [ "@mxx" "amxamxa" ];
  
  # Define user group
  users.groups.mxx = {
  	gid = 1001;  # Festgelegte GID für die Gruppe "mxx"
  	members = [ "amxamxa" "finja" ];  # Gruppenmitglieder
  };  
  # Disable mutable users (all user management via configuration.nix)
  users.mutableUsers = false;
 # Wenn true, können "useradd" und "groupadd"-Befehle verwendet werden
 # ACHTUNG: Bei VM: enthält keine Daten des Hosts, daher werden vorhandene Benutzer nicht automatisch übernommen, außer mutableUsers = false wird gesetzt. ODER "InitialHashedPassword" kann ebenfalls verwendet werden.
  # ─────────────────────────────────────────────────────────────

  # USER ACCOUNTS
  # Primary user account
  users.users.amxamxa = {
    name = "amxamxa";
    isNormalUser = true;
    initialHashedPassword = "$6$HNT32bO29gVtrQad$kanyT7X4pD.IcrE3obH9c3wmWfv4ZPAJ933Pw4NI.TNIvCmP1E9US47lmVz8iuR.VrtbmB1cXwSQ/PD.sQXRw.";
    description = "max.kempter@gmail.com";
    group = "mxx";
    extraGroups = [ 
      "networkmanager" 
      "wheel"     # Sudo access
      "video"     # Video device access
      # Audio groups defined in audio.nix
    ];
    packages = with pkgs; [ 
      libnotify  # Desktop notifications (notify-send)
    ];
  };

  # Secondary user account
  users.users.finja = {
    name = "finja"; 
    isNormalUser = true;
    description = "finja (formerly mxxkee)";
    initialHashedPassword = "$6$HNT32bO29gVtrQad$kanyT7X4pD.IcrE3obH9c3wmWfv4ZPAJ933Pw4NI.TNIvCmP1E9US47lmVz8iuR.VrtbmB1cXwSQ/PD.sQXRw.";
    group = "mxx";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  # ============================================================================
  # SUDO CONFIGURATION 
  security.sudo = {
    # Define passwordless commands for mxx group
    extraRules = [
      { 
        groups = ["mxx"];
        commands = [
          { command = "${pkgs.eza}/bin/eza"; options = ["NOPASSWD"]; } 
          { command = "${pkgs.coreutils}/bin/dd"; options = ["NOPASSWD"]; } 
          { command = "${pkgs.coreutils}/bin/df"; options = ["NOPASSWD"]; }
          { command = "${pkgs.toybox}/bin/reboot"; options = ["NOPASSWD"]; } 
          { command = "${pkgs.toybox}/bin/shutdown"; options = ["NOPASSWD"]; }
        ]; 
      }
    ];
    
    # Global sudo settings
    # Note: logfile is set in logging.nix for centralized logging
    extraConfig = ''
      Defaults env_reset              # Reset environment for security
      Defaults pwfeedback             # Show asterisks when typing password
      Defaults mail_badpass           # Send email on failed password attempt
      Defaults mailto="admin@localhost"  # Email recipient (changed from hardcoded address)
      Defaults timestamp_timeout=50   # Sudo password timeout in minutes
      Defaults lecture=always         # Always show security lecture
    '';
  };
  # ============================================================================
  # PERMISSION MANAGEMENT
  # Activation script to set correct ownership and permissions of:
  #       - permissions 4 $HOME/.ssh
  #       - r/w 4 group "mxx" of /share/*
  # ====================================================================
  /* ---------------------------------------------------------------------
                    __  _             __  _                                  
        ____ ______/ /_(_)   ______ _/ /_(_)___  ____                        
 ______/ __ `/ ___/ __/ / | / / __ `/ __/ / __ \/ __ \__________________     
/_____/ /_/ / /__/ /_/ /| |/ / /_/ / /_/ / /_/ / / / /_____/_____/_____/     
      \__,_/\___/\__/_/ |___/\__,_/\__/_/\____/_/ /_/                        
                    _______________(_)___  / /______                         
 __________________/ ___/ ___/ ___/ / __ \/ __/ ___/_________________        
/_____/_____/_____(__  ) /__/ /  / / /_/ / /_(__  )_____/_____/_____/        
                 /____/\___/_/  /_/ .___/\__/____/                           
                                 /_/   für User, Grps, ch-Rechte, ln, ...
_________________________________________________________________________ */
  # ============================================================================
    system.activationScripts = {
    setPermissions = {
      text = ''
        # Use centralized logging location
        LOG_FILE=/var/log/nixos/setPermissions.log
        echo "=== $(date '+%Y-%m-%d %H:%M:%S') - Start setPermissions Script ===" > $LOG_FILE
        
        # Set group ownership for /home
        chown -R :mxx /home && echo "Group 'mxx' for /home set successfully" >> $LOG_FILE
        
        # Set permissions for /share (2760 = setgid + rwxrw----)
        chmod -R 0755 /share && echo "Permissions 0755 for /share set successfully" >> $LOG_FILE
        chown -R :mxx /share && echo "Group 'mxx' for /share set successfully" >> $LOG_FILE
        
        # Set SSH permissions
        find /home -name ".ssh" -exec chmod 0700 {} \; && echo "chmod 0700 for ~/.ssh set" >> $LOG_FILE
        find /home -type f -name "id_ed25519" -exec chmod 0600 {} \; && echo "chmod 0600 for id_ed25519 set" >> $LOG_FILE
        find /home -type f -name "id_ed25519.pub" -exec chmod 0644 {} \; && echo "chmod 0644 for id_ed25519.pub set" >> $LOG_FILE
        
        echo "=== $(date '+%Y-%m-%d %H:%M:%S') - End setPermissions Script ===" >> $LOG_FILE
      '';
      deps = [];
    };
  };

}
