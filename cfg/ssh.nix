{ config, pkgs, lib, ... }:

{
  # results in:
  #  ssh-keygen: command not found
  #  builder for 'sshd.conf-validated.drv' failed with exit code 127
  # programs.ssh.package = pkgs.dropbear;

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "yes";
    };
  };
}
