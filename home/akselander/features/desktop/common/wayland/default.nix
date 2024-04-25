{pkgs, ...}: {
  imports = [
    ./gammastep.nix
  ];
  home.packages = with pkgs; [
    # pkgs
  ];

  home.sessionVariables = {
     MOZ_ENABLE_WAYLAND = 1;
  };
}
