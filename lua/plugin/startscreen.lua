math.randomseed(os.time())

local leader = "SPC"

--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param keybind_opts table? optional
local function button(sc, txt, keybind, keybind_opts)
    local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

    local opts = {
        position = "center",
        shortcut = sc,
        cursor = 3,
        width = 50,
        align_shortcut = "right",
        hl = "AlphaButton",
        hl_shortcut = "AlphaButtonShortcut",
    }
    if keybind then
        keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
        opts.keymap = { "n", sc_, keybind, keybind_opts }
    end

    local function on_press()
        local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "t", false)
    end

    return {
        type = "button",
        val = txt,
        on_press = on_press,
        opts = opts,
    }
end

local header = {
    type = "text",
    val = require("plugin.headers").random(),
    opts = {
        position = "center",
        hl = "Type",
        -- wrap = "overflow";
    },
}

local metadata = (function()
    local datetime = os.date " %d-%m-%Y   %H:%M:%S"
    local platform = vim.fn.has "win32" == 1 and "" or ""
    local v = vim.version()
    return {
        type = "text",
        val = string.format("%s   v%d.%d.%d  %s",
            datetime, v.major, v.minor, v.patch, platform),
        opts = {
            position = "center",
            hl = "Number",
        },
    }
end)()

local function calc_plugins()
    local stats = require("lazy").stats()
    local ms = tostring(math.floor(stats.startuptime * 100 + 0.5) / 100)
    return {
        type = "text",
        -- val = string.format(" %d plugins loaded in %sms", stats.count, ms),
        val = string.format("󱐋 %d plugins loaded in %sms", stats.count, ms),
        opts = {
            position = "center",
            hl = "Number",
        },
    }
end

local plugins = calc_plugins()

vim.api.nvim_create_autocmd('User', {
    pattern = 'LazyVimStarted',
    callback = function()
        plugins.val = calc_plugins().val
        pcall(vim.cmd.AlphaRedraw)
    end,
})


local buttons = {
    type = "group",
    val = {
        button("SPC n n", "  New file", "<cmd>enew<cr>"),
        button("SPC p p", "  Find file", "<cmd>Files<cr>"),
        button("SPC p h", "  Recent files", "<cmd>History<cr>"),
        -- button("SPC f f", "  Find word", "<cmd>Rg<cr>"),
        button("SPC g b", "  Open repo", "<cmd>GBrowse<cr>"),
        -- button("SPC s s", "  Open session", "<cmd>source Session.vim<cr>"),
        button("SPC s s", "  Open session", "<cmd>lua require('persistence').load()<cr>"),
        button("SPC l s", "  Update plugins", "<cmd>Lazy sync<cr>"),
        button("q", "  Quit", "<Cmd>qa<CR>"),
    },
    opts = {
        spacing = 1,
    },
}

local quote = {
    type = "text",
    val = require "alpha.fortune" (),
    opts = {
        position = "center",
        hl = "AlphaQuote",
    },
}

local config = {
    layout = {
        { type = "padding", val = 12 },
        header,
        { type = "padding", val = 2 },
        metadata,
        { type = "padding", val = 1 },
        plugins,
        { type = "padding", val = 1 },
        -- buttons,
        quote,
    },
    opts = {
        margin = 5,
    },
}

require("alpha").setup(config)

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
