# /etc/nixos/modules/audio.nix
/*    O~                    O~~             
     O~ ~~                  O~~ O~          
    O~  O~~    O~~  O~~     O~~      O~~    
   O~~   O~~   O~~  O~~ O~~ O~~O~~ O~~  O~~ 
  O~~~~~~ O~~  O~~  O~~O~   O~~O~~O~~    O~~
 O~~       O~~ O~~  O~~O~   O~~O~~ O~~  O~~ 
O~~         O~~  O~~O~~ O~~ O~~O~~   O~~    
# Audio system configuration for NixOS  */

# Components:
# - PipeWire audio server (replaces PulseAudio and JACK)
# - WirePlumber session manager
# - ALSA compatibility layer
# - Low-latency configuration for audio production
# - Bluetooth audio enhancements
# - Default volume setup
# wireplumber: Most configuration of devices is performed by the session manager. It typically loads ALSA and other devices and configures the profiles, port volumes and more. The session manager also configures new clients and links them to the targets, as configured in the session manager policy.
# PipeWire clients: Each native PipeWire client also loads a configuration file. Emulated JACK client also have separate configuration.
{ config, pkgs, ... }: 
{
  # ============================================
  # USER GROUPS
  # Add audio-related groups for the primary user
 
  users.users.amxamxa.extraGroups = [ "jackaudio" "audio" ];

  # ============================================
  # KERNEL CONFIGURATION
  # Optimize kernel for audio performance
   boot.kernelModules = [ 
    "snd-seq"      # ALSA sequencer
    "snd-rawmidi"  # Raw MIDI support
  ];
  
  boot.kernel.sysctl = {
    # Increase inotify limits for audio applications
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 512;
    
    # Reduce swappiness to minimize audio dropouts
    "vm.swappiness" = 10;
  };
  # =========================================

  # =========================================
  # HARDWARE FIRMWARE
  hardware.firmware = [ pkgs.alsa-firmware ];

  # ========================================
  # AUDIO SERVICE CONFIGURATION
  
  # Disable JACK daemon (PipeWire provides JACK emulation)
  services.jack.jackd.enable = false;
  
  # Disable PulseAudio (PipeWire replaces it)
  # Note: The option name changed in NixOS 24.11
  # Old: sound.enable = false
  # New: services.pulseaudio.enable = false (implicit)
  
  # Enable RealtimeKit for real-time audio scheduling
  # This allows audio processes to get real-time priority on demand
  security.rtkit.enable = true;

  # ====================================
  # PIPEWIRE CONFIGURATION
  # PipeWire is a modern audio server that replaces both PulseAudio and JACK
   services.pipewire = {
    enable = true;
    
    # Enable ALSA support (Advanced Linux Sound Architecture)
    alsa.enable = true;
    alsa.support32Bit = true;  # For 32-bit applications
    
    # Enable JACK emulation (for professional audio applications)
    jack.enable = true;
    
    # Enable WirePlumber session manager
    # WirePlumber is the modern replacement for pipewire-media-session
    wireplumber.enable = true;
    
    # Low-latency configuration for audio production
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;      # Sample rate: 48kHz
        "default.clock.quantum" = 32;       # Buffer size: 32 samples
        "default.clock.min-quantum" = 32;   # Minimum buffer
        "default.clock.max-quantum" = 32;   # Maximum buffer
        # Note: 32 samples @ 48kHz = 0.67ms latency (very low)
      };
    };

    # Bluetooth audio enhancements
    wireplumber.extraConfig.bluetoothEnhancements = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;     # High-quality SBC codec
        "bluez5.enable-msbc" = true;       # mSBC for better call quality
        "bluez5.enable-hw-volume" = true;  # Hardware volume control
        "bluez5.roles" = [ 
          "hsp_hs"   # Headset role
          "hsp_ag"   # Audio gateway role
          "hfp_hf"   # Hands-free role
          "hfp_ag"   # Hands-free audio gateway
        ];
      };
    };
  };

  # ==============================================
  # ENVIRONMENT VARIABLES
   environment.variables = {
    # Set default latency for PipeWire clients
    PIPEWIRE_LATENCY = "32/48000";  # 32 samples at 48kHz
    # Disable JACK audio reservation for allow multiple clients
    JACK_NO_AUDIO_RESERVATION = "1";
  };

  # ===========================================
  # Testing
  # TESTING AUDIO:
  # - Test PipeWire: pw-top
  # - Test JACK: jack_lsp (should work via PipeWire JACK emulation)
  # - Test ALSA: aplay -l
  # - Test volume: wpctl status
  # - Monitor latency: pw-top (watch "RATE/QUAN" column)
  #
  # TROUBLESHOOTING:
  # - Check PipeWire status: systemctl --user status pipewire wireplumber
  # - Check volume service: systemctl --user status set-volume
  # - View audio logs: journalctl --user -u pipewire -u wireplumber -u set-volume -f
  # - List audio devices: wpctl status
  # - Set volume manually: wpctl set-volume @DEFAULT_AUDIO_SINK@ 80%
  # =============================================
  
  # ============================================
  # DEFAULT VOLUME SERVICE
  # Set volume to 80% after WirePlumber starts
  systemd.user.services.set-volume = {
    description = "Set default audio output volume to 80%";
    
    # Start after WirePlumber is ready
    wantedBy = [ "default.target" ];
    after = [ "wireplumber.service" ];
    
    serviceConfig = {
      # SystemD services don't have PATH set, must specify absolute path
      ExecStart = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 80%";
      # Service behavior
      Type = "oneshot";              # Run once and exit
      RemainAfterExit = true;        # Consider successful after completion
      Restart = "on-failure";        # Retry if it fails
      RestartSec = "5s";             # Wait 5 seconds before retry
      # Logging to centralized journal
      StandardOutput = "journal";
      StandardError = "journal";
      SyslogIdentifier = "set-volume";  # Tag for filtering logs
    };
  };
  # Umgebungsvariablen LV2_PATH, VST_PATH und LADSPA_PATH werden global gesetzt
    system.activationScripts.audioPlugins = ''
    # Verzeichnisstruktur erstellen
    mkdir -p /home/project/AUDIO/plugins/{lv2,vst,ladspa}
    chown amxamxa:mxx -R /home/project/AUDIO/plugins

    # Symlinks für LV2-Plugins
    ln -sfn ${pkgs.lsp-plugins}/lib/lv2 /home/project/AUDIO/plugins/lv2/lsp-plugins
    ln -sfn ${pkgs.zam-plugins}/lib/lv2 /home/project/AUDIO/plugins/lv2/zam-plugins
    ln -sfn ${pkgs.dragonfly-reverb}/lib/lv2 /home/project/AUDIO/plugins/lv2/dragonfly-reverb
  '';

  environment.sessionVariables = {
    LV2_PATH = "/home/project/AUDIO/plugins/lv2";
    VST_PATH = "/home/project/AUDIO/plugins/vst";
    LADSPA_PATH = "/home/project/AUDIO/plugins/ladspa";
  };
  
