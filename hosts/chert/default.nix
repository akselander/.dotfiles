{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/akselander
  ];

  impermanence.nukeRoot.enable = true;

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
      CastleStatModifiers_Global = {
        CastleLimit = 8;
        HeartLimits = {
          Level3 = {
            FloorLimit = 360;
          };
          Level4 = {
            FloorLimit = 550;
            HeightLimit = 5;
          };
          Level5 = {
            FloorLimit = 1000;
            HeightLimit = 6;
          };
        };
      };
      DropTableModifier_General = 1.25;
      DurabilityDrainModifier = 0.5;
    };
  };

  networking = {
    hostName = "chert";
    networkmanager.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
