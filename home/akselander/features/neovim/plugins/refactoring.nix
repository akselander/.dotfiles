{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      nvim-treesitter
      {
        plugin = refactoring-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require("refactoring").setup()
          '';
      }
    ];
  };
}
