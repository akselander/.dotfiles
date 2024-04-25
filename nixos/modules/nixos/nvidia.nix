{
  environment.variables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  hardware = {
    nvidia = {
      prime.offload.enable = false;
      modesetting.enable = true;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    bluetooth.enable = true;
  };

  services.hardware.openrgb.enable = true;

  services = {
    xserver.videoDrivers = ["nvidia"];
    printing.enable = true;
  };
}
