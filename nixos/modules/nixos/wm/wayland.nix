{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs;
    [ wayland ];

  services.xserver = {
    enable = true;
    xkb = {
      layout = "pl";
      variant = "";
    };
  };
  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      package = pkgs.sddm;
    };
  };
}

