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

  nixpkgs.overlays = [(self: super: {
    urbit = super.urbit.override {
      version = "0.10.7";

      src = fetchFromGitHub {
        owner = "urbit";
        repo = "urbit";

        # "271abcd3e76cc0a3d7d37b4efdfe3d73c62a1e0b";
        rev = "${pname}-v${version}";

        sha256 = "1w61w48173pd9gfx4ghf9c4bbjy3hkhdzh778igsv974r29bagrr";
        fetchSubmodules = true;
      };
    };
  })];
}