# ==============================================
  # AUDIO PACKAGES
  # Professional audio tools and utilities
  environment.systemPackages = with pkgs; [
    # audio driver  	
    pipewire # Audio server:     pipewire und wireplumber sind kompatibel und arbeiten gut zusammen.
    wireplumber # Session manager for PipeWire
    alsa-firmware # Soundcard firmwares from the alsa project
    qmidinet # MIDI network gateway application that sends and receives MIDI data (ALSA Sequencer and/or JACK MIDI) over the network
    alsa-utils # ALSA, the Advanced Linux Sound Architecture utils'aconnect -l'
    alsa-scarlett-gui # GUI for alsa controls presented by Focusrite Scarlett Gen 2/3/4 Mixer Driver
    ffmpeg # Complete, cross-platform solution to record, convert and stream audio and video
    pwvucontrol # PipeWire volume control
   # pavucontrol # pulseaudio controls the volume (per-sink and per-app basis. entfernt, da es für PulseAudio ist und nicht mit PipeWire kompatibel 

    # JACK und Audio-Routing
    jack2 # JACK audio connection kit, version 2 with jackdbus
    #  jamin 		# JACK Audio Mastering interface
    # jack_rack # An effects "rack" for the JACK low latency audio API
    # jackmix # Matrix-Mixer for the Jack-Audio-connection-Kit
    meterbridge # Audio metering tools for JACK
    # ALT: jackmeter   # Simple level meter for JACK
    xtuner # Tuner for Jack Audio Connection Kit

    # FIREWIRE
    # ffado 		# FireWire audio drivers
    # ffado-mixer
    # jujuutils 	# Utilities around FireWire devices connected to a Linux computer
    # dvgrab 		# Receive and store audio & video over IEEE1394

    # PATCHFELD  
    helvum # GTK patchbay for PipeWire
    carla # komplexere Alternative zu Helvum
    #alt:  patchage # Modular patch bay for Jack and ALSA systems
    #alt:  qjackctl  # application to control the JACK sound server daemon

    # DAWs und Audio-Editoren
    vlc # Media player
    ardour # Multi-track hard disk recording software
    # reaper      # Professional digital audio workstation (DAW)
    # bitwig-studio4  # Digital audio workstation

    # MIDI- Drum-, Loop-Machines,  MIDI-Sequencing und virtuelle Instrumente
    # mamba # Virtual MIDI keyboard for Jack Audio Connection Kit
   # hydrogen # Advanced drum machine for beat production
    #  drumgizmo   # Drum sampler with high-quality samples
    zita-resampler # Resample library by Fons Adriaensen
    sooperlooper # Live looping tool for performances
    # oxefmsynth # Open source VST 2.4 instrument plugin
    # ninjas2    # sample slicer plugin
    # qtractor    # MIDI/Audio sequencer with recording/editing
    helm # Polyphonic synthesizer with a powerful interface
    #  zynaddsubfx # Advanced software synthesizer
    # muse       # MIDI/Audio sequencer with recording/editing
    # petrifoo   # MIDI controllable audio sampler
    #  bespokesynth-with-vst2 # sw modular synth with controllers
    # decent-sampler   # Audio sample player
    # zita-resampler   # Resample library by Fons Adriaensen	
    #  sooperlooper # Live looping tool for performances

    # EFFETCS 
    guitarix # Virtual guitar amplifier for Linux running with JACK
    calf # Collection of high-quality audio plugins (EQ, compressor, etc.)
    rakarrack # Guitar effects processor
     lsp-plugins # Collection of open-source audio plugins
    zam-plugins # Collection of LV2/LADS audio plugins by ZamAudio
    dragonfly-reverb # High-quality reverb effects
    # japa # 'perceptual' or 'psychoacoustic' audio spectrum analyser for JACK and ALSA
    # easyeffects # Audio effects for PipeWire, Entfernt, für PulseAudio entwickelt, nicht mit PipeWire kompatibel ist. 
    # jamesdsp # mit native PipeWire

    # SONSTIGES   
    cava # console-based Audio Visualizer for Alsa
    cavalier # visualize audio with CAVA
    playerctl # cmd utility and lib for media players that implement MPRIS

    xfce.xfburn # Disc burner and project creator for Xfce

    yt-dlp
    ytfzf
  ];

}

