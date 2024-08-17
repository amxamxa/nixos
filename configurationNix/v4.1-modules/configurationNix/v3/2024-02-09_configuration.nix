# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

#services.xserver.videoDrivers = [ "nvidia"];
hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_390;

boot.kernelPackages = pkgs.linuxPackages_5_4;

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
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  
  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
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

  users.users.max = {
    isNormalUser = true;
    description = "nix";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nix = {
    isNormalUser = true;
    description = "nix";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [

#      firefox
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


############################# ZSH
#enable zsh system-wide use 
users.defaultUserShell = pkgs.zsh;
# add a shell to /etc/shells
environment.shells = with pkgs; [ zsh ];

programs.zsh = {
enable	= true;
enableCompletion = true;
autosuggestions.enable = true;

# shellAliases = "/home/nix/zsh/.zsh-alias";

  histSize = 10000;
  histFile = "/home/nix/zsh/zhistory";
  setOptions = [		# see man 1 zshoptions
	"APPEND_HISTORY"
	"INC_APPEND_HISTORY"
	"SHARE_HISTORY "
	"EXTENDED_HISTORY"
	"HIST_IGNORE_DUPS"
  	"HIST_IGNORE_ALL_DUPS"
	"HIST_FIND_NO_DUPS"
	"HIST_SAVE_NO_DUPS"
	"RM_STAR_WAIT"
	"PRINT_EXIT_VALUE	"
	"sh_word_split"
	"correct"
	"notify"
	"INTERACTIVE_COMMENTS"
	"ALIAS_FUNC_DEF "
	"EXTENDEDGLOB"
	"AUTO_CD"
	
	        ];
	};


  programs.zsh.ohMyZsh = {
    enable = true;
#    plugins = [ "git" "python" "man" ]; # 
    plugins = [ "colored-man-pages" "colorize" "command-not-found" "extract" "thefuck" ];	
    theme = "fino-time"; #"agnoster";
  };
programs.thefuck.enable = true;
programs.thefuck.alias = "F0";
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
#nvidia_legacy_390
###		EFI boot tools
grub2
memtest86-efi
#refind
os-prober
## 		Gnome
gnome.gnome-tweaks #customize advanced GNOME 3 options
gnome.gnome-themes-extra
gnome.gedit
gnome.gnome-shell-extensions
gnome.gnome-color-manager
gnome.gnome-logs
gnome.dconf-editor
gnome-firmware
colord-gtk4
bat

gnomeExtensions.forge #Tiling and window manager 
#gnomeExtensions.pano
#gnomeExtensions.hack #Add the Flip to Hack experience to the desktop
gnomeExtensions.freon # Shows CPU temperature, disk temperature, video card temperature 
gnomeExtensions.move-panel #Moves panel to secondary monitor on startup, without changing the primary display. Only works on Waylan
gnomeExtensions.gtk4-desktop-icons-ng-ding #gtk4 port of Desktop Icons NG with GSconnect Integration, Drag and Drop on to Dock or Dash
gnomeExtensions.applications-overview-tooltip #hows a tooltip over applications icons on applications overview with application name and/or description

dynamic-wallpaper #https://github.com/dusansimic/dynamic-wallpaper
papirus-icon-theme
#gnome.adwaita-icon-theme
whitesur-gtk-theme #MacOS Big Sur like theme for Gnome desktops
numix-icon-theme-circle
numix-cursor-theme
#nordzy-icon-theme 	# schrott
#theme-obsidian2	#schrott
#sierra-gtk-theme
#ubuntu-themes
pop-icon-theme
mojave-gtk-theme # Mac OSX Mojave like theme for GTK based desktop environments
pop-gtk-theme
##		GUI internet tools
firefox
##		GUI Zubehör

cinnamon.nemo
cinnamon.nemo-with-extensions
nemo-qml-plugin-dbus
#cinnamon.nemo-emblems
cinnamon.folder-color-switcher
cinnamon.nemo-fileroller
cinnamon.nemo-python


### 		GUI system
timeshift
gparted

##		GUI knowledge base		
cherrytree
#### Obsidian
obsidian
#haskellPackages.Obsidian
haskellPackages.commonmark-wikilink
#dwarf-fortress-packages.themes.obsidian
iconpack-obsidian
pandoc # Conversion html- markup formats

xorg.xrandr
arandr
#gnome-randr
#wlr-randr
###

zsh
zsh-history
# zsh-edit #powerful extensions to the Zsh command line editor
zsh-autosuggestions
zsh-autocomplete
zsh-syntax-highlighting
thefuck
zsh-completions
zsh-you-should-use #plugin that reminds you to use existing aliases for commands 
zsh-command-time #utput time: xx after long commands
zsh-fzf-tab
#zsh-autoenv #Automatically sources whitelisted .autoenv.zsh files
zsh-clipboard #Ohmyzsh plugin that integrates kill-ring with system clipboard
zsh-nix-shell #to use zsh in nix-shell shell
nix-zsh-completions

powerline-go
zsh-powerlevel9k #Powerlevel9k ZSH theme
zsh-powerlevel10k
meslo-lgs-nf #Meslo Nerd Font patched for Powerlevel10k
zoxide
zsh-git-prompt
oh-my-zsh
shellspec #full-featured BDD unit testing framework for bash, ksh, zsh, dash and all POSIX shells
### 		CLI tools
tealdeer #tldr
tree
neofetch
freshfetch
hyfetch
perl
micro
#fzf-zsh
#fzf
#fzf-obc
neo-cowsay
xcowsay 
fortune
clolcat
blahaj
theme-sh #script which lets you set your $terminal theme
cope #colourful wrapper for terminal programs 
duf ## color mounts Disk Usage/Free Utility
coreutils # the core utilities which are expected to exist on every OS
btop
inxi
lsd
#linuxKernel.packages.linux_6_1.nvidia_x11_legacy390
#linuxKernel.packages.linux_5_4.nvidia_x11_legacy390
#linuxKernel.packages.linux_xanmod.nvidia_x11_legacy470

#####
gitFull #Distributed version control system
#gitnr #Create `.gitignore` files using one or more templates from TopTal, GitHub or your own collection
gitlab #GitLab Community Edition
git-my #List remote branches if they're merged and/or available locally
git-mit #Minimalist set of hooks to aid pairing and link commits to issues
git-hub #interface to GitHub, enabling most useful GitHub tasks (like creating and listing pull request or issues) to be accessed directly through the Git command line.
git-doc
gitstats
gitleaks #Scan git repos (or files) for secretslinhjt
gitlint #Linting for your git commit messages

fzf
fzf-zsh
fzf-git-sh
zsh-forgit # utility tool powered by fzf for using git interactively


gamehub #unified library for all your games. It allows you to store your games from different platforms
haskellPackages.general-games
steam
haskellPackages.hackertyper #ck" like a programmer in movies and games!

#fonts
#fontfinder
tt2020
nerdfonts
terminus-nerdfont
terraform-providers.ibm
powerline-fonts
];


services.xserver.videoDrivers = [ "intel" ];
#  services.xserver.videoDrivers = [ 
#				"nvidia"
#				"nvidiaLegacy390"
#				"nvidiaLegacy340"
#				"nvidiaLegacy304"
#				"intel" 
#				  ];

# hardware.opengl.extraPackages = [vaapiIntel];

services.gnome.games.enable = false;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
	  # Enable the OpenSSH daemon.
  	 services.openssh.enable = true;
  	 # Enable the Flatpak
	services.flatpak.enable = true;         


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  
system.autoUpgrade.enable = true;
system.autoUpgrade.allowReboot = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
