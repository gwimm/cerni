{ config, pkgs, lib, ... }:

# simple SSHD configuration

# TODO
# find way to limit to only dropbear
# currently fails at:

# ```
# ssh-keygen: command not found
# builder for 'sshd.conf-validated.drv' failed with exit code 127
# ```

let
  prefix = "/srv/ssh";

in {
  programs.ssh.package = pkgs.dropbear;

  networking.firewall.allowedTCPPorts = [ 22 ];

  services.openssh = {
    enable = true;

    # default key generation fails under dropbear:
    hostKeys = [];

    # disable NixOS insecure default of `true`
    # passwordAuthentication = false;
    permitRootLogin = "yes";
    authorizedKeysFiles =
      builtins.attrNames (builtins.readDir "${prefix}/keys");
  };
}
