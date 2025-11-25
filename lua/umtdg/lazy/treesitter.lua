---@type LazyPluginSpec
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',
  ---@module 'nvim-treesitter'
  ---@type TSConfig
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    ensure_installed = { 'bash', 'lua', 'vim' },
    auto_install = true,
    modules = {
      ---@diagnostic disable-next-line: missing-fields
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'rust' },
      },
      ---@diagnostic disable-next-line: missing-fields
      indent = {
        enable = true,
        disable = { 'rust' },
      },
    },
  },
}
