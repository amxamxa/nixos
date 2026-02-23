# File: /etc/nixos/modules/color-env.nix
{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.colorEnv;
  
  # Shell script with properly escaped variables
  colorScript = pkgs.writeText "color-env.sh" ''
    # Color environment variables setup
    _setup_colors() {
      # Use ZDOTDIR from environment (set by other module)
      local LOG_FILE="''${ZDOTDIR}/zsh.log"
      local TIMESTAMP="$(date '+[%Y-%m-%d %H:%M:%S]')"
      
      # Validate ZDOTDIR is set and writable
      if [[ -z "$ZDOTDIR" ]]; then
        echo "[ERROR] ZDOTDIR not set - color-env module requires ZDOTDIR" >&2
        return 1
      fi
      
      if [[ ! -d "$ZDOTDIR" ]]; then
        echo "[ERROR] ZDOTDIR=$ZDOTDIR does not exist" >&2
        return 1
      fi
      
      # Function for detailed logging to shared zsh.log
      _log() {
        local LEVEL="$1"
        local MESSAGE="$2"
        ${optionalString cfg.enableLogging ''
        if [[ -w "$ZDOTDIR" ]] || [[ -w "$LOG_FILE" ]]; then
          echo "$TIMESTAMP [$LEVEL] [color-env] $MESSAGE" >> "$LOG_FILE" 2>/dev/null || true
        fi
        ''}
      }
      
      _log "INFO" "======================================================================"
      _log "INFO" "Color environment initialization started"
      _log "INFO" "======================================================================"
      _log "DEBUG" "ZDOTDIR=$ZDOTDIR"
      _log "DEBUG" "LOG_FILE=$LOG_FILE"
      _log "DEBUG" "TERM=$TERM"
      _log "DEBUG" "COLORTERM=''${COLORTERM:-<not set>}"
      _log "DEBUG" "COLOR_MODE=''${COLOR_MODE:-<not set, using default: ${cfg.colorMode}}"
      _log "DEBUG" "PWD=$PWD"
      _log "DEBUG" "USER=$USER"
      _log "DEBUG" "SHELL=$SHELL"
      
      # Check color mode preference (environment variable overrides module default)
      local COLOR_MODE="''${COLOR_MODE:-${cfg.colorMode}}"
      local SUPPORTS_24BIT=false
      local DETECTED_MODE=""
      
      _log "INFO" "Selected color mode: $COLOR_MODE"
      
      if [[ "$COLOR_MODE" == "mono" ]] || [[ "$COLOR_MODE" == "monochrome" ]]; then
        DETECTED_MODE="monochrome"
        _log "INFO" "Activating monochrome mode - all colors mapped to bold/dim"
        
        # Monochrome mode - all same intensity
        export RED=$'\033[1m'
        export GELB=$'\033[1m'
        export GREEN=$'\033[1m'
        export PINK=$'\033[1m'
        export LILA=$'\033[1m'
        export LIL2=$'\033[1m'
        export VIO=$'\033[1m'
        export BLUE=$'\033[1m'
        export LIME=$'\033[1m'
        export YELLO=$'\033[1m'
        export LAVEN=$'\033[1m'
        export PINK2=$'\033[1m'
        export RASPB=$'\033[1m'
        export VIOLE=$'\033[1m'
        export ORANG=$'\033[1m'
        export CORAL=$'\033[1m'
        export GOLD=$'\033[1m'
        export OLIVE=$'\033[1m'
        export PETRO=$'\033[1m'
        export CYAN=$'\033[1m'
        export GREY=$'\033[2m'
        export TEAL=$'\033[1m'
        export MINT=$'\033[1m'
        export SKY=$'\033[1m'
        export PLUM=$'\033[1m'
        export BROWN=$'\033[1m'
        export IVORY=$'\033[1m'
        export SLATE=$'\033[2m'
        export INDIG=$'\033[1m'
        export EMBER=$'\033[1m'
        
        _log "INFO" "Monochrome: Exported 30 color variables (all bold/dim variants)"
        
      elif [[ "$COLOR_MODE" == "256" ]]; then
        DETECTED_MODE="256-color (forced)"
        _log "INFO" "Activating 256-color mode (forced via COLOR_MODE)"
        
        # 256-color mode
        export RED=$'\033[38;5;203m\033[48;5;88m'
        export GELB=$'\033[38;5;227m'
        export GREEN=$'\033[38;5;46m\033[48;5;22m'
        export PINK=$'\033[38;5;205m\033[48;5;54m'
        export LILA=$'\033[38;5;213m\033[48;5;54m'
        export LIL2=$'\033[38;5;222m\033[48;5;54m'
        export VIO=$'\033[38;5;205m\033[48;5;54m'
        export BLUE=$'\033[38;5;226m\033[48;5;18m'
        export LIME=$'\033[38;5;30m\033[48;5;51m'
        export YELLO=$'\033[38;5;220m\033[48;5;58m'
        export LAVEN=$'\033[38;5;183m\033[48;5;60m'
        export PINK2=$'\033[38;5;212m\033[48;5;53m'
        export RASPB=$'\033[38;5;125m\033[48;5;52m'
        export VIOLE=$'\033[38;5;129m\033[48;5;53m'
        export ORANG=$'\033[38;5;208m\033[48;5;58m'
        export CORAL=$'\033[38;5;209m\033[48;5;52m'
        export GOLD=$'\033[38;5;220m\033[48;5;94m'
        export OLIVE=$'\033[38;5;142m\033[48;5;58m'
        export PETRO=$'\033[38;5;37m\033[48;5;23m'
        export CYAN=$'\033[38;5;51m\033[48;5;23m'
        export GREY=$'\033[38;5;252m\033[48;5;240m'
        export TEAL=$'\033[38;5;38m\033[48;5;23m'
        export MINT=$'\033[38;5;121m\033[48;5;22m'
        export SKY=$'\033[38;5;117m\033[48;5;24m'
        export PLUM=$'\033[38;5;170m\033[48;5;53m'
        export BROWN=$'\033[38;5;137m\033[48;5;52m'
        export IVORY=$'\033[38;5;230m\033[48;5;94m'
        export SLATE=$'\033[38;5;146m\033[48;5;60m'
        export INDIG=$'\033[38;5;54m\033[48;5;53m'
        export EMBER=$'\033[38;5;202m\033[48;5;52m'
        
        _log "INFO" "256-color: Exported 30 color variables using 8-bit palette"
        _log "DEBUG" "Sample codes: RED=38;5;203/48;5;88, GREEN=38;5;46/48;5;22"
        
      elif [[ "$COLOR_MODE" == "24bit" ]]; then
        DETECTED_MODE="24-bit truecolor (forced)"
        _log "INFO" "Activating 24-bit truecolor mode (forced via COLOR_MODE)"
        
        # 24-bit RGB colors
        export RED=$'\033[38;2;240;128;128m\033[48;2;139;0;0m'
        export GELB=$'\033[38;2;255;255;0m'
        export GREEN=$'\033[38;2;0;255;0m\033[48;2;0;100;0m'
        export PINK=$'\033[38;2;255;0;53m\033[48;2;34;0;82m'
        export LILA=$'\033[38;2;255;105;180m\033[48;2;75;0;130m'
        export LIL2=$'\033[38;2;239;217;129m\033[48;2;59;14;122m'
        export VIO=$'\033[38;2;255;0;53m\033[48;2;34;0;82m'
        export BLUE=$'\033[38;2;252;222;90m\033[48;2;0;0;139m'
        export LIME=$'\033[38;2;6;88;96m\033[48;2;0;255;255m'
        export YELLO=$'\033[38;2;255;215;0m\033[48;2;60;50;0m'
        export LAVEN=$'\033[38;2;200;170;255m\033[48;2;40;30;70m'
        export PINK2=$'\033[38;2;255;105;180m\033[48;2;60;20;40m'
        export RASPB=$'\033[38;2;190;30;90m\033[48;2;50;10;30m'
        export VIOLE=$'\033[38;2;170;0;255m\033[48;2;30;0;60m'
        export ORANG=$'\033[38;2;255;140;0m\033[48;2;60;30;0m'
        export CORAL=$'\033[38;2;255;110;90m\033[48;2;70;30;20m'
        export GOLD=$'\033[38;2;255;200;60m\033[48;2;80;60;10m'
        export OLIVE=$'\033[38;2;120;140;40m\033[48;2;40;50;20m'
        export PETRO=$'\033[38;2;0;160;160m\033[48;2;0;40;40m'
        export CYAN=$'\033[38;2;80;220;220m\033[48;2;0;50;50m'
        export GREY=$'\033[38;2;200;200;200m\033[48;2;60;60;60m'
        export TEAL=$'\033[38;2;0;180;140m\033[48;2;0;60;50m'
        export MINT=$'\033[38;2;150;255;200m\033[48;2;20;60;40m'
        export SKY=$'\033[38;2;120;200;255m\033[48;2;30;60;80m'
        export PLUM=$'\033[38;2;180;80;200m\033[48;2;50;20;60m'
        export BROWN=$'\033[38;2;160;110;60m\033[48;2;50;30;10m'
        export IVORY=$'\033[38;2;255;250;220m\033[48;2;80;70;50m'
        export SLATE=$'\033[38;2;150;160;170m\033[48;2;40;50;60m'
        export INDIG=$'\033[38;2;90;0;130m\033[48;2;30;0;50m'
        export EMBER=$'\033[38;2;255;80;40m\033[48;2;60;20;10m'
        
        _log "INFO" "24-bit: Exported 30 color variables using RGB codes"
        _log "DEBUG" "Sample codes: RED=38;2;240;128;128/48;2;139;0;0"
        
      else
        # Auto-detect terminal capabilities
        _log "INFO" "Auto-detecting terminal color capabilities..."
        _log "DEBUG" "Starting capability detection logic"
        
        if [[ -n "$COLORTERM" ]] && [[ "$COLORTERM" == "truecolor" || "$COLORTERM" == "24bit" ]]; then
          SUPPORTS_24BIT=true
          _log "DEBUG" "Detection: 24-bit support via COLORTERM=$COLORTERM"
        elif [[ "$TERM" == "xterm-kitty" ]]; then
          SUPPORTS_24BIT=true
          _log "DEBUG" "Detection: 24-bit support via TERM=xterm-kitty (kitty terminal)"
        elif [[ "$TERM" == *"256color"* ]]; then
          SUPPORTS_24BIT=true
          _log "DEBUG" "Detection: Assuming 24-bit support from TERM=$TERM"
        else
          _log "WARN" "Detection: No clear 24-bit indicators found"
          _log "WARN" "  TERM=$TERM (no '256color' or 'xterm-kitty')"
          _log "WARN" "  COLORTERM=''${COLORTERM:-<not set>} (not 'truecolor' or '24bit')"
        fi
        
        # Try tput as additional check
        if command -v tput &>/dev/null; then
          local TPUT_COLORS=$(tput colors 2>/dev/null || echo "0")
          _log "DEBUG" "tput reports: $TPUT_COLORS colors"
          if [[ "$TPUT_COLORS" -ge 256 ]]; then
            SUPPORTS_24BIT=true
            _log "DEBUG" "Detection: tput confirms 256+ color support"
          fi
        else
          _log "DEBUG" "tput command not available for detection"
        fi
        
        if [[ "$SUPPORTS_24BIT" == true ]]; then
          DETECTED_MODE="24-bit truecolor (auto-detected)"
          _log "INFO" "Result: Activating 24-bit truecolor mode"
          
          # 24-bit RGB colors
          export RED=$'\033[38;2;240;128;128m\033[48;2;139;0;0m'
          export GELB=$'\033[38;2;255;255;0m'
          export GREEN=$'\033[38;2;0;255;0m\033[48;2;0;100;0m'
          export PINK=$'\033[38;2;255;0;53m\033[48;2;34;0;82m'
          export LILA=$'\033[38;2;255;105;180m\033[48;2;75;0;130m'
          export LIL2=$'\033[38;2;239;217;129m\033[48;2;59;14;122m'
          export VIO=$'\033[38;2;255;0;53m\033[48;2;34;0;82m'
          export BLUE=$'\033[38;2;252;222;90m\033[48;2;0;0;139m'
          export LIME=$'\033[38;2;6;88;96m\033[48;2;0;255;255m'
          export YELLO=$'\033[38;2;255;215;0m\033[48;2;60;50;0m'
          export LAVEN=$'\033[38;2;200;170;255m\033[48;2;40;30;70m'
          export PINK2=$'\033[38;2;255;105;180m\033[48;2;60;20;40m'
          export RASPB=$'\033[38;2;190;30;90m\033[48;2;50;10;30m'
          export VIOLE=$'\033[38;2;170;0;255m\033[48;2;30;0;60m'
          export ORANG=$'\033[38;2;255;140;0m\033[48;2;60;30;0m'
          export CORAL=$'\033[38;2;255;110;90m\033[48;2;70;30;20m'
          export GOLD=$'\033[38;2;255;200;60m\033[48;2;80;60;10m'
          export OLIVE=$'\033[38;2;120;140;40m\033[48;2;40;50;20m'
          export PETRO=$'\033[38;2;0;160;160m\033[48;2;0;40;40m'
          export CYAN=$'\033[38;2;80;220;220m\033[48;2;0;50;50m'
          export GREY=$'\033[38;2;200;200;200m\033[48;2;60;60;60m'
          export TEAL=$'\033[38;2;0;180;140m\033[48;2;0;60;50m'
          export MINT=$'\033[38;2;150;255;200m\033[48;2;20;60;40m'
          export SKY=$'\033[38;2;120;200;255m\033[48;2;30;60;80m'
          export PLUM=$'\033[38;2;180;80;200m\033[48;2;50;20;60m'
          export BROWN=$'\033[38;2;160;110;60m\033[48;2;50;30;10m'
          export IVORY=$'\033[38;2;255;250;220m\033[48;2;80;70;50m'
          export SLATE=$'\033[38;2;150;160;170m\033[48;2;40;50;60m'
          export INDIG=$'\033[38;2;90;0;130m\033[48;2;30;0;50m'
          export EMBER=$'\033[38;2;255;80;40m\033[48;2;60;20;10m'
          
          _log "INFO" "24-bit: Exported 30 RGB color variables"
        else
          DETECTED_MODE="256-color (auto-detected fallback)"
          _log "WARN" "Result: Falling back to 256-color mode"
          _log "WARN" "Terminal does not appear to support 24-bit truecolor"
          
          # 256-color fallback
          export RED=$'\033[38;5;203m\033[48;5;88m'
          export GELB=$'\033[38;5;227m'
          export GREEN=$'\033[38;5;46m\033[48;5;22m'
          export PINK=$'\033[38;5;205m\033[48;5;54m'
          export LILA=$'\033[38;5;213m\033[48;5;54m'
          export LIL2=$'\033[38;5;222m\033[48;5;54m'
          export VIO=$'\033[38;5;205m\033[48;5;54m'
          export BLUE=$'\033[38;5;226m\033[48;5;18m'
          export LIME=$'\033[38;5;30m\033[48;5;51m'
          export YELLO=$'\033[38;5;220m\033[48;5;58m'
          export LAVEN=$'\033[38;5;183m\033[48;5;60m'
          export PINK2=$'\033[38;5;212m\033[48;5;53m'
          export RASPB=$'\033[38;5;125m\033[48;5;52m'
          export VIOLE=$'\033[38;5;129m\033[48;5;53m'
          export ORANG=$'\033[38;5;208m\033[48;5;58m'
          export CORAL=$'\033[38;5;209m\033[48;5;52m'
          export GOLD=$'\033[38;5;220m\033[48;5;94m'
          export OLIVE=$'\033[38;5;142m\033[48;5;58m'
          export PETRO=$'\033[38;5;37m\033[48;5;23m'
          export CYAN=$'\033[38;5;51m\033[48;5;23m'
          export GREY=$'\033[38;5;252m\033[48;5;240m'
          export TEAL=$'\033[38;5;38m\033[48;5;23m'
          export MINT=$'\033[38;5;121m\033[48;5;22m'
          export SKY=$'\033[38;5;117m\033[48;5;24m'
          export PLUM=$'\033[38;5;170m\033[48;5;53m'
          export BROWN=$'\033[38;5;137m\033[48;5;52m'
          export IVORY=$'\033[38;5;230m\033[48;5;94m'
          export SLATE=$'\033[38;5;146m\033[48;5;60m'
          export INDIG=$'\033[38;5;54m\033[48;5;53m'
          export EMBER=$'\033[38;5;202m\033[48;5;52m'
          
          _log "INFO" "256-color: Exported 30 palette-based color variables"
        fi
      fi
      
      # Text formatting codes (always exported)
      export BOLD=$'\033[1m'
      export BLINK=$'\033[5m'
      export UNDER=$'\033[4m'
      export RESET=$'\033[0m'
      
      _log "INFO" "Text formatting: Exported BOLD, BLINK, UNDER, RESET"
      _log "INFO" "======================================================================"
      _log "INFO" "Color environment initialization complete"
      _log "INFO" "Active mode: $DETECTED_MODE"
      _log "INFO" "Total variables: 34 (30 colors + 4 formatting)"
      _log "INFO" "======================================================================"
    }
    
    # Execute setup
    _setup_colors
  '';
  
in
{
  options.programs.colorEnv = {
    enable = mkEnableOption "color environment variables for shells";
    
    colorMode = mkOption {
      type = types.enum [ "auto" "24bit" "256" "mono" "monochrome" ];
      default = "auto";
      description = ''
        Color mode selection:
        - auto: Detect terminal capabilities (default)
        - 24bit: Force 24-bit truecolor
        - 256: Force 256-color palette
        - mono/monochrome: Disable colors (bold/dim only)
        
        Can be overridden at runtime with COLOR_MODE environment variable.
      '';
    };
    
    enableLogging = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable detailed logging to $ZDOTDIR/zsh.log
        Logs are prefixed with [color-env] for identification.
        Shares log file with other ZSH scripts in ZDOTDIR.
      '';
    };
  };
  
  config = mkIf cfg.enable {
    # Do NOT set ZDOTDIR - it's managed by another module
    # The script will use ZDOTDIR from the environment
    
    # Initialize for ZSH
    programs.zsh = {
      enable = true;
      interactiveShellInit = ''
        # Load color environment (requires ZDOTDIR from other module)
        if [[ -z "$ZDOTDIR" ]]; then
          echo "[ERROR] color-env.nix: ZDOTDIR not set by other module" >&2
        else
          source ${colorScript}
        fi
      '';
    };
    
    # Initialize for Bash (optional fallback)
    programs.bash.interactiveShellInit = mkIf config.programs.bash.enable ''
      # Load color environment
      if [[ -z "$ZDOTDIR" ]]; then
        echo "[ERROR] color-env.nix: ZDOTDIR not set" >&2
      else
        source ${colorScript}
      fi
    '';
  };
}
