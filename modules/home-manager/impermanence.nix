{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  cfg = config.impermanence;
in {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  options.impermanence = {
    home.directories = lib.mkOption {
      default = [];
      description = ''
      '';
    };
    data.directories = lib.mkOption {
      default = [
      ];
      description = ''
      '';
    };
    data.files = lib.mkOption {
      default = [];
      description = ''
      '';
    };
    cache.directories = lib.mkOption {
      default = [];
      description = ''
      '';
    };
    cache.files =
      lib.mkOption {
      };
    default = [];
    description = ''
    '';
  };

  config = {
    home.persistence."/persist/userdata/home/${config.home.username}" = {
      directories = cfg.home.directories;
      allowOther = true;
    };
  };
}
