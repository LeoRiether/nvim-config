local format_sync_grp = vim.api.nvim_create_augroup("UiuaFormat", {clear=true})
vim.api.nvim_create_autocmd({'BufWritePost'}, {
  pattern = '*.ua',
  callback = function()
      vim.cmd [[ :silent !uiua fmt % ]]
  end,
  group = format_sync_grp,
})
