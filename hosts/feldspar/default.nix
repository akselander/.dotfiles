{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix

    ../common/global
    ../common/users/akselander

    ../common/optional/nuke-root.nix
    ../common/optional/greetd.nix
    ../common/optional/pipewire.nix
    ../common/optional/quietboot.nix
    ../common/optional/bluetooth.nix
  ];

  networking = {
    hostName = "feldspar";
    networkmanager.enable = true;
  };

  services.vrising-server = {
    enable = true;
    openFirewall = true;
    game = {
      DeathContainerPermission = "ClanMembers";
      GameDifficulty = 2;
      ClanSize = 10;
      PlayerDamageMode = "Always";
      CastleDamageMode = "Never";
      SunDamageModifier = 1.0;
      BloodDrainModifier = 1.0;
      UnitStatModifiers_Global = {
        MaxHealthModifier = 1.0;
        PowerModifier = 1.4;
      };
      UnitStatModifiers_VBlood = {
        MaxHealthModifier = 1.25;
        PowerModifier = 1.7;
        LevelIncrease = 3;
      };
      DropTableModifier_General = 1.25;
      DurabilityDrainModifier = 0.5;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };

  # Loads nvidia driver for bothj X and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  programs = {
    dconf.enable = true;
  };

  hardware = {
    nvidia = {
      prime.offload.enable = false;
      modesetting.enable = true;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
