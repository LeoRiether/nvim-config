local keymap = vim.keymap.set
local command = vim.api.nvim_create_user_command

-- write/quit
keymap('n', '<Leader>w',':w<cr>', {desc='Write', silent=true})
keymap('n', '<Leader>q',':q<cr>', {desc='Quit', silent=true})
keymap('n', '<Leader>x',':wq<cr>', {desc='Write & Quit', silent=true})

-- keymap('n', '<cr>', ':noh<cr><cr>', {noremap=true})
keymap('n', '<esc>', '<esc>:noh<cr>', {noremap=true, silent=true})

-- Up/down/left/right
local opts = {noremap=true}
local nxo = { 'n', 'x', 'o' }
keymap(nxo, 'n', 'gj', opts) -- :h gj
keymap(nxo, 'e', 'gk', opts) -- :h gk
keymap(nxo, 'i', 'l', opts)
keymap(nxo, 'j', 'e', opts)
keymap(nxo, 'k', 'n', opts)
keymap(nxo, 'l', 'i', opts)
keymap('n', '<C-l>', '<C-i>', opts)

-- Move visual selection up & down
keymap('v', 'N', ":m '>+1<CR>gv=gv", {noremap=true, silent=true})
keymap('v', 'E', ":m '<-2<CR>gv=gv", {noremap=true, silent=true})

-- second greatest remaps ever
local nxv = { 'n', 'x', 'v' }
keymap(nxv, "<leader>d", '"_d', {noremap=true})
keymap(nxv, "<leader>y", '"+y', {noremap=true})
keymap(nxv, "<leader>p", '"+p', {noremap=true})
keymap(nxv, "<leader>P", '"+P', {noremap=true})

-- quickfix
keymap('n', '<C-[>', '<cmd>copen<cr>', {noremap=true})
keymap('n', '<M-n>', '<cmd>cnext<cr>', {noremap=true})
keymap('n', '<M-e>', '<cmd>cprev<cr>', {noremap=true})
keymap('n', "<C-'>", vim.diagnostic.setqflist, {silent=true})

-- open :help and quickfix in vertical split
vim.cmd [[ autocmd! FileType help wincmd L | vert resize 80 ]]
vim.cmd [[ autocmd! FileType qf   wincmd L | vert resize 80 ]]

-- macros
keymap('x', '@', ':normal @', {remap=true}) -- execute a macro in every line of the visual selection
keymap('n', 'Q', '@qn', {remap=true})
keymap('x', 'Q', ':normal @q<CR>', {remap=true})

-- ?
keymap('n', '<leader>ca', 'gg"_cG', {noremap=true, desc='Change all'}) -- change all
keymap({ 'n', 'v' }, '<leader>ff', function() vim.lsp.buf.format() end, {noremap=true})
command('H', 'Help', {})
keymap('n', '<Tab>', 'za', {noremap=true})
keymap('n', '<S-Tab>', 'zA', {noremap=true})
keymap('n', '-', ':e.<cr>', {noremap=true})

-- vim-argumentative
keymap('x', 'l,', '<Plug>Argumentative_InnerTextObject', {})
keymap('o', 'l,', '<Plug>Argumentative_OpPendingInnerTextObject', {})
keymap('n', 'K', 'N', {noremap=true})
keymap('n', 'L', 'I', {noremap=true})

-- Window resizing and switching
opts = { noremap=true, silent=true }
keymap('n', 'gwh', '<C-w>h', opts)
keymap('n', 'gwn', '<C-w>j', opts)
keymap('n', 'gwe', '<C-w>k', opts)
keymap('n', 'gwi', '<C-w>l', opts)
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-n>', '<C-w>j', opts)
keymap('n', '<C-e>', '<C-w>k', opts)
keymap('n', '<C-i>', '<C-w>l', opts)
keymap('n', 'gwo', '<C-w>o', opts)
keymap('n', 'gwv', '<C-w><C-v> :vertical resize 83<cr>', opts)
keymap('n', 'gws', '<C-w><C-s>', opts)

-- Activate a 'resize mode' which is like i3's resize mode.
-- by Kk on https://www.youtube.com/watch?v=Zir28KFCSQw
local resize_active = false
local function My_switch_resize_keys()
    local map = function(from, to) keymap('n', from, to, {noremap=true}) end
    if not resize_active then
        resize_active = true
		-- Resize splits
		map('h', ':vertical resize -5<cr>')
		map('n', ':resize +5<cr>')
		map('e', ':resize -5<cr>')
		map('i', ':vertical resize +5<cr>')
		map('_', '<C-w>_')
		map('|', '<C-w><bar>')
		map('=', '<C-w>=')
		-- Move splits
		map('H', '<C-w>H')
		map('N', '<C-w>J')
		map('E', '<C-w>K')
		map('I', '<C-w>L')
		map('R', '<C-w>R')
		-- Remap escape to escape mode
		map('<esc>', My_switch_resize_keys)
        vim.api.nvim_out_write("Resizing mode active\n")
	else
        resize_active = false
		-- Switch back to normal keys (with colemak)
		map('h', 'h')
		map('n', 'j')
		map('e', 'k')
		map('i', 'l')
		map('_', '_')
		map('|', '|')
		map('=', '=')
		map('H', 'H')
		map('N', 'J')
		map('E', 'K')
		map('I', 'L')
		map('R', 'R')
		map('<esc>', '<esc>')
        vim.api.nvim_out_write("Back to normal mode\n")
    end
