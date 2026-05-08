---@type LazyPluginSpec
---@diagnostic disable: missing-fields
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    local nvim_ts = require 'nvim-treesitter'

    nvim_ts.setup {
      install_dir = vim.fn.stdpath 'data' .. '/site',
    }

    nvim_ts
      .install({
        'bash',
        'lua',
        'vim',
        'json',
        'c',
        'cpp',
        'rust',
        'python',
        'java',
        'markdown',
      })
      :wait()
  end,
}
