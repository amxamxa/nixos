#lslbk -f 
#lsblk -f --topology --ascii --all --list 
# setxkbmap -query -v

# You can get a list of the available packages as follows:
# nix-env -qaP '*' --description

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

boot = {
  kernelPackages = pkgs.linuxPackages_latest;
  initrd.kernelModules = ["amdgpu"];
};

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
#  Filesystems.
#fileSystems."/boot" = {
# device = "/dev/disk/by-uuid/ACD7-8E7C";
# fsType = "vfat"; };

# Use the systemd-boot EFI boot loader.
#  boot.loader.systemd-boot.enable = true;

# Whether the installation process is allowed to modify EFI boot variables:
boot.loader.efi.canTouchEfiVariables = true;

# GRUB2
boot.loader.grub = {
  enable = true;
  version = 2;
  device = ["nodev"];
  configurationLimit =5;
  # GRUB w/ built with EFI support
    efiSupport = true;
  # append entries for other OSs detected by os-probe
    useOSProber = true; 
   # fsIdentifier:#how GRUB will identify devices when generating the configuration file. 
   # grub will always resolve the uuid or label of the device before using it
   # means that GRUB will use the device name as show in df or mount. 
    fsIdentifier = "uuid";
	#  splashMode = "stretch";
  	#  default  =  "saved";
 	#  copyKernels = true;
  	#  efiInstallAsRemovable = true;  
  extraEntries = ''
        menuentry "Reboot" { reboot }
    	menuentry "Poweroff" { halt }
   '';
};

   networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
   networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
   networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.enp4s0.name = ["eth0"];
   networking.interfaces.wlp3s0.name = ["wlan0"];

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

   console = {
     font = "Lat2-Terminus16";
     colors =  [ 	#Leave empty to use the default colors. Colors must be in 
  "002b36"	#01 #hexadecimal format and listed in order from color 0 to color 15.
  "dc322f"	#02
  "859900"	#03
  "b58900"	#04
  "268bd2"	#05
  "d33682"	#06
  "2aa198"	#07
  "eee8d5"	#08
  "002b36"	#09
  "cb4b16"	#10
  "586e75"	#11
  "657b83"	#12
  "839496"	#13
  "6c71c4"	#14
  "93a1a1"	#15
  "fdf6e3"  ]	#16  
   
    keyMap = "de";
    useXkbConfig = true; # use xkbOptions in tty.
   };

#GPU und so
  hardware.enableRedistributableFirmware = true; # AMD RAEDON treiber

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
    #   xkbOptions = "eurosign:e,caps:escape";# oder "terminate:ctrl_alt_bksp"; # oder "grp:caps_toggle,grp_led:scroll";
  };
  # Enable the GNOME Desktop Environment.

# Enable the X11 windowing system.
  services.xserver.enable = true;


#### DM -  d i s p l a y   m a n a g e r
services.xserver.displayManager.defaultSession = lightdm;
  autorun = true; # run on graphic interface startup
#User to be used for the automatic login.
services.xserver.displayManager.autoLogin.user = "max"; #null or string
services.xserver.displayManager.autoLogin.enable  = true;
# enable lightdm as DM 
  services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.displayManager.lightdm.background  = "pkgs.nixos-artwork.wallpapers.simple-dark-gray-bottom.gnomeFilePath";
  services.xserver.displayManager.lightdm.greeters.slick.theme.package = pkgs.gnome.gnome-themes-extra; 
  # icon theme to use for the lightdm-slick-greeter
  services.xserver.displayManager.lightdm.greeters.slick.enable = true;
  services.xserver.displayManager.lightdm.greeters.slick.iconTheme.package = pkgs.gnome.adwaita-icon-theme;
  services.xserver.displayManager.lightdm.greeters.slick.iconTheme.name = "Adwaita";
  services.xserver.displayManager.lightdm.greeters.slick.font.package = pkgs.ubuntu_font_family;
  services.xserver.displayManager.lightdm.greeters.slick.font.name = "Ubuntu 11"; #string
# “startx” pseudo-display manager, must provide ~/.xinitrc file, see startx(1)
 services.xserver.displayManager.startx.enable = true;
# enable gdm as DM 
  	# services.xserver.displayManager.gdm.enable = true;
# enable SDDM as DM
	# services.xserver.displayManager.sddm.enable = true;
	# services.xserver.displayManager.sddm.theme = "string" #string
	# services.xserver.displayManager.sddm.autoLogin.relogin = true;

### ### WM -  w i n d o w    m a n a g e r ### ###
### 	W M 4gnome: 		sway, hyperland
### 	W M 4Xorg/x11:		bspwm, i3
    services.xserver.windowManager.default = true;
####i3 -better compatibility w/ Xorg - tiling window manager that focuses on efficiency and productivity. It arranges windows in a tile-based layout, allowing users to easily manage multiple windows simultaneously.
    services.xserver.windowManager.i3.enable = true;
    services.xserver.windowManager.i3.package  = true;
    services.xserver.windowManager.i3.configFile  = true;
    services.xserver.windowManager.i3.extraPackages  = true;

### bspwm: bspwm steht für "binary space partitioning window manager" und ist ein tiling window manager für Xorg. Es basiert auf dem Prinzip des binären Raumteilungsverfahrens, bei dem der Bildschirm in rechteckige Bereiche unterteilt wird, um Fenster anzuordnen. bspwm ist dafür bekannt, dass es sehr leichtgewichtig und ressourcenschonend ist. 
#    services.xserver.windowManager.bspwm.enable
#    services.xserver.windowManager.bspwm.package
#    services.xserver.windowManager.bspwm.configFile


### ### DM -  d e s k t o p  m a n a g e r ### ###
# services.xserver.desktopManager.default
services.xserver.desktopManager.gnome.enable = true;
#services.xserver.desktopManager.pantheon.enable = true;
#services.xserver.desktopManager.cinnamon.enable = true;
#services.xserver.desktopManager.lxqt.enable = true;
#services.xserver.desktopManager.xfce.enable = true;
# set to true the wallpaper will stretch across all screens:
services.xserver.desktopManager.wallpaper.combineScreens= true;

  # user configuration
  users.users = {
    max = { # change this to you liking
      createHome = true;
      isNormalUser = true;
      extraGroups = [
        "wheel"
      ];
 };
root = {
      extraGroups = [
        "wheel"
      ];
    };
  };

# installed packages
  environment.systemPackages = with pkgs; [
#efi
pkgs.efibootmgr
    pkgs.grub2_efi
    pkgs.os-prober
    pkgs.tt2020
pkgs.font-awesome
  #fish
  fish

  pkgs.partimage  
  pkgs.parted  
# tools
         pkgs.num-utils #programs for dealing with numbers from the command line, zB >
        pkgs.unzip
        pkgs.zip
        pkgs.vlc
 pkgs.flameshot
    pkgs.gsound
    pkgs.gparted
        
# git
        pkgs.git
        pkgs.gitFull
        pkgs.git-doc
    

# cli utils

    curl
    wget
    vim
    htop

    # browser
firefox
  ];



  services.openssh.enable = true;         # Enable the OpenSSH daemon.
  services.flatpak.enable = true;         # Enable the Flatpak
  

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

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
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

