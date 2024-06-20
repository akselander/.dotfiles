{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      FixCursorHold-nvim
      nvim-treesitter
      neotest-vitest
      neotest-plenary
      nvim-nio
      {
        plugin = neotest;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            local neotest = require("neotest")
            neotest.setup({
                adapters = {
                    require("neotest-vitest"),
                    require("neotest-plenary").setup({
                        -- this is my standard location for minimal vim rc
                        -- in all my projects
                        min_init = "./scripts/tests/minimal.vim",
                    }),
                }
            })

            vim.keymap.set("n", "<leader>tc", function()
                neotest.run.run()
            end)
          '';
      }
    ];
  };
}
