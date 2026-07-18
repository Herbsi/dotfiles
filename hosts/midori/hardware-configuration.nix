# Layout created manually during install (rescue system):
# 1 MiB BIOS boot partition + ext4 root on /dev/sda.
# Verify the initrd modules with `nixos-generate-config` on the
# server after install; do not blindly overwrite this file.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "sd_mod"
    "virtio_blk"
    "virtio_scsi"
    "virtio_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
