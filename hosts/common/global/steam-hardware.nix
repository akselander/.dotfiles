{pkgs, ...}: {
  hardware.steam-hardware.enable = true;

  security.wrappers = {
    gamescope = {
      owner = "root";
      group = "root";
      source = "${pkgs.gamescope}/bin/gamescope";
      capabilities = "cap_sys_nice+ep";
    };
  };
}
