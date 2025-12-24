{ config, pkgs, ... }:

{
# Intel CPU microcode updates
hardware.cpu.intel.updateMicrocode = true;

hardware.firmware = with pkgs; [ linux-firmware ];

 boot.consoleLogLevel = 3;
 boot.initrd.verbose = true;
  
 boot.kernel.sysctl = {
  "kernel.sysrq" = 1;
  "kernel.printk" = "3 3 3 3";   # Kernel-Log (console_/default_message_/minimum_console_/default_console_)loglevel
};
 boot.kernelModules = [ 
  "kvm-intel"                      # Intel virtualization (statt kvm-amd)
  "bfq"                            # I/O scheduler
  
  # Optional für bessere Intel GPU performance
  # "i915"                         # Wird meist automatisch geladen
];
 
# Turbo Boost explizit aktivieren (falls deaktiviert)
boot.kernelParams = [
  "intel_pstate=active"
  "intel_pstate.no_hwp=1"  # Disable Hardware P-States auf Ivy Bridge
    # Intel-specific CPU frequency scaling
  "intel_pstate=active"           # Modern Intel P-State driver
    # Security 
  "mitigations=auto"              # Empfohlen statt "off" für Ivy Bridge
  
  # System behavior
  "panic=1"
  
  # Boot verbosity
  "rd.systemd.show_status=auto"
  "rd.udev.log_priority=3"
  
  "zswap.enabled=1"
  
  # Intel graphics (integrierte GPU)
  "i915.enable_fbc=1"             # Framebuffer compression
  "i915.enable_psr=0"             # Panel Self Refresh (oft buggy bei Ivy Bridge)
  "i915.fastboot=1"               # Faster boot for Intel GPU
];


  boot.loader = {
  # UEFI
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  # SYSTEMD-BOOT
   systemd-boot = { enable = true; };
   
  # GRUB2
    grub = {
      enable = false;
      efiSupport = true;
      memtest86.enable = true;
      fsIdentifier = "label";
      devices = [ "nodev" ];
      useOSProber = true;
      splashImage = "./assets/background.png";
      backgroundColor = "#7EBAE4";
      configurationLimit = 77;
      font = "./data/cfont.pf2";
      fontSize = 14;
   #   gfxmodeEfi = "1920x1080";
      /*
     	insmod all_video             # Alle verfügbaren Videotreiber laden
 	set gfxmode=1920x1080,auto   # GRUB-Auflösung setzen
	set gfxpayload=keep          # Auflösung an den Kernel durchreichen
      	set timeout_style=hidden
      	set timeout=10
      	set color_normal=green/black 
      	set color_highlight=yellow/blue
      
 	 ### --- Sicherheit ---
 	# set superusers="admin"
  	# Passwort-Hash mit "grub-mkpasswd-pbkdf2" erzeugen:
 	 # password_pbkdf2 admin <hash>
  	# Beispiel: password_pbkdf2 admin grub.pbkdf2.sha512.10000.ABCDEF123...
  	#lock  # Menü sperren, wenn Passwort nötig

	### --- Debugging---
	 # set debug=all
  
  */
  
      extraConfig = ''    	
      	### --- Fallback auf Textmodus, falls Grafik scheitert ---
  	if ! gfxterm; then
    		terminal_output console
  	fi
      '';
      extraEntriesBeforeNixOS = false;
      #extraInstallCommands = ''          ${pkgs.grub2}/bin/grub-install --target=x86_64-efi --efi-directory=/boot/efi '';
      extraEntries = ''
      #   menuentry "Netboot.xyz (UEFI)" {
       #  insmod part_gpt
        # insmod fat
         #search --no-floppy --fs-uuid ED08-2B0B --set=root
        # chainloader ($root)/netboot/netboot.xyz.efi
        # }
        menuentry "Reboot" { reboot }  
	menuentry "Poweroff" { halt }
      '';
    }; 
  };
  
    boot.tmp.cleanOnBoot = true;
 

      /*
      ''
  menuentry "Windows 7" {  # GRUB 2 example
    chainloader (hd0,4)+1
  }
  menuentry "Fedora" {   # GRUB 2 with UEFI example, chainloading another distro
    set root=(hd1,1)
    chainloader /efi/fedora/grubx64.efi       
  }
''
*/
    
# ISO-Datei bereitstellen 
/*
environment.etc."netboot.xyz.iso" = {
    source = pkgs.fetchurl {
      url = "https://github.com/netbootxyz/netboot.xyz/releases/download/2.0.72/netboot.xyz.iso";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Aktuelle Hash eintragen!
    };
    target = "var/lib/netboot/netboot.xyz.iso";
  };
  */
}

