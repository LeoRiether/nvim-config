local lsp = require('lsp-zero')

lsp.set_preferences({
  suggest_lsp_servers = true,
  setup_servers_on_start = true,
  set_lsp_keymaps = false,
  configure_diagnostics = true,
  cmp_capabilities = true,
  manage_nvim_cmp = false,
  call_servers = 'local',
  sign_icons = {
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = ''
  }
})

-- lspconfig.clangd.setup {
lsp.configure('clangd', {
    init_options = {
      fallbackFlags = {'--std=c++20'},
    },
})

lsp.configure('rust_analyzer', {
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy",
            },
        },
    },
})

lsp.configure('typst_lsp', {
    filetypes = { 'typst', 'typ' },
})

require'lspconfig'.ocamllsp.setup{}

-- lsp mappings
lsp.on_attach(function(client, bufnr)
    local opts = { noremap = true, buffer = bufnr }
    local keymap = vim.keymap.set
    keymap('n', 'gh', function() vim.lsp.buf.hover() end, opts)
    keymap('n', 'gD', function() vim.lsp.buf.declaration() end, opts)
    -- NOTE: Handled by telescope now!
    -- keymap('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    -- keymap('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
    -- keymap('n', 'go', function() vim.lsp.buf.type_definition() end, opts) 
    -- keymap('n', 'gr', function() vim.lsp.buf.references() end, opts)
    keymap('n', '<F2>', function() vim.lsp.buf.rename() end, opts)
    keymap('n', '<F4>', function() vim.lsp.buf.code_action() end, opts)
    keymap('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)

    keymap('n', ']d', function() vim.diagnostic.goto_next() end, opts)
    keymap('n', '[d', function() vim.diagnostic.goto_prev() end, opts)
    keymap('n', '\\d', function() vim.diagnostic.open_float() end, opts)
end)

-- Configure nvim-cmp
local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local lines = vim.api.nvim_buf_get_lines(0, line - 1, line, true)
    return col ~= 0 and lines[1]:sub(col, col):match("%s") == nil
end

-- LuaSnip
local luasnip = require("luasnip")
luasnip.config.set_config({
    history = true, -- keep around last snippet local to jump back
    enable_autosnippets = true,
})
-- luasnip.setup()

local snippets_dir = vim.fn.stdpath('config') .. '/lua/snippets'
require("luasnip.loaders.from_lua").lazy_load({paths = snippets_dir})
require("luasnip.loaders.from_snipmate").lazy_load({paths = snippets_dir})
require("luasnip.loaders.from_vscode").lazy_load()

vim.cmd [[ imap <silent><expr> <C-o> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<C-o>' ]]

-- edit snippets
vim.keymap.set('n', '<leader>es', require("luasnip.loaders").edit_snippet_files)

local cmp = require("cmp")

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },

    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'calc' },
        { name = 'nvim_lsp_signature_help' },
    }, {
        { name = 'buffer' },
        { name = 'nvim_lua' },
    }),

    mapping = lsp.defaults.cmp_mappings({
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),

        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        })
    }),

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, item)
            local menu_icon ={
                nvim_lsp = 'λ',
                luasnip = '⋗',
                snip = '⋗',
                buffer = 'Ω',
                path = '🖫',
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
})

-- Mason
require("mason").setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    }
})

lsp.setup()

-- diagnostics
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.goimports,
  }
})
