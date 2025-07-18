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
  		nix-prefetch-docker # Script used to obtain source hashes for dockerTools.pullImage
  		];
  
  users.users.amxamxa.extraGroups = [ "docker" ];
  
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;  # When enabled dockerd is started on boot. required for containers with --restart=always' flag. 
    # If disabled, docker might be started on demand by socket activation.
   rootless = {
    	enable = true;  # Podman socket avail Docker ohne Root-Rechte betreiben (sicherer)
    	setSocketVariable = true;  # Setzt Umgebungsvariable für Docker Socket
    	daemon.settings = {
  		# fixed-cidr-v6 = "fd00::/80";
 		# ipv6 = true;
		}; # These attributes are serialized to JSON used as daemon.conf.
		# See https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file
  	 };

	autoPrune.enable = true; # periodically prune/empty Docker resources.
   # systemd timer will run docker system prune -f as specified by the dates option.
	autoPrune.dates = "weekly";
	autoPrune.flags = [
 	# "--all" # Any additional flags passed to docker system prune.
	 ];
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

  virtualisation.containers.registries.search = [ "docker.io" ];



  #  services.hello.image = pkgs.dockerTools.buildImage {
  #    name = "hello-docker";
  #    config = { Cmd = [ "${pkgs.hello}/bin/hello" ]; };
  #  }
    /*
    services.nginx3 = { 
      image = "nginx";
      ports =nix-prefetch-docker
Script used to obtain source hashes for dockerTools.pullImage [ "8083:80" ]; # Port-Weiterleitung 8083→80
      volumes = [
        {
          source = pkgs.writeText "index.html" "Man, SCREW WORLD!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
          target = "/usr/share/nginx/html/index.html";
        }
        {
          volumeName = "test-volume";
          target = "/my-volume";
        }nix-prefetch-docker
Script used to obtain source hashes for dockerTools.pullImage
        {
          volumeName = "test-volume2";
          target = "/my-volume2";
        }
        {
          volumeName = "test-volume3";
          target = "/my-volume3";
        }
      ];
    };
    volumes = {
      test = { };
    };
  }; */

}

