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
vim.filetype.add {
  extension = {
    jsx = 'javascriptreact',
    tsx = 'typescriptreact',
  },
}

-- Treesitter Highlight
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype

    local function fallback()
      print 'Fallback to syntax'
      vim.bo[ev.buf].syntax = 'ON'
    end

    local function start()
      print 'Start TS'
      if not vim.api.nvim_buf_is_valid(ev.buf) then
        return
      end

      -- try to start treesitter, if fails, fallback to regex
      -- this is in order to silence errors when trying to start
      -- treesitter for filetypes like `neo-tree` or `dashboard`.
      local ok = pcall(vim.treesitter.start, ev.buf)
      if not ok then
        fallback()
      end
    end

    -- if parser is not available, fallback to syntax
    if not require('nvim-treesitter.parsers')[ft] then
      print 'TS parser is not available'
      fallback()
      return
    end

    local ts = require 'nvim-treesitter'
    if vim.list_contains(ts.get_installed(), ft) then
      print 'Parser available'
      start()
      return
    end

    -- if parser is available and is installed, start
    print 'Install TS parser'
    ts.install(ft):await(function ()
      start()
    end)
  end,
})

-- Treesitter Indent
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- vim: ts=2 sts=2 sw=2 et
