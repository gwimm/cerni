{ config, pkgs, lib, ... }:

# server wireguard setup

let
  listenPort = 51820;
  externalInterface = "wlan0";

in

{
  networking = {
    firewall = {
      allowedUDPPorts = [ listenPort ];
    };

    nat = {
      enable = true;
      externalInterface = externalInterface;
      internalInterfaces = [ "wg0" ];
    };

    wireguard.interfaces = {
      "wg0" = {
        listenPort = listenPort;
        postSetup = ''
          ${pkgs.iptables}/bin/iptables
            -t nat
            -A POSTROUTING
            -s 10.100.0.0/24
            -o ${externalInterface}
            -j MASQUERADE
        '';

        postShutdown = ''
          ${pkgs.iptables}/bin/iptables
            -t nat
            -D POSTROUTING
            -s 10.100.0.0/24
            -o ${externalInterface}
            -j MASQUERADE
        '';

        privateKeyFile = "<path key private>";
        peers = [
          { # cpli
            publicKey = "{key public cpli}";
            allowedIPs = [ "10.100.0.2" ];
          }
        ];
      };
    };
  };
}
