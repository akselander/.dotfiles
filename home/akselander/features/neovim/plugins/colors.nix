{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = rose-pine;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            function ColorMyPencils(color)
                color = color or "rose-pine"
                vim.cmd.colorscheme(color)

                vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
                vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            end
            require('rose-pine').setup({
                disable_background = true,
            })

            vim.cmd("colorscheme rose-pine")

            ColorMyPencils()
          '';
      }
    ];
  };
}
