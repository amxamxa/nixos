# /etc/nixos/modules/shell-colors.nix
{ config, lib, pkgs, ... }:

{
  options.programs.shellColors = {
    enable = lib.mkEnableOption "shell color definitions for zsh and bash";
  };

  config = lib.mkIf config.programs.shellColors.enable {
    environment.etc."shell-colors.sh" = {
      text = ''
        # Use 24-bit RGB colors (modern terminals like kitty)
        readonly RED=$'\033[38;2;240;128;128m\033[48;2;139;0;0m'
        readonly GELB=$'\e[33m'
        readonly GREEN=$'\033[38;2;0;255;0m\033[48;2;0;100;0m'
        readonly PINK=$'\033[38;2;255;0;53m\033[48;2;34;0;82m'
        readonly LILA=$'\033[38;2;255;105;180m\033[48;2;75;0;130m'
        readonly LIL2=$'\033[38;2;239;217;129m\033[48;2;59;14;122m'
        readonly VIO=$'\033[38;2;255;0;53m\033[48;2;34;0;82m'
        readonly BLUE=$'\033[38;2;252;222;90m\033[48;2;0;0;139m'
        readonly LIME=$'\033[38;2;6;88;96m\033[48;2;0;255;255m'
        readonly YELLO=$'\033[38;2;255;215;0m\033[48;2;60;50;0m'
        readonly LAVEN=$'\033[38;2;200;170;255m\033[48;2;40;30;70m'
        readonly PINK2=$'\033[38;2;255;105;180m\033[48;2;60;20;40m'
        readonly RASPB=$'\033[38;2;190;30;90m\033[48;2;50;10;30m'
        readonly VIOLE=$'\033[38;2;170;0;255m\033[48;2;30;0;60m'
        readonly ORANG=$'\033[38;2;255;140;0m\033[48;2;60;30;0m'
        readonly CORAL=$'\033[38;2;255;110;90m\033[48;2;70;30;20m'
        readonly GOLD=$'\033[38;2;255;200;60m\033[48;2;80;60;10m'
        readonly OLIVE=$'\033[38;2;120;140;40m\033[48;2;40;50;20m'
        readonly PETRO=$'\033[38;2;0;160;160m\033[48;2;0;40;40m'
        readonly CYAN=$'\033[38;2;80;220;220m\033[48;2;0;50;50m'
        readonly GREY=$'\033[38;2;200;200;200m\033[48;2;60;60;60m'
        readonly TEAL=$'\033[38;2;0;180;140m\033[48;2;0;60;50m'
        readonly MINT=$'\033[38;2;150;255;200m\033[48;2;20;60;40m'
        readonly SKY=$'\033[38;2;120;200;255m\033[48;2;30;60;80m'
        readonly PLUM=$'\033[38;2;180;80;200m\033[48;2;50;20;60m'
        readonly BROWN=$'\033[38;2;160;110;60m\033[48;2;50;30;10m'
        readonly IVORY=$'\033[38;2;255;250;220m\033[48;2;80;70;50m'
        readonly SLATE=$'\033[38;2;150;160;170m\033[48;2;40;50;60m'
        readonly INDIG=$'\033[38;2;90;0;130m\033[48;2;30;0;50m'
        readonly EMBER=$'\033[38;2;255;80;40m\033[48;2;60;20;10m'
        readonly BOLD=$'\033[1m'
        readonly BLINK=$'\033[5m'
        readonly UNDER=$'\033[4m'
        readonly RESET=$'\033[0m'
      '';
      mode = "0444"; # read-only
    };

    programs.zsh.interactiveShellInit = ''
      source /etc/shell-colors.sh
    '';

    programs.bash.interactiveShellInit = ''
      source /etc/shell-colors.sh
    '';
  };
}
