{ config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #     	./test.nix # zum Testen neuer Konfig
    ./modules/boot.nix # grub2 & lightDM
    ./modules/zsh.nix # shell
    ./modules/cosmic.nix # Display/Window-Mgr
    ./modules/packages.nix # env.pkgs
    ./modules/enviroment.nix # ENV
    ./modules/audio.nix
#    ./modules/docker.nix
    ./modules/fonts.nix
 #   ./modules/python.nix # ehem.	./ld.nix
    ./modules/read-only/adBloxx.nix # ehem. ./AdBloxx.nix
    ./modules/read-only/tuxpaint.nix

  ];

  fileSystems."/share" = {
    device = "/dev/disk/by-uuid/6dd1854a-047e-4f08-9ca1-ca05c25d03af";
    fsType = "btrfs";
  };

  fileSystems."/home/project/AUDIO/samples+" = {
    device = "/dev/disk/by-uuid/4d274de6-7e6b-4f01-ab6a-696ea91abec8";
    fsType = "ext4";
  };

  hardware.cpu.intel.updateMicrocode =
    true; # update the CPU microcode for Intel processors.
  networking.hostName = "local"; # Define your hostname.
  # Enable networking
  networking.networkmanager.enable = true;
  networking.usePredictableInterfaceNames = false; # eth0 statt ensp0
  networking.nameservers = [
    # www.ccc.de/censorship/dns-howto
    "5.9.164.112" # (digitalcourage, Informationsseite)
    "204.152.184.76" # (f.6to4-servers.net, ISC, USA)
    "2001:4f8:0:2::14" # (f.6to4-servers.net, IPv6, ISC)
    "194.150.168.168" # (dns.as250.net; Berlin/Frankfurt)
  ];
  networking.networkmanager.appendNameservers = [
    # www.ccc.de/censorship/dns-howto
    "5.9.164.112" # (digitalcourage, Informationsseite)
    "204.152.184.76" # (f.6to4-servers.net, ISC, USA)
    "2001:4f8:0:2::14" # (f.6to4-servers.net, IPv6, ISC)
    "194.150.168.168" # (dns.as250.net; Berlin/Frankfurt)
  ];

  networking.networkmanager.settings.connectivity.uri =
    "http://nmcheck.gnome.org/check_network_status.txt";

  networking.networkmanager.dns =
    "default"; # default", "dnsmasq", "systemd-resolved", "none"
  # networking.interfaces.enp4s0.useDHCP = true;
  # networking.interfaces.enp4s0.name = [ "eth0" ];
  hardware.usb-modeswitch.enable =
    false; # to support certain USB WLAN and WWAN adapters.  These network adapters initial present themselves as Flash Drives containing their drivers. This option enables automatic switching to the networking mode
  #   Use services.logind.settings.Login instead.  # services.logind.extraConfig = ''     	HandlePowerKey = poweroff;    	HandlePowerKeyLongPress = reboot;	'';	
  security.polkit.enable =
    true; # Framework, um privilegierte Aktionen auszuführen
  services.udisks2.enable =
    true; # Daemon, der Festplatten, USB-Sticks, SD-Karten und andere Wechselmedien verwaltet  Enable automount for removable media
  services.fwupd.enable = true;
  gtk.iconCache.enable =
    true; # Improve GTK icon cache generation to ensure immediate visibility
  boot.supportedFilesystems = [ "ntfs" ];
  # programs.pay-respects = true; #  This usually happens if `programs.pay-respects' has option        definitions inside that are not matched. Please check how to properly define       this option by e.g. referring to `man 5 configuration.nix'!insteadt  programs.thefuck
  programs.pay-respects.enable = true;
  services.gvfs.enable = true;
  services.upower.enable = lib.mkForce
    false; # Daemon, der Informationen über die Energieversorgung sammelt und bereitstellt. Für Akku-Betrieb
  services.power-profiles-daemon.enable = lib.mkForce false;
  services.tlp.enable = lib.mkForce
    true; # Energieoptimierung, CPU-freq, Aktivitäts-Timeouts für Festplatten und USB-Ports
  boot.tmp.cleanOnBoot = true; # Wipe /tmp on boot.
  hardware.ksm.enable =
    true; # Aktiviert den Kernel Samepage Merging (KSM)-Dienst, durchsucht den RAM nach identischen Speicherseiten (Pages), spart Speicher, aber CPU-Last. Für Virtualisierungsumgebungen mit  ähnlichen VMs ... oder redundanten Speicher allozieren

  nix.nixPath =  [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"  
  ];
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  services.xserver = {
    enable =
      true; # Enable the X11 windowing system. Die Reihenfolge ist wichtig, da das erste Layout standardmäßig verwendet wird.
    xkb.layout = lib.mkForce "de";
    xkb.variant = "";
    xkb.options =
      "lv3:ralt_switch"; # Option zum Umschalten der Layouts, # AltGr als Level-3-Taste (für Sonderzeichen)
  };

  console = {
    enable = true;
    font =
      "Lat2-Terminus16"; # Beispiel  # ls  $(nix-shell -p kbd --run "ls \$out/share/kbd/consolefonts/")
    earlySetup = true;
    useXkbConfig =
      true; # Makes it so the tty console has about the same layout as the one configured in the services.xserver options.
    keyMap =
      lib.mkForce "de"; # keyboard mapping table for the virtual consoles.
  };

  i18n = {
    defaultLocale = "de_DE.UTF-8";
    supportedLocales = [
      "de_DE.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ]; # Sprache auf Deutsch/Englisch begrenzen
    extraLocaleSettings = {
      LC_NAME = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_ADDRESS = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
    };
  }; # de_DE/ISO-8859-1  en_US.UTF-8/UTF-8 en_US/ISO-8859-1  de_DE.UTF-8/UTF-8 de_DE/ISO-8859-1 \de_DE@euro/ISO-8859-15

  #############################################################################

  services.xserver.displayManager.startx.enable =
    true; # Whether to enable the dummy “startx” pseudo-display manager, which allows users to start X manually via the startx command from a virtual terminal.
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you accidentally delete configuration.nix.
  services.xserver.exportConfiguration =
    true; # Makes it so the above mentioned xkb directory (and the xorg.conf file) gets exported to /etc/X11/xkb
  services.xserver.desktopManager.runXdgAutostartIfNone =
    true; # whether to run XDG autostart files for sessions without a desktop manager (with only a window manager), these sessions usually don’t handle XDG autostart files by defaul

  services.xserver.displayManager.sessionCommands = ''
    xcowsay " 
    "Hello World!" this is - Greetings from GUI - & Xamxama"'';

  # Enable CUPS to print documents.
  services.printing.enable = false;
  # Enable touchpad support (enabled default in most desktopManager)
  services.libinput.enable = lib.mkForce false;

  nix.settings.auto-optimise-store = true;
  nix.settings.sandbox = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  # nixos.org/manual/nix/stable/contributing/experimental-features
  # "flakes"

  nix.settings = {
    download-buffer-size = 268435456; # 256 MB
    #134217728;
    http-connections = 25; # Max parallel HTTP connections
    max-jobs = "auto"; # Parallel builds
    cores = 3; # 0=Use all available cores
    experimental-features =
      [ "nix-command" ]; # Aktiviert Cmds: nix search, nix run, nix shell
    #  extra-sandbox-paths = [ "/dev/nvidiactl" "/dev/nvidia0" "/dev/nvidia-uvm" ];
  };
  # to install from unstable-channel, siehe packages.nix

  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "vivaldi"           
        "vagrant"
    	"memtest86-efi"
        "sublimetext"
        "obsidian"
        "typora"
        "decent-sampler"
        "vst2-sdk"
      ];
    allowUnfree = false;

    packageOverrides = pkgs: {
      unstable = import (fetchTarball
        "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") { };
    };

  };

  #  Allow InsecurePackages
  nixpkgs.config.permittedInsecurePackages = [
    #"openssl-1.1.1w" 	
    #"gradle-6.9.4" 
    # "electron-25.9.0" 	
    # "dotnet-sdk-7.0.410"
    # "dotnet-runtime-7.0.20"
  ];

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
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
  networking.firewall.enable = false;

  # Firewall für Warpinator-Ports öffnen
  #networking.firewall = {
  #allowedTCPPorts = [ 42000 ]; # Standard-Port für Warpinator
  #allowedUDPPorts = [ 42000 ];  
  #};

  /* # Enable the Flatpak
       services.flatpak.enable = true;
       # Enable xdg-desktop-portal for better integration with Flatpak
       xdg.portal = {
         enable = true;
         extraPortals = [
           	pkgs.xdg-desktop-portal-gtk  # integrasion for sandbox app, Ensures GTK support for XFCE, xdg-desktop-port
         	pkgs.xdg-desktop-portal-xapp # integration for XFCE, ..
         ];
       };
      #xdg-desktop-portal-gtk -6˚
     	# -> flatpak.github.io/xdg-desktop-portal/
     # Flatpak Ende
  */

  # Avahi für Netzwerk-Discovery aktivieren
  services.avahi = {
    enable = true;
    nssmdns4 = true; # mDNS-Unterstützung
    publish = {
      enable = true;
      addresses = true; # IP-Adresse veröffentlichen
      userServices = true; # Nutzerdienste sichtbar machen
    };
  };
  /* services.samba.enable = true;
     services.samba.package = pkgs.sambaFull; # Statt des minimalen `samba`
     services.samba.nsswins = true;
     services.samba-wsdd.enable = true;
  */
  programs.xwayland.enable = true; # Aktiviere XWayland
  # programs.sway.enable = true;
  programs.thunar.enable = lib.mkForce false; # Deaktiviere Thunar
