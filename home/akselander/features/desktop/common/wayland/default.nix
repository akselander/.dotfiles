{pkgs, ...}: {
  imports = [
    ./kitty.nix
    ./swayidle.nix
    ./swaylock.nix
    ./waybar.nix
    ./rofi.nix
    ./zathura.nix
    ./imv.nix
  ];

  xdg.mimeApps.enable = true;
  home.packages = with pkgs; [
    wf-recorder
    wl-clipboard
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
  };

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-wlr];
}
