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
    local datetime = os.date " %d-%m-%Y   %H:%M:%S"
    local platform = vim.fn.has "win32" == 1 and "" or ""
    return string.format(" %d   v%d.%d.%d %s  %s", plugins, v.major, v.minor, v.patch, platform, datetime)
end

-- header
local hstr = require("plugin.headers").random()
-- local fd = io.popen(string.format("printf '%s' | lolcat -f", table.concat(hstr, '\\n')))
-- hstr = fd:read('*a')
-- fd:close()
-- local header = {}
-- for line in string.gmatch(hstr, "([^\n]+)") do
--     header[#header+1] = line
-- end
-- dashboard.section.header.val = header
dashboard.section.header.val = hstr
-- dashboard.section.header.opts.hl = "AlphaCol" .. math.random(5) -- doesn't work anymore?

-- buttons
dashboard.section.buttons.val = {
    button("SPC n n","  New file", "<cmd>enew<cr>"),
    button("SPC p p", "  Find file", "<cmd>Files<cr>"),
    button("SPC p h", "  Recent files", "<cmd>History<cr>"),
    button("SPC f f", "  Find word", "<cmd>Rg<cr>"),
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
table.insert(dashboard.config.layout, { type = "padding", val = 1 })
table.insert(dashboard.config.layout, {
    type = "text",
    val = require "alpha.fortune"(),
    opts = {
        position = "center",
        hl = "AlphaQuote",
    },
})

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
