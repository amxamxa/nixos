
{ config, pkgs, ... }:
{
programs.sway.enable = true;
  xdg.portal.wlr.enable = true;
}
