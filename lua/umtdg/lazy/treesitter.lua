---@type LazyPluginSpec
---@diagnostic disable: missing-fields
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup {
      install_dir = vim.fn.stdpath 'data' .. '/site',
    }
    require('nvim-treesitter')
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
