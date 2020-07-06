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
    ./nfs.nix
    ./wireguard.nix
    # ./mpd.nix
    # ./server.nix
  ];

  users.users = {
    # FIXME: doesn't set root pswrd
    "root" = { password = "ETAisq"; };
    "${user}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      password = "ETAisq";
    };
  };

  # the 'Broadcom BCM2711' is an armv8, 64-bit, quad core cpu
  nix.maxJobs = lib.mkDefault 4;

  # personal media harddrive
  fileSystems."/mnt/gravi" = {
    device = "/dev/sda1";
    fsType = "ext4";
    options = [ "nofail" ];
  };
}
