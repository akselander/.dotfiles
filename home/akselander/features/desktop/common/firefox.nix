{pkgs, ...}: {
  programs.firefox.enable = true;

  home = {
    persistence = {
      "/persist/home/akselander".directories = [".mozilla" ".cache/mozilla"];
    };
  };
}
