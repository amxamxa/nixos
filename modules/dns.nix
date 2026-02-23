{ config, pkgs, ... }:

  let
    dnsChanger = pkgs.appimageTools.wrapType2 {
      name = "dns-changer";
      src = pkgs.fetchurl {
        url = "https://github.com/DnsChanger/dnsChanger-desktop/releases/download/v2.3.5/DNS-Changer-linux-x86_64-
  2.3.5.AppImage";
        sha256 = "0i74wyrj1wrcg1634pqbgfqfkli1yl6i7ilmn5ipvzr3rd8vid8y";
      };
    };
  in {
    environment.systemPackages = [
      dnsChanger
    ];
  }
  
