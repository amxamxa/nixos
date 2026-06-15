# nfs.nix
{ config, pkgs, ... }:
{
environment.systemPackages = with pkgs; [
    # GVfs supports NFS mounts in file managers (Nautilus, Nemo)
    # via nfs://host/share URIs without manual mount commands.
    gvfs
  ];

  services.gvfs.enable = true;

  # ============================================================
  # NFS SERVER
  # Exports two paths to the local subnet (192.168.0.0/24).
  # IP-based access control replaces Samba's user/guest model.
  # all_squash maps every client UID/GID to nobody (anonuid 65534),
  # equivalent to Samba's "force user = nobody".
  #
  # Share     Path                   Access
  # video     /home/video            read-only  (subnet)
  # public    /home/amxamxa/public   read-write (subnet)
  #
  # Client mount (Linux):
  #   mount -t nfs 192.168.0.100:/home/video /mnt/video
  #   mount -t nfs 192.168.0.100:/home/amxamxa/public /mnt/public
  #
  # TSHOOT:
  #   systemctl status nfs-server.service
  #   exportfs -v
  #   showmount -e localhost
  #   rpcinfo -p localhost
  # ============================================================
  services.nfs.server = {
    enable = true;
    exports = ''
      # ro          = read-only
      # sync        = write to disk before replying (data safety)
      # no_subtree_check = skip subtree validation (recommended for perf)
      # all_squash  = map all UIDs/GIDs to anonuid/anongid
      # anonuid/anongid 65534 = nobody/nogroup on Linux
      /home/video          192.168.0.0/24(ro,sync,no_subtree_check,all_squash,anonuid=65534,anongid=65534)
      /home/amxamxa/public 192.168.0.0/24(rw,sync,no_subtree_check,all_squash,anonuid=65534,anongid=65534)
    '';
  };

  # Create share directories on boot if missing.
  # owner = nobody matches anonuid=65534 so NFS writes succeed.
  systemd.tmpfiles.rules = [
    # type  path                     mode  user    group   age
    "d /home/video          0775 nobody nogroup -"
    "d /home/amxamxa/public 0775 nobody nogroup -"
  ];

  # ============================================================
  # FIREWALL RULES
  #
  # TCP/UDP 2049  → NFS daemon (NFSv3 + NFSv4)
  # TCP/UDP 111   → RPC portmapper (required for NFSv3 clients)
  # UDP 5353      → mDNS (Avahi)
  #
  # NFSv4-only clients need only port 2049; port 111 covers
  # legacy NFSv3 clients (older NAS, embedded devices).
  # ============================================================
  networking.firewall.allowedTCPPorts = [ 111 2049 ];
  networking.firewall.allowedUDPPorts = [ 111 2049 5353 ];

  # ============================================================
  # AVAHI (mDNS / DNS-SD)
  # Resolves nixos.local without a DNS server.
  # NFS itself has no discovery protocol; Avahi fills that gap
  # for Linux and macOS file managers.
  # ============================================================
  services.avahi = {
    enable   = true;
    nssmdns4 = true;
    publish = {
      enable       = true;
      workstation  = true;
      domain       = true;
      hinfo        = true;
      addresses    = true;
      userServices = true;
    };
  };

  # ============================================================
  # AVAHI PID FILE WORKAROUND
  # Removes stale /run/avahi-daemon/pid after unclean shutdowns.
  # ============================================================
  systemd.services.avahi-daemon.serviceConfig.ExecStartPre =
    "${pkgs.coreutils}/bin/rm -f /run/avahi-daemon/pid";
    
 }
