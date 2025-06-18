vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "Justfile",
  callback = function()
    vim.bo.filetype = "just"
  end,
})
