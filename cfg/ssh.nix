{ config, pkgs, lib, ... }:

let
  prefix = "/srv/ssh";

in

{
  programs.ssh.package = pkgs.dropbear;

  networking.firewall.allowedTCPPorts = [ 22 ];

  services.openssh = {
    enable = true;

    # default key generation fails under dropbear:
    #  ssh-keygen: command not found
    #  builder for 'sshd.conf-validated.drv' failed with exit code 127
    hostKeys = [];

    # doesn't work without root password, which can't be set...
    permitRootLogin = "yes";

    authorizedKeysFiles =
      builtins.attrNames (builtins.readDir "${prefix}/keys");
  };
}
