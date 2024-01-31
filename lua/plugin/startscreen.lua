local dashboard = require "alpha.themes.dashboard"
math.randomseed(os.time())

local function button(sc, txt, keybind, keybind_opts)
    local b = dashboard.button(sc, txt, keybind, keybind_opts)
    b.opts.hl = "AlphaButton"
    b.opts.hl_shortcut = "AlphaButtonShortcut"
    return b
end

local function footer()
    -- local plugins = #vim.tbl_keys(packer_plugins)
    local plugins = require("lazy").stats().count
    local v = vim.version()
    local platform = vim.fn.has "win32" == 1 and "" or ""
    return string.format(" %d   v%d.%d.%d %s", plugins, v.major, v.minor, v.patch, platform)
end

-- header
dashboard.section.header.val = require("plugin.headers").random()

-- date
local datetime = os.date " %d-%m-%Y   %H:%M:%S"
local date = {
    type = "text",
    val = datetime,
    opts = {
        position = "center",
        hl = "Number",
    },
}

-- buttons
dashboard.section.buttons.val = {
    button("SPC n n", "  New file", "<cmd>enew<cr>"),
    button("SPC p p", "  Find file", "<cmd>Files<cr>"),
    button("SPC p h", "  Recent files", "<cmd>History<cr>"),
    -- button("SPC f f", "  Find word", "<cmd>Rg<cr>"),
    button("SPC g b", "  Open repo", "<cmd>GBrowse<cr>"),
    -- button("SPC s s", "  Open session", "<cmd>source Session.vim<cr>"),
    button("SPC s s", "  Open session", "<cmd>lua require('persistence').load()<cr>"),
    button("SPC l s", "  Update plugins", "<cmd>Lazy sync<cr>"),
    button("q", "  Quit", "<Cmd>qa<CR>"),
}

-- footer
dashboard.section.footer.val = footer()
dashboard.section.footer.opts.hl = dashboard.section.header.opts.hl

-- quote
local quote = {
    type = "text",
    val = require "alpha.fortune" (),
    opts = {
        position = "center",
        hl = "AlphaQuote",
    },
}

dashboard.config.layout = {
    { type = "padding", val = 12 },
    dashboard.section.header,
    { type = "padding", val = 2 },
    date,
    { type = "padding", val = 1 },
    dashboard.section.footer,
    { type = "padding", val = 1 },
    -- dashboard.section.buttons,
    quote,
}

require("alpha").setup(dashboard.config)

-- hide tabline and statusline on startup screen
vim.api.nvim_create_augroup("alpha_tabline", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = "alpha_tabline",
    pattern = "alpha",
    command = "set showtabline=0 laststatus=0 noruler",
})

local showtabline = vim.g.showtabline
vim.api.nvim_create_autocmd("FileType", {
    group = "alpha_tabline",
    pattern = "alpha",
    callback = function()
        vim.api.nvim_create_autocmd("BufUnload", {
            group = "alpha_tabline",
            buffer = 0,
            command = "set showtabline=" .. tostring(showtabline) .. " ruler laststatus=3",
        })
    end,
})
