{ config, pkgs, lib, ... }:

{
# Bootloader und Kernel-Optimierungen
 # boot.kernelPackages = pkgs.linuxPackages_6_6; # Festlegung auf den LTS-Kernel
  /*
  boot.kernelParams = [
    # mitigations=off`**: Dies ist der effektivste Hebel für Ivy Bridge. Moderne Linux-Kernel implementieren Schutzmaßnahmen gegen Spectre, Meltdown und L1TF, die auf dieser Hardware-Generation massiven Overhead verursachen. Durch das Deaktivieren wird die CPU-Pipeline entlastet, was besonders bei Dateioperationen und Prozesswechseln spürbar ist.
    "mitigations=off" 
    # Deaktiviert CPU-Sicherheits-Patches für maximale Performance (Risikoabwägung!)
    "intel_pstate=passive" # Ermöglicht feineres Power-Management bei älteren Intel-CPUs
    "nowatchdog" # Deaktiviert den Hardware-Watchdog zur Reduzierung von Interrupts
  ];
  */
#####################
# 1. Aktivierung des Irqbalance-Service
  # Balanciert Hardware-Interrupts dynamisch über alle 4 Kerne
  services.irqbalance.enable = true;

  # 2. RFS (Receive Flow Steering) - Globale Kernel-Einstellungen
  boot.kernel.sysctl = {
    # Maximale Anzahl an gleichzeitig verfolgten Flows (Sonden)
    # Empfohlener Wert für Workstations: 32768
    "net.core.rps_sock_flow_entries" = 32768;
  };

  # 3. RFS (Per-Queue) und XPS (Transmit Packet Steering) via Udev
  /*
  services.udev.extraRules = ''
    # RFS: Zuweisung der Flow-Kapazität pro Empfangswarteschlange (rx-0)
    # Wert sollte 'rps_sock_flow_entries' geteilt durch Anzahl der Queues sein
    ACTION=="add", SUBSYSTEM=="net", NAME=="eth0", RUN+="${pkgs.bash}/bin/bash -c 'echo 32768 > /sys/class/net/eth0/queues/rx-0/rps_flow_cnt'"

    # XPS: Übertragungssteuerung auf alle Kerne verteilen
    # Verbessert die Sende-Effizienz analog zu RPS/RFS (Maske f = alle 4 Kerne)
    ACTION=="add", SUBSYSTEM=="net", NAME=="eth0", RUN+="${pkgs.bash}/bin/bash -c 'echo f > /sys/class/net/eth0/queues/tx-0/xps_cpus'"
  '';
*/

 ###############################
 # Sicherstellen, dass das notwendige Kernel-Modul geladen wird
  #boot.kernelModules = [ "bfq" ];
  # Hardware-Microcode Updates (Essentiell für Stabilität)
  hardware.cpu.intel.updateMicrocode = true;

# Entlastung des Schreib-I/O: Durch das Verschieben des `/tmp`-Verzeichnisses in den Arbeitsspeicher (RAM) werden unnötige Schreibzugriffe auf die SSD und CPU-Interrupts durch den I/O-Controller reduziert:
boot.tmp.useTmpfs = true;
boot.tmp.tmpfsSize = "2G";

# Setzen auf `10` wird der Nix-Daemon angewiesen, im Hintergrund zu arbeiten.
# kein Hyperthreading verfügt, würde ein Nix-Build auf allen 4 Kernen bei Standardpriorität das System "einfrieren" lassen. Mit Priorität 10 bleibt das System responsiv, da die interaktiven Prozesse den Vortritt erhalten.
nix.settings.daemon-base-priority = 10;

  # Grafikbeschleunigung (Intel HD Graphics 2500/4000)
 /* hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
    # Hardware-Dekodierung von H.264 und VC-1.
      intel-vaapi-driver # Spezifischer Treiber für Ivy Bridge (VA-API)
 #     libvdpau-va-gl
    ];
  };
*/
  # Ressourcen-Management und Performance-Daemons
#  services.thermald.enable = true; # Verhindert Überhitzung durch intelligentes Throttling
/*  
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };
*/
  # ZRAM zur Entlastung des DDR3-Arbeitsspeichers
  zramSwap.enable = true;
  zramSwap.memoryPercent = 25;

  # Speicheroptimierung für ältere SSDs/HDDs
  services.fstrim.enable = true; # Wichtig für die Langlebigkeit alter SSDs
##########################################  

# IPv6-Deaktivierung: lokale Netzwerk IPv4 basiert. Deaktivierung von IPv6 den Overhead des Netzwerk-Stacks und die Anzahl der Kernel-Threads 
boot.kernel.sysctl."net.ipv6.conf.all.disable_ipv6" = 1;
boot.kernel.sysctl."net.ipv6.conf.default.disable_ipv6" = 1;
  
 #  treefmt as environment package
 environment.systemPackages = [ pkgs.nixfmt ];
 }


