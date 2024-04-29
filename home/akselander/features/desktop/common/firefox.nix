{pkgs, ...}: {
  programs.firefox.enable = true;

  home = {
    persistence = {
      "/persist/home/akselander".directories = [".mozzila" ".cache/mozilla"];
    };
  };
}
