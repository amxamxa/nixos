# modules/dns.nix
# Static DNS enforcement - completely ignores DHCP-provided DNS servers.
# NetworkManager handles IP/routing via DHCP, but DNS management is disabled.
# DNS-over-TLS via systemd-resolved.
# Bypasses router DNS on port 53 entirely, uses encrypted port 853.
{ config, pkgs, lib, ... }:
{

  
  networking = {
  useDHCP = false;

  interfaces.eth0 = {
    useDHCP = false;
    ipv4.addresses = [{
      address      = "192.168.0.222";
      prefixLength = 24;
    }];
  };

  defaultGateway = {
    address   = "192.168.0.1";
    interface = "eth0";
  };

  nameservers = [ "127.0.0.53" ];
};

# Disable DNS DefaultRoute on eth0 via resolved
systemd.services.eth0-dns-default-route = {
  description = "Disable DNS DefaultRoute on eth0";
  after    = [ "network-online.target" "systemd-resolved.service" ];
  wants    = [ "network-online.target" ];
  wantedBy = [ "multi-user.target" ];
  serviceConfig = {
    Type            = "oneshot";
    RemainAfterExit = true;
    ExecStart = "${pkgs.systemd}/bin/resolvectl default-route eth0 no";
    # Set Digitalcourage DNS server for eth0
    ExecStartPost = "${pkgs.systemd}/bin/resolvectl dns eth0 5.9.164.112";
  };
};

services.resolved = {
  enable        = true;
  dnssec        = "allow-downgrade";
  dnsovertls    = "opportunistic";
  domains       = [ "~." ];
  extraConfig   = ''
    DNS=5.9.164.112#digitalcourage.de
    FallbackDNS=46.182.19.48#dns2.digitalcourage.de
  '';
};
  # resolved creates /etc/resolv.conf as symlink to its stub:
  # /etc/resolv.conf -> /run/systemd/resolve/stub-resolv.conf
  # stub listens on 127.0.0.53:53 locally
}

