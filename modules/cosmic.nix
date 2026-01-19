{ config, pkgs, lib, ... }:
# sudo nixos-rebuild boot --profile-name xam4boom --cores 2 --show-trace
{
  /* ______________________________________  ███
                                                   ░░░
           ██████   ██████   █████  █████████████   ████   ██████
          ███░░███ ███░░███ ███░░  ░░███░░███░░███ ░░███  ███░░███
         ░███ ░░░ ░███ ░███░░█████  ░███ ░███ ░███  ░███ ░███ ░░░
         ░███  ███░███ ░███ ░░░░███ ░███ ░███ ░███  ░███ ░███  ███
         ░░██████ ░░██████  ██████  █████░███ █████ █████░░██████
          ░░░░░░   ░░░░░░  ░░░░░░  ░░░░░ ░░░ ░░░░░ ░░░░░  ░░░░░░
   ______  _______ _______ _     _ _______  _____   _____
  |     \ |______ |______ |____/     |    |     | |_____]
  |_____/ |______ ______| |    \_    |    |_____| |
       _______ __   _ _    _ _____  ______  _____  _______ _______ __   _ _______
|______ | \  |  \  /    |   |_____/ |     | |  |  | |______ | \  |    |
|______ |  \_|   \/   __|__ |    \_ |_____| |  |  | |______ |  \_|    |
------------------------------------------------------------------------
   COSMIC Desktop Environment::  unter Wayland
      - basiert nicht auf wlroots
      - hat eigene Rendering- und Scene-Graph-Logik
      - priorisiert: Stabilität, deterministische Latenz, saubere Input-Pfade
   Konsequenz:kein globales Farbprofil, kein ICC-basierter Desktop-Farbraum
         COSMIC vermeidet aktuell bewusst „halb-funktionales HDR“.
  */

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # Performance-Optimierung (System76 Integration)
  services.system76-scheduler.enable = true;

  #  Disable warning about excluded packages
  services.desktopManager.cosmic.showExcludedPkgsWarning = false;

  # Clipboard Manager not working, so zwlr_data_control_manager_v1 protocol needs to be available.
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

  nix.settings = {
    # Erlaubt das Beziehen von fertigen COSMIC-Builds ohne Flakes
    substituters = [ "https://cosmic.cachix.org" ];
    trusted-public-keys =
      [ "cosmic.cachix.org-1:9/S695oLGOnS9e12Rh9CLGiL9uX9HId+6A473Y9U158=" ];
  };
  #-------------------------------------------

  # sonstige Greeter / Login / display mgr
  services.displayManager.gdm.enable = false;
  services.xserver.displayManager = { lightdm.enable = false; };
  #-------------------------------------------
  #  window / desktop mgr
  services.desktopManager = {
    gnome.enable = false;
    pantheon.enable = false;
  };
  services.xserver.desktopManager = {
    cinnamon.enable = false;
    lxqt.enable = false;
    xfce.enable = false;
  };
  programs.firefox.preferences = {
    # disable libadwaita theming for Firefox
    "widget.gtk.libadwaita-colors.enabled" = false;
  };
  # make Qt 5 applications look similar to GTK ones
  qt.enable = true;
  qt.platformTheme = "gtk2";
  qt.style = "gtk2";

  # INCLUDE !!!!!!!!!!!!
  environment.systemPackages = with pkgs; [
    examine # system information viewer for the COSMIC Desktop
    tasks # simple task management application for the COSMIC desktop
    quick-webapps
    cosmic-design-demo # Design Demo for the COSMIC Desktop Environment
    cosmic-applibrary # Application Template for the COSMIC Desktop Environment
    cosmic-ext-tweaks # Tweaking tool for the COSMIC
    cargo #  Downloads your Rust project's dependencies and builds your project4 cosmic-ext-tweaks 
    just #  4 cosmic-ext-tweaks 
    libxkbcommon #  library to handle keyboard descriptions 4 cosmic-ext-tweaks 
    libcosmicAppHook # Setup hook for configuring and wrapping applications based on libcosmic  #  4 cosmic-ext-tweaks 

    cosmic-protocols # Additional wayland-protocols used by COSMIC de
    cosmic-applets # Applets for the COSMIC
    cosmic-store # App Store
    cosmic-randr # Library and utility for displaying and configuring Wayland outputs
    cosmic-ext-applet-minimon
    cosmic-ext-calculator # Calculator for the COSMIC Desktop
    cosmic-ext-ctl # cli for managing the configuration of the COSMIC Desktop
    libcosmicAppHook # Setup hook for configuring and wrapping applications based on libcosmic
    xdg-desktop-portal-cosmic # XDG Desktop Portal for the COSMIC
    
    # WAYLAND Stuff
    wlr-layout-ui #Simple GUI to setup the screens layout on wlroots based systems
    wl-color-picker # Wayland color picker that also works on wlroots
    wlprop # Xprop clone for wlroots based compositors
    wlr-randr # Xrandr clone for wlroots compositors
    wlroots_0_19 # Modular Wayland compositor library


  ];

 
 environment.cosmic.excludePackages = with pkgs; [
    cosmic-player # Media player for the COSMIC Desktop Environment
    cosmic-edit # Text Editor
    cosmic-files # File Manager
    cosmic-player # media player
    cosmic-reader # PDF reader
  ];

}

