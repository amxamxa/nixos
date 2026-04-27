# /etc/nixos/modules/audio.nix
/*    O~                    O~~
     O~ ~~                  O~~ O~
    O~  O~~    O~~  O~~     O~~      O~~
   O~~   O~~   O~~  O~~ O~~ O~~O~~ O~~  O~~
  O~~~~~~ O~~  O~~  O~~O~   O~~O~~O~~    O~~
 O~~       O~~ O~~  O~~O~   O~~O~~ O~~  O~~
O~~         O~~  O~~O~~ O~~ O~~O~~   O~~
# Audio system configuration for NixOS  */

# Components:
# - PipeWire audio server (replaces PulseAudio and JACK)
# - WirePlumber session manager
# - ALSA compatibility layer
# - Low-latency configuration for audio production
# - Bluetooth audio enhancements
# - Default volume setup
# wireplumber: Most configuration of devices is performed by the session manager. It typically loads ALSA and other devices and configures the profiles, port volumes and more. The session manager also configures new clients and links them to the targets, as configured in the session manager policy.
# PipeWire clients: Each native PipeWire client also loads a configuration file. Emulated JACK client also have separate configuration.

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ PHONIC HELIX BOARD 18 FIREWIRE MkII – RECORDING WORKFLOW               │
# │                                                                         │
# │ Daily use:  PipeWire handles all audio (BT, apps, system)               │
# │ Recording:  Switch to pure JACK2+FFADO mode (see JACK RECORDING MODE)   │
# │                                                                         │
# │ Signal path:                                                            │
# │   FireWire card → firewire_ohci → snd_bebob (ALSA)                     │
# │     → FFADO (Userspace) → JACK2 → Ardour                               │
# │                                                                         │
# │ snd_bebob: Native kernel ALSA driver – expliziter Eintrag in            │
# │   sound/firewire/bebob/bebob.c für Phonic Helix Board 18 FW MkII        │
# │                                                                         │
# │ Voraussetzung FireWire-Karte: Texas Instruments (TI) Chipsatz!          │
# │   VIA/Ricoh-Chips → bekannte FFADO-Probleme                            │
# │   Prüfen: lspci -k | grep -i firewire                                  │
# └─────────────────────────────────────────────────────────────────────────┘

# musnix – optional: RT-Kernel-Patches, udev-Regeln, Limits (empfohlen)
# Aktivierung:
#   sudo nix-channel --add https://github.com/musnix/musnix/archive/master.tar.gz musnix
#   sudo nix-channel --update
# Dann: imports = [ <musnix> ]; und musnix.enable = true;
# musnix.kernel.realtime = true; # echter RT-Kernel (längerer Build)

