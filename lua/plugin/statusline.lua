-- "┃", "█", "", "", "", "", "", "", "●"

local function setup_lualine()
    -- local cs = vim.g.colors_name or vim.env.NVIM_COLORSCHEME or "onedark"
    local cs = 'auto'

    local fileformat = {
        'fileformat',
        symbols = {
            -- unix = ' ', -- (not) e712
            unix = ' ',
            dos = '',  -- e70f
            mac = '',  -- e711
        }
    }

    local function cursor() return "L:C %l:%v" end
    local selection = {
        function()
            local isVisualMode = vim.fn.mode():find("[Vv]")
            if not isVisualMode then return "" end
            local starts = vim.fn.line("v")
            local ends = vim.fn.line(".")
            local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
            return "V " .. tostring(lines) .. "L " .. tostring(vim.fn.wordcount().visual_chars) .. "C"
        end,
        cond = function()
            return vim.fn.mode():find("[Vv]") ~= nil
        end,
    }
    local function words() return vim.fn.wordcount().words .. "w" end

    local buffers = {
        "buffers",
        max_length = function() return vim.o.columns - 3 end,
        show_filename_only = false,
    }

    local filename = {
        'filename',
        path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path,
                  -- 3 = absolute path with ~ as home
    }

    local function neovim_logo()
        return ""
    end

    local separator = ({
        {
            section = { left = '', right = '' },
            component = { left = '', right = '' }
        },
        {
            section = { left = "", right = "" },
            component = { left = '\\', right = '/' },
        },
        {
            section = { left = '', right = '' },
            component = { left = '', right = '' }
        },
        {
            section = { left = '', right = '' },
            component = { left = '', right = '' }
        },
        {
            section = { left = "", right = "" },
            component = { left = '', right = '' },
        },
    })[5]

    require("lualine").setup {
        options = {
            theme = cs,
            globalstatus = false,
            section_separators = separator.section,
            component_separators = separator.component,
        },
        sections = {
            lualine_a = { neovim_logo, 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { filename },
            lualine_x = { 'encoding', fileformat },
            lualine_y = { cursor, selection, words },
            lualine_z = { 'filetype' },
        },
        tabline = {},
        -- tabline = {
        --        lualine_a = { buffers, },
        --        lualine_z = { "tabs" },
        -- },
        extensions = { "quickfix", "fugitive" },
    }
end

setup_lualine()

