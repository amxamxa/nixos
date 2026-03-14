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
/* Kernel ≥ 6.5 – firewire_ohci ist im Mainline-Kernel enthalten, kein DKMS nötig ✓
  FIREPOD Samplerate – Das Gerät unterstützt 44.1 kHz und 48 kHz. Bei 96 kHz ist die Kanalanzahl reduziert.
  Kein Pulseaudio – hardware.pulseaudio.enable = false ist zwingend, sonst Konflikt mit PipeWire. */

{ config, pkgs, ... }:
{
  # ============================================
  # USER GROUPS
  # Add audio-related groups for the primary user
  users.users.amxamxa.extraGroups = [ "jackaudio" "audio" ];
  users.users.l33.extraGroups = [ "jackaudio" "audio" ];
  users.users.gast.extraGroups = [ "jackaudio" "audio" ];

  # ============================================
  # KERNEL CONFIGURATION
  # Optimize kernel for audio performance
   boot.kernelModules = [
    "snd-seq"        # ALSA sequencer
    "snd-rawmidi"    # Raw MIDI support
    "firewire_ohci"  # FireWire OHCI host controller (PCIe FireWire card)
    "firewire_core"  # FireWire core stack (IEEE 1394)
    "firewire_sbp2"  # Serial Bus Protocol 2 (required for some FW devices)
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

  # Disable PulseAudio (PipeWire replaces it):
  hardware.pulseaudio.enable = false;

  # Enable RealtimeKit for real-time audio scheduling
  # This allows audio processes to get real-time priority on demand
  security.rtkit.enable = true;

  # ====================================
  # FIREWIRE udev RULES
  # Grant audio group access to IEEE 1394 bus devices (FIREPOD)
  services.udev.extraRules = ''
    # Allow audio group read/write access to FireWire character devices
    SUBSYSTEM=="firewire", GROUP="audio", MODE="0664"
    SUBSYSTEM=="ieee1394", GROUP="audio", MODE="0664"
  '';

  # ====================================
  # REALTIME PAM LIMITS
  # Required for JACK/FFADO real-time scheduling without xruns
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio";  type = "-"; value = "99"; }
    { domain = "@audio"; item = "nofile";  type = "-"; value = "99999"; }
  ];

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

    # Enable PulseAudio emulation (for legacy apps)
    pulse.enable = true;

    # Enable WirePlumber session manager
    # WirePlumber is the modern replacement for pipewire-media-session
    wireplumber.enable = true;

    # Low-latency configuration for audio production
    # NOTE: FireWire (FIREPOD) needs quantum >= 256 for stable operation
    # 32 samples is too aggressive for IEEE 1394 bus latency overhead
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;       # Sample rate: 48kHz (FIREPOD native)
        "default.clock.quantum" = 256;      # Buffer: 256 samples (FireWire-stable)
        "default.clock.min-quantum" = 256;  # Minimum buffer
        "default.clock.max-quantum" = 1024; # Maximum buffer (headroom for load spikes)
        # Note: 256 samples @ 48kHz = 5.3ms latency (safe for FireWire bus)
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
    # Set default latency for PipeWire clients (matches quantum above)
    PIPEWIRE_LATENCY = "256/48000";  # 256 samples at 48kHz (~5.3ms, FireWire-stable)
    # Disable JACK audio reservation to allow multiple clients
    JACK_NO_AUDIO_RESERVATION = "1";
  };

  # --- JACK daemon with FFADO (FireWire) backend ---
  services.jack.jackd = {
    extraOptions = [
      "-d" "firewire"          # use FFADO FireWire backend
      "-r" "48000"             # sample rate (FirePOD supports 44100 / 48000)
      "-p" "256"               # buffer size (frames per period)
      "-n" "2"                 # number of periods
    ];
  };

  # ===========================================
  # Testing
  # TESTING AUDIO:
  # - Test PipeWire: pw-top
  # - Test ALSA: aplay -l
  # - Test volume: wpctl status
  # TESTING FIREWIRE (FIREPOD):
  # - Check FireWire controller: lspci -k | grep -i firewire
  # - Check kernel modules: lsmod | grep firewire
  # - Diagnose FIREPOD: ffado-diag
  # - Test FW addresses: ffado-test-fw-addresses
  # - Start JACK with FIREPOD: jackd -d firewire -r 48000 -p 256
  # TROUBLESHOOTING:
  # - Check PipeWire status: systemctl --user status pipewire wireplumber
  # - Set volume manually: wpctl set-volume @DEFAULT_AUDIO_SINK@ 80%
  # - FIREPOD xruns → increase quantum (512 or 1024)
# JACK mit FFADO starten: FIREPOD als JACK-Backend starten
# jackd -d firewire -r 48000 -p 256
# qjackctl GUI: Driver → firewire
# PipeWire-JACK-Bridge testen:
# pw-jack jackd -d firewire

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
    ln -sfn ${pkgs.lsp-plugins}/lib/lv2 /home/project/AUDIO/plugins/lv2/
    ln -sfn ${pkgs.zam-plugins}/lib/lv2 /home/project/AUDIO/plugins/lv2/
    ln -sfn ${pkgs.dragonfly-reverb}/lib/lv2 /home/project/AUDIO/plugins/lv2/
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
    # jamin 		# JACK Audio Mastering interface
    # jack_rack # An effects "rack" for the JACK low latency audio API
    # jackmix # Matrix-Mixer for the Jack-Audio-connection-Kit
    meterbridge # Audio metering tools for JACK
    # ALT: jackmeter   # Simple level meter for JACK
    xtuner # Tuner for Jack Audio Connection Kit

    # FIREWIRE
     ffado 		# FireWire audio drivers
     ffado-mixer
     jujuutils 	# Utilities around FireWire devices connected to a Linux computer
     dvgrab 		# Receive and store audio & video over IEEE1394

    # PATCHFELD
    helvum # GTK patchbay for PipeWire
    carla # komplexere Alternative zu Helvum
    #alt:  patchage # Modular patch bay for Jack and ALSA systems
    qjackctl  # application to control the JACK sound server daemon

    # DAWs und Audio-Editoren
    vlc # Media player
    ardour # Multi-track hard disk recording software
    # reaper      # Professional digital audio workstation (DAW)
    # bitwig-studio4  # Digital audio workstation

    # MIDI- Drum-, Loop-Machines,  MIDI-Sequencing und virtuelle Instrumente
    # mamba # Virtual MIDI keyboard for Jack Audio Connection Kit
    hydrogen # Advanced drum machine for beat production
    drumgizmo   # Drum sampler with high-quality samples
    zita-resampler # Resample library by Fons Adriaensen
    sooperlooper # Live looping tool for performances
    oxefmsynth # Open source VST 2.4 instrument plugin
    ninjas2    # sample slicer plugin
    qtractor    # MIDI/Audio sequencer with recording/editing
    helm # Polyphonic synthesizer with a powerful interface
    zynaddsubfx # Advanced software synthesizer
    # muse       # MIDI/Audio sequencer with recording/editing
    # petrifoo   # MIDI controllable audio sampler
    bespokesynth-with-vst2 # sw modular synth with controllers
#    decent-sampler   # Audio sample player
    zita-resampler   # Resample library by Fons Adriaensen
    sooperlooper # Live looping tool for performances

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