{ config, pkgs, lib, ... }:
{
imports = [ <musnix> ];
musnix.enable = true; # Modul wird dadurch in die NixOS-Konfiguration eingebunden
  # ============================================

  # ============================================
  # KERNEL CONFIGURATION
  # Optimize kernel for audio performance
  boot.kernelModules = [
    "snd-seq"        # ALSA sequencer
    "snd-rawmidi"    # Raw MIDI support
    "firewire_ohci"  # FireWire OHCI host controller (PCIe FireWire card) – must load first
    "firewire_core"  # FireWire core stack (IEEE 1394)
    # "firewire_sbp2"  # Serial Bus Protocol 2 – only for FireWire storage, NOT needed for audio
    "snd_bebob"      # Native ALSA driver for Phonic Helix Board 18 FW MkII
                     # Explicit entry in sound/firewire/bebob/bebob.c – loads after firewire_ohci
  ];

  # Blacklist the obsolete ieee1394 legacy stack – conflicts with firewire_ohci
  boot.blacklistedKernelModules = [
    "ohci1394"  # old OHCI controller (replaced by firewire_ohci)
    "ieee1394"  # old ieee1394 core     (replaced by firewire_core)
    "raw1394"   # old raw access layer  (replaced by firewire device nodes)
  ];

  boot.kernel.sysctl = {
    # Increase inotify limits for audio applications
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 512;

    # Reduce swappiness to minimize audio dropouts
    "vm.swappiness" = lib.mkForce 10;
  };
  # =========================================

  # =========================================
  # CPU PERFORMANCE GOVERNOR
  # Forces max clock speed – reduces latency jitter caused by frequency scaling
  powerManagement.cpuFreqGovernor = "performance";

  # =========================================
  # HARDWARE FIRMWARE
  hardware.firmware = [ pkgs.alsa-firmware ];

  # ========================================
  # AUDIO SERVICE CONFIGURATION

  # Disable PulseAudio – correct NixOS attribute path (not services.pulseaudio)
  hardware.pulseaudio.enable = false;

  # Disable jackd system service – PipeWire provides JACK emulation for daily use.
  # For dedicated recording sessions with the Helix Board, jackd is started manually
  # (see JACK RECORDING MODE below).
  services.jack.jackd.enable = false;

  # Enable RealtimeKit for real-time audio scheduling
  security.rtkit.enable = true;

  # ====================================
  # FIREWIRE udev RULES
  # Grant audio group access to FireWire bus and character devices
  services.udev.extraRules = ''
    # IEEE 1394 FireWire raw access for audio group (legacy subsystem path)
    SUBSYSTEM=="firewire", GROUP="audio", MODE="0664"
    SUBSYSTEM=="ieee1394", GROUP="audio", MODE="0664"

    # Direct fw-node access (fw0, fw1, ...) – required for FFADO/snd_bebob
    KERNEL=="fw[0-9]*", SUBSYSTEM=="firewire", GROUP="audio", MODE="0664"
  '';

  # ====================================
  # REALTIME PAM LIMITS
  # Required for JACK/FFADO real-time scheduling without xruns
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio";  type = "-"; value = "99"; }
    { domain = "@audio"; item = "nofile";  type = "-"; value = "99999"; }
    { domain = "@audio"; item = "nice";    type = "-"; value = "-20"; }
  ];

  # ====================================
  # PIPEWIRE CONFIGURATION
  # PipeWire is a modern audio server that replaces both PulseAudio and JACK.
  # Used for daily audio (system sounds, Bluetooth, apps).
  # For FireWire recording: stop PipeWire, start JACK with FFADO (see below).
  services.pipewire = {
    enable = true;

    # Enable ALSA support (Advanced Linux Sound Architecture)
    alsa.enable = true;
    alsa.support32Bit = true;  # For 32-bit applications

    # Enable JACK emulation (for professional audio applications under PipeWire)
    jack.enable = true;

    # Enable PulseAudio emulation (for legacy apps)
    pulse.enable = true;

    # Enable WirePlumber session manager
    wireplumber.enable = true;

    # Low-latency configuration for audio production
    # NOTE: FireWire (Helix Board 18) needs quantum >= 256 for stable operation.
    # 32 samples is too aggressive for IEEE 1394 bus latency overhead.
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;       # Sample rate: 48kHz (Helix Board 18 native)
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

  # ┌─────────────────────────────────────────────────────────────────────────┐
  # │ JACK RECORDING MODE – Phonic Helix Board 18 FW MkII                    │
  # │                                                                         │
  # │ Für Aufnahme-Sessions: PipeWire stoppen, JACK mit FFADO starten.        │
  # │                                                                         │
  # │ 1. PipeWire stoppen:                                                    │
  # │      systemctl --user stop pipewire pipewire.socket wireplumber         │
  # │                                                                         │
  # │ 2. Gerät prüfen:                                                        │
  # │      ffado-diag                                                         │
  # │      ffado-test-streaming                                               │
  # │      ffado-mixer   (Helix-eigener Mixer)                                │
  # │                                                                         │
  # │ 3. JACK mit FFADO-Backend starten:                                      │
  # │      jackd -d firewire -r 48000 -p 512 -n 3                            │
  # │        -r  Samplerate (48000 Hz = Helix Board 18 Standard)             │
  # │        -p  Puffergröße in Frames (512 = ~10ms, stabil zum Starten)     │
  # │        -n  Anzahl Puffer  (3 für FireWire empfohlen)                   │
  # │      Alternativ via qjackctl: Driver=firewire, Rate=48000, P=512, N=3  │
  # │                                                                         │
  # │ 4. Optional – ALSA-MIDI → JACK-MIDI-Bridge:                            │
  # │      a2jmidid -e &                                                      │
  # │                                                                         │
  # │ 5. Ardour starten:                                                      │
  # │      Audio/MIDI Setup → Audio System: JACK                              │
  # │      (JACK muss bereits laufen, bevor Ardour geöffnet wird)            │
  # │                                                                         │
  # │ 6. Nach der Session – PipeWire wieder starten:                          │
  # │      systemctl --user start pipewire pipewire.socket wireplumber        │
  # │                                                                         │
  # │ IRQ-Konflikt prüfen:                                                    │
  # │      cat /proc/interrupts | grep -i "1394\|firewire"                   │
  # │      FireWire-IRQ sollte nicht mit USB/GPU geteilt sein.               │
  # └─────────────────────────────────────────────────────────────────────────┘

  # ===========================================
  # TESTING & TROUBLESHOOTING
  # TESTING AUDIO:
  # - Test PipeWire:          pw-top
  # - Test ALSA devices:      aplay -l
  # - Test volume:            wpctl status
  # TESTING FIREWIRE (Helix Board 18):
  # - Check FW controller:    lspci -k | grep -i firewire  (TI-Chipsatz!)
  # - Kernel modules loaded:  lsmod | grep -E "firewire|bebob"
  # - dmesg beim Einstecken:  sudo dmesg -w | grep -E "firewire|bebob|1394"
  # - FFADO erkennt Gerät:    ffado-diag && ffado-test-streaming -t 5
  # - ALSA sieht Gerät:       aplay -l | grep -i bebob
  # - FW addresses:
  #     ffado-test Discover    # erkennt alle FireWire-Geräte am Bus
  #     ffado-test ListDevices # listet gefundene Audio-Devices
  # - Helix Mixer GUI:        ffado-mixer
  # TROUBLESHOOTING:
  # - PipeWire-Status:        systemctl --user status pipewire wireplumber
  # - Volume manuell:         wpctl set-volume @DEFAULT_AUDIO_SINK@ 80%
  # - Xruns (Aussetzer):      Quantum auf 512 oder 1024 erhöhen (-p 1024)
  # - JACK-Log:               qjackctl → Messages-Tab
  # Sind die PAM-Limits aktiv?
  # ulimit -r    # rtprio – erwartet: 99
  # ulimit -l    # memlock – erwartet: unlimited

  # =============================================
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
    # Create plugin directory structure
    mkdir -p /home/project/AUDIO/plugins/{lv2,vst,ladspa}
    chown amxamxa:mxx -R /home/project/AUDIO/plugins

    # Symlinks for LV2 plugins
    ln -sfn ${pkgs.lsp-plugins}/lib/lv2 /home/project/AUDIO/plugins/lv2/
    ln -sfn ${pkgs.zam-plugins}/lib/lv2 /home/project/AUDIO/plugins/lv2/
    ln -sfn ${pkgs.dragonfly-reverb}/lib/lv2 /home/project/AUDIO/plugins/lv2/
  '';

  environment.sessionVariables = {
    LV2_PATH = "/home/project/AUDIO/plugins/lv2";
    VST_PATH = "/home/project/AUDIO/plugins/vst";
    LADSPA_PATH = "/home/project/AUDIO/plugins/ladspa";
  };

  systemd.tmpfiles.rules = [
    # Create base Hydrogen data directory with correct permissions
    # Type  Path                                        Mode User Group Age Argument
    "d /home/project/AUDIO/drums/hydrogen              0755  *  users  -    -"
    "d /home/project/AUDIO/drums/hydrogen/data         0755  *  users  -    -"
    "d /home/project/AUDIO/drums/hydrogen/presets      0755  *  users  -    -"
    "d /home/project/AUDIO/drums/hydrogen/patterns     0755  *  users  -    -"
    "d /home/project/AUDIO/drums/hydrogen/drumkits     0755  *  users  -    -"
    "d /home/project/AUDIO/drums/hydrogen/songs        0755  *  users  -    -"
    "d /home/project/AUDIO/drums/hydrogen/soundlibrary 0755  *  users  -    -"
    "d /home/project/AUDIO/drums/hydrogen/demos        0755  *  users  -    -"
    "d /home/project/AUDIO/drums/hydrogen/doc          0755  *  users  -    -"
  ];

  # ==============================================
  # AUDIO PACKAGES
  # Professional audio tools and utilities
  environment.systemPackages = with pkgs; [
    # Audio server / driver layer
    pipewire        # Audio server: pipewire und wireplumber arbeiten kompatibel zusammen
    wireplumber     # Session manager for PipeWire
    alsa-firmware   # Soundcard firmwares from the alsa project
    alsa-utils      # ALSA utils: aplay, arecord, amixer, aconnect -l
    ffmpeg          # Complete, cross-platform solution to record, convert and stream audio and video
    pwvucontrol     # PipeWire volume control

    # JACK and audio routing
    jack2           # JACK2 audio connection kit with jackdbus (includes FFADO FireWire backend)
    meterbridge     # Audio metering tools for JACK
    xtuner          # Tuner for Jack Audio Connection Kit

    # FireWire (Phonic Helix Board 18 FW MkII)
    ffado           # Free FireWire Audio Drivers (libffado) – Userspace for snd_bebob
    ffado-mixer     # Helix Board hardware mixer GUI
    jujuutils       # Utilities around FireWire devices on Linux
    dvgrab          # Receive and store audio & video over IEEE1394

    # Patchbay / routing
    helvum          # GTK patchbay for PipeWire
    carla           # Advanced plugin host and patchbay (LV2, VST, JACK)
    qjackctl        # JACK GUI control + connection manager + log
    liblo           # OSC protocol library (Open Sound Control)
    a2jmidid        # ALSA MIDI → JACK MIDI bridge (needed during JACK recording mode)

    # DAWs and audio editors
    vlc             # Media player
    ardour          # Multi-track hard disk recording software (JACK-native)

    # MIDI, drum, loop machines and virtual instruments
    qmidinet        # MIDI network gateway (ALSA Sequencer / JACK MIDI over network)
    drumgizmo       # Drum sampler with high-quality samples
 #   zita-resampler  # Resample library by Fons Adriaensen
    sooperlooper    # Live looping tool for performances
 #   oxefmsynth      # Open source VST 2.4 instrument plugin
    ninjas2         # Sample slicer plugin
    qtractor        # MIDI/Audio sequencer with recording/editing
 #   helm            # Polyphonic synthesizer with a powerful interface
    zynaddsubfx     # Advanced software synthesizer
#    bespokesynth-with-vst2 # Modular software synth with controllers
    hydrogen        # Advanced drum machine for beat production
    # Wrapper script that overrides the hydrogen binary
    (pkgs.writeShellScriptBin "hydrogen" ''
      # Launch Hydrogen with alternate system data path
      exec ${pkgs.hydrogen}/bin/hydrogen --data "/home/project/AUDIO/drums/hydrogen" "$@"
    '')

    # Effects / plugins
    guitarix        # Virtual guitar amplifier for Linux (JACK)
    calf            # High-quality audio plugins (EQ, compressor, reverb, etc.)
    rakarrack       # Guitar effects processor
    lsp-plugins     # Collection of open-source LV2 audio plugins
    zam-plugins     # LV2/LADSPA audio plugins by ZamAudio
    dragonfly-reverb # High-quality reverb effects (LV2)

    # Miscellaneous
    alsa-scarlett-gui  # GUI for Focusrite Scarlett Gen 2/3/4 Mixer Driver
    sonic-pi           # Free live coding synth for everyone
    cava               # Console-based Audio Visualizer for ALSA
    cavalier           # Visualize audio with CAVA
    playerctl          # CLI utility for MPRIS media players
    xfce.xfburn        # Disc burner for Xfce
    yt-dlp
    ytfzf
  ];
}





