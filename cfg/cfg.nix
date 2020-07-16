{ config, pkgs, lib, ... }:

# cerni's config
# aarch64 armv7 rpi 4b 4gb

let
  user = "cpli";

in

{
  imports = [
    ./net.nix
    ./ssh.nix
    # ./nfs.nix
    # ./mpd.nix
    ./hw.nix
    ./wg.nix
  ];

  nix = {
    # the 'Broadcom BCM2711' is an armv8, 64-bit, quad core cpu
    maxJobs = lib.mkDefault 4;

    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  users.users = {
    # FIXME: doesn't set root pswrd
    "root" = { password = "ETAisq"; };
    "${user}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      password = "ETAisq";
    };
  };

  # personal media harddrive
  # fileSystems."/mnt/gravi" = {
  #   device = "/dev/sda1";
  #   fsType = "ext4";
  #   options = [ "nofail" ];
  # };
}
