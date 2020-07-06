{ config, pkgs, lib, ... }:

{
  networking = {
    hostName = "cerni";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    enableIPv6 = false;

    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
      networks = {
        "View123" = {
          psk = "88888888";
        };
      };
    };
  };
}
