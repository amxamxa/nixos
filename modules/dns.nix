# modules/dns.nix
# Static DNS enforcement - completely ignores DHCP-provided DNS servers.
# NetworkManager handles IP/routing via DHCP, but DNS management is disabled.
# DNS-over-TLS via systemd-resolved.
# Bypasses router DNS on port 53 entirely, uses encrypted port 853.
{ config, pkgs, lib, ... }:
{

  networking.networkmanager.dns = lib.mkForce "systemd-resolved";

  # Tell NM globally to never use DHCP-provided DNS for any connection
  networking.networkmanager.settings.connection = {
    "ipv4.ignore-auto-dns" = true;
    "ipv6.ignore-auto-dns" = true;
  };

  networking.nameservers = [
    "5.9.164.112#digitalcourage.de"
  ];

  services.resolved = {
    enable     = true;
    domains    = [ "~." ];
    dnsovertls = "true";
    dnssec     = "allow-downgrade";
    llmnr      = "false";
    fallbackDns = [ "9.9.9.9#dns.quad9.net" ];
    extraConfig = ''
      Cache=yes
      ReadEtcHosts=yes
    '';
  };
  # resolved creates /etc/resolv.conf as symlink to its stub:
  # /etc/resolv.conf -> /run/systemd/resolve/stub-resolv.conf
  # stub listens on 127.0.0.53:53 locally
}

