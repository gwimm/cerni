{ config, pkgs, lib, ... }:

{
  programs.ssh.package = pkgs.dropbear;

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "yes";
    };
  };
}
