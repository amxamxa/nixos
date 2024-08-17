{ config, pkgs, ... }:
{
  
      #-----------------------------------
   #        ██████╗ ██████╗ ██╗   ██╗
   #       ██╔════╝ ██╔══██╗██║   ██║
   #       ██║  ███╗██████╔╝██║   ██║
   #       ██║   ██║██╔═══╝ ██║   ██║
   #       ╚██████╔╝██║     ╚██████╔╝
   #        ╚═════╝ ╚═╝      ╚═════╝ 
   #---ansi shadow-----------------------

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
#  # blacklisted, the proprietary NVIDIA kernel module from nvidia_x11 will still
#  # be loaded because it is added explicitly via boot.extraModulePackages.
   boot.extraModulePackages = [ pkgs.linuxPackages.nvidia_x11 ];
   # boot.blacklistedKernelModules = [ "nouveau"	"nvidia_drm" "nvidia_modeset"];
# Load nvidia driver for Xorg and Wayland
   services.xserver.videoDrivers = [ "nvidia" ]; 

   hardware.nvidia = {
#   # modesetting when using the NVIDIA proprietary driver.
 	   modesetting.enable = true;
  # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
     	powerManagement.enable = false;
     	powerManagement.finegrained = false;
 
  # Currently alpha-quality/buggy, so false is currently the recommended setting
      	open = false; #Ob das Open-Source-NVIDIA-Kernelmodul aktiviert werden s>
      	nvidiaSettings = true; #  the settings menu, via nvidia-settings
   	nvidiaPersistenced = false; #es stellt sicher, dass alle GPUs auch im Headlesss
         #prime = { # Zusammenarbeit Intel-GPU) und NVIDIA-GPU
#           		  # Make sure to use the correct Bus ID values for your system!
#         #  		  intelBusId = "PCI:00:02.0";
#          # 		  nvidiaBusId = "PCI:01:00.0";
#           #	};
            };
            #  hardware.bumblebee.enable = true;
#  hardware.bumblebee.driver = "nvidia";  #"nvidia" or "nouveau"
#  hardware.bumblebee.pmMethod = "auto"; #Set preferred power management method 

    hardware.opengl.enable 			= true; # Treiber HW-beschleunigung von Medienfunktionen
  	hardware.opengl.driSupport 		= true;
	hardware.opengl.driSupport32Bit = true;
#   
}
