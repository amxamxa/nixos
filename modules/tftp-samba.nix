# tftp-samba.nix
{ config, pkgs, ... }:
{
/*
# TFTP server for router flashing
services.atftpd = {
  enable = true;
#  root = "/srv/tftp";
  '';
})

root = "/home/project/openWRT";
};
*/
# Firewall: allow TFTP port
#networking.firewall.allowedUDPPorts = [ 69 ];
environment.systemPackages = with pkgs; [
  gvfs          # GVfs core
  samba         # SMB client tools (smbclient etc.)
  avahi
  wsdd
];

services.gvfs.enable = true;  # GVfs-Daemon aktivieren
 /*
  Share	URL
share	smb://192.168.0.222/share
video	smb://192.168.0.222/video
Da beide Shares guest ok = yes haben → Anmeldung als Gast oder leer */

  services.samba = {
    enable = true;
    package = pkgs.sambaFull;
    nsswins = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "map to guest" = "Bad User";
        "guest account" = "nobody";
        "server string" = "NixOS Samba Server";
        "netbios name" = "nixos-samba";
        security = "user";
      };
      share = {
        path = "/share";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0666";
        "directory mask" = "0777";
        "force user" = "sambaguest";  # Optional, aber empfohlen
      };
      music = {
        path = "      /home/amxamxa/media/music";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0666";
        "directory mask" = "0777";
        "force user" = "sambaguest";  # Optional, aber empfohlen
      };

      
      video = {
        path = "/home/video";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0666";
        "directory mask" = "0777";
        "force user" = "sambaguest";  # Optional, aber empfohlen
      };
    };
  };

# gruppe anlegen  
    users.groups.sambaguest = {};

services.samba-wsdd = {
enable = true;
discovery = true;

};

# Eigener Gast-Benutzer und Gruppe
  users.users.sambaguest = {
    isSystemUser = true;
    group = "sambaguest";
    home = "/share";
    createHome = true;
    shell = "/sbin/nologin";
  };

  # Verzeichnis deklarativ anlegen
  systemd.tmpfiles.rules = [
    "d /share 0777 sambaguest sambaguest - -"
  ];
  
  # Avahi für Netzwerk-Discovery aktivieren
  services.avahi = {
    enable = true;
    # mDNS-Unterstützung
    nssmdns4 = true;
    publish = {
      enable = true;
      # macht PC im lokalen Netzwerk „sichtbar“ als generische Workstation über mDNS/DNS-SD.
      workstation = true;
      domain = true;
      # hw,cpu
      hinfo = true;
      # IP-Adresse veröffentlichen
      addresses = true;
      # Nutzerdienste sichtbar machen
      userServices = true;     };
  };


 # Remove stale PID file before avahi-daemon starts
systemd.services.avahi-daemon.serviceConfig.ExecStartPre =
  "${pkgs.coreutils}/bin/rm -f /run/avahi-daemon/pid";

}
