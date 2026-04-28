{ config, pkgs, lib, ... }:
## nix-env -qaP '*' --description # You can get a list of the available packages as follows:
# lsblk -f --topology --ascii --all --list
# setxkbmap -query -v
/*
channel probs:
❯ sudo nix-channel --list
❯ sudo nix-channel --add https://nixos.org/channels/nixos-25.11 nixos
❯ sudo nix-channel --update
# ohne www
❯ sudo nixos-rebuild switch --profile-name xam4boom  --option substitute false
*/
{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/boot.nix # grub2 & lightDM
    ./modules/enviroment.nix # ENV
    ./modules/user-n-permissions.nix
    ./modules/cosmic.nix # Display/Window-Mgr
    ./modules/packages.nix # env.pkgs
    ./modules/audio.nix
    ./modules/fonts.nix
#    ./modules/logs.nix
    ./modules/zsh.nix # shell
#    ./modules/bash.nix # shell
    ./modules/aliases.nix
#    ./modules/rust.nix #
    ./modules/treefmt.nix #
     ./modules/dns.nix #
    #   ./modules/python.nix # ehem.	./ld.nix
    #./modules/docker.nix
#       ./modules/npm.nix
        ./modules/tftp-samba.nix
    ./modules/read-only/adBloxx.nix # ehem. ./AdBloxx.nix
    ./modules/read-only/tuxpaint.nix

  ];

nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
             "vst2-sdk"
                "vivaldi"              "vagrant"
        "memtest86-efi"        "sublimetext"
        "obsidian"             "typora"
        "decent-sampler"
        # "kiro"
        "claude-code"
           ];
# SSD 21 GB
  fileSystems."/public" = {
    device = "/dev/disk/by-uuid/6dd1854a-047e-4f08-9ca1-ca05c25d03af";
    fsType = "btrfs";
  };
# SSD 136 GB /dev/sda4
  fileSystems."/home/project" = {
    device = "/dev/disk/by-uuid/4d274de6-7e6b-4f01-ab6a-696ea91abec8";
    fsType = "ext4";
  };
  # HDD /dev/sdb1 320 GB
    fileSystems."/home/video" = {
      device = "/dev/disk/by-uuid/f6ebb1cc-3fff-422a-8be4-ed8dd4cb1e61";
      fsType = "ext4";
    };



  hardware.cpu.intel.updateMicrocode =
    true; # update the CPU microcode for Intel processors.

      # ZRAM zur Entlastung des DDR3-Arbeitsspeichers
      zramSwap.enable = true;
      zramSwap.memoryPercent = 25;

  # Deaktivierung IPv6: lokale Netzwerk IPv4. Deaktivierung -> Overhead des Netzwerk-Stacks sinkt
  boot.kernel.sysctl."net.ipv6.conf.all.disable_ipv6" = 1;
  boot.kernel.sysctl."net.ipv6.conf.default.disable_ipv6" = 1;
  # RFS (Receive Flow Steering) - Globale Kernel-Einstellungen
  boot.kernel.sysctl = {
    # Maximale Anzahl an gleichzeitig verfolgten Flows (Sonden)
    # Empfohlener Wert für Workstations: 32768
    "net.core.rps_sock_flow_entries" = 32768;
  };
  boot.tmp.cleanOnBoot = true; # Wipe /tmp on boot.
  boot.supportedFilesystems = [ "ntfs" ];

 # Balanciert Hardware-Interrupts dynamisch über alle 4 Kerne
  services.irqbalance.enable = true;

  # Entlastung des Schreib-I/O: Durch das Verschieben des `/tmp`-Verzeichnisses in den   Arbeitsspeicher (RAM) werden unnötige Schreibzugriffe auf die SSD und CPU-Interrupts durch den I/O-Controller reduziert:
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "2G";

  # Enable networking
  networking.enableIPv6 = false;
  networking.networkmanager.enable = true;
  networking.usePredictableInterfaceNames = false; # eth0 statt ensp0
  networking.hostName = "localhorst"; # Offiziell reservierte Domains (RFC 6761)
