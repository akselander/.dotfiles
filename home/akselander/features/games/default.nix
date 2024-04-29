{pkgs, ...}: {
  imports = [
    ./steam.nix
  ];
  home = {
    packages = with pkgs; [gamescope protonup-ng];

    persistence = {
      "/persist/home/akselander" = {
        allowOther = true;
        directories = [
          {
            # Use symlink, as games may be IO-heavy
            directory = "Games";
            method = "symlink";
          }
        ];
      };
    };
  };
}
