{
  config,
  pkgs,
  ...
}: {
  home.sessionVariables.EDITOR = "nvim";

  programs.neovim = {
    enable = true;
  };

  xdg.configFile = {
    nvim = {
      source = ./nvim;
      recursive = true;
    };
  };
}
