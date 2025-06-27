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
    { 'ThePrimeagen/harpoon', branch = 'harpoon2', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { global_settings = { mark_branch = true } },
        config = function () require('harpoon'):setup({}) end
    },
    { 'folke/todo-comments.nvim', event = 'BufRead', opts = {
        keywords = {
            SAFETY = { icon = " ", color = "warning" },
            SECTION = { icon = "§", color = "test", alt = { "SEC", "Q", "A" } },
            DRAFT = { icon = "", color = "warning" },
            J = { icon = "", color = "warning" },
        },
        search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
        highlight = {
          -- DONE(CX):https://github.com/folke/todo-comments.nvim/issues/10
          -- SOLVED: https://github.com/folke/todo-comments.nvim/issues/332
          pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
        },
    } },
    { 'goolord/alpha-nvim', config = p 'startscreen' },
    { 'numToStr/Comment.nvim', event = 'BufRead', opts = {} },
    { 'nvim-lualine/lualine.nvim', config = p 'statusline' },
    { 'nvim-treesitter/nvim-treesitter', event = { 'BufRead', 'BufNewFile' }, config = p 'treesitter', build = ':TSUpdate' },
    { 'stevearc/oil.nvim', opts = {
        keymaps = {
            ["<C-p>"] = false,
        }
    } },
    { 'tommcdo/vim-lion' },
    { 'tpope/vim-fugitive' },
    { 'tpope/vim-repeat', event = 'BufRead' },
    { 'tpope/vim-rhubarb' },
    { 'tpope/vim-surround' },
    { 'windwp/nvim-autopairs', opts = { fast_wrap={} } },
    { 'pteroctopus/faster.nvim', opts = {} },
    { "folke/persistence.nvim",
        event = "BufReadPre", -- this will only start session saving when an actual file was opened
        module = "persistence",
        opts = {}, },
    { 'J-hui/fidget.nvim', event = "VeryLazy", opts = {} },

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
    { 'nvim-telescope/telescope.nvim',
       dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzy-native.nvim',
                        'nvim-telescope/telescope-ui-select.nvim' },
       config = p 'telescope',
       event = 'VeryLazy',
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

    -- lsp
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

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
    { 'nanotech/jellybeans.vim', lazy = true },
    { 'bluz71/vim-nightfly-guicolors', lazy = true },
    { 'folke/tokyonight.nvim', lazy = true, opts = { style = 'storm' } },
    { 'nyoom-engineering/oxocarbon.nvim', lazy = true },
    { 'wuelnerdotexe/vim-enfocado', lazy = true },
    { 'igorgue/danger', lazy = true, opts = { kitty=true } },
    { 'NTBBloodbath/sweetie.nvim', lazy = true, config = function() vim.g.sweetie = {} end },
    { 'navarasu/onedark.nvim', lazy = true, opts = { style='warmer' } },
    { 'mhartington/oceanic-next', lazy = true, config = function() end },
    { 'rebelot/kanagawa.nvim', lazy = true, opts = {} },
    { 'oxfist/night-owl.nvim', lazy = true, opts = {} },
    { 'rose-pine/neovim', name = 'rose-pine', lazy = true },
    { 'tiagovla/tokyodark.nvim', lazy = true, opts = {} },
    { 'catppuccin/nvim', name = "catppuccin", lazy = true, opts = {} },
    { 'metalelf0/base16-black-metal-scheme', lazy = false },

    -- Language-specific
    { 'lervag/vimtex', ft = 'tex' },
    { 'mattn/emmet-vim', ft = 'html' },
    { 'adelarsq/neofsharp.vim', ft = 'fsharp' },
    { 'kaarmu/typst.vim', ft = 'typ', lazy=false },
    { 'chrisbra/csv.vim', ft = 'csv' },
    { 'jakewvincent/mkdnflow.nvim', event = { 'BufRead', 'BufNew' }, config = p 'mkdnflow' },
    { 'gpanders/nvim-parinfer', event = 'BufRead' },
    { 'sputnick1124/uiua.vim', ft = 'uiua' },
    { 'adam12/ruby-lsp.nvim', ft = { 'ruby', 'eruby' }, config=true },

    -- Maybe delete
    { 'nvim-tree/nvim-web-devicons', opts = {} },
    { 'projekt0n/circles.nvim', opts = { lsp = true }, dependencies = 'nvim-tree/nvim-web-devicons' },
    { "chrisgrieser/nvim-various-textobjs",
      lazy = false,
      config = p 'textobjs',
    },
    { 'lewis6991/gitsigns.nvim', opts = {} },
    { 'rgroli/other.nvim', name = 'other-nvim', opts = {
        mappings = {
            'golang',
            {
                pattern = "/main/(.*)/(.*).java$",
                target = "/test/%1/%2Test.java",
                context = "test",
            },
            {
                pattern = "/main/(.*)/(.*).java$",
                target = "/integration/%1/%2Test.java",
                context = "integration",
            },
            {
                pattern = "/test/(.*)/(.*)Test.java$",
                target = "/main/%1/%2.java",
                context = "main",
            },
            {
                pattern = "/integration/(.*)/(.*)Test.java$",
                target = "/main/%1/%2.java",
                context = "main",
            },
        },
    } },
    { 'awerebea/git-worktree.nvim', opts = {}, branch = 'handle_changes_in_telescope_api' },

    -- Useless
    { 'alec-gibson/nvim-tetris', cmd = 'Tetris' },
    { 'seandewar/nvimesweeper', cmd = 'Nvimesweeper' },
    { 'Eandrju/cellular-automaton.nvim', cmd = 'CellularAutomaton' },
    { 'efueyo/td.nvim', cmd = 'TDStart' },

    -- Local
    { 'LeoRiether/wasp.nvim', config = p 'wasp', dev = true },
    { dir = '~/Workspace/aoc/nvim', name = 'aoc', opts = {} },
    { dir = '~/.config/nvim/lua/colorschemes/bloom', dev = true },
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
    "oxocarbon", "enfocado", "danger", "sweetie", "onedark",
    "kanagawa", "night-owl", "rose-pine", "tokyodark", "catppuccin",
    "base16-black-metal-dark-funeral", "bloom",
}
math.randomseed(tonumber(os.date("%Y%m%d")) + 4)
local colorscheme = colorschemes[math.random(#colorschemes)]
colorscheme = 'night-owl'
math.randomseed(os.time())
vim.cmd.colorscheme(colorscheme)

-- vim.g.ayucolor = 'dark'
vim.opt.background = 'dark'

-- Workaround for creating transparent bg
-- vim.cmd [[
--     autocmd vimenter * highlight Normal      ctermbg=NONE guibg=NONE
--                    \ | highlight NonText     ctermbg=NONE guibg=NONE
--                    \ | highlight LineNr      ctermbg=NONE guibg=NONE
--                    \ | highlight SignColumn  ctermbg=NONE guibg=NONE
--                    \ | highlight EndOfBuffer ctermbg=NONE guibg=NONE
--     autocmd colorscheme * highlight Normal      ctermbg=NONE guibg=NONE
--                    \ | highlight NonText     ctermbg=NONE guibg=NONE
--                    \ | highlight LineNr      ctermbg=NONE guibg=NONE
--                    \ | highlight SignColumn  ctermbg=NONE guibg=NONE
--                    \ | highlight EndOfBuffer ctermbg=NONE guibg=NONE
-- ]]

if math.random(100) < 10 then
    vim.cmd [[ DeleteOldSessions ]]
end
