# audio.nix
# TSHOOT:
# aplay -l
# pw-info
#pactl list clients short
#cards             --  list available cards
#clients           --  list connected clients
#message-handlers  --  list available message-handlers
#modules           --  list loaded modules
#samples           --  list samples
#sink-inputs       --  list connected sink inputs
#sinks             --  list available sinks
{ config, lib, pkgs, ... }:
{
# die verfügbaren Governors: powersave / performance. performance pinnt die CPU bei 3600 MHz und eliminiert Frequency-Jitter.
# powerManagement.cpuFreqGovernor = lib.mkForce "performance";

 # --------------------------------------------------
 # User groups
 #    "audio"    → direct ALSA device access
 #    "rtkit" → required by RTKit for real-time thread promotion
 # ----------------------------------------------------
 users.users.amxamxa.extraGroups = [ "audio" "rtkit" ];
  #  "pipewire" als Gruppe ist auf NixOS nicht notwendig – der Socket-Zugriff wird über rtkit und die PAM-Limits geregelt. Nur "audio" und "rtkit" sind erforderlich.


# Grant real-time audio permissions via PAM limits for @audio group
security.pam.loginLimits = [
  { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
  { domain = "@audio"; item = "rtprio";  type = "-"; value = "99"; }
  { domain = "@audio"; item = "nice";    type = "-"; value = "-20"; }
  { domain = "@audio"; item = "nofile";  type = "-"; value = "99999"; }
];
#=============================================================
# Audio module – Focusrite Scarlett Solo + PipeWire / WirePlumber
#   Scarlett Solo Gen 4  – USB ID 1235:8211 =====================

  # -------------------------------------------------------
  # Disable PulseAudio – it conflicts with PipeWire's pulse emulation layer
   services.pulseaudio.enable = false;
  # -------------------------------------------------------
  # RTKit – grants real-time scheduling priority to audio threads
  #    Required for reliable low-latency operation without xruns
  security.rtkit.enable = true;
  # ------------------------------------------------
  # Kernel module options for snd-usb-audio
  #    device_setup=1  → enables "pro audio" / native 24-bit mode on Gen 3/4
  #    vid/pid pair    → scopes the option to the Scarlett Solo only
    # Gn 4 → 0x8211
    # |__ Port 1: Dev 2, If 0, Class=hub, Driver=hub/0p, 480M        ID 1235:8211
  # ------------------------------------------------
  boot.extraModprobeConfig = ''
    # Focusrite Scarlett Solo Gen 4 – enable pro-audio mode
    options snd_usb_audio vid=0x1235 pid=0x8211 device_setup=1
  '';
  # ----------------------------------------------------------------
  # 4. udev rules – ensure the device is accessible without root privileges
  #    Add additional ATTR lines if multiple generations are used
  # ----------------------------------------------------------
  services.udev.extraRules = ''
    # Focusrite Scarlett Solo Gen 4
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1235", ATTRS{idProduct}=="8211", \
      MODE="0664", GROUP="audio", TAG+="uaccess"
  '';
  # ------------------------------------------------------
  # PipeWire – main audio server
  # -------------------------------------------------------
  services.pipewire = {
    enable = true;
    # Compatibility layers – keep all three enabled for maximum app support
    alsa.enable        = true;
    alsa.support32Bit  = true;   # required for 32-bit DAWs / Wine
    pulse.enable       = true;   # emulates PulseAudio API
    jack.enable        = true;   # emulates JACK API for pro-audio apps
    # -------------------------------------------------------
    # PipeWire daemon tuning
    #   clock.rate      → sample rate; Scarlett Solo natively runs at 48 kHz
    #   clock.quantum   → default buffer in frames (64 = ~1.3 ms @ 48 kHz)
    #   min-quantum     →  lower = more latency headroom risk
    #   max-quantum     → upper bound for non-real-time clients
    # -----------------------------------------------------------------
    extraConfig.pipewire."92-scarlett-lowlatency" = {
      "context.properties" = {
        "default.clock.rate"        = 48000;
        "default.clock.quantum"     = 64;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 512;
        # Limits the allowed sample rates to what the hardware supports
        "default.clock.allowed-rates" = [ 44100 48000 ];
      };
    };
    # ------------------------------------------
    # ALSA monitor extra config
    #     Disables the default "dummy" sink that appears in some setups
    # -------------------------------------------
    extraConfig.pipewire."10-no-bell" = {
      "context.properties"."module.x11.bell" = false;
    };

    # -------------------------------------------------
    # WirePlumber – session / policy manager
    #    "monitor.alsa.rules" matches nodes by their ALSA device name pattern and applies hardware-specific properties.
    #    node.name pattern:
    #      Input  → alsa_input.usb-Focusrite_Scarlett_Solo_<serial>-00.*
    #      Output → alsa_output.usb-Focusrite_Scarlett_Solo_<serial>-00.*
    #
    #  Key properties:
    # audio.rate          → forces 48 kHz on the node level
    # api.alsa.period-size → frames per period; matches clock.quantum
    # api.alsa.headroom   → extra frames added as safety buffer (0 = minimal)
    #  api.alsa.disable-batch → avoids ALSA batched transfers (reduces latency)
    # node.latency        → explicit latency hint: <frames>/<rate>
    # session.suspend-timeout-seconds → 0 = never auto-suspend the device
   # --------------------------------------------------
    wireplumber.enable = true;

    wireplumber.extraConfig."51-scarlett-solo" = {
      "monitor.alsa.rules" = [
        # -- Input node (microphone + instrument input)
        {
  matches = [
            # Match by device name prefix (more robust than node.name)
            { "device.name" = "~alsa_card.usb-Focusrite_Scarlett_Solo.*"; }
            { "node.name" = "~alsa_input.*"; }
          ];
                  actions.update-props = {
            "node.nick"                        = "Scarlett Solo – Input";
            "node.description"                 = "Focusrite Scarlett Solo (Input)";
            "audio.rate"                       = 48000;
            "api.alsa.period-size"             = 64;
            "api.alsa.headroom"                = 4;
            "api.alsa.disable-batch"           = true;
            "node.latency"                     = "64/48000";
            "session.suspend-timeout-seconds"  = 0;
            "priority.session"                 = 1500;   # prefer over built-in mic
          };
        }
        # -- Output node (monitor / headphone output) -------------------------
        {
            matches = [
            { "device.name" = "~alsa_card.usb-Focusrite_Scarlett_Solo.*"; }
            { "node.name" = "~alsa_output.*"; }
          ];
          actions.update-props = {
            "node.nick"              = "Scarlett Solo – Output";
            "node.description"       = "Focusrite Scarlett Solo (Output)";
            "audio.rate"                       = 48000;
            "api.alsa.period-size"             = 64;
            "api.alsa.headroom"                = 0;
            "api.alsa.disable-batch"           = true;
            "node.latency"                     = "64/48000";
            "session.suspend-timeout-seconds"  = 0;
            "priority.session"                 = 1500;   # prefer over built-in output
          };
        }
      ];
    };

    # ---------------------------------------------------------
    # Bluetooth policy – keep disabled unless needed;
    #  BT + low-latency USB audio can cause scheduler conflicts
    #---------------------------------------------------------
    
  #  wireplumber.extraConfig."80-disable-bluetooth-autoswitch" = {
  #    "wireplumber.settings" = {
  #      "bluetooth.autoswitch-to-headset-profile" = false;
  #    };
  #  };
  };  # ← This brace now correctly closes services.pipewire
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

  #-------------------------------------------------------
  # Packages
  # alsa-utils    → aplay, arecord, amixer, alsamixer (hardware diagnostics)
  #   helvum        → PipeWire patchbay (visual node graph)
  #   pwvucontrol   → native PipeWire volume control (replaces pavucontrol)
  #   alsa-scarlett-gui → OPTIONAL: GUI for Scarlett hardware mixer controls
  # -----------------------------------------------------
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
#    ffado           # Free FireWire Audio Drivers (libffado) - Userspace for snd_bebob
#    ffado-mixer     # GUI for Helix Board hardware mixer
#    jujuutils       # FireWire device utilities
#    dvgrab          # Receive/store audio & video over IEEE1394

    # --- Patchbay & Routing ---
    crosspipe
   # helvum         # GTK patchbay for PipeWire (disabled by default)
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
    # hydrogen        # Advanced drum machine
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
    xtuner      #Tuner for Jack Audio Connection Kit
    alsa-scarlett-gui  # GUI for Focusrite Scarlett mixer (if needed)
   # sonic-pi           # Live coding synth
    xfce.xfburn        # Disc burner
    yt-dlp
    ytfzf
    whipper
    losslesscut-bin        # Swiss army knife of lossless video/audio editing
    flac        # Library and tools for encoding and decoding the FLAC lossless audio file format
    ffmpeg # Complete, cross-platform solution to record, convert and stream audio and video
     
  ];

}

