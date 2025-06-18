vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.rule",
  callback = function()
    vim.bo.syntax = "javascript"
  end,
})
