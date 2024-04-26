{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    xkb = {
      layout = "pl";
      variant = "";
    };
  };

  services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      package = pkgs.sddm;
  };
}
