# tftp-samba.nix
{ config, pkgs, ... }:
{
/*
# TFTP server for router flashing
services.atftpd = {
  enable = true;
#  root = "/srv/tftp";
root = "/home/project/openWRT";
};
*/
# Firewall: allow TFTP port
#networking.firewall.allowedUDPPorts = [ 69 ];

  services.samba = {
    enable = true;
    package = pkgs.sambaFull; # Statt des minimalen `samba`
    nsswins = true;

    settings = {
      global = {
        workgroup = "WORKGROUP";
      };

      videos = {
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
       public = {
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
    nssmdns4 = true; # mDNS-Unterstützung
    publish = {
      enable = true;
      workstation = true; # macht PC im lokalen Netzwerk „sichtbar“ als generische Workstation über mDNS/DNS-SD.
      domain = true;
      hinfo = true; # hw,cpu
      addresses = true; # IP-Adresse veröffentlichen
      userServices = true; # Nutzerdienste sichtbar machen
    };
  };

}
