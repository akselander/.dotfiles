{
  modulesPath,
  lib,
  ...
}: {
  imports = [
    (import ../common/optional/disko.nix {device = "/dev/sda";})
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform.system = "x86_64-linux";
}
