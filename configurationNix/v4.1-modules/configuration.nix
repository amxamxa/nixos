# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, lib,  ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
### Bootloader.
## (U)EFI
boot.loader.efi.canTouchEfiVariables = true;
boot.loader.efi.efiSysMountPoint  =  "/boot";
## SYSTEMD-BOOT
#boot.loader.systemd-boot.enable = true;
## GRUB2
#boot.loader.grub.enable = false;
boot.loader.grub.enable = true;
boot.loader.grub.efiSupport = true;
boot.loader.grub.configurationLimit = 55;
#boot.loader.grub.theme ="/boot/grub/themes/dark-matter/theme.txt";
boot.loader.grub.memtest86.enable = true;
boot.loader.grub.fsIdentifier = "label";
boot.loader.grub.devices = [ "nodev" ];
boot.loader.grub.useOSProber = true;

fileSystems."/share" =
  { device = "/dev/disk/by-uuid/6dd1854a-047e-4f08-9ca1-ca05c25d03af";
    fsType = "btrfs";
  };


   networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
   networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.enp4s0.name = ["eth0"];
  #GPU und so   hardware.enableRedistributableFirmware = true; # AMD RAEDON treiber
   # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Set your time zone.
   time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n.defaultLocale = "de_DE.UTF-8";
   console = {
     font = "Lat2-Terminus16";
#     keyMap = mk.defaut "de";
     useXkbConfig = true; # use xkb.options in tty.
   };

  # Enable the X11 windowing system.
  	services.xserver.enable = true;
	programs.sway.enable = true;
  	xdg.portal.wlr.enable = true;
  	 # Enable the GNOME Desktop Environment.
# -------------------------------------------
  services.xserver.desktopManager.xfce.enable = true;
  services.displayManager.defaultSession = "xfce";
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.displayManager.gnome.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Configure keymap in X11
   services.xserver.xkb.layout = "de";
   services.xserver.xkb.options = "eurosign:e,caps:escape";
 #  	system.autoUpgrade.enable = false;
 #		system.autoUpgrade.allowReboot = true;
 #  	nix.settings.auto-optimise-store = true;

	nix.settings.sandbox = true;
 #  nixpkgs.config.allowBroken = true;

   #  Allow InsecurePackages
   nixpkgs.config.permittedInsecurePackages = [   "electron-25.9.0"     ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # Sudo-Version 1.9.15p2 -Policy-Plugin Ver 1.9.15p2 Sudooers-Datei-Grammatik-Version 50
   # Sudoers - I/O plugin version 1.9.15p2  Sudoers - audit plugin version 1.9.15p2
   	security.sudo = {
   	  extraRules = [
   	  	{ groups = ["wheel"];
   	      commands = [
   	        {	command = "${pkgs.coreutils}/sbin/df"; 	options = ["NOPASSWD"];  } 
   	        { command = "${pkgs.systemd}/bin/systemctl suspend"; options = ["NOPASSWD"]; }
   	        { command = "${pkgs.systemd}/bin/reboot"; options = ["NOPASSWD"];     }
   	        { command = "${pkgs.systemd}/bin/poweroff"; options = ["NOPASSWD"];   }
   	        { command = "${pkgs.systemd}/sbin/shutdown"; options = ["NOPASSWD"];  }
   	      ];
   	    }
   	  ];
   	   extraConfig = ''
   		Defaults env_reset #  safety measure used to clear potentially harmful environmental variables 
   	  	 Defaults mail_badpass   	  	# Mail bei fehlgeschlagenem Passwort
   	 #    Defaults mailto="admin@example.com"   	 # Mail an diese Adresse senden
   		Defaults timestamp_timeout = 50
   		Defaults logfile = /var/log/sudo.log #  Speichert Sudo-Aktionen in  Logdatei
   		Defaults lecture = always #, script=/etc/sudoers.lecture.sh
     					'';	
   	};
   	    	#	''wheel ALL=(ALL:ALL) NOPASSWD: /sbin/shutdown''
        environment.variables.EDITOR = "micro";
         environment.variables.ZDOTDIR = "/share/zsh";

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;
/*        environment.sessionVariables =  {

            XDG_CACHE_HOME  = "$(HOME/.cache)";
            
            XDG_CONFIG_HOME = "$(HOME/.config)";
            XDG_DATA_HOME   = "$(HOME/.local/share)";
            XDG_STATE_HOME  = "$(HOME/.local/state)";
            	
            #	 XAUTHORITY = "$(XDG_CONFIG_HOME}/Xauthority)";
            	 GIT_CONFIG = "$(XDG_CONFIG_HOME/git/config)";
        	       WWW_HOME = "$(XDG_CONFIG_HOME}/w3m)";       # w3m config path
	 KITTY_CONFIG_DIRECTORY = "$(XDG_CONFIG_HOME}/kitty)";  	# kitty, nur PATH angeben:
                      }; 
*/
  users.users.manix = {
    isNormalUser = true;
    description = "nix";
    extraGroups = [ "networkmanager" "wheel" "mxx" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alice = {
    isNormalUser = true;
    description = "nix";
    extraGroups = [ "networkmanager" "wheel" "mxx" ];
    packages = with pkgs; [

#      firefox
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
	 environment.systemPackages = with pkgs; [

	 
	micro
	zsh
gnome-text-editor
gparted
     wget
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
   system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

