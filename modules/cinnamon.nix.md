# /etc/nixos/modules/cinnamon.nix
# Cinnamon desktop with X11, running parallel to COSMIC/Wayland.
# Session selection is handled by cosmic-greeter (greetd-based),
# which reads both /share/xsessions/ and /share/wayland-sessions/.
{ config, pkgs, lib, ... }:
{
  # Enable X server — required for any X11 desktop
  services.xserver.enable = true;

  # Enable Cinnamon desktop manager (registers cinnamon.desktop in xsessions)
  services.xserver.desktopManager.cinnamon.enable = true;

  # Explicitly disable LightDM — cosmic-greeter (greetd) is the display manager
  # Without this, NixOS may activate LightDM as default when xserver is enabled
  services.xserver.displayManager.lightdm.enable = false;

  # Useful Cinnamon companion packages
  environment.systemPackages = with pkgs; [
    cinnamon.nemo-with-extensions  # File manager with extras
    cinnamon.mint-themes           # Mint/Cinnamon themes
    cinnamon.mint-y-icons          # Icon theme
    xorg.xrandr                    # Display configuration for X11
  ];
}
