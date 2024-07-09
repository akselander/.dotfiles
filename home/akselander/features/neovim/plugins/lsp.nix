{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    # Status updates
    fidget-nvim
    # LSP
    {
      plugin = nvim-lspconfig;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          local lspconfig = require("lspconfig")
          function add_lsp(server, options)
              if not options["cmd"] then
                  options["cmd"] = server["document_config"]["default_config"]["cmd"]
              end
              if not options["capabilities"] then
                  options["capabilities"] = require("cmp_nvim_lsp").default_capabilities()
              end

              if vim.fn.executable(options["cmd"][1]) == 1 then
                  server.setup(options)
              end
          end

          add_lsp(lspconfig.bashls, {})
          add_lsp(lspconfig.clangd, {})
          add_lsp(lspconfig.dockerls, {})
          add_lsp(lspconfig.gopls, {})
          add_lsp(lspconfig.lua_ls, {})
          add_lsp(
            lspconfig.nixd, {
                settings = {
                    nixd = {
                        formatting = {command = {"alejandra"}}
                    }
                }
            }
          )
          add_lsp(lspconfig.pylsp, {})
          add_lsp(lspconfig.tsserver, {})
          add_lsp(
            lspconfig.eslint, {
                on_attach = function(client, bufnr)
                    vim.api.nvim_create_autocmd(
                        "BufWritePre",
                        { buffer = bufnr, command = "EslintFixAll" }
                    )
                end
              }
          )
          add_lsp(elixirls, {cmd = {"elixir-ls"}})
        '';
    }
    # Snippets
    luasnip

    # Completions
    cmp-nvim-lsp
    cmp_luasnip
    cmp-rg
    cmp-buffer
    cmp-path
    {
      plugin = cmp-git;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          require("cmp_git").setup({})
        '';
    }

    lspkind-nvim
    {
      plugin = nvim-cmp;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          local cmp = require("cmp")

          cmp.setup(
              {
           formatting = {
               format = require("lspkind").cmp_format(
            {
                before = function(entry, vim_item)
          	  return vim_item
                end
            }
               )
           },
           snippet = {
               expand = function(args)
            require("luasnip").lsp_expand(args.body)
               end
           },
           mapping = cmp.mapping.preset.insert(
               {
            ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
            ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
            ["<C-y>"] = cmp.mapping.confirm({select = true}),
            ["<C-Space>"] = cmp.mapping.complete()
               }
           ),
           sources = {
               {name = "nvim_lsp"},
               {name = "luasnip"},
               {name = "git"},
               {name = "buffer", option = {get_bufnrs = vim.api.nvim_list_bufs}},
               {name = "path"},
               {name = "rg"}
           }
              }
            )
        '';
    }
  ];
}
