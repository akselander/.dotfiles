{pkgs, ...}: {
  programs.firefox.enable = true;

  xdg.mimeApps.defaultApplications = {
    "text/html" = ["firefox.desktop"];
    "text/xml" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };

  impermanence.data.directories = [
    ".mozilla"
  ];

  impermanence.cache.directories = [
    ".cache/mozilla"
  ];
}
