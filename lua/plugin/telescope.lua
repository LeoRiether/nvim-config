-- TODO: preview images with `kitty icat`
local telescope = require'telescope'
local builtin = require'telescope.builtin'
local actions_state = require'telescope.actions.state'
local actions = require'telescope.actions'
local from_entry = require'telescope.from_entry'

local defaults = {
    preview = {
        -- Use terminal image viewer to preview images
        -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#use-terminal-image-viewer-to-preview-images
        mime_hook = function(filepath, bufnr, opts)
            local is_image = function(filepath)
                local image_extensions = {'png','jpg','jpeg'}   -- Supported image formats
                local split_path = vim.split(filepath:lower(), '.', {plain=true})
                local extension = split_path[#split_path]
                return vim.tbl_contains(image_extensions, extension)
            end
            if is_image(filepath) then
                local term = vim.api.nvim_open_term(bufnr, {})
                local function send_output(_, data, _ )
                    for _, d in ipairs(data) do
                        vim.api.nvim_chan_send(term, d..'\r\n')
                    end
                end
                vim.fn.jobstart(
                {
                    'catimg', filepath  -- Terminal image viewer command
                },
                {on_stdout=send_output, stdout_buffered=true, pty=true})
            else
                require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
            end
        end
    },
    path_display = { filename_first = {} },
}

local extensions = {
    fzy_native = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    },
    fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    },

    ["ui-select"] = {
        require("telescope.themes").get_dropdown {
            -- even more opts
        },
    },
}

local function cd(prompt_bufnr)
    local selection = actions_state.get_selected_entry()
    local dir = vim.fn.fnamemodify(selection.path, ":p:h")
    actions.close(prompt_bufnr)
    -- Depending on what you want put `cd`, `lcd`, `tcd`
    vim.cmd(string.format("silent lcd %s", dir))
end

-- currently O(N²) because mark.add_file checks if the file a repeat in O(N) :(
local function add_all_to_harpoon(bufnr)
    local picker = actions_state.get_current_picker(bufnr)
    local manager = picker.manager

    local mark = require'harpoon.mark'
    for entry in manager:iter() do
        mark.add_file(from_entry.path(entry, false, false))
    end
    actions.close(bufnr)
    require'harpoon.ui'.toggle_quick_menu()
end

local function add_selected_to_harpoon(bufnr)
    local picker = actions_state.get_current_picker(bufnr)

    local mark = require'harpoon.mark'
    for _, entry in ipairs(picker:get_multi_selection()) do
        mark.add_file(from_entry.path(entry, false, false))
    end
    actions.close(bufnr)
    require'harpoon.ui'.toggle_quick_menu()
end

local pickers = {
    find_files = {
        mappings = {
            n = {
                ["cd"] = cd,
            },
            i = {
                ["<C-h>"] = add_all_to_harpoon,
                ["<C-k>"] = add_selected_to_harpoon,
            }
        },
    }
}

telescope.setup {
    defaults = defaults,
    extensions = extensions,
    pickers = pickers,
}

-- Extensions
telescope.load_extension("fzf")
telescope.load_extension("harpoon")
telescope.load_extension("ui-select")
telescope.load_extension("git_worktree")

local function get_visual_selection()
  vim.cmd('normal! "vy') -- Yank selection into the unnamed register
  return vim.fn.getreg("v")
end

-- Keymaps
local keymap = vim.keymap.set
local command = vim.api.nvim_create_user_command
local opts = { silent = true, noremap = true }
keymap('n', '<C-p>', builtin.find_files, opts)
keymap('n', '<leader>fp', builtin.find_files, opts)
keymap('n', '<leader>fb', builtin.buffers, opts)
keymap('n', '<leader>fi', builtin.live_grep, opts) -- no fuzzy matching, but faster
keymap('x', '<leader>fu', function()
  builtin.live_grep {
    default_text = get_visual_selection(),
  }
end, opts)
keymap('n', '<leader>fu', function()
  builtin.live_grep {
    default_text = vim.fn.expand("<cword>"),
  }
end, opts)
keymap('n', '<leader>fc', function() 
  -- find class
  builtin.live_grep {
    default_text = "(class|enum|interface|record|type) "
  }
end, opts)
keymap('n', '<leader>fx', function() 
  -- find class with the word under cursor 
  builtin.live_grep {
    default_text = "(class|enum|interface|record|type) " .. vim.fn.expand("<cword>") .. ' ',
  }
end, opts)
keymap('x', '<leader>fx', function() 
  -- find class under selection
  builtin.live_grep {
    default_text = "(class|enum|interface|record|type) " .. get_visual_selection() .. ' ',
  }
end, opts)
keymap('n', '<leader>f/', builtin.current_buffer_fuzzy_find, opts)
keymap('n', '<C-t>', builtin.treesitter, opts)
keymap('n', 'gd', builtin.lsp_definitions, opts)
keymap('n', '<C-]>', function() vim.cmd("normal gwv"); builtin.lsp_definitions(); end, opts)
keymap('n', 'gr', builtin.lsp_references, opts)
keymap('n', 'gi', builtin.lsp_implementations, opts)
keymap('n', 'gT', builtin.lsp_type_definitions, opts)
keymap('n', '<leader>fj', builtin.jumplist, opts)
keymap('n', '<leader>fq', builtin.quickfix, {})
keymap('n', '<leader>fT', '<cmd>TodoTelescope<cr>', opts)
keymap('n', '<leader>tw', function() require('telescope').extensions.git_worktree.git_worktrees() end)
keymap('n', '<leader>tW', function() require('telescope').extensions.git_worktree.create_git_worktree() end)
keymap('n', '<leader>fw', function() require('telescope').extensions.git_worktree.git_worktrees() end)
keymap('n', '<leader>fW', function() require('telescope').extensions.git_worktree.create_git_worktree() end)
command('Commits', builtin.git_commits, {})
command('Stash', builtin.git_stash, {})
command('Checkout', builtin.git_branches, {})
command('Co', builtin.git_branches, {})
command('Maps', builtin.keymaps, {})
command('Helptags', builtin.help_tags, {})
command('Colors', builtin.colorscheme, {})
command('Commands', builtin.commands, {})
command('Ft', builtin.filetypes, {})
command('Planets', builtin.planets, {})
command('Diagnostics', builtin.diagnostics, {})
-- keymap('i', '<C-t>', '<Plug>(fzf-complete-path)', opts) -- ;-;

-- fuzzy live_grep
keymap('n', '<C-f>', function() builtin.grep_string {
    shorten_path = true,
    word_match = "-w",
    only_sort_text = true,
    search = ''
} end, opts)

-- harpoon
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

local function toggle_harpoon() toggle_telescope(require('harpoon'):list()) end
vim.keymap.set("n", "<leader>fh", toggle_harpoon, { desc = "Open harpoon window" })
