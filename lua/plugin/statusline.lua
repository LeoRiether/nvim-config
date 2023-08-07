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

    local function line() return "L %l:%L" end
    local function column() return "C %v" end
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

    require("lualine").setup {
        options = {
            theme = cs,
            globalstatus = false,
            component_separators = { left = '\\', right = '/' },
            section_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { filename },
            lualine_x = { 'overseer', 'encoding', fileformat },
            lualine_y = { line, column, words },
            lualine_z = { 'filetype' },
        },
        tabline = {
            lualine_a = { buffers, },
            lualine_z = { "tabs" },
        },
        extensions = { "quickfix", "fugitive" },
    }
end

setup_lualine()
