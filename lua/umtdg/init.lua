vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'umtdg.options'
require 'umtdg.keymaps'
require 'umtdg.lazy-init'

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('umtdg-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
