{ config, pkgs, lib, ... }:

# nfs setup
# potentially possible to isolate into its own function

let
  name = "gravi";
  export = "/srv/nfs";

in

{
  fileSystems."${export}/${name}" = {
    device = "/mnt/${name}";
    options = [ "bind" ];
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      ${export} *(fsid=0,crossmnt,sync)
    '';
  };

  # NFSv4 uses only this TCP port
  networking.firewall.allowedTCPPorts = [ 2049 ];
}
