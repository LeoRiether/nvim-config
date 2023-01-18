-- Setup folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

local p = function(name)
    local module = string.format('plugin.%s', name)
    return function()
        require(module)
    end
end

-- TODO: split these into multiple modules maybe?
local plugins = {
    { 'PeterRincker/vim-argumentative', event = 'BufRead' },
    { 'ThePrimeagen/harpoon', dependencies={'nvim-lua/plenary.nvim'}, opts={} },
    { 'ggandor/lightspeed.nvim' },
    { 'goolord/alpha-nvim', config = p 'startscreen' },
    { 'jiangmiao/auto-pairs' },
    { 'kshenoy/vim-signature' },
    { 'metakirby5/codi.vim', cmd = {'Codi', 'CodiNew'} },
    { 'numToStr/Comment.nvim', event = 'BufRead', opts = {} },
    { 'nvim-lualine/lualine.nvim', config = p 'statusline' },
    { 'nvim-treesitter/nvim-treesitter', event = { 'BufRead', 'BufNewFile' }, config = p 'treesitter', build = ':TSUpdate' },
    { 'tommcdo/vim-lion' },
    { 'tpope/vim-fugitive' },
    { 'tpope/vim-repeat', event = 'BufRead' },
    { 'tpope/vim-rhubarb' },
    { 'tpope/vim-surround' },
    { 'vimwiki/vimwiki', branch = 'master' },

    -- telescope
    { 'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = p 'telescope',
    },
    { 'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
        lazy = true,
    },
    { 'nvim-telescope/telescope-ui-select.nvim', lazy = true },

    -- lsp
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip', event = 'BufRead'},
            {'rafamadriz/friendly-snippets', event = 'BufRead'},
        },
        opts = p 'lsp',
        event = {'BufRead', 'BufNew'},
    },

    -- Colorschemes
    { 'ayu-theme/ayu-vim', lazy=true },
    { 'morhetz/gruvbox', lazy=true },
    { 'nanotech/jellybeans.vim', lazy=true },
    { 'bluz71/vim-nightfly-guicolors', lazy=true },
    { 'srcery-colors/srcery-vim', lazy=true },
    { 'pineapplegiant/spaceduck', lazy=true },
    { 'folke/tokyonight.nvim', lazy=true, opts = { style='storm' } },
    { 'nyoom-engineering/oxocarbon.nvim', lazy=true },
    { 'wuelnerdotexe/vim-enfocado', lazy=true },

    -- Language-specific
    { 'lervag/vimtex', ft = 'tex' },
    { 'mattn/emmet-vim', ft = 'html' },

    -- Maybe delete
    { 'folke/todo-comments.nvim', event = 'BufRead', opts = {} },
    { 'rareitems/printer.nvim', opts = {keymap='gp'} },
    { 'dense-analysis/neural',
    opts = {
        -- https://beta.openai.com/account/api-keys
        open_ai = { api_key = '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' }
    }, dependencies = {
        'MunifTanjim/nui.nvim',
        'ElPiloto/significant.nvim',
    } },
    { "folke/persistence.nvim",
      event = "BufReadPre", -- this will only start session saving when an actual file was opened
      module = "persistence",
      opts = {}, },
    { 'folke/zen-mode.nvim', opts = { window = { width = 90 } } },
    { 'hkupty/iron.nvim', config = p 'iron', cmd = 'IronRepl' },

    -- Useless
    { 'alec-gibson/nvim-tetris', cmd = 'Tetris' },
    { 'seandewar/nvimesweeper', cmd = 'Nvimesweeper' },

    -- Local
    { 'LeoRiether/wasp.nvim', config = p 'wasp', dev = true },
    { dir = '~/Workspace/aoc/nvim', opts = {} },
}

-- ~/.config/nvim/lua/lazy
require('lazy').setup(plugins, {
    dev = {
        path = '~/Workspace'
    },
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = true,
        notify = true, -- get a notification when changes are found
    },
})

local colorschemes = {
    "jellybeans", "nightfly", "srcery", "spaceduck", "tokyonight",
    "ayu", "gruvbox", "oxocarbon", "enfocado"
}
local colorscheme = colorschemes[math.random(#colorschemes)]
vim.cmd.colorscheme(colorscheme)

-- vim.g.ayucolor = 'dark'
vim.opt.background = 'dark'

-- Workaround for creating transparent bg
-- vim.cmd [[
--     autocmd vimenter * highlight Normal      ctermbg=NONE guibg=NONE
--                    \ | highlight LineNr      ctermbg=NONE guibg=NONE
--                    \ | highlight SignColumn  ctermbg=NONE guibg=NONE
--                    \ | highlight EndOfBuffer ctermbg=NONE guibg=NONE
-- ]]

if math.random(100) < 10 then
    vim.cmd [[ DeleteOldSessions ]]
end