#
  networking.networkmanager.settings.connectivity.uri =
    "http://nmcheck.gnome.org/check_network_status.txt";

 # to support certain USB WLAN and WWAN adapters.  These network adapters initial present themselves as Flash Drives containing their drivers. This option enables automatic switching to the networking mode
  hardware.usb-modeswitch.enable =
    false;

  #   Use services.logind.settings.Login instead.  # services.logind.extraConfig = ''     	HandlePowerKey = poweroff;    	HandlePowerKeyLongPress = reboot;	'';


  # Speicheroptimierung für ältere SSDs/HDDs
  services.fstrim.enable = true; # Wichtig für die Langlebigkeit alter SSDs
  security.polkit.enable =
    true; # Framework, um privilegierte Aktionen auszuführen
  services.udisks2.enable =
    true; # Daemon, der Festplatten, USB-Sticks, SD-Karten und andere Wechselmedien verwaltet  Enable automount for removable media
  services.fwupd.enable = true;
  gtk.iconCache.enable =
    true; # Improve GTK icon cache generation to ensure immediate visibility

  services.gvfs.enable = true;
  services.upower.enable = lib.mkForce
    false; # Daemon, der Informationen über die Energieversorgung sammelt und bereitstellt. Für Akku-Betrieb
  services.power-profiles-daemon.enable = lib.mkForce false;
  services.tlp.enable = lib.mkForce
    true; # Energieoptimierung, CPU-freq, Aktivitäts-Timeouts für Festplatten und USB-Ports

  hardware.ksm.enable =
    true; # Aktiviert den Kernel Samepage Merging (KSM)-Dienst, durchsucht den RAM nach identischen Speicherseiten (Pages), spart Speicher, aber CPU-Last. Für Virtualisierungsumgebungen mit  ähnlichen VMs ... oder redundanten Speicher alloziere

 nix.settings = {
    download-buffer-size = 268435456; # 256 MB
    #134217728;
    http-connections = 25; # Max parallel HTTP connections
    max-jobs = 2; # Parallel builds
    cores = 2; # use N  cores
      # Enable the Flakes feature and the accompanying new nix command-line tool
  # nixos.org/manual/nix/stable/contributing/experimental-features
  # "flakes"
    experimental-features =
      [ "nix-command" ]; # Aktiviert Cmds: nix search, nix run, nix shell
    #  extra-sandbox-paths = [ "/dev/nvidiactl" "/dev/nvidia0" "/dev/nvidia-uvm" ];
  #  Nix automatically detects files in the store that have identical contents, and replaces them with hard links to a single copy. This saves disk space.
    auto-optimise-store = true;
    sandbox = true;
    require-sigs =true;
  };
# Lower CPU priority for nix-daemon builds
nix.daemonCPUSchedPolicy = "batch";
# Lowest I/O priority → system stays responsive
nix.daemonIOSchedClass   = "idle";

  nix.nixPath = [
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
    # Get the store path first, then list it:
    #   kbd_path=$(nix-build '<nixpkgs>' -A kbd --no-out-link 2>/dev/null)
    #   ls "$kbd_path/share/kbd/consolefonts/"
    "gr737b-9x16-medieval"; # "Lat2-Terminus16";
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

# Older Intel GPUs use the i965 driver, which can be installed with:
   # Grafikbeschleunigung (Intel HD Graphics 2500/4000)
   hardware.graphics = {
     enable = true;
     extraPackages = with pkgs; [
     # Hardware-Dekodierung von H.264 und VC-1.
      driversi686Linux.intel-vaapi-driver # Spezifischer Treiber für Ivy Bridge (VA-API)
      libvdpau-va-gl
     ];
};
system.copySystemConfiguration = true;   # Copy configuration.nix into the nix store with each build to /run/current-system/configuration.nix

  services.xserver.displayManager.startx.enable =
    true; # Whether to enable the dummy “startx” pseudo-display manager, which allows users to start X manually via the startx command from a virtual terminal.

  services.xserver.exportConfiguration =
    true; # Makes it so the above mentioned xkb directory (and the xorg.conf file) gets exported to /etc/X11/xkb
  services.xserver.desktopManager.runXdgAutostartIfNone =
    true; # whether to run XDG autostart files for sessions without a desktop manager (with only a window manager), these sessions usually don’t handle XDG autostart files by default

  services.xserver.displayManager.sessionCommands = ''
    xcowsay "
    "Hello World!" this is $USER
         Greetings from your GUI and
============================================================
   .S_sSSs     .S   .S S.     sSSs_sSSs      sSSs
   .SS~YS%%b   .SS  .SS SS.   d%%SP~YS%%b    d%%SP
   S%S   `S%b  S%S  S%S S%S  d%S'     `S%b  d%S'
   S%S    S%S  S%S  S%S S%S  S%S       S%S  S%|
   S%S    S&S  S&S  S%S S%S  S&S       S&S  S&S
   S&S    S&S  S&S   SS SS   S&S       S&S  Y&Ss
   S&S    S&S  S&S    S_S    S&S       S&S  `S&&S
   S&S    S&S  S&S   SS~SS   S&S       S&S    `S*S
   S*S    S*S  S*S  S*S S*S  S*b       d*S     l*S
   S*S    S*S  S*S  S*S S*S  S*S.     .S*S    .S*P
   S*S    S*S  S*S  S*S S*S   SSSbs_sdSSS   sSS*S
   S*S    SSS  S*S  S*S S*S    YSSP~YSSY    YSS'
   SP          SP   SP
 ============================================================
    '';

  # Enable CUPS to print documents.
  services.printing.enable = false;
  # Enable touchpad support (enabled default in most desktopManager)
  services.libinput.enable = lib.mkForce false;

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

  # Some applicationsare built for X11. XWayland acts as a translator, allowing
  # these X11 windows to run inside my Wayland session
  programs.xwayland.enable = true;
  # Deaktiviere Thunar
  programs.thunar.enable = lib.mkForce false;
  #  programs.traceroute.enable = true;
  programs.gnome-disks.enable = true;
  programs.git = {
    enable = true;
    prompt.enable = true; # Git-Prompt aktivieren
  };

  services.postgresql.enable =
    true;
  # Aktivieren `vnstat`-Dienst für "Console-based network statistics"
  services.vnstat.enable =
    true; #
 # ac/dc/enable the playerctld daemon.

  services.playerctld.enable =
    false;

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  system.stateVersion = "24.05"; # Did you read the comment?

}
