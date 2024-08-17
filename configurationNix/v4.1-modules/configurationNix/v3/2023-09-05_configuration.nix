# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:   

#nix-colors = import <nix-colors> { };	
#{ import = [
#    nix-colors.homeManagerModules.default
#  ];

#  colorScheme = nix-colors.colorSchemes.paraiso;
  #siehe  https://github.com/Misterio77/nix-colors
#}


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
 Filesystems.
fileSystems."/boot/efi" = {
  evice = "/dev/disk/by-uuid/3710-98B1"; #AC95-9D6A";
  fsType = "vfat";
};

boot.loader.systemd-boot = {
  enable = true;
  editor = false;
};

boot.loader.efi = {
  canTouchEfiVariables = true;
  efiSysMountPoint  =  "/boot/efi";

};

boot.loader.grub = {
  enable = true;
    useOSProber = true;
    default  =  "saved";

  copyKernels = true;
  efiInstallAsRemovable = true;
  efiSupport = true;
  fsIdentifier = "uuid";
  splashMode = "stretch";
  version = 2;
  device = "nodev";
   
 extraEntries = ''
    	menuentry "Reboot" {
      	reboot
    	}
    menuentry "Poweroff" {
      halt
      }
   '';
};



  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  #GPU und so
  hardware.enableRedistributableFirmware = true; # AMD RAEDON treiber

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents. / DRUCKER
  # services.printing.enable = true;

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mxx = {
    isNormalUser = true;
    description = "mxx";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    firefox
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


# ######################          environment.systemPackages =   [   ];
# List packages installed in system profile. To search, run:	 $ nix search wget

 environment.systemPackages = with pkgs; [

#efi
pkgs.efibootmgr
    pkgs.grub2_efi
    pkgs.os-prober


pkgs.python39
	 pkgs.home-manager
 #Bash
  pkgs.go
  pkgs.powerline-go
  pkgs.powerline-fonts  
#fonts
   pkgs.font-manager
    pkgs.tt2020
pkgs.font-awesome
  #fish
  fish

  pkgs.partimage  
  pkgs.parted  
pkgs.libgda6 

#  gsound
      pkgs.gnome.gnome-software
  #basic
  	gtk3
  	gtkmm3
 	pkgs.btop  
pkgs.tmatrix
  #File 
  	findutils
	mlocate
   pkgs.cinnamon.nemo-with-extensions #Name: nemo-with-extensionsVersion: 5.6.5  
  	mc

  	fltk14 #flatpak 
  	#xfce.thunar #nemo besser
      	xdg-desktop-portal-gnome      
 
#nix funzt	pkgs.libsForQt5.yakuake

# tools
	 pkgs.num-utils #programs for dealing with numbers from the command line, zB random
       	pkgs.unzip
      	pkgs.zip
      	pkgs.vlc
     	
# git
	pkgs.git
    	pkgs.gitFull
 	pkgs.git-doc
      
# gnome-shell-extensions
#      pkgs.gnome-extension-manager
###gnome-shell-extension-tweaks-in-system-menu
  gnomeExtensions.pano

gnome.gnome-tweaks
gnomeExtensions.yakuake
 pkgs.gnomeExtensions.downfall
  pkgs.gnomeExtensions.shortcuts
qgnomeplatform
qgnomeplatform-qt6
#	pkgs.gnomeExtensions.tweaks-in-system-menu  
	gnomeExtensions.dashbar
	pkgs.gnomeExtensions.tilingnome	
#	gnome-shell-extension-gsconnect
	pkgs.gnomeExtensions.nasa-apod
	pkgs.gnomeExtensions.animate
      	pkgs.pantheon.gnome-bluetooth-contract
      pkgs.gnome-browser-connector
      pkgs.comixcursors #mouse theme
       
       pkgs.clolcat #Much faster lolcat
       pkgs.blahaj #Gay sharks at your local terminal - lolcat-like CLI tool

 #  pkgs.apt # funzt nicht
    pkgs.flameshot
    pkgs.gsound
    pkgs.gparted

 #  vim # Do not forget to add an editor to edit configuration.nix! 
#The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  ### SERVICES ### ### SERVICES ###  ### SERVICES ###  ### SERVICES ###  ### SERVICES ###
  # List services that you want to enable:



  services.openssh.enable = true;	  # Enable the OpenSSH daemon.
  services.flatpak.enable = true;  	  # Enable the Flatpak
  
  ### FIREWALL ###  ### FIREWALL ###  ### FIREWALL ###  ### FIREWALL ###  ### FIREWALL ###
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;




 ### ENVIROMENT # PKGS ### ### ENVIROMENT # PKGS ### ### ENVIROMENT # PKGS ### ### ENVIROMENT # PKGS ### 


   
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
