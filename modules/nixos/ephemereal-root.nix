{
  lib,
  config,
  ...
}: let
  cfg = config.ephemereal-root;
in {
  options.ephemereal-root = {
    enable = lib.mkEnableOption "Whether to enable ephemereal root.";
    device = lib.mkOption {
      type = types.path;
      description = "Disk device";
    };
    nukeRoot = lib.mkOption {
      type = types.bool;
      description = "Whether to nuke the root on boot.";
      default = false;
    };

    config = lib.mkIf cfg.enable {
      imports = [
        inputs.disko.nixosModules.default
        (import ./disko.nix {device = cfg.device;})
      ];

      boot.initrd.postDeviceCommands =
        lib.mkIf cfg.nukeRoot
        (lib.mkAfter ''
          mkdir /btrfs_tmp
          mount /dev/${cfg.volumeGroup}/root /btrfs_tmp
          if [[ -e /btrfs_tmp/root ]]; then
              mkdir -p /btrfs_tmp/old_roots
              timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
              mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          delete_subvolume_recursively() {
              IFS=$'\n'
              for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "/btrfs_tmp/$i"
              done
              btrfs subvolume delete "$1"
          }

          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
              delete_subvolume_recursively "$i"
          done

          btrfs subvolume create /btrfs_tmp/root
          umount /btrfs_tmp
        '');
    };
  };
}
