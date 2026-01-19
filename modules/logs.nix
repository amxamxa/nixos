# /etc/nixos/modules/logging.nix
#   l)L                          
#      l)                          
#      l)   o)OOO   g)GGG   s)SSSS 
#      l)  o)   OO g)   GG s)SSSS  
#      l)  o)   OO g)   GG      s) 
#      l)LL  o)OOO   g)GGGG s)SSSS  
#                       GG   
#                  g)GGGG    
#--------------------------------------------
# Centralized logging configuration for NixOS
#--------------------------------------------
# This module consolidates all system logging into journald (systemd's journal)
# and provides unified log management, rotation, and access.
#
# All logs go to: /var/log/journal/
# Access via: journalctl (with various filters)

{ config, pkgs, lib, ... }:

{
  # ============================================================================
  # JOURNALD CONFIGURATION (Primary logging system)
  # All system services, user services, and kernel messages go here
  # ============================================================================
  
  services.journald = {
    # Storage mode: persist logs to disk
    # Options: "volatile" (RAM only), "persistent" (disk), "auto"
    storage = "persistent";
    
    # Extra configuration for journald
    extraConfig = ''
      # ──────────────────────────────────────────────────────────────────
      # SIZE LIMITS
      # Prevent logs from consuming excessive disk space
      # ──────────────────────────────────────────────────────────────────
      SystemMaxUse=512M          # Maximum disk space for all journals
      SystemMaxFileSize=64M      # Maximum size per journal file
      SystemMaxFiles=8           # Keep max 8 journal files (8 × 64M = 512M)
      RuntimeMaxUse=128M         # Maximum RAM for volatile logs
      RuntimeMaxFileSize=32M     # Maximum size per runtime journal file
      
      # ──────────────────────────────────────────────────────────────────
      # RETENTION POLICY
      # How long to keep old logs
      # ──────────────────────────────────────────────────────────────────
      MaxRetentionSec=2week      # Delete logs older than 2 weeks
      MaxFileSec=1day            # Rotate journal files daily
      
      # ──────────────────────────────────────────────────────────────────
      # COMPRESSION & PERFORMANCE
      # ──────────────────────────────────────────────────────────────────
      Compress=yes               # Compress old logs to save space
      Seal=yes                   # Cryptographically seal logs (tamper detection)
      SplitMode=uid              # Separate logs per user (better security)
      
      # ──────────────────────────────────────────────────────────────────
      # LOG FORWARDING
      # Forward logs to traditional syslog and kernel message buffer
      # This ensures compatibility with tools expecting /var/log files
      # ──────────────────────────────────────────────────────────────────
      ForwardToSyslog=no         # Don't duplicate to rsyslog (we use journald only)
      ForwardToKMsg=yes          # Forward to kernel ring buffer
      ForwardToConsole=no        # Don't spam console with logs
      ForwardToWall=no           # Don't broadcast critical messages to all terminals
      
      # ──────────────────────────────────────────────────────────────────
      # RATE LIMITING
      # Prevent log flooding from misbehaving services
      # ──────────────────────────────────────────────────────────────────
      RateLimitIntervalSec=30s   # Rate limit window
      RateLimitBurst=10000       # Max messages per interval
      
      # ──────────────────────────────────────────────────────────────────
      # LOG LEVELS
      # Control verbosity of different log sources
      # ──────────────────────────────────────────────────────────────────
      MaxLevelStore=info         # Store info and higher (info, notice, warning, err, crit, alert, emerg)
      MaxLevelSyslog=info        # Forward info and higher to syslog
      MaxLevelKMsg=notice        # Forward notice and higher to kernel buffer
      MaxLevelConsole=warning    # Only show warnings+ on console
      MaxLevelWall=emerg         # Only broadcast emergencies
    '';
  };

  # ============================================================================
  # TRADITIONAL LOG ROTATION (for /var/log text files)
  # Only needed for services that still write to text files
  # ============================================================================
  
  services.logrotate = {
    enable = true;
    
    # Global configuration file
    configFile = pkgs.writeText "logrotate.conf" ''
      # ──────────────────────────────────────────────────────────────────
      # GLOBAL DEFAULTS
      # Applied to all log files unless overridden
      # ──────────────────────────────────────────────────────────────────
      
      # Rotate logs weekly
      weekly
      
      # Keep 4 weeks of rotated logs
      rotate 4
      
      # Create new log file after rotation (with same permissions)
      create
      
      # Add date extension to rotated files (e.g., logfile-20250111)
      dateext
      dateformat -%Y%m%d
      
      # Compress old logs to save space
      compress
      delaycompress          # Don't compress the most recent rotation
      
      # Don't error if log file is missing
      missingok
      
      # Don't rotate empty log files
      notifempty
      
      # Use sharedscripts to run scripts once for all logs
      sharedscripts
      
      # ──────────────────────────────────────────────────────────────────
      # SPECIFIC LOG FILES
      # Custom rotation rules for specific logs
      # ──────────────────────────────────────────────────────────────────
      
      # Sudo logs (from environment.nix sudo configuration)
      /var/log/sudo.log {
        weekly
        rotate 12              # Keep 3 months of sudo logs
        compress
        missingok
        notifempty
        create 0600 root root  # Restrictive permissions for security logs
      }
      
      # Custom permission management logs
      /var/log/setPermissions.log {
        weekly
        rotate 4
        compress
        missingok
        notifempty
        create 0644 root root
      }
      
      # System build logs (if custom logging added)
      /var/log/nixos/*.log {
        weekly
        rotate 8
        compress
        missingok
        notifempty
        create 0644 root root
      }
    '';
  };

  # ============================================================================
  # CENTRALIZED LOG DIRECTORY STRUCTURE
  # Ensure all custom logs go to /var/log/nixos/
  # ============================================================================
  
  # Create log directory structure on activation
  system.activationScripts.createLogDirs = {
    text = ''
      # Create centralized log directory
      mkdir -p /var/log/nixos
      chmod 755 /var/log/nixos
      chown root:root /var/log/nixos
      
      # Create subdirectories for different log categories
      mkdir -p /var/log/nixos/system
      mkdir -p /var/log/nixos/services
      mkdir -p /var/log/nixos/custom
      
      # Set permissions
      chmod 755 /var/log/nixos/*
      chown root:root /var/log/nixos/*
    '';
    deps = [];
  };

  # ============================================================================
  # SUDO LOGGING CONFIGURATION
  # Update sudo to log to centralized location
  # ============================================================================
  
  # This will be imported by environment.nix
  # Update the sudo logfile path to use centralized location
  security.sudo.extraConfig = lib.mkAfter ''
    # Override logfile from environment.nix
    Defaults logfile=/var/log/nixos/sudo.log
  '';

  # ============================================================================
  # HELPFUL LOGGING ALIASES
  # Add to shell configuration for easy log access
  # ============================================================================
  
  environment.etc."zsh/logging-aliases.sh".text = ''
    # Centralized logging aliases for easy access
    
    # ──────────────────────────────────────────────────────────────────
    # JOURNALCTL SHORTCUTS
    # ──────────────────────────────────────────────────────────────────
    
    # View all logs from current boot
    alias logs='journalctl -b 0'
    
    # View all logs from current boot with pager
    alias logsp='journalctl -b 0 | less'
    
    # Follow logs in real-time (like tail -f)
    alias logsf='journalctl -f'
    
    # View logs from previous boot
    alias logsp='journalctl -b -1'
    
    # View only error messages
    alias logse='journalctl -b 0 -p err'
    
    # View only warnings and errors
    alias logsw='journalctl -b 0 -p warning'
    
    # View kernel messages
    alias logsk='journalctl -b 0 -k'
    
    # ──────────────────────────────────────────────────────────────────
    # SERVICE-SPECIFIC LOGS
    # ──────────────────────────────────────────────────────────────────
    
    # View logs for a specific service
    # Usage: logsvc pipewire
    logsvc() {
      if [ -z "$1" ]; then
        echo "Usage: logsvc <service-name>"
        echo "Example: logsvc pipewire"
        return 1
      fi
      journalctl -u "$1" -f
    }
    
    # View user service logs
    # Usage: logsvu set-volume
    logsvu() {
      if [ -z "$1" ]; then
        echo "Usage: logsvu <user-service-name>"
        echo "Example: logsvu set-volume"
        return 1
      fi
      journalctl --user -u "$1" -f
    }
    
    # ──────────────────────────────────────────────────────────────────
    # TIME-BASED FILTERING
    # ──────────────────────────────────────────────────────────────────
    
    # Logs from the last hour
    alias logs1h='journalctl --since "1 hour ago"'
    
    # Logs from today
    alias logstoday='journalctl --since today'
    
    # Logs from yesterday
    alias logsyesterday='journalctl --since yesterday --until today'
    
    # ──────────────────────────────────────────────────────────────────
    # PRIORITY-BASED FILTERING
    # ──────────────────────────────────────────────────────────────────
    
    # Only critical errors
    alias logscrit='journalctl -b 0 -p crit'
    
    # All errors and critical
    alias logserr='journalctl -b 0 -p err'
    
    # ──────────────────────────────────────────────────────────────────
    # SEARCH & GREP
    # ──────────────────────────────────────────────────────────────────
    
    # Search logs for pattern
    # Usage: logsgrep "error"
    logsgrep() {
      if [ -z "$1" ]; then
        echo "Usage: logsgrep <pattern>"
        echo "Example: logsgrep 'failed to start'"
        return 1
      fi
      journalctl -b 0 | grep -i "$1"
    }
    
    # ──────────────────────────────────────────────────────────────────
    # BOOT LOGS
    # ──────────────────────────────────────────────────────────────────
    
    # List all available boots
    alias logsboots='journalctl --list-boots'
    
    # ──────────────────────────────────────────────────────────────────
    # DISK USAGE
    # ──────────────────────────────────────────────────────────────────
    
    # Show journal disk usage
    alias logssize='journalctl --disk-usage'
    
    # Vacuum old logs (free up space)
    alias logsvacuum='sudo journalctl --vacuum-time=2weeks'
    
    # ──────────────────────────────────────────────────────────────────
    # SPECIFIC COMMON SERVICES
    # ──────────────────────────────────────────────────────────────────
    
    # Audio logs
    alias logsaudio='journalctl -b 0 -u pipewire -u wireplumber --user -u set-volume'
    
    # Network logs
    alias logsnet='journalctl -b 0 -u NetworkManager'
    
    # System logs (boot, systemd, etc.)
    alias logssys='journalctl -b 0 -u systemd-journald'
    
    # PAM authentication logs
    alias logspam='journalctl -b 0 | grep pam'
    
    # ──────────────────────────────────────────────────────────────────
    # CUSTOM LOG FILES (non-journald)
    # ──────────────────────────────────────────────────────────────────
    
    # View sudo log
    alias logssudo='sudo tail -f /var/log/nixos/sudo.log'
    
    # View permissions log
    alias logsperm='sudo tail -f /var/log/nixos/setPermissions.log'
    
    # View all custom logs
    alias logscustom='sudo tail -f /var/log/nixos/**/*.log'
  '';

  # ============================================================================
  # LOG MONITORING TOOLS
  # Advanced log viewing and analysis tools
  # ============================================================================
  
  environment.systemPackages = with pkgs; [
    # journalctl is included by default in NixOS
    
    # Advanced Log Viewers
    lnav        # Log file navigator with automatic format detection, SQL queries, histograms
    glogg       # Fast log explorer with regexp search and filtering (Qt-based GUI)
    multitail   # Tail multiple log files simultaneously with color coding
    ccze        # Colorize log files with automatic format detection
  ];

  # ============================================================================
  # DOCUMENTATION
  # ============================================================================
  
  # Create documentation file for logging
  environment.etc."nixos/docs/logging-guide.md".text = ''
    # NixOS Centralized Logging Guide
    
    ## Overview
    
    All system logs are centralized in the systemd journal at `/var/log/journal/`.
    Custom text logs are in `/var/log/nixos/`.
    
    ## Log Viewing Tools
    
    ### 1. journalctl (Built-in)
    SystemD's native log viewer, always available.
    
    **Best for:** Quick queries, system services, real-time monitoring
    
    ```bash
    journalctl -b 0        # Current boot
    journalctl -f          # Follow (live)
    journalctl -u pipewire # Specific service
    ```
    
    ### 2. lnav (Log File Navigator)
    Interactive log viewer with automatic format detection, SQL queries, and histograms.
    
    **Best for:** Complex queries, log analysis, statistics, finding patterns
    
    **Features:**
    - Automatic format detection (syslog, JSON, etc.)
    - SQL queries on log data
    - Histogram view of log messages
    - Syntax highlighting
    - Bookmark important lines
    - Session saving
    
    **Usage:**
    ```bash
    # View logs interactively
    journalctl -b 0 --no-pager | lnav
    
    # Or use alias
    logsnav
    
    # Inside lnav:
    #   / - Search
    #   n - Next match
    #   ; - SQL query mode
    #   h - Help
    #   q - Quit
    
    # Example SQL query (press ; first):
    SELECT log_time, log_level, log_body 
    FROM all_logs 
    WHERE log_level = 'error' 
    ORDER BY log_time DESC 
    LIMIT 10;
    
    # Show error histogram
    # In lnav: press 'i' for histogram view
    ```
    
    **Aliases:**
    - `logsnav` - View all logs in lnav
    - `logsnavf` - Follow logs in lnav
    - `logsnav-svc <service>` - Service logs in lnav
    - `logsaudio-nav` - Audio logs in lnav
    - `logssudo-nav` - Sudo log in lnav
    - `logscustom-nav` - All custom logs in lnav
    - `logsstats` - Error frequency analysis
    - `logssql` - SQL query interface
    
    ### 3. ccze (Colorizer)
    Automatically colorizes log files with intelligent format detection.
    
    **Best for:** Making logs readable, identifying important messages quickly
    
    **Features:**
    - Automatic format detection (syslog, Apache, etc.)
    - Color-codes log levels (errors in red, warnings in yellow, etc.)
    - Highlights timestamps, IPs, URLs
    - Pipes well with tail/journalctl
    
    **Usage:**
    ```bash
    # Colorize journal output
    journalctl -b 0 --no-pager | ccze -A
    
    # Or use alias
    logscolor
    
    # Follow with color
    journalctl -f --no-pager | ccze -A
    logscolorf
    
    # Service logs with color
    journalctl -u pipewire --no-pager | ccze -A
    logscolor-svc pipewire
    ```
    
    **Aliases:**
    - `logscolor` - Colorized current boot logs
    - `logscolorf` - Follow logs with color
    - `logscolor-svc <service>` - Colorized service logs
    - `logsaudio` - Colorized audio logs
    - `logssudo` - Colorized sudo log
    
    ### 4. glogg (GUI Log Explorer)
    Fast Qt-based GUI for exploring large log files.
    
    **Best for:** Visual log exploration, regexp filtering, large files
    
    **Features:**
    - Fast search even in huge files
    - Regular expression filtering
    - Highlight matches in different colors
    - Split view for filtered/all logs
    - Session saving
    - Graphical interface
    
    **Usage:**
    ```bash
    # Export logs and open in glogg
    journalctl -b 0 --no-pager > /tmp/logs.txt
    glogg /tmp/logs.txt
    
    # Or use alias
    logsgui-export
    
    # Open existing log file
    glogg /var/log/nixos/sudo.log
    
    # Inside glogg:
    #   Ctrl+F - Search
    #   Ctrl+Shift+F - Filter (regexp)
    #   Colors - Highlight different patterns
    ```
    
    **Aliases:**
    - `logsgui` - Open glogg
    - `logsgui-export` - Export current boot and open in glogg
    
    ### 5. multitail (Multiple Tail)
    Monitor multiple log files simultaneously in split-screen view.
    
    **Best for:** Real-time monitoring of multiple services, comparing logs
    
    **Features:**
    - Multiple log files in split windows
    - Color highlighting per window
    - Merge mode (interleave logs)
    - Filter lines per window
    - Scroll independently or together
    
    **Usage:**
    ```bash
    # Monitor three services at once
    multitail \
      -l "journalctl -f -u pipewire --no-pager" \
      -l "journalctl -f -u wireplumber --no-pager" \
      -l "journalctl -f -u NetworkManager --no-pager"
    
    # Or use alias
    logsmulti
    
    # Custom combination
    logsmulti-custom pipewire wireplumber set-volume
    
    # With colorization
    logsmulticolor
    
    # Inside multitail:
    #   b - Scroll back
    #   / - Search
    #   q - Quit
    ```
    
    **Aliases:**
    - `logsmulti` - Monitor system, audio, network
    - `logsmulti-custom <svc1> <svc2>...` - Custom services
    - `logsmulticolor` - With ccze colorization
    - `logsaudio-multi` - Audio services split view
    - `logscustom` - All custom log files
    
    ## Tool Comparison Matrix
    
    | Tool       | Interface | Best For                | Real-time | SQL | Color | GUI |
    |------------|-----------|-------------------------|-----------|-----|-------|-----|
    | journalctl | CLI       | Quick queries           | Yes       | No  | No    | No  |
    | lnav       | TUI       | Analysis, Statistics    | Yes       | Yes | Yes   | No  |
    | ccze       | CLI       | Readable output         | Yes       | No  | Yes   | No  |
    | glogg      | GUI       | Visual exploration      | No        | No  | Yes   | Yes |
    | multitail  | TUI       | Multiple logs           | Yes       | No  | Yes   | No  |
    
    ## Recommended Workflows
    
    ### Quick Check (Single Service)
    ```bash
    logsvc pipewire        # Colorized, follows in real-time
    ```
    
    ### Troubleshooting Audio
    ```bash
    # Option 1: Split view of all audio services
    logsaudio-multi
    
    # Option 2: Interactive analysis
    logsaudio-nav
    # Then use SQL: SELECT * FROM all_logs WHERE log_level = 'error'
    
    # Option 3: Export and use GUI
    logsexport-svc pipewire /tmp/pipewire.log
    glogg /tmp/pipewire.log
    ```
    
    ### Finding Errors Across All Services
    ```bash
    # Method 1: Colorized grep
    logsgrep "error"
    
    # Method 2: Interactive search
    logsnav
    # Press / and type "error"
    
    # Method 3: Statistical analysis
    logsstats
    # Shows error histogram and frequency
    ```
    
    ### Monitoring System During Boot
    ```bash
    # Start multitail before reboot
    sudo multitail \
      -l "journalctl -f -k --no-pager | ccze -A" \
      -l "journalctl -f -u systemd --no-pager | ccze -A"
    ```
    
    ### Comparing Two Boots
    ```bash
    # Export both boots
    journalctl -b 0 --no-pager > /tmp/boot-current.log
    journalctl -b -1 --no-pager > /tmp/boot-previous.log
    
    # Open in glogg side-by-side
    glogg /tmp/boot-current.log &
    glogg /tmp/boot-previous.log &
    ```
    
    ## Quick Reference
    
    ### journalctl Commands
    
    ```bash
    # Time-based
    journalctl --since "1 hour ago"
    journalctl --since "2024-01-11 10:00:00"
    journalctl --since today
    
    # Priority-based
    journalctl -p err          # Errors only
    journalctl -p warning      # Warnings and above
    journalctl -p crit         # Critical only
    
    # Service-specific
    journalctl -u pipewire
    journalctl --user -u set-volume
    
    # Kernel messages
    journalctl -k
    journalctl -b 0 -k
    
    # Boot selection
    journalctl --list-boots
    journalctl -b 0            # Current boot
    journalctl -b -1           # Previous boot
    
    # Output format
    journalctl -o json         # JSON output
    journalctl -o json-pretty  # Pretty JSON
    journalctl -o cat          # Just the message
    
    # Maintenance
    journalctl --disk-usage
    journalctl --vacuum-time=2weeks
    journalctl --vacuum-size=500M
    journalctl --verify
    ```
    
    ### lnav Commands
    
    ```bash
    # Inside lnav:
    ?         - Help
    /pattern  - Search forward
    n/N       - Next/previous match
    ;         - SQL query mode
    i         - Histogram view
    t         - Text file view
    s/S       - Move to next/previous search hit
    m         - Mark line
    u         - Unmark line
    c         - Clear marked lines
    q         - Quit
    
    # SQL queries:
    ;SELECT COUNT(*) FROM all_logs WHERE log_level = 'error'
    ;SELECT log_time, log_body FROM all_logs WHERE log_body LIKE '%failed%'
    ```
    
    ### ccze Color Codes
    
    - **Red**: Errors, failures
    - **Yellow**: Warnings
    - **Green**: Success, OK
    - **Blue**: Info messages
    - **Cyan**: Timestamps, IPs
    - **Magenta**: URLs, paths
    
    ## Troubleshooting Common Issues
    
    ### "No entries" in journalctl
    ```bash
    # Check if journal is running
    systemctl status systemd-journald
    
    # Verify journal files exist
    ls -lh /var/log/journal/
    
    # Try different boot
    journalctl -b -1
    ```
    
    ### lnav shows binary data
    ```bash
    # Force text mode
    lnav -t /path/to/log
    
    # Or use --no-pager with journalctl
    journalctl --no-pager | lnav
    ```
    
    ### ccze colors not showing
    ```bash
    # Check terminal supports 256 colors
    echo $TERM
    
    # Try with -A flag
    journalctl | ccze -A
    
    # Set TERM if needed
    export TERM=xterm-256color
    ```
    
    ### multitail windows too small
    ```bash
    # Press 'q' to quit, then adjust terminal size
    # Or use -s flag to set number of columns
    multitail -s 2 -l "cmd1" -l "cmd2"  # 2 columns
    ```
    
    ## Additional Resources   
    - `man journalctl` - Full journalctl documentation
    - `man journald.conf` - Journal configuration
    - `man lnav` - lnav documentation
    - `man ccze` - ccze documentation
    - `man multitail` - multitail documentation
    - `logshelp` - Show all logging aliases
    - Online: https://lnav.org - lnav website with tutorials
  '';

  # Create quick reference cheatsheet
  environment.etc."nixos/docs/logging-tools-cheatsheet.txt".text = ''
    ╔═══════════════════════════════════════════════════════════════╗
    ║          LOGGING TOOLS QUICK REFERENCE CARD                   ║
    ╚═══════════════════════════════════════════════════════════════╝

    WHEN TO USE WHICH TOOL:
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Quick error check       → ccze       → logse
    Find pattern            → lnav       → logssearch "pattern"
    Monitor multiple        → multitail  → logsmulti
    Visual exploration      → glogg      → logsgui-export
    Statistical analysis    → lnav       → logsstats
    Real-time color         → ccze       → logscolorf
    SQL queries             → lnav       → logssql

    TOOL COMPARISON:
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Tool       Interface  Best For              Real-time  SQL
    ─────────────────────────────────────────────────────────────────
    journalctl CLI        Quick queries         Yes        No
    lnav       TUI        Analysis/Statistics   Yes        Yes
    ccze       CLI        Readable output       Yes        No
    glogg      GUI        Visual exploration    No         No
    multitail  TUI        Multiple logs         Yes        No

    JOURNALCTL QUICK COMMANDS:
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    journalctl -b 0                # Current boot
    journalctl -f                  # Follow (live)
    journalctl -u SERVICE          # Specific service
    journalctl -p err              # Only errors
    journalctl -k                  # Kernel messages
    journalctl --since "1h ago"    # Time filter
    journalctl --disk-usage        # Check size

    LNAV INTERACTIVE KEYS:
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    /pattern   Search forward      ;          SQL query mode
    n / N      Next/prev match     i          Histogram view
    m          Mark line           q          Quit
    TAB        Switch files        ?          Help

    LNAV SQL EXAMPLES:
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ;SELECT COUNT(*) FROM all_logs WHERE log_level = 'error'
    ;SELECT log_time, log_body FROM all_logs WHERE log_body LIKE '%fail%'

    MULTITAIL KEYS:
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    b          Scroll back         0-9        Jump to window
    /pattern   Search              m          Merge windows
    q          Quit                h          Help

    CCZE COLOR CODES:
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Red        Errors/failures     Yellow     Warnings
    Green      Success/OK          Blue       Info messages
    Cyan       Timestamps/IPs      Magenta    URLs/paths

    COMMON WORKFLOWS:
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Quick check:     logse
    Audio debug:     logsaudio-multi → logsaudio-nav
    Service check:   logsvc pipewire → logsnav-svc pipewire
    Find errors:     logsgrep "error" → logssearch "error"
    Boot compare:    logsgui-export (boot 0 and boot -1)

    ESSENTIAL ALIASES:
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    logs           All current boot logs
    logsf          Follow logs live
    logse          Only errors (colorized)
    logsaudio      Audio logs (colorized)
    logsaudio-nav  Audio logs in lnav
    logsaudio-multi Audio logs split view
    logsnav        All logs in lnav
    logscolor      Colorized output
    logsmulti      Multiple logs split
    logsgui-export Export and open in glogg
    logssudo       Sudo log (colorized)
    logshelp       Show all aliases

    PRO TIPS:
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    • Export once, analyze multiple ways
    • Use ccze for readability, lnav for analysis, glogg for visual
    • multitail for live comparison, lnav for historical patterns
    • Save lnav sessions automatically
    • Combine tools: journalctl | ccze | lnav

    HELP:
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    logshelp                              # All aliases
    cat /etc/nixos/docs/logging-guide.md # Detailed guide
    man journalctl / lnav / ccze / multitail
  '';

  # Create tools cheatsheet
  #environment.etc."nixos/docs/logging-tools-cheatsheet.md".source =     builtins.toFile "logging-tools-cheatsheet.md" (builtins.readFile ./logging-tools-cheatsheet.md);
}

