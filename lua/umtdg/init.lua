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

-- Neovim detects jsx/tsx files as javascriptreact/typescriptreact
-- but treesitter needs jsx/tsx
vim.filetype.add({
  extension = {
    jsx = 'javascriptreact',
    tsx = 'typescriptreact',
  }
})

-- Treesitter Highlight
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    -- if parser is available, install
    local ft = vim.bo[ev.buf].filetype
    if require('nvim-treesitter.parsers')[ft] then
      require('nvim-treesitter').install(ft)
    end

    -- try to start treesitter, if fails, fallback to regex
    -- this is in order to silence errors when trying to start
    -- treesitter for filetypes like `neo-tree` or `dashboard`.
    local ok = pcall(vim.treesitter.start)
    if not ok then
      vim.bo[ev.buf].syntax = 'ON'
    end
  end,
})

-- Treesitter Indent
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- vim: ts=2 sts=2 sw=2 et
