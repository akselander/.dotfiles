{
  config,
  pkgs,
  ...
}: let
  reloadNvim = ''
    XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
    for server in $XDG_RUNTIME_DIR/nvim.*; do
      nvim --server $server --remote-send '<Esc>:source $MYVIMRC<CR>' &
    done
  '';
in {
  imports = [
    ./remap.nix
    ./set.nix
    ./plugins
  ];
  home.sessionVariables.EDITOR = "nvim";

  programs.neovim = {
    enable = true;

    extraLuaConfig =
      /*
      lua
      */
      ''
        function R(name)
            require("plenary.reload").reload_module(name)
        end

        local augroup = vim.api.nvim_create_augroup
        local AkselanderGroup = augroup('Akselander', {})

        local autocmd = vim.api.nvim_create_autocmd
        local yank_group = augroup('HighlightYank', {})

        function R(name)
            require("plenary.reload").reload_module(name)
        end

        autocmd('TextYankPost', {
            group = yank_group,
            pattern = '*',
            callback = function()
                vim.highlight.on_yank({
                    higroup = 'IncSearch',
                    timeout = 40,
                })
            end,
        })

        autocmd({ "BufWritePre" }, {
            group = AkselanderGroup,
            pattern = "*",
            command = [[%s/\s\+$//e]],
        })

        autocmd('LspAttach', {
            group = AkselanderGroup,
            callback = function(e)
                local opts = { buffer = e.buf }
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
            end
        })

        vim.g.netrw_browse_split = 0
        vim.g.netrw_banner = 0
        vim.g.netrw_winsize = 25
      '';
  };

  xdg.configFile."nvim/init.lua".onChange = reloadNvim;

  xdg.desktopEntries = {
    nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      comment = "Edit text files";
      exec = "nvim %F";
      icon = "nvim";
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
      terminal = true;
      type = "Application";
      categories = [
        "Utility"
        "TextEditor"
      ];
    };
  };
}
