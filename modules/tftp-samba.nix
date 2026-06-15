{ config, pkgs, ... }:
{
  # ============================================================
  # TFTP SERVER (currently disabled)
  # atftpd = Advanced TFTP Daemon, used for router firmware
  # flashing (e.g. OpenWRT). Uncomment to activate.
  # Default TFTP port: UDP 69 (also uncomment firewall rule below)
  # ============================================================
  /*
  services.atftpd = {
    enable = true;
    root = "/home/project/openWRT";
  };
  networking.firewall.allowedUDPPorts = [ 69 ];
  */
  services.nginx = {
  enable = true;

  # Add dav_ext module for PROPFIND/OPTIONS support
  package = pkgs.nginx.override {
    modules = [ pkgs.nginxModules.davExt ];
  };

  virtualHosts."webdav.local" = {
    listen = [{ addr = "0.0.0.0"; port = 8080; }];
    locations."/" = {
      root = "/home/video";
      extraConfig = ''
        # Standard DAV methods
        dav_methods PUT DELETE MKCOL COPY MOVE;

        # Extended methods required for directory browsing
        dav_ext_methods PROPFIND OPTIONS;

        dav_access user:rw group:r all:r;
        autoindex on;
      '';
    };
  };
};
  environment.systemPackages = with pkgs; [
    # GNOME Virtual File System: enables file managers
    # (Nautilus, Thunar) to mount SMB shares via URI
    # smb://host/share without manual mount commands.
    # Note: samba and avahi packages are pulled in automatically
    # by services.samba.enable and services.avahi.enable.
    gvfs  # GVfs core + CLI tools
  ];

  # The GVfs daemon must run as a service so that file managers
  # can mount SMB shares on demand via D-Bus activation.
  # Without this, smb:// URIs in file managers will not work.
  services.gvfs.enable = true;

  # ============================================================
  # SAMBA SERVER
  # Samba implements the SMB/CIFS protocol, allowing Windows,
  # macOS, and Linux clients to access shares transparently.
  #
  # Share   URL
  # video   smb://192.168.0.100/video
  # public  smb://192.168.0.100/public
  #
  # TSHOOT:
  #   systemctl status samba-smbd.service
  #   systemctl status samba-nmbd.service
  #   systemctl status samba-winbindd.service
  #   testparm
  #   smbclient -L localhost -N
  #   smbclient //<server-ip>/video -U amxamxa -d 3
  #   sudo mount -t cifs //<server-ip>/public /mnt -o username=amxamxa
  # ============================================================
  services.samba = {
    enable = true;
    # Opens TCP 445, 139 and UDP 137, 138 automatically
    openFirewall = true;
    # Enables winbindd to resolve WINS/NetBIOS names via NSS
    nsswins = true;
    settings = {
      global = {
        # Workgroup name - adjust to match your network
        workgroup = "WORKGROUP";
        # Server description visible in network browser
        "server string" = "NixOS Samba Server";
        # Security mode: user-level, unknown users map to guest
        security = "user";
        "map to guest" = "Bad User";
        "guest account" = "nobody";

        # Disable printing to avoid spooler errors
        "load printers" = "no";
        "printcap name" = "/dev/null";

        # Logging: rotate at 1 MB, level 1 (errors only)
        "log file" = "/var/log/samba/log.%m";
        "max log size" = "1000";
        "log level" = "1";
      };

      # Share 1: /home/video - read-only guest access
      "video" = {
        path = "/home/video";
        comment = "Video Library";
        browseable = "yes";
        "read only" = "yes";        # Guests get read-only access
        "guest ok" = "yes";         # No password required
        "force user" = "nobody";    # All access runs as nobody
        "create mask" = "0644";
        "directory mask" = "0755";
      };

      # Share 2: /home/amxamxa/public - read-write guest access
      "public" = {
        path = "/home/amxamxa/public";
        comment = "Public Share";
        browseable = "yes";
        "read only" = "no";         # Guests can read and write
        "guest ok" = "yes";
        "force user" = "nobody";    # All access runs as nobody
        "create mask" = "0664";
        "directory mask" = "0775";
      };
    };
  };

  # Create share directories on boot if missing.
  # owner = nobody so that 'force user = nobody' in samba
  # can actually write into these directories.
  systemd.tmpfiles.rules = [
    # type  path                     mode  user    group   age
    "d /home/video          0775 nobody nogroup -"
    "d /home/amxamxa/public 0775 nobody nogroup -"
  ];

  # ============================================================
  # WS-DISCOVERY (wsdd)
  # Implements WS-Discovery (UDP 3702): the modern Windows 10/11
  # mechanism for finding network shares in Network Neighbourhood,
  # replacing legacy NetBIOS browsing.
  # --discovery: host actively announces itself in addition to
  # responding to incoming discovery queries.
  # openFirewall = true opens UDP 3702 automatically.
  # ============================================================
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
    extraOptions = [ "--discovery" ];
  };

  # ============================================================
  # FIREWALL RULES
  #
  # TCP 139, 445 and UDP 137, 138      → opened by services.samba.openFirewall
  # UDP 3702 (WS-Discovery)            → opened by services.samba-wsdd.openFirewall
  # UDP 5353 (mDNS)                    → required by Avahi, must be set manually
  # ============================================================
  networking.firewall.allowedUDPPorts = [ 5353 ];

  # ============================================================
  # AVAHI (mDNS / DNS-SD)
  # Implements Zeroconf (RFC 6762/6763):
  #   mDNS:   resolves nixos-samba.local without a DNS server
  #   DNS-SD: announces services (SMB, SSH) so macOS Finder and
  #           Linux file managers discover them automatically.
  #
  # nssmdns4 = true → plugs Avahi into NSS so getaddrinfo()
  #   resolves .local names; required for "ping nixos.local".
  # ============================================================
  services.avahi = {
    enable   = true;
    nssmdns4 = true;
    publish = {
      enable       = true;
      workstation  = true;   # announces host as workstation
      domain       = true;   # publishes local domain
      hinfo        = true;   # hardware/OS info (CPU, OS type)
      addresses    = true;   # publishes IPv4/IPv6 addresses
      userServices = true;   # publishes user-started services
    };
  };

  # ============================================================
  # AVAHI PID FILE WORKAROUND
  # On unclean shutdowns, avahi-daemon leaves a stale PID file
  # at /run/avahi-daemon/pid, causing startup failure on next
  # boot. ExecStartPre removes it before each start.
  # "rm -f" is idempotent: no error if file is absent.
  # ============================================================
  systemd.services.avahi-daemon.serviceConfig.ExecStartPre =
    "${pkgs.coreutils}/bin/rm -f /run/avahi-daemon/pid";
    

}