#  programs.traceroute.enable = true; # Aktiviere Traceroute
  programs.gnome-disks.enable = true; # Aktiviere GNOME Disks
  programs.git = {
    enable = true;
    prompt.enable = true; # Git-Prompt aktivieren
  };

  services.postgresql.enable = true;
  services.vnstat.enable =
    true; # Aktivieren `vnstat`-Dienst für "Console-based network statistics"
  services.playerctld.enable = false; # ac/dc/enable the playerctld daemon.
  services.logrotate.enable = true;
  services.logrotate.configFile = pkgs.writeText "logrotate.conf"
    "	weekly 				\n	rotate 4 		\n	create 				\n	dateext				\n	compress		\n	missingok			\n	notifempty\n";
  #--------------
  services.journald.extraConfig = ''
    		SystemMaxUse=256M		
    		SystemMaxFiles=10
    		Compress=yes			
    		MaxFileSec=1week
        		ForwardToSyslog=yes	  
        		ForwardToKMsg=yes 	
        		'';

  # Enable NixOS-specific documentation, including the NixOS manual
  documentation.nixos.enable = true;
  # Enable system-wide man pages. This uses man-db by default.
  documentation.man.enable = true;
  # Crucially, enable the generation of the 'whatis' database cache.
  # This is required for search functionality like 'man -k' and our fzf widget.
  documentation.man.generateCaches = true;
  documentation.man.man-db.enable = true;

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration, 
  system.stateVersion = "24.05"; # Did you read the comment?

}

