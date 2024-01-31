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
    { 'ThePrimeagen/harpoon', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { global_settings = { mark_branch = true } } },
    { 'folke/todo-comments.nvim', event = 'BufRead', opts = { keywords = { SAFETY = { icon = " ", color = "warning" } } } },
    { 'goolord/alpha-nvim', config = p 'startscreen' },
    { 'numToStr/Comment.nvim', event = 'BufRead', opts = {} },
    { 'nvim-lualine/lualine.nvim', config = p 'statusline' },
    { 'nvim-treesitter/nvim-treesitter', event = { 'BufRead', 'BufNewFile' }, config = p 'treesitter', build = ':TSUpdate' },
    { 'stevearc/oil.nvim', opts = {} },
    { 'tommcdo/vim-lion' },
    { 'tpope/vim-fugitive' },
    { 'tpope/vim-repeat', event = 'BufRead' },
    { 'tpope/vim-rhubarb' },
    { 'tpope/vim-surround' },
    { 'windwp/nvim-autopairs', opts = { fast_wrap={} } },

    -- flash.nvim
    {
        'folke/flash.nvim',
        opts = {
            modes = {
                char = {
                    jump_labels = true,
                },
                search = {
                    -- when `true`, flash will be activated during regular search by default.
                    -- You can always toggle when searching with `require("flash").toggle()`
                    enabled = false,
                },
            },
            style = 'inline',
        },
        event = 'VeryLazy',
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n" },
                function()
                    require("flash").jump({
                        pattern = vim.fn.expand("<cword>"),
                    })
                end,
                desc = "Initialize flash with the word under the cursor",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
        },
    },


    -- telescope
    { 'dmtrKovalenko/telescope.nvim', --[[ 'nvim-telescope/telescope.nvim' ]]
       branch = 'feat/support-file-path-location',
       dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzf-native.nvim',
                       'nvim-telescope/telescope-ui-select.nvim' },
       config = p 'telescope',
       event = 'VeryLazy',
    },
    { 'nvim-telescope/telescope-fzf-native.nvim',
       build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- lsp
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            { 'jose-elias-alvarez/null-ls.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp', dependencies = {
                -- Snippets
                'rafamadriz/friendly-snippets',
                'L3MON4D3/LuaSnip',
            } },
            { 'hrsh7th/cmp-nvim-lua' },

        },
        config = p 'lsp',
        event = { 'BufRead', 'BufNew' },
    },

    -- Colorschemes
    { 'ayu-theme/ayu-vim', lazy = true },
    { 'nanotech/jellybeans.vim', lazy = true },
    { 'bluz71/vim-nightfly-guicolors', lazy = true },
    { 'folke/tokyonight.nvim', lazy = true, opts = { style = 'storm' } },
    { 'nyoom-engineering/oxocarbon.nvim', lazy = true },
    { 'wuelnerdotexe/vim-enfocado', lazy = true },
    { 'igorgue/danger', lazy = true, opts = { kitty=true } },
    { 'NTBBloodbath/sweetie.nvim', lazy = true, config = function() vim.g.sweetie = {} end },
    { 'navarasu/onedark.nvim', lazy = true, opts = { style='warmer' } },
    { 'mhartington/oceanic-next', lazy = true, config = function() end },

    -- Language-specific
    { 'lervag/vimtex', ft = 'tex' },
    { 'mattn/emmet-vim', ft = 'html' },
    { 'adelarsq/neofsharp.vim', ft = 'fsharp' },
    { 'kaarmu/typst.vim', ft = 'typ', lazy=false },
    { 'chrisbra/csv.vim', ft = 'csv' },
    { 'jakewvincent/mkdnflow.nvim', event = { 'BufRead', 'BufNew' }, config = p 'mkdnflow' },

    -- Maybe delete
    { "folke/persistence.nvim",
        event = "BufReadPre", -- this will only start session saving when an actual file was opened
        module = "persistence",
        opts = {}, },
    { 'zbirenbaum/copilot.lua', event = "InsertEnter", opts = { suggestion = { auto_trigger = true } } },
    { 'nvim-tree/nvim-web-devicons', opts = {} },
    { 'J-hui/fidget.nvim', event = "VeryLazy", opts = {} },
    -- { 'folke/noice.nvim', event = 'VeryLazy', opts = {
    --     lsp = {
    --         hover = { enabled = false },
    --         signature = { enabled = false },
    --     },
    --     presets = {
    --         bottom_search = true,
    --     }
    -- }, dependencies = { 'MunifTanjim/nui.nvim', --[[ 'rcarriga/nvim-notify'  ]]} },
    { "chrisgrieser/nvim-various-textobjs",
      lazy = false,
      config = p 'textobjs',
    },

    -- Useless
    { 'alec-gibson/nvim-tetris', cmd = 'Tetris' },
    { 'seandewar/nvimesweeper', cmd = 'Nvimesweeper' },
    { 'Eandrju/cellular-automaton.nvim', cmd = 'CellularAutomaton' },
    { 'efueyo/td.nvim', cmd = 'TDStart' },

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
    "jellybeans", "nightfly", "tokyonight", "OceanicNext",
    "ayu", "oxocarbon", "enfocado", "danger", "sweetie", "onedark",
}
local colorscheme = colorschemes[math.random(#colorschemes)]
vim.cmd.colorscheme(colorscheme)

-- vim.g.ayucolor = 'dark'
vim.opt.background = 'dark'

-- Workaround for creating transparent bg
vim.cmd [[
    autocmd vimenter * highlight Normal      ctermbg=NONE guibg=NONE
                   \ | highlight NonText     ctermbg=NONE guibg=NONE
                   \ | highlight LineNr      ctermbg=NONE guibg=NONE
                   \ | highlight SignColumn  ctermbg=NONE guibg=NONE
                   \ | highlight EndOfBuffer ctermbg=NONE guibg=NONE
    autocmd colorscheme * highlight Normal      ctermbg=NONE guibg=NONE
                   \ | highlight NonText     ctermbg=NONE guibg=NONE
                   \ | highlight LineNr      ctermbg=NONE guibg=NONE
                   \ | highlight SignColumn  ctermbg=NONE guibg=NONE
                   \ | highlight EndOfBuffer ctermbg=NONE guibg=NONE
]]

if math.random(100) < 10 then
    vim.cmd [[ DeleteOldSessions ]]
end

