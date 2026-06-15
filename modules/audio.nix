# /etc/nixos/modules/audio.nix
/*    O~                    O~~
     O~ ~~                  O~~ O~
    O~  O~~    O~~  O~~     O~~      O~~
   O~~   O~~   O~~  O~~ O~~ O~~O~~ O~~  O~~
  O~~~~~~ O~~  O~~  O~~O~   O~~O~~O~~    O~~
 O~~       O~~ O~~  O~~O~   O~~O~~ O~~  O~~
O~~         O~~  O~~O~~ O~~ O~~O~~   O~~
# Audio system configuration for NixOS - OPTIMIZED FOR LIVE MULTITRACK RECORDING
# Phonic Helix Board 18 FireWire MkII + Ardour + JACK2 + FFADO
# Configured for: 18-channel recording, low-latency monitoring, real-time performance */

# ========================================================================================
# GENERAL NOTES:
# - This configuration is optimized for LIVE MULTITRACK RECORDING with Phonic Helix Board 18.
# - Uses JACK2 + FFADO for recording sessions (PipeWire disabled to avoid conflicts).
# - RT-Kernel (musnix) for real-time performance.
# - All FireWire modules (snd_bebob) and JACK2 settings tuned for 18 channels at 48kHz.
# - PAM limits set for real-time audio (memlock, rtprio, nice).
# - udev rules for FireWire access by audio group.
# - For daily use (non-recording): Enable PipeWire and disable JACK2 manually.
# ========================================================================================

# ┌──────────────────────────────────────────────────────────────────────────────────┐
# │ PHONIC HELIX BOARD 18 FIREWIRE MkII – LIVE RECORDING WORKFLOW                     │
# │                                                                                  │
# │ 1. Daily Use:      PipeWire disabled (use only for non-recording tasks)           │
# │ 2. Recording:      JACK2 + FFADO + Ardour (see JACK RECORDING MODE below)          │
# │                                                                                  │
# │ Signal Path (Recording Mode):                                                  │
# │   Helix Board 18 → FireWire (TI chipset) → snd_bebob (ALSA) → FFADO → JACK2 → Ardour │
# │                                                                                  │
# │ Requirements:                                                                      │
# │   - FireWire card with TI chipset (e.g., Delock 89397, SONNET Allegro FW800)     │
# │   - Check TI chipset: lspci -k | grep -i firewire                                 │
# │   - Avoid VIA/Ricoh chipsets (known FFADO issues)                              │
# └──────────────────────────────────────────────────────────────────────────────────┘

# ========================================================================================
# MUSNIX: Real-Time Kernel & Audio Optimizations
# ========================================================================================
# To enable musnix, run before using this config:
#   sudo nix-channel --add https://github.com/musnix/musnix/archive/master.tar.gz musnix
#   sudo nix-channel --update
# ========================================================================================

{ config, pkgs, lib, ... }:

