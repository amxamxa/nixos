# default-Lautstärke einstellen?


# wireplumber: Most configuration of devices is performed by the session manager. It typically loads ALSA and other devices and configures the profiles, port volumes and more. The session manager also configures new clients and links them to the targets, as configured in the session manager policy.
# PipeWire clients: Each native PipeWire client also loads a configuration file. Emulated JACK client also have separate configuration.

# audio.nix
{ config, pkgs, ... }:
{
users.users.amxamxa.extraGroups = ["jackaudio" "audio" ];
boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];
boot.kernel.sysctl = { # Verbessert die Audio-Performance und speicherbezogene Latenzen
  "fs.inotify.max_user_watches" = 524288;
  "fs.inotify.max_user_instances" = 512;
  "vm.swappiness" = 10;
};



# Enable sound with pipewire.
 hardware.firmware = [ pkgs.alsa-firmware ];
   # Option ist VERALTET seit 24.11 # sound.enable = true;  
 services.jack.jackd.enable = false; # PipeWire based JACK emulation doesn't use the JACK service. This option requires `services.jack.jackd.enable` to be set to false. PipeWire ersetzt jackd

# service.pulseaudio.enable = false; # pipewire ist alternative zu pulseaudio
 hardware.pulseaudio.package = pkgs.pulseaudio.override { jackaudioSupport = true; }; # Unnötig, weil du Pulseaudio deaktiviert hast.
 security.rtkit.enable = true; # realtimeKit system service, which hands out realtime scheduling priority to user processes on demand

 systemd.user.services.set-volume = {
  description = "Set volume to 75% at startup";
  wantedBy = [ "default.target" ];
  after = [ "wireplumber.service" ]; 
  serviceConfig = {
  #wpctl set-volume @DEFAULT_AUDIO_SINK@ 80% 
    ExecStart = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 75%";
    Restart = "on-failure";
      StandardOutput = "journal";
    StandardError = "journal";
  };
};

 services.pipewire = {
       enable = true;
       alsa.enable = true;
       alsa.support32Bit = true;
       jack.enable = true;
       wireplumber.enable = true; # a modularhardware.pulseaudio.package session / policy manager for PipeWire   # pipewire-media-session is no longer supported, switch to `services.pipewire.wireplumber`.
	extraConfig.pipewire."92-low-latency" = {
    		"context.properties" = {
   		"default.clock.rate" = 48000;
   		"default.clock.quantum" = 32;      
   		"default.clock.min-quantum" = 32;
   		"default.clock.max-quantum" = 32;
    			}; 
    		};
    	 
	wireplumber.extraConfig.bluetoothEnhancements = {
  		"monitor.bluez.properties" = {
      		"bluez5.enable-sbc-xq" = true;
      		"bluez5.enable-msbc" = true;
      		"bluez5.enable-hw-volume" = true;
      		"bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
  			};
		};
	};  
   /*
   systemd.services.pipewire = {
    serviceConfig = {
      LimitMEMLOCK = "infinity";
      LimitRTPRIO = 99;
      LimitNICE = -20;
    };
  }; */

  environment.variables = {
    PIPEWIRE_LATENCY = "32/48000";
    JACK_NO_AUDIO_RESERVATION = "1";
  };

environment.systemPackages = with pkgs; [

# audio driver  	##########################################
  pipewire # Audio server:     pipewire und wireplumber sind kompatibel und arbeiten gut zusammen. 
  wireplumber # Session manager for PipeWire
  alsa-firmware # Soundcard firmwares from the alsa project
  alsa-scarlett-gui # GUI for alsa controls presented by Focusrite Scarlett Gen 2/3/4 Mixer Driver
  ffmpeg # Complete, cross-platform solution to record, convert and stream audio and video
   pwvucontrol # PipeWire volume control
  # pavucontrol # pulseaudio controls the volume (per-sink and per-app basis. entfernt, da es für PulseAudio ist und nicht mit PipeWire kompatibel 

# JACK und Audio-Routing 
 jack2 # JACK audio connection kit, version 2 with jackdbus
 jamin # JACK Audio Mastering interface
 # jack_rack # An effects "rack" for the JACK low latency audio API
 jackmix # Matrix-Mixer for the Jack-Audio-connection-Kit
  meterbridge # Audio metering tools for JACK
 # ALT: jackmeter   # Simple level meter for JACK
#  carla # Audio plugin hostQjackCtl
#  patchage # Modular patch bay for Jack and ALSA systems
#  qjackctl  # application to control the JACK sound server daemon
  xtuner # Tuner for Jack Audio Connection Kit
  helvum # GTK patchbay for PipeWire
 
# DAWs und Audio-Editoren
  vlc # Media player
  ardour      # Multi-track hard disk recording software
  # reaper      # Professional digital audio workstation (DAW)
  # bitwig-studio4  # Digital audio workstation

  # MIDI- Drum-, Loop-Machines,  MIDI-Sequencing und virtuelle Instrumente
 # mamba # Virtual MIDI keyboard for Jack Audio Connection Kit
  hydrogen    # Advanced drum machine for beat production
  drumgizmo   # Drum sampler with high-quality samples
  decent-sampler   # Audio sample player
  zita-resampler   # Resample library by Fons Adriaensen	
  sooperlooper # Live looping tool for performances
  # oxefmsynth # Open source VST 2.4 instrument plugin
  ninjas2    # sample slicer plugin
 
 # qtractor    # MIDI/Audio sequencer with recording/editing
  helm        # Polyphonic synthesizer with a powerful interface
  #  zynaddsubfx # Advanced software synthesizer
  muse       # MIDI/Audio sequencer with recording/editing
  petrifoo   # MIDI controllable audio sampler
  # bespokesynth-with-vst2 # sw modular synth with controllers
  japa # 'perceptual' or 'psychoacoustic' audio spectrum analyser for JACK and ALSA
  decent-sampler   # Audio sample player
  zita-resampler   # Resample library by Fons Adriaensen	
  sooperlooper # Live looping tool for performances
 
  guitarix # Virtual guitar amplifier for Linux running with JACK
  calf        # Collection of high-quality audio plugins (EQ, compressor, etc.)
  rakarrack   # Guitar effects processor
  lsp-plugins # Collection of open-source audio plugins
  zam-plugins # Collection of LV2/LADS audio plugins by ZamAudio
  dragonfly-reverb # High-quality reverb effects
   # easyeffects # Audio effects for PipeWire, ntfernt, da es für PulseAudio entwickelt wurde und nicht direkt mit PipeWire kompatibel ist.
   
  cava # console-based Audio Visualizer for Alsa
  cavalier # visualize audio with CAVA
  playerctl # cmd utility and lib for media players that implement MPRIS
  
  yt-dlp
  ytfzf
tuxguitar   # Guitar tablature and score editor
	 ];


}
  