end
keymap('n', 'gwr', My_switch_resize_keys, {noremap=true, silent=true})

-- zoom/restore window
-- https://stackoverflow.com/a/26551079
vim.cmd [[
    function! s:ZoomToggle() abort
        if exists('t:zoomed') && t:zoomed
            execute t:zoom_winrestcmd
            let t:zoomed = 0
        else
            let t:zoom_winrestcmd = winrestcmd()
            resize
            vertical resize
            let t:zoomed = 1
        endif
    endfunction
    command! ZoomToggle call s:ZoomToggle()
]]
keymap('n', 'gwz', '<cmd>ZoomToggle<cr>', {noremap=true, silent=true})

-- Terminal <esc>
vim.cmd([[
    au TermOpen * tnoremap <Esc> <c-\><c-n>
    au FileType fzf tunmap <Esc>
]])

-- Clipboard (remember to install win32yank (with chocolatey) so nvim can set
-- the + register!)
-- vim.cmd [[command Clip silent execute "w !clip.exe"]]
-- ^ I wrote this in my Windows era
vim.cmd [[command Clip silent execute "w !xclip -selection clipboard"]]

-- Remove Trailing Whitespace
vim.cmd([[
    function TrimWhitespace()
        %s/\s\+$//e
        noh
    endfunction
    command! TrimWhitespace call TrimWhitespace()
]])

local function fold_toggle()
    if vim.o.foldmethod == "indent" then
        vim.o.foldmethod = "marker"
    else
        vim.o.foldmethod = "indent"
    end
    print("foldmethod=" .. vim.o.foldmethod)
end
vim.api.nvim_create_user_command('FoldToggle', fold_toggle, {})

-- lazy.nvim
keymap('n', '<leader>ls', '<cmd>Lazy sync<cr>', {})

-- lightspeed
keymap('n', 's', '<Plug>Lightspeed_omni_s', {noremap=true})

-- Git / fugitive
keymap('n', '<leader>gb', '<cmd>GBrowse<cr>', {})
keymap('v', '<leader>gb', "<cmd>'<,'>GBrowse<cr>", {})
keymap('n', '<leader>gv', '<cmd>Gvdiffsplit<cr>', {})
keymap('n', '<leader>coo', ':Git switch ', {})
keymap('n', '<leader>cob', ':Git switch --create ', {})
keymap('n', '<leader>cot', ':Telescope git_branches<cr>', {})

-- persistence.nvim
keymap('n', '<leader>ss', "<cmd>lua require('persistence').load()<cr>", {})
keymap('n', '<leader>sl', "<cmd>lua require('persistence').load({ last=true })<cr>", {})
command('DeleteOldSessions', function()
    local threshold = 14 -- days
    local th_seconds = threshold * 24 * 60 * 60
    local now = os.time()
    local file_list = require('persistence').list()
    for i = 1,#file_list do
        local file = file_list[i]
        -- print("Checking " .. file)
        local stat_file = io.popen('stat -c %Y "' .. file .. '"')
        local last_modified = stat_file:read()
        -- print("Modified " .. ((now-last_modified) / 24 / 60 / 60) .. " days ago")
        if now - last_modified >= th_seconds then
            -- print("Removing " .. file)
            os.remove(file)
        end
    end
end, {})

-- harpoon
-- TODO: move this to a harpoon config, probably
local function harpoon() return require('harpoon') end
keymap('n', "<leader>hh", function() harpoon().ui:toggle_quick_menu(harpoon():list())  end, {})
keymap('n', "<leader>ha", function() harpoon():list():add() end, {})
for i=1,9 do
    -- '1, '2, ...
    keymap('n', "'" .. i, function() harpoon():list():select(i) end, {})
end

-- very important
keymap('n', '<leader>gol', '<cmd>CellularAutomaton game_of_life<cr>', {})
keymap('n', '<leader>fml', '<cmd>CellularAutomaton make_it_rain<cr>', {})

-- Vimwiki
keymap('n', 'gl>', '<Plug>VimwikiIncreaseLvlSingleItem', {})
keymap('n', 'gl<', '<Plug>VimwikiDecreaseLvlSingleItem', {})

-- Typst
command('Typst', function()
    vim.cmd[[ TermExec cmd="typst watch *.typ" ]]
    vim.cmd[[ ! xdg-open *.pdf ]]
end, {})

-- oil.nvim
keymap('n', '<C-->', function() require('oil').open() end)

-- Relative line numbers
command('RelativeLineNumbers', function()
  vim.o.relativenumber = (not vim.o.relativenumber)
end, {})

-- showtabline
keymap('n', '<leader>tl', function()
  vim.o.showtabline = 2 - vim.o.showtabline
end)

-- other.nvim
keymap('n', '<leader>aa', '<cmd>Other<cr>', {})
keymap('n', '<leader>at', '<cmd>Other test<cr>', {})
keymap('n', '<leader>ai', '<cmd>Other integration<cr>', {})
keymap('n', '<leader>ac', '<cmd>OtherClear<cr>', {})

