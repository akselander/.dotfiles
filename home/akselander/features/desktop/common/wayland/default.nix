{pkgs, ...}: {
  imports = [
    ./gammastep.nix
    ./kitty.nix
  ];

  xdg.mimeApps.enable = true;

  home.packages = with pkgs; [
    # pkgs
  ];

  home.sessionVariables = {
     MOZ_ENABLE_WAYLAND = 1;
  };
}
