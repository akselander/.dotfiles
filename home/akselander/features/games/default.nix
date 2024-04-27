{pkgs, ...}: {
  imports = [
    ./steam.nix
  ];
  home = {
    packages = with pkgs; [gamescope protonup-ng];
  };
}
