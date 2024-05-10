{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
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

    server = {
      serverName = mkOption {
        type = types.str;
        default = "V Rising Game Server";
        description = ''
          Name of the server. The name that shows up in server list.
        '';
      };
      port = mkOption {
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

    game = {
      GameDifficulty = mkOption {
        type = types.int;
        default = 1;
        description = ''
          Difficulty level of the game.
        '';
        example = ''
          * 0 - Easy
          * 1 - Normal
          * 2 - Brutal
        '';
      };
      GameModeType = mkOption {
        type = types.str;
        default = "PvP";
        description = ''
          Defines basics for PvP Gamemode
        '';
        example = ''
          * PvP
          * PvE
        '';
      };
      CastleDamageMode = mkOption {
        type = types.str;
        default = "Always";
        description = ''
          Defines when players can deal damage to enemy castle structures.
        '';
        example = ''
          * Never - Players may never deal damage to enemy castle structures
          * Always - Players may always deal damage to enemy castle structures
          * TimeRestricted - Players may only damage enemy castle structures during certain real-time frames
        '';
      };
      SiegeWeaponHealth = mkOption {
        type = types.str;
        default = "Normal";
        description = ''
          Setting for Siege Golem Health
        '';
        example = ''
          * VeryLow - 500
          * Low - 500
          * Normal - 1500
          * High - 2000
          * VeryHigh - 2500
        '';
      };
      PlayerDamageMode = mkOption {
        type = types.str;
        default = "Always";
        description = ''
          Setting for when players can damage other players (Disabled in PvE)
        '';
        example = ''
          * Always - Players can always deal damage to other playres
          * TimeRestrictged - Players may only damage other players during certain real-time frames
        '';
      };
      CastleHeartDamageMode = mkOption {
        type = types.str;
        default = "CanBeDestroyedOnlyWhenDecaying";
        description = ''
          Defines interactions with enemy Castle Hearts
        '';
        example = ''
          * Always - Players can always deal damage to other playres
          * TimeRestrictged - Players may only damage other players during certain real-time frames
          * CanBeDestroyedOnlyWhenDecaying - Players may only destroy enemy castle hearts when the Castle Heart is in Decay
          * CanBeDestroyedByPlayers - Players may destroy enemy castle hearts using "key" items in the game
          * CanBeSeizedOrDestroyedByPlayers - Players may destroy and seize control of enemy castle hearts using "key" items in the game
        '';
      };
      PvPProtectionMode = mkOption {
        type = types.str;
        default = "Short";
        description = ''
          The duration where players cannot be damage by other players when joining a PvP server in seconds
        '';
        example = ''
          * Disabled - 0
          * VeryShort - 900
          * Short - 1800
          * Medium - 3600
          * Long - 7200
        '';
      };
      DeathContainerPermission = mkOption {
        type = types.str;
        default = "Anyone";
        description = ''
          Defines who may loot the body when a player dies
        '';
        example = ''
          * Anyone - Everyone can loot the body
          * ClanMembers - Only self and Clan members may loot the body
          * OnlySelf - Only self may loot the body
        '';
      };
      RelicSpawnType = mkOption {
        type = types.str;
        default = "Unique";
        description = ''
          Defines if soul shard items are unique (only one of each per server) or if a new one spawn everytime a soul shard boss is slain
        '';
        example = ''
          * Unique - Soul shards are unique - only one of each type may exist at a time on the server
          * Plentiful - Soul shards are plentiful - a new one is dropped everytime a soul shard boss is slain
        '';
      };
      CanLootEnemyContainers = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If players may loot enemy stashes, containers, and crafting stations
        '';
      };
      BloodBoundEquipment = mkOption {
        type = types.bool;
        default = true;
        description = ''
          When enabled, most equipment will not be dropped upon death.
        '';
      };
      TeleportBoundItems = mkOption {
        type = types.bool;
        default = true;
        description = ''
          When enabled, some items will prevent you from using waygates.
        '';
      };
      BatBoundItems = mkOption {
        type = types.bool;
        default = false;
        description = ''
          When enabled, some items will prevent you from becoming a bat.
        '';
      };
      AllowGlobalChat = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Allow players to write messages that all players on the server can read.
        '';
      };
      AllWaypointsUnlocked = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Do NOT change this it does not work and breaks the game atm
        '';
      };
      FreeCastleRaid = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Raiding an enemy player castle heart requires no materials.
        '';
      };
      FreeCastleClaim = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Seizing an enemy player castle heart requires no materials.
        '';
      };
      FreeCastleDestroy = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Destroying an enemy player castle heart requires no materials.
        '';
      };
      InactivityKillEnabled = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Inactive players are automatically killed after a set duration
        '';
      };
      InactivityKillTimeMin = mkOption {
        type = types.int;
        default = 3600;
        description = ''
          Minimum timer before inactive player is killed in seconds based on gear level
        '';
        example = ''
          Value in range [0, max).
        '';
      };
      InactivityKillTimeMax = mkOption {
        type = types.int;
        default = 604800;
        description = ''
          Minimum timer before inactive player is killed in seconds based on gear level
        '';
        example = ''
          No min/max.
        '';
      };
      InactivityKillTimeSafeAddition = mkOption {
        type = types.int;
        default = 172800;
        description = ''
          Additional time before an inactive player is killed in seconds when standing in a castle territory
        '';
        example = ''
          No min/max.
        '';
      };
      InactivityKillTimerMaxItemLevel = mkOption {
        type = types.int;
        default = 84;
        description = ''
          The maximum gear level that the inactivity min and max timers are based on from 1 - this value
        '';
        example = ''
          No min/max.
        '';
      };
      StartingProgressionLevel = mkOption {
        type = types.int;
        default = 0;
      };
      DisableDisconnectedDeadEnabled = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If dead disconnected players are disabled
        '';
      };
      DisableDisconnectedDeadTimer = mkOption {
        type = types.int;
        default = 60;
        description = ''
          The time for a disconnected dead player to become disabled
        '';
      };
      DisconnectedSunImmunityTime = mkOption {
        type = types.int;
        default = 300;
      };
      InventoryStacksModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Multiplies the amount of items that can be combined into a single stack.
        '';
        example = ''
          Value in range [0.25, 5]
        '';
      };
      DropTableModifier_General = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Multiplies all droptables with this factor granting more or less drops from kills and chests
        '';
        example = ''
          Value in range [0.25, 5]
        '';
      };
      DropTableModifier_Missions = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Multiplies the amount of loot received from successful servant hunts.
        '';
        example = ''
          Value in range [0.25, 5]
        '';
      };
      MaterialYieldModifier_Global = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Mulitiplies the amount of materials received from harvesting resource
          nodes.
        '';
        example = ''
          Value in range [0.25, 5]
        '';
      };
      BloodEssenceYieldModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Multiplies the amount of blood essence received from defeating enemies.
          Value in range [0.25, 5]
        '';
      };
      JournalVBloodSourceUnitMaxDistance = mkOption {
        type = types.float;
        default = 25.0;
        description = ''
          NOT USED
        '';
      };
      PvPVampireRespawnModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Multiplies the additional respawn duration players suffer from being
          slain in PvP.
        '';
        example = ''
          Value in range [0, 5]
        '';
      };
      CastleMinimumDistanceInFloors = mkOption {
        type = types.int;
        default = 2;
        description = ''
          The number of minimum tiles where placers can place a castle heart
          and/or floors next to another heart.
        '';
        example = ''
          Value in range [1, 10]
        '';
      };
      ClanSize = mkOption {
        type = types.int;
        default = 4;
        description = ''
          The number of players that can join a single clan. Players in a clan
          can rise together, share progress and build castles together.
        '';
        example = ''
          Value in range [1, 10]
        '';
      };
      BloodDrainModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Rate for how quickly players loose blood. A higher rate results in
          higher blood consumption.
        '';
        example = ''
          Value in range [0, 5]
        '';
      };
      DurabilityDrainModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Multiplies the amount of durability suffered from dealing or receiving
          damage.
        '';
        example = ''
          Value in range [0, 5]
        '';
      };
      GarlicAreaStrengthModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Affects the rate of how quickly garlic stack when exposed.
        '';
        example = ''
          Value in range [0, 5]
        '';
      };
      HolyAreaStrengthModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Multiplies the effect of the Holy element.
        '';
        example = ''
          Value in range [0, 5]
        '';
      };
      SilverStrengthModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Affects the damage received when carrying silver items.
        '';
        example = ''
          Value in range [0, 5]
        '';
      };
      SunDamageModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Affects the duration a player may stand in the sun before starting to
          take damage.
        '';
        example = ''
          Value in range [0, 5]
        '';
      };
      CastleDecayRateModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Rate for how quickly a castle deteriorate when the castle heart has
          run out of Blood Essence.
        '';
        example = ''
          Value in range [0, 5]
        '';
      };
      CastleBloodEssenceDrainModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Rate for how quickly a castle consumes blood essence. A higher rate
          results in higher blood essence consumption.
        '';
        example = ''
          Value in range [0.1, 5]
        '';
      };
      CastleSiegeTimer = mkOption {
        type = types.float;
        default = 420.0;
        description = ''
          The amount of time a castle is deemed as breached when enemy players
          breaks through the outer defenses. Players may not construct new
          structures or walls while a castle is breached and all structures are
          susceptible  to damage while in this state. Time is defined in seconds.
        '';
        example = ''
          Value in range [1, 1800]
        '';
      };
      CastleUnderAttackTimer = mkOption {
        type = types.float;
        default = 60.0;
        description = ''
          The amount of time where players are blocked from building structures
          or walls while being under attack. A castle is deemed under attack
          whenever enemy players manages to deal damage to any wall or door
          using explosives or siege golems.
        '';
        example = ''
          Value in range [1, 180]
        '';
      };
      CastleRaidTimer = mkOption {
        type = types.float;
        default = 600.0;
      };
      CastleRaidProtectionTime = mkOption {
        type = types.float;
        default = 60.0;
      };
      CastleExposedFreeClaimTimer = mkOption {
        type = types.float;
        default = 300.0;
      };
      CastleRelocationCooldown = mkOption {
        type = types.float;
        default = 10800.0;
      };
      CastleRelocationEnabled = mkOption {
        type = types.bool;
        default = true;
      };
      AnnounceSiegeWeaponSpawn = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Shows a system message in the chat when a Siege Golem is being summoned.
        '';
      };
      ShowSiegeWeaponMapIcon = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Show Siege Golems on the big map.
        '';
      };
      BuildCostModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Multiplies the amount of materials required to build structures.
        '';
        example = ''
          Value in range [0, 10]
        '';
      };
      RecipeCostModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Multiplies the cost of crafting items.
        '';
        example = ''
          Value in range [0, 10]
        '';
      };
      CraftRateModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          The rate for crafting items and equipment in crafting stations,
          a higher rate results in more rapid crafting (not refinement stations)
        '';
        example = ''
          Value in range [0.1, 10]
        '';
      };
      ResearchCostModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Unused Modifier for Research
        '';
        example = ''
          Value in range [0.1, 10]
        '';
      };
      RefinementCostModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Multiplies the cost of refining items.
        '';
        example = ''
          Value in range [0.1, 10]
        '';
      };
      RefinementRateModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Rate for how quickly materials are refined. A higher rate result in
          more rapid refinement.
        '';
        example = ''
          Value in range [0.1, 10]
        '';
      };
      ResearchTimeModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Unused Modifier for Research
        '';
        example = ''
          Value in range [0.1, 10]
        '';
      };
      DismantleResourceModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          The material reimbursement players receive from dismantling a structure.
        '';
        example = ''
          Value in range [0, 1]
        '';
      };
      ServantConvertRateModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Rate for how quickly humans turn into servants. A higher rate result
          in more rapid conversion.
        '';
        example = ''
          Value in range [0.1, 20]
        '';
      };
      RepairCostModifier = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Modifies the cost for repairing an item
        '';
        example = ''
          Value in range [0, 10]
        '';
      };
      Death_DurabilityFactorLoss = mkOption {
        type = types.float;
        default = 0.125;
        description = ''
          The amount of durability loss that equipment suffer upon death when
          defeated in PvP. Players are deemed as in PvP for a duration after dealing damage to another player or receiving damage from another player.
        '';
        example = ''
          Value in range [0, 1.0]
        '';
      };
      Death_DurabilityLossFactorAsResources = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Durability loss suffered upon death is dropped as materials. This
          value defines the amount of materials that are either lost or dropped.
          A value of 0 results in all materials being lost while a value of 1 results in all materials being dropped.
        '';
        example = ''
          Value in range [0, 1.0]
        '';
      };
      GameTimeModifiers = {
        DayDurationInSeconds = mkOption {
          type = types.int;
          default = 1080;
          description = ''
            The duration of an ingame day in seconds
          '';
          example = ''
            Value in range [60, 86400]
          '';
        };
        DayStartHour = mkOption {
          type = types.int;
          default = 9;
          description = ''
            The starting hour of the ingame day
          '';
          example = ''
            Value in range [0, 25]
          '';
        };
        DayStartMinute = mkOption {
          type = types.int;
          default = 0;
          description = ''
            The starting minute of the ingame day
          '';
          example = ''
            Value in range [0, 60]
          '';
        };
        DayEndHour = mkOption {
          type = types.int;
          default = 17;
          description = ''
            The end hour of the ingame day
          '';
          example = ''
            Value in range [0, 24]
          '';
        };
        DayEndMinute = mkOption {
          type = types.int;
          default = 9;
          description = ''
            The end minute of the ingame day
          '';
          example = ''
            Value in range [0, 24]
          '';
        };
        BloodMoonFrequency_Min = mkOption {
          type = types.int;
          default = 10;
          description = ''
            The minimum frequence for how often a blood mon may occur
          '';
          example = ''
            Value in range [1, 255]
          '';
        };
        BloodMoonFrequency_Max = mkOption {
          type = types.int;
          default = 18;
          description = ''
            The maximum frequence for how often a blood mon may occur
          '';
          example = ''
            Value in range [1, 255]
          '';
        };
        BloodMoonBuff = mkOption {
          type = types.float;
          default = 0.2;
          description = ''
            The amount of additional movement speed in % that a player gain
            during blood moon
          '';
          example = ''
            Value in range [0.1, 1]
          '';
        };
      };
      VampireStatModifiers = {
        MaxHealthModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Multiplies the maximum amount of health.
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        MaxEnergyModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Unused modifier
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        PhysicalPowerModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Multiplies players physical power, this value affects the amount of
            damage players deal using weapon attacks and weapon skills.
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        SpellPowerModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Multiplies players spell power, this value affects the amount of
            damage and healing players deal using spells.
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        ResourcePowerModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Multiplies the amount of damage players deal to resource objects.
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        SiegePowerModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Unused modifier
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        DamageReceivedModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Multiplies any damage received.
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        ReviveCancelDelay = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Do not change this modifier
          '';
        };
      };
      UnitStatModifiers_Global = {
        DamageReceivedModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Multiplies any damage received.
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        MaxHealthModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Multiplies the maximum amount of health of standard units
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        PowerModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Multiplies the damage output of standard units
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        LevelIncrease = mkOption {
          type = types.int;
          default = 0;
        };
      };
      UnitStatModifiers_VBlood = {
        MaxHealthModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Multiplies the maximum amount of health of V Blood units
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        PowerModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Multiplies the damage output of V Blood units
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        LevelIncrease = mkOption {
          type = types.int;
          default = 0;
        };
      };
      EquipmentStatModifiers_Global = {
        MaxEnergyModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Unused modifier
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        MaxHealthModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Multiplies the amount of health received from equipment
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        ResourceYieldModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Multiplies the resource yield modifiers from equipment
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        PhysicalPowerModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Multiplies the physical power gained from equipment, this value affects
            the amount of damage players deal using weapon attacks and weapon skills.
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        SpellPowerModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Multiplies the amount of spell power gained from equipment, this value
            affects the amount of damage and healing players deal using spells.
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        SiegePowerModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Unused modifier.
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
        MovementSpeedModifier = mkOption {
          type = types.float;
          default = 1.0;
          description = ''
            Multiplies the amount of movement speed players gain from equipment
            that affects movement speed
          '';
          example = ''
            Value in range [0.1, 5]
          '';
        };
      };
      CastleStatModifiers_Global = {
        TickPeriod = mkOption {
          type = types.int;
          default = 5;
          description = ''
            How often the castle decay damage should tick
          '';
        };
        DamageResistance = mkOption {
          type = types.int;
          default = 0;
          description = ''
            Not used
          '';
        };
        SafetyBoxLimit = mkOption {
          type = types.int;
          default = 1;
          description = ''
            The number of vampire lockboxes players may build in a single castle.
          '';
          example = ''
            Value in range [0, 20]
          '';
        };
        TombLimit = mkOption {
          type = types.int;
          default = 12;
          description = ''
            The number of tombs players may build in a single castle.
          '';
          example = ''
            Value in range [1, 20]
          '';
        };
        VerminNestLimit = mkOption {
          type = types.int;
          default = 4;
          description = ''
            The number of vermin nests players may build in a single castle.
          '';
          example = ''
            Value in range [1, 20]
          '';
        };
        CastleLimit = mkOption {
          type = types.int;
          default = 2;
          description = ''
            The number of castle hearts a single player is allowed to construct
          '';
          example = ''
            Value in range [1, 5]
          '';
        };
        NetherGateLimit = mkOption {
          type = types.int;
          default = 1;
        };
        ThroneOfDarknessLimit = mkOption {
          type = types.int;
          default = 1;
        };
        HeartLimits = {
          Level1 = {
            FloorLimit = mkOption {
              type = types.int;
              default = 30;
              description = ''
                Defines the number of borders and castle floors that players may build in each castle.
              '';
            };
            ServantLimit = mkOption {
              type = types.int;
              default = 3;
              description = ''
                The number of servant coffins players may build in a single castle.
              '';
              example = ''
                Value in range [1, 20]
              '';
            };
            BuildLimits = mkOption {
              type = types.int;
              default = 2;
            };
            HeightLimit = mkOption {
              type = types.int;
              default = 3;
            };
          };
          Level2 = {
            FloorLimit = mkOption {
              type = types.int;
              default = 140;
              description = ''
                Defines the number of borders and castle floors that players may build in each castle.
              '';
            };
            ServantLimit = mkOption {
              type = types.int;
              default = 5;
              description = ''
                The number of servant coffins players may build in a single castle.
              '';
              example = ''
                Value in range [1, 20]
              '';
            };
            BuildLimits = mkOption {
              type = types.int;
              default = 2;
            };
            HeightLimit = mkOption {
              type = types.int;
              default = 3;
            };
          };
          Level3 = {
            FloorLimit = mkOption {
              type = types.int;
              default = 240;
              description = ''
                Defines the number of borders and castle floors that players may build in each castle.
              '';
            };
            ServantLimit = mkOption {
              type = types.int;
              default = 6;
              description = ''
                The number of servant coffins players may build in a single castle.
              '';
              example = ''
                Value in range [1, 20]
              '';
            };
            BuildLimits = mkOption {
              type = types.int;
              default = 2;
            };
            HeightLimit = mkOption {
              type = types.int;
              default = 3;
            };
          };
          Level4 = {
            FloorLimit = mkOption {
              type = types.int;
              default = 360;
              description = ''
                Defines the number of borders and castle floors that players may build in each castle.
              '';
            };
            ServantLimit = mkOption {
              type = types.int;
              default = 7;
              description = ''
                The number of servant coffins players may build in a single castle.
              '';
              example = ''
                Value in range [1, 20]
              '';
            };
            BuildLimits = mkOption {
              type = types.int;
              default = 2;
            };
            HeightLimit = mkOption {
              type = types.int;
              default = 3;
            };
          };
          Level5 = {
            FloorLimit = mkOption {
              type = types.int;
              default = 550;
              description = ''
                Defines the number of borders and castle floors that players may build in each castle.
              '';
            };
            ServantLimit = mkOption {
              type = types.int;
              default = 8;
              description = ''
                The number of servant coffins players may build in a single castle.
              '';
              example = ''
                Value in range [1, 20]
              '';
            };
            BuildLimits = mkOption {
              type = types.int;
              default = 2;
            };
            HeightLimit = mkOption {
              type = types.int;
              default = 3;
            };
          };
        };
      };
      PlayerInteractionSettings = {
        TimeZone = mkOption {
          type = types.str;
          default = "Local";
          description = ''
            Player & Castle Interactions
          '';
          example = ''
            * PST - Pacific Standard Time, UTC -8
            * CET - Central European Time, UTC +1
            * CST - China Standard Time, UTC +8
          '';
        };
        VSPlayerWeekdayTime = {
          StartHour = mkOption {
            type = types.int;
            default = 20;
            description = ''
              The real time starting hour for activating Player vs Player PvP during standard weekdays
            '';
            example = ''
              Value in range [0, 24]
            '';
          };
          StartMinute = mkOption {
            type = types.int;
            default = 0;
            description = ''
              The real time starting minute for activating Player vs Player PvP during standard weekdays
            '';
            example = ''
              Value in range [0, 60]
            '';
          };
          EndHour = mkOption {
            type = types.int;
            default = 22;
            description = ''
              The real time ending hour for deactivating Player vs Player PvP during standard weekdays
            '';
            example = ''
              Value in range [0, 24]
            '';
          };
          EndMinute = mkOption {
            type = types.int;
            default = 0;
            description = ''
              The real time end minute for deactivating Player vs Player PVP during standard weekdays
            '';
            example = ''
              Value in range [0, 60]
            '';
          };
        };
        VSPlayerWeekendTime = {
          StartHour = mkOption {
            type = types.int;
            default = 20;
            description = ''
              The real time starting hour for activating Player vs Player PvP during weekends
            '';
            example = ''
              Value in range [0, 24]
            '';
          };
          StartMinute = mkOption {
            type = types.int;
            default = 0;
            description = ''
              The real time starting minute for activating Player vs Player PvP during weekends
            '';
            example = ''
              Value in range [0, 60]
            '';
          };
          EndHour = mkOption {
            type = types.int;
            default = 22;
            description = ''
              The real time ending hour for deactivating Player vs Player PvP during weekends
            '';
            example = ''
              Value in range [0, 24]
            '';
          };
          EndMinute = mkOption {
            type = types.int;
            default = 0;
            description = ''
              The real time end minute for deactivating Player vs Player PVP during weekends
            '';
            example = ''
              Value in range [0, 60]
            '';
          };
        };
        VSCastleWeekdayTime = {
          StartHour = mkOption {
            type = types.int;
            default = 20;
            description = ''
              The real time starting hour for activating Castle PvP during standard weekdays
            '';
            example = ''
              Value in range [0, 24]
            '';
          };
          StartMinute = mkOption {
            type = types.int;
            default = 0;
            description = ''
              The real time starting minute for activating Castle PvP during standard weekdays
            '';
            example = ''
              Value in range [0, 60]
            '';
          };
          EndHour = mkOption {
            type = types.int;
            default = 22;
            description = ''
              The real time ending hour for deactivating Castle PvP during standard weekdays
            '';
            example = ''
              Value in range [0, 24]
            '';
          };
          EndMinute = mkOption {
            type = types.int;
            default = 0;
            description = ''
              The real time end minute for deactivating Castle PvP during standard weekdays
            '';
            example = ''
              Value in range [0, 60]
            '';
          };
        };
        VSCastleWeekendTime = {
          StartHour = mkOption {
            type = types.int;
            default = 20;
            description = ''
              The real time starting hour for activating Castle PvP during weekends
            '';
            example = ''
              Value in range [0, 24]
            '';
          };
          StartMinute = mkOption {
            type = types.int;
            default = 0;
            description = ''
              The real time starting minute for activating Castle PvP during weekends
            '';
            example = ''
              Value in range [0, 60]
            '';
          };
          EndHour = mkOption {
            type = types.int;
            default = 22;
            description = ''
              The real time ending hour for deactivating Castle PvP during weekends
            '';
            example = ''
              Value in range [0, 24]
            '';
          };
          EndMinute = mkOption {
            type = types.int;
            default = 0;
            description = ''
              The real time end minute for deactivating Castle PvP during weekends
            '';
            example = ''
              Value in range [0, 60]
            '';
          };
        };
      };
      TraderModifiers = {
        StockModifier = mkOption {
          type = types.float;
          default = 1.0;
        };
        PriceModifier = mkOption {
          type = types.float;
          default = 1.0;
        };
        RestockTimerModifier = mkOption {
          type = types.float;
          default = 1.0;
        };
      };
      WarEventGameSettings = {
        Interval = mkOption {
          type = types.int;
          default = 1;
        };
        MajorDuration = mkOption {
          type = types.int;
          default = 1;
        };
        MinorDuration = mkOption {
          type = types.int;
          default = 1;
        };
        WeekdayTime = {
          StartHour = mkOption {
            type = types.int;
            default = 0;
            example = ''
              Value in range [0, 24]
            '';
          };
          StartMinute = mkOption {
            type = types.int;
            default = 0;
            example = ''
              Value in range [0, 60]
            '';
          };
          EndHour = mkOption {
            type = types.int;
            default = 23;
            example = ''
              Value in range [0, 24]
            '';
          };
          EndMinute = mkOption {
            type = types.int;
            default = 59;
            example = ''
              Value in range [0, 60]
            '';
          };
        };
        WeekendTime = {
          StartHour = mkOption {
            type = types.int;
            default = 0;
            example = ''
              Value in range [0, 24]
            '';
          };
          StartMinute = mkOption {
            type = types.int;
            default = 0;
            example = ''
              Value in range [0, 60]
            '';
          };
          EndHour = mkOption {
            type = types.int;
            default = 23;
            example = ''
              Value in range [0, 24]
            '';
          };
          EndMinute = mkOption {
            type = types.int;
            default = 59;
            example = ''
              Value in range [0, 60]
            '';
          };
        };
        ScalingPlayers1 = {
          PointsModifier = mkOption {
            type = types.float;
            default = 1.0;
          };
          DropModifier = mkOption {
            type = types.float;
            default = 1.0;
          };
        };
        ScalingPlayers2 = {
          PointsModifier = mkOption {
            type = types.float;
            default = 0.5;
          };
          DropModifier = mkOption {
            type = types.float;
            default = 0.5;
          };
        };
        ScalingPlayers3 = {
          PointsModifier = mkOption {
            type = types.float;
            default = 0.25;
          };
          DropModifier = mkOption {
            type = types.float;
            default = 0.25;
          };
        };
        ScalingPlayers4 = {
          PointsModifier = mkOption {
            type = types.float;
            default = 0.25;
          };
          DropModifier = mkOption {
            type = types.float;
            default = 0.25;
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.vrising-server = let
      steamcmd = "${pkgs.steamcmd}/bin/steamcmd";
      settingsFile = pkgs.writeText "settings.json" (builtins.toJSON cfg.game);
    in {
      description = "V Rising Dedicated Server";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      serviceConfig = {
        ExecStart = ''
          ${pkgs.xvfb-run}/bin/xvfb-run --server-args="-screen 0 1024x768x16" \
          ${wine}/bin/wine64 /var/lib/vrising/server/VRisingServer.exe \
            -persistentDataPath Z:/var/lib/vrising/data \
            -serverName ${cfg.server.serverName} \
            -gamePort ${toString cfg.server.port} \
            -queryPort ${toString cfg.server.queryPort} \
            -lowerFPSWhenEmpty true \
            -password kremowka \
            -saveName ${cfg.server.saveName}
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
        cfg.server.port
        cfg.server.queryPort
      ];
    };
  };
}
