{ config, pkgs, lib, ... }:

# server wireguard setup

let
  listenPort = 51820;
  externalInterface = "wlan0";

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
        ips = [ "10.100.0.0/24" ];
        listenPort = listenPort;

        postSetup = ''
          ${pkgs.iptables}/bin/iptables -A FORWARD -i %i -j ACCEPT
          ${pkgs.iptables}/bin/iptables -A FORWARD -o %i -j ACCEPT
          ${pkgs.iptables}/bin/iptables \
            -t nat                      \
            -A POSTROUTING              \
            -o ${externalInterface}     \
            -j MASQUERADE               \
        '';

        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -D FORWARD -i %i -j ACCEPT
          ${pkgs.iptables}/bin/iptables -D FORWARD -o %i -j ACCEPT
          ${pkgs.iptables}/bin/iptables \
            -t nat                      \
            -D POSTROUTING              \
            -o ${externalInterface}     \
            -j MASQUERADE               \
        '';

        privateKeyFile = "/srv/wg/prv.b64";

        peers = [ { # cpli
            allowedIPs = [ "0.0.0.0/0" ];
            publicKey = "o1oXp9AfJW9anC8WNZU+01VhGrtbq4vazmwRPTil03E=";
        } ];
      };
    };
  };
}
