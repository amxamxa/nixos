{ config, lib, pkgs, modulesPath, ... }:
{
#  Alle Docker-Daten werden im /docker-Verzeichnis gespeichert, das auf einer separaten Partition liegen kann.
  fileSystems."/docker" = {
    device = "/dev/disk/by-label/docker";     # /dev/sdb2: LABEL="docker" UUID="81c7ce53-592b-44a4-aa8a-a4add588e292"
    fsType = "ext4";
    options = [ "defaults" /*"subvol=share" "noatime" "nodiratime" "discard" */ ];
  };

 # virtualisation.docker.storageDriver = "btrfs";
 # hardware.nvidia-container-toolkit.enable = true;
  environment.systemPackages = with pkgs; [ 
  		docker 
  		docker-compose  # Docker CLI plugin to run multi-container applications
  		docui 		# TUI Client for Docker
  		lazydocker 	# A simple terminal UI for both docker and docker-compose
  		];
  
  users.users.amxamxa.extraGroups = [ "docker" ];
  
  virtualisation.docker = {
  enable = true;
  rootless = {
    	enable = true;  # Docker ohne Root-Rechte betreiben (sicherer)
    	setSocketVariable = true;  # Setzt Umgebungsvariable für Docker Socket
  	 };
   daemon.settings = {
    	data-root = "/docker";
     	experimental = true;
     	# userland-proxy = false;
     	#   metrics-addr = "0.0.0.0:9323";
     	storage-driver = "overlay2";     # overlay2 ist der empfohlene Treiber für ext4-Dateisysteme. 
     	# KONFIGURATION FÜR DOCKER-BRIDGE IP fur docker0
     	"bip" = "172.17.0.0/16";
   };
};
  # Umgebungsvariablen für Docker
  environment.sessionVariables = {
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";  # Socket für rootless Docker
  };
}

 


