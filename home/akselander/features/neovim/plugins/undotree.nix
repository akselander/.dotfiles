{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = undotree;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
          '';
      }
    ];
  };
}
