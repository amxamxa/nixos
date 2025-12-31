{ config, pkgs, lib, ... }:
{
programs.pay-respects.enable = true;

  environment.variables = {
    EDITOR = "${pkgs.micro}/bin/micro";
       VISUAL =  "${pkgs.micro}/bin/micro";
       SYSTEMD_EDITOR =  "${pkgs.micro}/bin/micro";
}; 

}
