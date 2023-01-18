if not vim.fn.getcwd():match('/comprog') then return end

require('wasp').setup {
    template_path = function() return 'x/template.' .. vim.fn.expand("%:e") end,
    lib = { finder='telescope' },
    competitive_companion = { file = 'inp' },
    graph = { dot = 'neato' },
}
require('wasp').set_default_keymaps()

local keymap = vim.keymap.set
keymap('n', '<leader>tfg', '<cmd>WaspLib 3rdparty/tfg/<cr>', { noremap=true })
keymap('n', '<leader>tiago', '<cmd>WaspLib 3rdparty/tiagodfs<cr>', { noremap=true })
keymap('n', '<leader>jose', '<cmd>WaspLib 3rdparty/jose/<cr>', { noremap=true })
keymap('n', '<leader>bruno', '<cmd>WaspLib 3rdparty/brunomaletta/<cr>', { noremap=true })
