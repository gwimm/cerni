{ config, pkgs, lib, ... }:

# server wireguard setup

let
  listenPort = 51820;
  externalInterface = "wlan0";
  source = "10.100.0.0/24";

in

{
  networking = {
    firewall.allowedUDPPorts = [ listenPort ];

    nat = {
      enable = true;
      externalInterface = externalInterface;
      internalInterfaces = [ "wg0" ];
    };

    wireguard.interfaces = {
      "wg0" = {
        ips = [ "10.100.0.1/24" ];
        listenPort = listenPort;

        postSetup = ''
          ${pkgs.iptables}/bin/iptables           \
            --table  nat                          \
            --append POSTROUTING                  \
            --source ${source}                    \
            --jump   MASQUERADE                   \
            --out-interface ${externalInterface}
        '';

        postShutdown = ''
          ${pkgs.iptables}/bin/iptables           \
            --table  nat                          \
            --delete POSTROUTING                  \
            --source ${source}                    \
            --jump   MASQUERADE                   \
            --out-interface ${externalInterface}
        '';

        privateKeyFile = "/srv/wg/prv.b64";

        peers = [ { # cpli
            allowedIPs = [ "10.100.0.2/32" ];
            publicKey = "o1oXp9AfJW9anC8WNZU+01VhGrtbq4vazmwRPTil03E=";
        } ];
      };
    };
  };
}
