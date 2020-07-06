{ config, pkgs, lib, ... }:

{
  boot = {
    kernelModules = [ ];
    extraModulePackages = [ ];

    kernelPackages = pkgs.linuxPackages_rpi4;

    initrd = {
      availableKernelModules = [ "usbhid" ];
      kernelModules = [ ];
    };

    loader = {
      grub.enable = false;
      # generationsDir.enable = false;

      raspberryPi = {
        enable = true;
        version = 4;
        uboot.enable = true;
        # firmwareConfig = ''
          # dtparam=audio=on
          # gpu_mem=192
          # start_x=1
          # gpu_mem=256
        # '';
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
    };
  };

  swapDevices = [{
    device = "/tmp/swapfile";
    size = 2048;
  }];

  hardware = {
    opengl = {
      enable = true;
      setLdLibraryPath = true;
      package = pkgs.mesa_drivers;
    };

    deviceTree = {
      base = pkgs.device-tree_rpi;
      overlays = [ "${pkgs.device-tree_rpi.overlays}/vc4-fkms-v3d.dtbo" ];
    };
  };
}
