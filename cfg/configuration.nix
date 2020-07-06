{ config, pkgs, lib, ... }:

# cerni's config
# aarch64 armv7 rpi 4b 4gb

let
  user = "cpli";

in

{
  imports = [
    ./hardware.nix
    ./networking.nix
    ./ssh.nix
    # ./wireguard.nix
    # ./mpd.nix
    # ./server.nix
  ];

  nix.maxJobs = lib.mkDefault 4;

  # filesystems."/mnt/adinf" = {
  #   device = "/dev/sda1";
  #   fsType = "ext4";
  #   options = [
  #     "nofail"
  #     "umask=0755"
  #     "uid=${user}"
  #     "gid=wheel"
  #   ];
  # };

  users.users = {
    "root" = {
      password = "ETAisq";
    };
    "${user}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      password = "ETAisq";
    };
  };
}
