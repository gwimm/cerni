{ config, pkgs, lib, ... }:

# server wireguard setup

let
  prefix = "/srv/wg";

  # known vpn ports:
  #   564:p9
  #   655:Tinc VPN
  #   981:Check Point VPN-1 (unofficial)
  #   1194:OpenVPN
  #   5000:VTun (unofficial)
  listenPort = 5000;
  externalInterface = "wlan0";

  # helper function, planned to create easy command builders
  iptables = arg: ''
    ${pkgs.iptables}/bin/iptables ${arg}
    ${
      lib.optionalString config.networking.enableIPv6
        "${pkgs.iptables}/bin/ip6tables ${arg}"
    }
  '';

in {
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
        ips = [ "10.10.0.0/24" ];
        listenPort = listenPort;

        postSetup = iptables ''     \
            -t nat                  \
            -A POSTROUTING          \
            -o ${externalInterface} \
            -j MASQUERADE
        '';

        postShutdown = iptables ''  \
            -t nat                  \
            -D POSTROUTING          \
            -o ${externalInterface} \
            -j MASQUERADE
        '';

        privateKeyFile = "${prefix}/prv.b64";
        # presharedKeyFile = "${prefix}/psk.b64";

        peers = [ { # cpli
            allowedIPs = [ "10.10.0.1/32" ];
            publicKey = "o1oXp9AfJW9anC8WNZU+01VhGrtbq4vazmwRPTil03E=";
        } ];
      };
    };
  };
}
