local textobjs = require 'various-textobjs';

textobjs.setup { useDefaultKeymaps = false }

local keymap = vim.keymap.set
keymap({ 'o', 'x' }, 'as', function() textobjs.subword('outer') end)
keymap({ 'o', 'x' }, 'ls', function() textobjs.subword('inner') end)
keymap({ 'o', 'x' }, 'ai', function() textobjs.indentation('outer', 'inner') end)
keymap({ 'o', 'x' }, 'li', function() textobjs.indentation('inner', 'inner') end)
keymap({ 'o', 'x' }, 'C', function() textobjs.toNextClosingBracket() end)
keymap({ 'o', 'x' }, 'am', function() textobjs.chainMember('outer') end)
