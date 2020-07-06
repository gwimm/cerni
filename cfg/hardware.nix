{ config, pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;

    initrd = {
      availableKernelModules = [ "usbhid" ];
    };

    loader = {
      # grub does not support arm at all
      # override nixos' default value of 'true'
      grub.enable = false;

      # generationsDir.enable = false;

      # rpi4b 4g
      raspberryPi = {
        enable = true;
        version = 4;

        # U-Boot is currently not supported on rpi4
        # https://github.com/NixOS/nixpkgs/issues/63720
        # uboot.enable = true;

        # supposedly required for audio output and gpu configuration
        # firmwareConfig = ''
          # dtparam=audio=on
          # gpu_mem=192
          # start_x=1
          # gpu_mem=256
        # '';
      };
    };
  };

  hardware = {
    deviceTree = {
      base = pkgs.device-tree_rpi;
      overlays = [ "${pkgs.device-tree_rpi.overlays}/vc4-fkms-v3d.dtbo" ];
    };

    # currently unnecessary, required for video later
    # opengl = {
    #   enable = true;
    #   setLdLibraryPath = true;
    #   package = pkgs.mesa_drivers;
    # };
  };

  fileSystems = {
    # I don't know if i much enjoy mounting by label
    # if "/boot" is disabled and removed, the root partition unambiguously
    # becomes '/dev/mmcblk0p1', letting us use that identifier instead
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };

    # the "/boot" partition doesn't seem to be required
    # https://nixos.wiki/wiki/NixOS_on_ARM#Disable_use_of_.2Fboot_partition
    "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
    };
  };

  swapDevices = [{
    device = "/tmp/swapfile";
    size = 2048;
  }];
}
