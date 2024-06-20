{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = trouble-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require("trouble").setup({
                icons = false,
            })

            vim.keymap.set("n", "<leader>tt", function()
                require("trouble").toggle()
            end)

            vim.keymap.set("n", "[t", function()
                require("trouble").next({ skip_groups = true, jump = true });
            end)

            vim.keymap.set("n", "]t", function()
                require("trouble").previous({ skip_groups = true, jump = true });
            end)
          '';
      }
    ];
  };
}
