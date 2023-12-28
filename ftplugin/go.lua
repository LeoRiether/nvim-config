-- Format on write
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
      vim.lsp.buf.format()
  end,
  group = format_sync_grp,
})

