---@type LazyPluginSpec
---@diagnostic disable: missing-fields
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',
  ---@module 'nvim-treesitter'
  ---@type TSConfig
  opts = {
    ensure_installed = { 'bash', 'lua', 'vim' },
    auto_install = true,
    ---@type TSModule
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'rust' },
    },
    ---@type TSModule
    indent = {
      enable = true,
      disable = { 'rust' },
    },
  },
}
