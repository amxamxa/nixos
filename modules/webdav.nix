# WebDAV.nix
{ config, pkgs, ... }:
#Typ:      WebDAV
#URL:      http://192.168.0.222:8080
#User:     user
#Passwort: q1w2e3r4
# Zugriff von außerhalb LAN	→ HTTP 403 (IP-Sperre greift)
# Falsches Passwort	→ HTTP 401
#sudo nix-shell -p apacheHttpd --run \
#  "htpasswd -Bc /etc/httpd/htpasswd user"
# Passwort: q1w2e3r4
#sudo chmod 640 /etc/httpd/htpasswd
#sudo chown root:wwwrun /etc/httpd/htpasswd

# TSHOOT:
# ACL prüfen
# getfacl /home/amxamxa/public
# getfacl /home/video
#http://192.168.0.222:8080/	Video – nur lesen
#http://192.168.0.222:8080/public	Public – lesen + schreiben
# Berechtigungen
# eza -ld /home/video /home/amxamxa/public


{
users.groups.mxx = {};

systemd.tmpfiles.rules = [
  # d = directory, 2775 = SGID+rwxrwxr-x, owner: nobody, group: mxx
  "d /home/video          2775 nobody mxx -"
  "d /home/amxamxa/public 2775 nobody mxx -"

  # ACL: wwwrun bekommt rwx auf public (a+ = ACL hinzufügen, nicht ersetzen)
  "a+ /home/amxamxa/public - - - - u:wwwrun:rwx"
  # ACL default: neue Dateien in public erben wwwrun-ACL
  "a+ /home/amxamxa/public - - - - d:u:wwwrun:rwx"
];
services.httpd = {
  enable = true;
  adminAddr = "admin@localhorst";
  extraModules = [ "dav" "dav_fs" ];

  virtualHosts."localhorst" = {
    serverAliases = [ "192.168.0.222" ];
    listen = [{ ip = "*"; port = 8080; }];
    documentRoot = "/home/video";

    extraConfig = ''
      DavLockDB /tmp/DavLock

      # /  → /home/video  (read-only via filesystem permissions)
      <Directory "/home/video">
        DAV On
        Options Indexes
        AuthType Basic
        AuthName "NAS"
        AuthUserFile /etc/httpd/htpasswd
        <RequireAll>
          Require valid-user
          Require ip 192.168.0.0/24
        </RequireAll>
      </Directory>

      # /public → /home/amxamxa/public  (read-write via ACL)
      Alias /public /home/amxamxa/public
      <Directory "/home/amxamxa/public">
        DAV On
        Options Indexes
        AuthType Basic
        AuthName "NAS"
        AuthUserFile /etc/httpd/htpasswd
        <RequireAll>
          Require valid-user
          Require ip 192.168.0.0/24
        </RequireAll>
      </Directory>
    '';
  };
};

networking.firewall.allowedTCPPorts = [ 8080 ];


}
