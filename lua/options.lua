local function extend (a, b)
    return vim.tbl_deep_extend("force", a, b)
end

-- set
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.scrolloff = 5
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.gdefault = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.foldmethod = 'indent' -- Switch to `marker` with :FoldToggle if needed
-- vim.opt.foldmethod="expr"
-- vim.opt.foldexpr="nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99 -- start unfolded
vim.opt.foldcolumn='0'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shortmess:append('A')
vim.opt.mouse = 'a'
vim.g.mapleader = ' '
vim.opt.pumheight = 8 -- 8 completion suggestions at most
vim.opt.colorcolumn = "101"
vim.opt.termguicolors = true -- enable true colors support
-- vim.opt.virtualedit = 'all' -- edit past the end character
-- vim.opt.cmdheight = 0 -- one day...
vim.opt.title = true
vim.opt.signcolumn = "yes"
vim.opt.titlestring = 'vi %f' -- filename

-- netrw
vim.g.netrw_liststyle = 3 -- tree view

-- TeX
vim.cmd [[autocmd FileType tex  setlocal textwidth=80]]

-- Indent F# with spaces
vim.cmd [[autocmd filetype fsharp set tabstop=4 shiftwidth=4 expandtab]]

-- Dashboard
vim.g.dashboard_default_executive = 'fzf'

-- VimTeX
vim.g.vimtex_view_general_viewer = 'okular'
vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_compiler_latexmk = {
    build_dir = 'texbin',
    out_dir   = 'texbin',
}

-- Codi
vim.g['codi#interpreters'] = {
    python = { bin = 'python3' }
}
vim.g['codi#autocmd'] = 'InsertLeave'

-- Vimwiki
vim.g.vimwiki_map_prefix = '<Leader><Leader>'
local vw_default = {
    path = '~/Workspace/vimwiki',
    template_path = '/home/leonardo/Workspace/vimwiki_html/templates/',
    template_default = 'def_template',
    template_ext = '.html',
    -- auto_tags = 1,
}
local vw_journal = extend(vw_default, { path = '~/j' })
local vw_tn = extend(vw_default, { path = '~/Workspace/unb/tn' })
local vw_c3 = extend(vw_default, { path = '~/Workspace/unb/c3' })
local vw_compiladores = extend(vw_default, { path = '~/Workspace/unb/compiladores' })
vim.g.vimwiki_list = { vw_default, vw_journal, vw_tn, vw_c3, vw_compiladores }

vim.cmd [[
    command! Diary VimwikiDiaryIndex
    augroup vimwikigroup
        autocmd!
        " automatically update links on read diary
        autocmd BufRead,BufNewFile diary.wiki VimwikiDiaryGenerateLinks
    augroup end
]]

-- Comments (vim-commentary)
vim.cmd([[
    autocmd FileType cpp    setlocal commentstring=//\ %s
    autocmd FileType c      setlocal commentstring=//\ %s
    autocmd FileType fsharp setlocal commentstring=//\ %s
    autocmd FileType typst  setlocal commentstring=//\ %s
    autocmd FileType asm    setlocal commentstring=#\ %s
]])

-- Hexmode
vim.g.hexmode_patterns = '*.bin,*.exe,*.dat,*.o'

-- nvim-markdown
vim.g.vim_markdown_math = 1

-- makes vim-rhubarb work
vim.cmd [[ command! -nargs=1 Browse silent execute '!open' shellescape(<q-args>,1) ]]
