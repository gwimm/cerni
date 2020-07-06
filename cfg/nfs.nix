{ config, pkgs, lib, ... }:

# nfs setup
# potentially possible to isolate into its own function

let
  name = "adinf";

in

{
  fileSystems."/export/${name}" = {
    device = "/mnt/${name}";
    options = [ "bind" ];
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export *(fsid=0,crossmnt,sync)
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [ 24 ];
  };
}
