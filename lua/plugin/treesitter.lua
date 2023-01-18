require('nvim-treesitter.configs').setup {
    ensure_installed = { "cpp", "python", "rust", "lua" },
    highlight = { enable = true },
}
