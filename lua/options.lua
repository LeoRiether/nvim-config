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
-- vim.opt.foldmethod = 'indent' -- Switch to `marker` with :FoldToggle if needed
vim.opt.foldmethod="expr"
vim.opt.foldexpr="nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 1 -- start folded
vim.opt.foldcolumn='0'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shortmess:append('A')
vim.opt.mouse = 'a'
vim.g.mapleader = ' '
vim.opt.pumheight = 7 -- 7 completion suggestions at most
vim.opt.colorcolumn = "81"
vim.opt.termguicolors = true -- enable true colors support
-- vim.opt.virtualedit = 'all' -- edit past the end character

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
vim.g.vimtex_compiler_latexmk = {
    build_dir = 'texbin'
}

-- Codi
vim.g['codi#interpreters'] = {
    python = { bin = 'python3' }
}
vim.g['codi#autocmd'] = 'InsertLeave'

-- Vimwiki
vim.g.vimwiki_map_prefix = '<Leader><Leader>'
local vimwiki_default = {
    path = '~/Workspace/vimwiki',
    template_path = '/home/leonardo/Workspace/vimwiki_html/templates/',
    template_default = 'def_template',
    template_ext = '.html',
    -- auto_tags = 1,
}
local vimwiki_tn = extend(vimwiki_default, { path='~/Workspace/unb/tn' })
vim.g.vimwiki_list = { vimwiki_default, vimwiki_tn }

-- Hexmode
vim.g.hexmode_patterns = '*.bin,*.exe,*.dat,*.o'
