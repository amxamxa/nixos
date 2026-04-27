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
];

services.gvfs.enable = true;  # GVfs-Daemon aktivieren

  services.samba = {
  /*
  Share	URL
share	smb://192.168.0.222/share
video	smb://192.168.0.222/video
Da beide Shares guest ok = yes haben → Anmeldung als Gast oder Felder leer lassen.b */
    enable = true;
    package = pkgs.sambaFull; # Statt des minimalen `samba`
    nsswins = true;

    settings = {
      global = {
        workgroup = "WORKGROUP";
      };
music = {
        path = "/home/amxamxa/media/music";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
      };

      video = {
        path = "/home/video";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
      };
  #     share = {
  #      path = "/share";
  #      browseable = "yes";
  #      "read only" = "no"; # write
  #      "guest ok" = "yes";
  #    };
       share = {
        path = "/share";
        browseable = "yes";
        "read only" = "no"; # write
        "guest ok" = "yes";
      };
    };
  };
  services.samba-wsdd.enable = true;

  # If you enable the firewall, allow Samba ports:
   #networking.firewall.allowedTCPPorts = [ 139 445 ];
   #networking.firewall.allowedUDPPorts = [ 137 138 ];


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