{
  # ============================================
  # MUSNIX: REAL-TIME KERNEL & AUDIO OPTIMIZATIONS
  # ============================================
  imports = [
    # Add musnix channel first (see instructions above)
    <musnix>
  ];

  musnix.enable = true;
  # musnix.kernel.realtime = true;  # Real-time kernel for low-latency audio
  musnix.das_watchdog.enable = true;  # Watchdog for real-time processes

  # ============================================
  # KERNEL CONFIGURATION
  # Optimized for audio performance and FireWire
  # ============================================
  /*
  boot.kernelModules = [
    "snd-seq"        # ALSA sequencer (MIDI support)
    "snd-rawmidi"    # Raw MIDI support
    "firewire_ohci"  # FireWire OHCI host controller (MUST LOAD FIRST)
    "firewire_core"  # FireWire core stack (IEEE 1394)
    "snd_bebob"      # Native ALSA driver for Phonic Helix Board 18 FW MkII
                         # Explicit entry in sound/firewire/bebob/bebob.c
  ];

  # Blacklist obsolete ieee1394 stack (conflicts with firewire_ohci)
  boot.blacklistedKernelModules = [
    "ohci1394"  # Old OHCI controller (replaced by firewire_ohci)
    "ieee1394"  # Old ieee1394 core (replaced by firewire_core)
    "raw1394"   # Old raw access layer (replaced by firewire device nodes)
  ];

  # Kernel sysctl optimizations for audio
  boot.kernel.sysctl = {
    # Increase inotify limits for audio applications (Ardour plugins)
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 512;

    # Reduce swappiness to minimize audio dropouts
    "vm.swappiness" = lib.mkForce 10;

    # FireWire stack optimizations
    "kernel.sched_rt_runtime_us" = lib.mkForce 950000;  # 95% RT time for audio processes
  };
*/
  # ============================================
  # CPU PERFORMANCE
  # Force max clock speed to reduce latency jitter
  # ============================================
  powerManagement.cpuFreqGovernor = "performance";

  # ============================================
  # HARDWARE FIRMWARE
  # ============================================
  hardware.firmware = [ pkgs.alsa-firmware ];

  # ============================================
  # AUDIO SERVICE CONFIGURATION
  # ============================================

  # Disable PulseAudio (replaced by PipeWire/JACK2)
  hardware.pulseaudio.enable = false;

  # Disable PipeWire for recording sessions (avoid conflicts with JACK2)
  # Enable manually for daily use: systemctl --user start pipewire wireplumber
  services.pipewire.enable = true;
  services.pipewire.wireplumber.enable = true;

  # Disable system-wide JACK2 service (start manually for recording)
  services.jack.jackd.enable = false;

  # Enable RealtimeKit for real-time audio scheduling
  security.rtkit.enable = true;

  # ============================================
  # FIREWIRE udev RULES
  # Grant audio group access to FireWire devices
  # ============================================
  /*
  services.udev.extraRules = ''
    # FireWire access for audio group (TI chipset cards)
    SUBSYSTEM=="firewire", GROUP="audio", MODE="0664"
    KERNEL=="fw[0-9]*", GROUP="audio", MODE="0664"
  '';

  # ============================================
  # REALTIME PAM LIMITS
  # Required for JACK2/FFADO real-time scheduling (no xruns)
  # ============================================
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }  # Unlimited memory locking
    { domain = "@audio"; item = "rtprio";  type = "-"; value = "99"; }        # Max real-time priority
    { domain = "@audio"; item = "nofile";  type = "-"; value = "99999"; }     # Max open files
    { domain = "@audio"; item = "nice";    type = "-"; value = "-20"; }       # Highest scheduling priority
  ];

  # ============================================
  # JACK2 CONFIGURATION (for Live Recording)
  # Note: JACK2 is started manually for recording sessions.
  # Recommended command:
  #   jackd -d firewire -r 48000 -p 1024 -n 3 -P 256
  # ============================================
  
  environment.variables = {
    # Default JACK2 settings for Helix Board 18 (18 channels @ 48kHz)
    JACK_DEFAULT_SERVER = "firewire";
    JACK_DEFAULT_SAMPLERATE = "48000";
    JACK_DEFAULT_PERIOD = "1024";  # 1024 frames (~21ms latency @ 48kHz)
    JACK_DEFAULT_NPERIODS = "3";     # 3 periods
    JACK_DEFAULT_PLAYBACK_PERIOD = "256";  # Smaller playback buffer
    JACK_NO_AUDIO_RESERVATION = "1"; # Allow multiple JACK clients
  };

  # ============================================
  # USER AND GROUP CONFIGURATION
  # Add users to audio and jackaudio groups for real-time access
  # ============================================
  users.groups.jackaudio = {};

  users.users.amxamxa = {
    extraGroups = [ "audio" "jackaudio" ];  # Required for FFADO/JACK2/RT scheduling
  };

  users.users.l33 = {
    extraGroups = [ "audio" "jackaudio" ];  # Required for FFADO/JACK2/RT scheduling
  };
*/
  # ============================================
  # AUDIO PLUGINS & DIRECTORIES
  # Setup for LV2/VST/LADSPA plugins and Hydrogen data
  # ============================================
  system.activationScripts.audioPlugins = ''
    # Create plugin and hydrogen directories
    mkdir -p /home/project/AUDIO/plugins/{lv2,vst,ladspa}
    mkdir -p /home/project/AUDIO/drums/hydrogen/{data,presets,patterns,drumkits,songs,soundlibrary,demos,doc}

    # Set correct ownership
    chown -R amxamxa:mxx /home/project/AUDIO/plugins /home/project/AUDIO/drums

    # Symlinks for LV2 plugins
    ln -sfn ${pkgs.lsp-plugins}/lib/lv2 /home/project/AUDIO/plugins/lv2/lsp-plugins
    ln -sfn ${pkgs.zam-plugins}/lib/lv2 /home/project/AUDIO/plugins/lv2/zam-plugins
    ln -sfn ${pkgs.dragonfly-reverb}/lib/lv2 /home/project/AUDIO/plugins/lv2/dragonfly-reverb
  '';

  environment.sessionVariables = {
    LV2_PATH = "/home/project/AUDIO/plugins/lv2";
    VST_PATH = "/home/project/AUDIO/plugins/vst";
    LADSPA_PATH = "/home/project/AUDIO/plugins/ladspa";
  };

  systemd.tmpfiles.rules = [
    # Hydrogen data directories
    "d /home/project/AUDIO/drums/hydrogen              0755  amxamxa  mxx  -  -"
    "d /home/project/AUDIO/drums/hydrogen/data         0755  amxamxa  mxx  -  -"
    "d /home/project/AUDIO/drums/hydrogen/presets      0755  amxamxa  mxx  -  -"
    "d /home/project/AUDIO/drums/hydrogen/patterns     0755  amxamxa  mxx  -  -"
    "d /home/project/AUDIO/drums/hydrogen/drumkits     0755  amxamxa  mxx  -  -"
    "d /home/project/AUDIO/drums/hydrogen/songs        0755  amxamxa  mxx  -  -"
    "d /home/project/AUDIO/drums/hydrogen/soundlibrary 0755  amxamxa  mxx  -  -"
    "d /home/project/AUDIO/drums/hydrogen/demos        0755  amxamxa  mxx  -  -"
    "d /home/project/AUDIO/drums/hydrogen/doc          0755  amxamxa  mxx  -  -"
  ];

  # ============================================
  # AUDIO PACKAGES
  # Professional audio tools for live recording and production
  # ============================================
  environment.systemPackages = with pkgs; [
  
    # --- Core Audio System ---
    alsa-firmware   # ALSA firmware for sound cards
    alsa-utils      # ALSA utilities (aplay, arecord, amixer, aconnect)
    ffmpeg          # Audio/video conversion and streaming

    # --- JACK2 & FireWire ---
    jack2           # JACK2 with FFADO FireWire backend
    libjack2        # JACK2 libraries
    ffado           # Free FireWire Audio Drivers (libffado) - Userspace for snd_bebob
    ffado-mixer     # GUI for Helix Board hardware mixer
    jujuutils       # FireWire device utilities
    dvgrab          # Receive/store audio & video over IEEE1394

    # --- Patchbay & Routing ---
 crosspipe
 
    carla           # Advanced plugin host and patchbay (LV2, VST, JACK)
    qjackctl        # JACK GUI control + connection manager + log
    liblo           # OSC protocol library
    a2jmidid        # ALSA MIDI → JACK MIDI bridge (for MIDI instruments)

    # --- DAWs ---
    vlc             # Media player (for playback)
    ardour          # Multi-track hard disk recording (JACK-native)

    # --- MIDI & Virtual Instruments ---
    qmidinet        # MIDI network gateway (ALSA Sequencer / JACK MIDI over network)
    drumgizmo       # Drum sampler with high-quality samples
    sooperlooper    # Live looping tool
    ninjas2         # Sample slicer plugin
    qtractor        # MIDI/Audio sequencer
    zynaddsubfx     # Advanced software synthesizer
    hydrogen        # Advanced drum machine
  # Custom Hydrogen wrapper script with alternate data path
     (writeShellScriptBin "hydrogen" ''
      # Launch Hydrogen with custom data path
      exec ${pkgs.hydrogen}/bin/hydrogen --data "/home/project/AUDIO/drums/hydrogen" "$@"
    '')
    # --- Effects & Plugins ---
    guitarix        # Virtual guitar amplifier (JACK)
    calf            # High-quality audio plugins (EQ, compressor, reverb, etc.)
    rakarrack       # Guitar effects processor
    lsp-plugins     # Collection of open-source LV2 audio plugins
    zam-plugins     # LV2/LADSPA audio plugins by ZamAudio
    dragonfly-reverb # High-quality reverb effects (LV2)

    # --- Monitoring & Utilities ---
    pwvucontrol      # PipeWire volume control (for daily use)
    cava             # Console-based Audio Visualizer for ALSA
    cavalier         # Visualize audio with CAVA
    playerctl        # CLI utility for MPRIS media players

    # --- Miscellaneous ---
    alsa-scarlett-gui  # GUI for Focusrite Scarlett mixer (if needed)
    sonic-pi           # Live coding synth
    xfce.xfburn        # Disc burner
    yt-dlp
    ytfzf
    whipper
  ];

  # ========================================================================================
  # JACK RECORDING MODE – Phonic Helix Board 18 FW MkII
  # For recording sessions: Stop PipeWire, start JACK2 with FFADO.
  # ========================================================================================
  # 1. Stop PipeWire (if running):
  #      systemctl --user stop pipewire pipewire.socket wireplumber
  #
  # 2. Verify FireWire device:
  #      ffado-diag
  #      ffado-test-streaming
  #      ffado-mixer    # Helix Board hardware mixer GUI
  #
  # 3. Start JACK2 with FFADO backend (18 channels @ 48kHz):
  #      jackd -d firewire -r 48000 -p 1024 -n 3 -P 256
  #        -d firewire  : FFADO backend for FireWire devices
  #        -r 48000     : Sample rate (Helix Board 18 native)
  #        -p 1024      : Buffer size in frames (~21ms latency @ 48kHz)
  #        -n 3         : Number of buffers (3 recommended for FireWire)
  #        -P 256       : Playback buffer size (can be smaller than capture)
  #
  #    Alternative via qjackctl:
  #      Driver: firewire
  #      Rate: 48000
  #      Period/Buffer: 1024
  #      Periods/Buffer: 3
  #      Playback Periods/Buffer: 256
  #
  # 4. (Optional) ALSA MIDI → JACK MIDI Bridge:
  #      a2jmidid -e &
  #
  # 5. Start Ardour:
  #      Audio/MIDI Setup → Audio System: JACK
  #      (JACK must be running before Ardour is opened)
  #
  # 6. After recording session – Restart PipeWire (for daily use):
  #      systemctl --user start pipewire pipewire.socket wireplumber
  #
  # 7. Check IRQ conflicts:
  #      cat /proc/interrupts | grep -i "1394\|firewire"
  #      FireWire IRQ should NOT be shared with USB/GPU!
  # ========================================================================================

  # ========================================================================================
  # TESTING & TROUBLESHOOTING
  # ========================================================================================
  # TESTING AUDIO:
  # - Test JACK2:          jack_control status
  # - Test ALSA devices:   aplay -l
  # - Test FireWire:       ffado-diag && ffado-test-streaming -t 5
  #
  # TESTING FIREWIRE (Helix Board 18):
  # - Check FW controller: lspci -k | grep -i firewire  (TI chipset required!)
  # - Kernel modules:      lsmod | grep -E "firewire|bebob"
  # - Kernel messages:     sudo dmesg -w | grep -E "firewire|bebob|1394"
  # - FFADO device list:   ffado-test Discover
  # - ALSA devices:        aplay -l | grep -i bebob
  #
  # TROUBLESHOOTING:
  # - JACK status:          jack_control status
  # - Xruns (dropouts):     Increase -p in JACK2 (e.g., -p 2048)
  # - No sound in Ardour:   Check JACK routing (qjackctl)
  # - PAM limits:           ulimit -r (should be 99), ulimit -l (should be unlimited)
  # - IRQ conflicts:        cat /proc/interrupts | grep -i firewire
  #
  # For live recordings:
  # - Use -p 1024 for 18 channels (stable)
  # - Avoid -p < 512 for FireWire (causes xruns)
  # - Use RT kernel (musnix.kernel.realtime = true)
  # ========================================================================================

  # ============================================
  # DEFAULT VOLUME SERVICE (for daily use with PipeWire)
  # Disabled by default for recording sessions.
  # Enable manually if needed:
  #   systemctl --user enable --now set-volume
  # ============================================
  systemd.user.services.set-volume = {
    description = "Set default audio output volume to 80%";
    wantedBy = [ "default.target" ];
    after = [ "wireplumber.service" ];
    enable = false;  # Disabled for recording sessions

    serviceConfig = {
      ExecStart = "${pkgs.pipewire}/bin/wpctl set-volume @DEFAULT_SINK@ 80%";
      Type = "oneshot";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = "5s";
      StandardOutput = "journal";
      StandardError = "journal";
      SyslogIdentifier = "set-volume";
    };
  };
}


# Components:
# - PipeWire audio server (replaces PulseAudio and JACK)
# - WirePlumber session manager
# - ALSA compatibility layer
# - Low-latency configuration for audio production
# - Bluetooth audio enhancements
# - Default volume setup
# wireplumber: Most configuration of devices is performed by the session manager. It typically loads ALSA and other devices and configures the profiles, port volumes and more. The session manager also configures new clients and linksthem to the targets, as configured in the session manager policy.
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


