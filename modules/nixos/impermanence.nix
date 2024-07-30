{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  cfg = config.impermanence;
  hostname = config.networking.hostName;
  wipeScript = ''
    mkdir /btrfs_tmp
    mount ${cfg.device} /btrfs_tmp
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
  '';
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.impermanence = {
    nukeRoot.enable = lib.mkEnableOption "Destroy /root on every boot";
    device = lib.mkOption {
      default = "/dev/mapper/cryptroot";
      description = ''
        device to use
      '';
    };

    directories = lib.mkOption {
      default = [];
      description = ''
        directories to persist
      '';
    };
  };

  config = {
    fileSystems."/persist".neededForBoot = true;
    programs.fuse.userAllowOther = true;

    environment.persistence = let
      persistentData = builtins.mapAttrs (name: user: {
        directories =
          [
            "Downloads"
            "Music"
            "Pictures"
            "Projects"
            "Documents"
            "Videos"

            ".dotfiles"
          ]
          ++ config.home-manager.users."${name}".impermanence.data.directories;
        files = config.home-manager.users."${name}".impermanence.data.files;
      }) (config.home-manager.users);
      persistentCache = builtins.mapAttrs (name: user: {
        directories =
          [".config/dconf"]
          ++ config.home-manager.users."${name}".impermanence.cache.directories;
        files = config.home-manager.users."${name}".impermanence.cache.files;
      }) (config.home-manager.users);
    in {
      "/persist/userdata".users = persistentData;
      "/persist/usercache".users = persistentCache;
      "/persist/system" = {
        hideMounts = true;
        directories =
          [
            "/etc/nixos"
            "/var/log"
            "/var/lib/bluetooth"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/var/cache/regreet"
            "/etc/NetworkManager/system-connections"
          ]
          ++ cfg.directories;
        files = [];
      };
    };

    boot.initrd.postDeviceCommands =
      lib.mkIf cfg.nukeRoot.enable
      (lib.mkAfter wipeScript);
  };
}