{ config, lib, pkgs, modulesPath, ... }:
{
  fileSystems."/docker" = {
    # /dev/sdb2: LABEL="docker" UUID="81c7ce53-592b-44a4-aa8a-a4add588e292"
    device = "/dev/disk/by-label/docker";
    #mountPoint = "/docker";
    fsType = "ext4";
    options = [ "defaults" /*"subvol=share" "noatime" "nodiratime" "discard" */ ];
  };

 # virtualisation.docker.storageDriver = "btrfs";
  
  environment.systemPackages = with pkgs; [ 
  		docker 
  		docker-compose  # Docker CLI plugin to run multi-container applications
  		docui 		# TUI Client for Docker
  		lazydocker 	# A simple terminal UI for both docker and docker-compose
  		];
  
  users.users.amxamxa.extraGroups = [ "docker" ];
  
  # hardware.nvidia-container-toolkit.enable = true;
   virtualisation = {
    docker = {
      enable = true;
      daemon = {
        settings = {
          data-root = "/docker";
          userland-proxy = false;
          experimental = true;
          metrics-addr = "0.0.0.0:9323";
        };
      };
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
