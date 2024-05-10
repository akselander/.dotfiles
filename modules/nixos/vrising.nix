{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  settings = {
    GameDifficulty = "2";
    GameModeType = "PvP";
    CastleDamageMode = "Never";
    SiegeWeaponHealth = "Normal";
    PlayerDamageMode = "Always";
    CastleHeartDamageMode = "CanBeDestroyedOnlyWhenDecaying";
    PvPProtectionMode = "Medium";
    DeathContainerPermission = "ClanMembers";
    RelicSpawnType = "Plentiful";
    CanLootEnemyContainers = false;
    BloodBoundEquipment = true;
    TeleportBoundItems = true;
    BatBoundItems = false;
    AllowGlobalChat = true;
    AllWaypointsUnlocked = false;
    FreeCastleRaid = false;
    FreeCastleClaim = false;
    FreeCastleDestroy = false;
    InactivityKillEnabled = true;
    InactivityKillTimeMin = 3600;
    InactivityKillTimeMax = 604800;
    InactivityKillSafeTimeAddition = 172800;
    InactivityKillTimerMaxItemLevel = 84;
    StartingProgressionLevel = 0;
    DisableDisconnectedDeadEnabled = true;
    DisableDisconnectedDeadTimer = 60;
    DisconnectedSunImmunityTime = 300.0;
    InventoryStacksModifier = 1.0;
    DropTableModifier_General = 1.25;
    DropTableModifier_Missions = 1.0;
    MaterialYieldModifier_Global = 1.0;
    BloodEssenceYieldModifier = 1.0;
    JournalVBloodSourceUnitMaxDistance = 25.0;
    PvPVampireRespawnModifier = 1.0;
    CastleMinimumDistanceInFloors = 2;
    ClanSize = 10;
    BloodDrainModifier = 1.0;
    DurabilityDrainModifier = 0.5;
    GarlicAreaStrengthModifier = 1.0;
    HolyAreaStrengthModifier = 1.0;
    SilverStrengthModifier = 1.0;
    SunDamageModifier = 1.0;
    CastleDecayRateModifier = 1.0;
    CastleBloodEssenceDrainModifier = 1.0;
    CastleSiegeTimer = 420.0;
    CastleUnderAttackTimer = 60.0;
    CastleRaidTimer = 600.0;
    CastleRaidProtectionTime = 1800.0;
    CastleExposedFreeClaimTimer = 300.0;
    CastleRelocationCooldown = 10800.0;
    CastleRelocationEnabled = true;
    AnnounceSiegeWeaponSpawn = false;
    ShowSiegeWeaponMapIcon = false;
    BuildCostModifier = 1.0;
    RecipeCostModifier = 1.0;
    CraftRateModifier = 1.0;
    ResearchCostModifier = 1.0;
    RefinementCostModifier = 1.0;
    RefinementRateModifier = 1.0;
    ResearchTimeModifier = 1.0;
    DismantleResourceModifier = 1.0;
    ServantConvertRateModifier = 1.0;
    RepairCostModifier = 1.0;
    Death_DurabilityFactorLoss = 0.0;
    Death_DurabilityLossFactorAsResources = 0.0;
    StarterEquipmentId = 0;
    StarterResourcesId = 0;
    VBloodUnitSettings = [];
    UnlockedAchievements = [];
    UnlockedResearchs = [];
    GameTimeModifiers = {
      DayDurationInSeconds = 1080.0;
      DayStartHour = 9;
      DayStartMinute = 0;
      DayEndHour = 17;
      DayEndMinute = 0;
      BloodMoonFrequency_Min = 10;
      BloodMoonFrequency_Max = 18;
      BloodMoonBuff = 0.2;
    };
    VampireStatModifiers = {
      MaxHealthModifier = 1.0;
      PhysicalPowerModifier = 1.0;
      SpellPowerModifier = 1.0;
      ResourcePowerModifier = 1.0;
      SiegePowerModifier = 1.0;
      DamageReceivedModifier = 1.0;
      ReviveCancelDelay = 5.0;
    };
    UnitStatModifiers_Global = {
      MaxHealthModifier = 1.0;
      PowerModifier = 1.4;
      LevelIncrease = 0;
    };
    UnitStatModifiers_VBlood = {
      MaxHealthModifier = 1.25;
      PowerModifier = 1.7;
      LevelIncrease = 3;
    };
    EquipmentStatModifiers_Global = {
      MaxHealthModifier = 1.0;
      ResourceYieldModifier = 1.0;
      PhysicalPowerModifier = 1.0;
      SpellPowerModifier = 1.0;
      SiegePowerModifier = 1.0;
      MovementSpeedModifier = 1.0;
    };
    CastleStatModifiers_Global = {
      TickPeriod = 5.0;
      SafetyBoxLimit = 1;
      EyeStructuresLimit = 1;
      TombLimit = 12;
      VerminNestLimit = 4;
      PrisonCellLimit = 16;
      HeartLimits = {
        Level1 = {
          FloorLimit = 50;
          ServantLimit = 4;
          BuildLimits = 2;
          HeightLimit = 3;
        };
        Level2 = {
          FloorLimit = 140;
          ServantLimit = 5;
          BuildLimits = 2;
          HeightLimit = 3;
        };
        Level3 = {
          FloorLimit = 240;
          ServantLimit = 6;
          BuildLimits = 2;
          HeightLimit = 3;
        };
        Level4 = {
          FloorLimit = 360;
          ServantLimit = 7;
          BuildLimits = 2;
          HeightLimit = 3;
        };
        Level5 = {
          FloorLimit = 550;
          ServantLimit = 8;
          BuildLimits = 2;
          HeightLimit = 3;
        };
      };
      CastleLimit = 2;
      NetherGateLimit = 1;
      ThroneOfDarknessLimit = 1;
    };
    PlayerInteractionSettings = {
      TimeZone = "Local";
      VSPlayerWeekdayTime = {
        StartHour = 20;
        StartMinute = 0;
        EndHour = 22;
        EndMinute = 0;
      };
      VSPlayerWeekendTime = {
        StartHour = 20;
        StartMinute = 0;
        EndHour = 22;
        EndMinute = 0;
      };
      VSCastleWeekdayTime = {
        StartHour = 20;
        StartMinute = 0;
        EndHour = 22;
        EndMinute = 0;
      };
      VSCastleWeekendTime = {
        StartHour = 20;
        StartMinute = 0;
        EndHour = 22;
        EndMinute = 0;
      };
    };
    TraderModifiers = {
      StockModifier = 1.0;
      PriceModifier = 1.0;
      RestockTimerModifier = 1.0;
    };
    WarEventGameSettings = {
      Interval = 1;
      MajorDuration = 1;
      MinorDuration = 1;
      WeekdayTime = {
        StartHour = 0;
        StartMinute = 0;
        EndHour = 23;
        EndMinute = 59;
      };
      WeekendTime = {
        StartHour = 0;
        StartMinute = 0;
        EndHour = 23;
        EndMinute = 59;
      };
      ScalingPlayers1 = {
        PointsModifier = 1.0;
        DropModifier = 1.0;
      };
      ScalingPlayers2 = {
        PointsModifier = 0.5;
        DropModifier = 0.5;
      };
      ScalingPlayers3 = {
        PointsModifier = 0.25;
        DropModifier = 0.25;
      };
      ScalingPlayers4 = {
        PointsModifier = 0.25;
        DropModifier = 0.25;
      };
    };
  };
  settingsFile = pkgs.writeText "settings.json" (builtins.toJSON settings);

  cfg = config.services.vrising-server;
  wine = pkgs.wine.override {wineBuild = "wine64";};
  shutdownScript =
    pkgs.writeShellScript "shutdown"
    ''
      PID=$(pgrep -f '^Z:\\var\\lib\\vrising\\server\\VRisingServer.exe')
      echo "Stopping PID: $PID"
      kill -SIGINT $PID

      # systemd will eventually kill this if it doesnt work after 90s
      while true; do
          sleep 1
          echo "Looking for VRising PID"
          PID=$(pgrep -f '^Z:\\var\\lib\\vrising\\server\\VRisingServer.exe')
          if [ -z "$PID" ]; then
              echo "Process successfully stopped gracefully"
              echo "Killing any leftover wine processes"
              wineserver -k
              sleep 1
              exit
          fi
          sleep 1
      done
    '';
in {
  options.services.vrising-server = {
    enable = mkEnableOption "V Rising Dedicated Server";

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open ports in the firewall for the server
      '';
    };

    serverName = mkOption {
      type = types.str;
      default = "V Rising Game Server";
      description = ''
        Name of the server. The name that shows up in server list.
      '';
    };
    serverPort = mkOption {
      type = types.int;
      default = 21370;
      description = ''
        UDP port for game traffic.
      '';
    };
    queryPort = mkOption {
      type = types.int;
      default = 21371;
      description = ''
        UDP port for game traffic.
      '';
    };
    saveName = mkOption {
      type = types.str;
      default = "world1";
      description = ''
        Name of save file/directory. Must be a valid directory name.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.vrising-server = let
      steamcmd = "${pkgs.steamcmd}/bin/steamcmd";
    in {
      description = "V Rising Dedicated Server";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      serviceConfig = {
        ExecStart = ''
          ${pkgs.xvfb-run}/bin/xvfb-run --server-args="-screen 0 1024x768x16" \
          ${wine}/bin/wine64 /var/lib/vrising/server/VRisingServer.exe \
            -persistentDataPath Z:/var/lib/vrising/data \
            -serverName ${cfg.serverName} \
            -gamePort ${toString cfg.serverPort} \
            -queryPort ${toString cfg.queryPort} \
            -lowerFPSWhenEmpty true \
            -password kremowka \
            -saveName ${cfg.saveName}
        '';
        ExecStop = "${pkgs.bash}/bin/bash ${shutdownScript}";
        Restart = "on-failure";
        RestartSec = "5";
        User = "vrising";
        WorkingDirectory = "/var/lib/vrising";
      };

      preStart = ''
               ${steamcmd} +@sSteamCmdForcePlatformType windows +force_install_dir "/var/lib/vrising/server" +login anonymous +app_update 1829350 validate +quit
        mkdir -p /var/lib/vrising/server/Settings
        rm -f /var/lib/vrising/data/Settings/ServerGameSettings.json
        ln -s ${settingsFile} /var/lib/vrising/data/Settings/ServerGameSettings.json
      '';
    };

    users.users.vrising = {
      description = "V Rising server service user";
      home = "/var/lib/vrising";
      createHome = true;
      isSystemUser = true;
      group = "vrising";
    };
    users.groups.vrising = {};

    networking.firewall = mkIf cfg.openFirewall {
      allowedUDPPorts = [
        cfg.serverPort
        cfg.queryPort
      ];
    };
  };
}
