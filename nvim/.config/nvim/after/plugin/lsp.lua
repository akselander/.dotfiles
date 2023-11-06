local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'tsserver',
        'eslint',
        'lua_ls',
        'gopls',
        'html',
    },
    handlers = {
        lsp_zero.default_setup,
    },
})

local lua_opts = lsp_zero.nvim_lua_ls({
    globals = {
        "vim",
    }
})

require('lspconfig').lua_ls.setup(lua_opts)

lsp_zero.format_on_save({
    format_opts = {
        async = false,
        timeout_ms = 10000,
    },
    servers = {
        ['eslint'] = { 'javascript', 'typescript' },
        ['lua_ls'] = { 'lua' },
        ['gopls'] = { 'go', 'godmod', 'gowork', 'gotmpl' },
        ['html'] = { 'html' },
    }
})
