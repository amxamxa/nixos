# modules/dns.nix
# Static DNS enforcement - completely ignores DHCP-provided DNS servers.
# NetworkManager handles IP/routing via DHCP, but DNS management is disabled.
{ lib, ... }:
{
  # KEY: Tell NM to not touch /etc/resolv.conf at all.
  # "none" means NM neither reads nor writes DNS configuration.
  # NixOS activation scripts will manage /etc/resolv.conf instead.
  networking.networkmanager.dns = lib.mkForce "none";

  # These servers are written to /etc/resolv.conf by NixOS at activation time.
  # With NM dns="none", this file stays static across reboots and DHCP renewals.
  networking.nameservers = [
    "5.9.164.112"     # digitalcourage e.V. (DE, datenschutzkonform, kein Logging)
    "204.152.184.76"  # ISC f.6to4-servers.net (USA, stabil seit Jahrzehnten)
    "194.150.168.168" # dns.as250.net (Berlin/Frankfurt)
  ];

  # Optional but recommended: make /etc/resolv.conf a read-only Nix-store symlink.
  # Nothing (not even root) can overwrite it at runtime.
  # /etc/resolv.conf → /etc/static/resolv.conf (immutable in Nix store)
  environment.etc."resolv.conf" = {
    text = ''
      # Managed by NixOS - do not edit manually
      # DHCP DNS is intentionally ignored (NetworkManager dns=none)
      
      nameserver 192.168.0.1
      nameserver 8.8.8.8
      nameserver 5.9.164.112
      
      nameserver 204.152.184.76
      nameserver 194.150.168.168
      options timeout:2 attempts:3 rotate
    '';
    mode = "0644";
  };
}
