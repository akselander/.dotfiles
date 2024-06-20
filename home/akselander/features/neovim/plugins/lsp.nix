{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    mason-nvim
    mason-lspconfig-nvim
    cmp-nvim-lsp
    cmp-buffer
    cmp-path
    cmp-cmdline
    nvim-cmp
    luasnip
    cmp_luasnip
    fidget-nvim
    {
      plugin = nvim-lspconfig;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          local lspconfig = require('lspconfig')
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
          add_lsp(lspconfig.gopls, {})
          add_lsp(lspconfig.lua_ls, {})
          add_lsp(lspconfig.nixd, { settings = { nixd = {
            formatting = { command = { "alejandra" }}
          }}})
          add_lsp(lspconfig.tsserver, {})
          add_lsp(elixirls, {cmd = {"elixir-ls"}})


          local cmp = require('cmp')
          local cmp_lsp = require("cmp_nvim_lsp")
          local capabilities = vim.tbl_deep_extend(
              "force",
              {},
              vim.lsp.protocol.make_client_capabilities(),
              cmp_lsp.default_capabilities())

          require("fidget").setup({})
          require("mason").setup()
          require("mason-lspconfig").setup({
              ensure_installed = {
                  "lua_ls",
              },
              handlers = {
                  function(server_name) -- default handler (optional)
                      require("lspconfig")[server_name].setup {
                          capabilities = capabilities
                      }
                  end,

                  ["eslint"] = function()
                      local lspconfig = require('lspconfig')
                      lspconfig.eslint.setup({
                          on_attach = function(client, bufnr)
                              vim.api.nvim_create_autocmd("BufWritePre", {
                                  buffer = bufnr,
                                  command = "EslintFixAll",
                              })
                          end,
                      })
                  end,

                  ["lua_ls"] = function()
                      local lspconfig = require("lspconfig")
                      lspconfig.lua_ls.setup {
                          capabilities = capabilities,
                          settings = {
                              Lua = {
                                  diagnostics = {
                                      globals = { "vim", "it", "describe", "before_each", "after_each" },
                                  }
                              }
                          }
                      }
                  end,
              }
          })

          local cmp_select = { behavior = cmp.SelectBehavior.Select }

          cmp.setup({
              snippet = {
                  expand = function(args)
                      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                  end,
              },
              mapping = cmp.mapping.preset.insert({
                  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                  ["<C-Space>"] = cmp.mapping.complete(),
              }),
              sources = cmp.config.sources({
                  { name = 'nvim_lsp' },
                  { name = 'luasnip' }, -- For luasnip users.
              }, {
                  { name = 'buffer' },
              })
          })

          vim.diagnostic.config({
              -- update_in_insert = true,
              float = {
                  focusable = false,
                  style = "minimal",
                  border = "rounded",
                  source = "always",
                  header = "",
                  prefix = "",
              },
          })
        '';
    }
  ];
}
