# Install PKGS not available in the official NixOS repositories
- some PKGS are not available in the official NixOS repositories, you'll need to create a custom Nix expressions.
- they are in this Folder /etc/nixos/nixos-costum-expre

# How integrate nix-expression to configuration.nix
```nix
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (import ./PATH/lightdm-settings.nix)
  ];
}
```


# to check nix expression   
 To check your Nix expression before rebuilding your system, 
 you can use the nix-instantiate command.
 ``` sh
 nix-instantiate ./lightdm-settings.nix
warning: you did not specify '--add-root'; the result might be removed by the garbage collector
/nix/store/wby0bzi5x4svq12120b9lqamnm6hyfrl-lightdm-settings-latest.drv"
```
