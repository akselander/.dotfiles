{
  config,
  lib,
  inputs,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.disko.nixosModules.default
    ./disko.nix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
    extraModulePackages = [];
    initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "usbhid" "sd_mod"];
    initrd.kernelModules = ["dm-snapshot"];
    kernelModules = ["kvm-amd"];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
