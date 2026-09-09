---@type LazyPluginSpec
---@diagnostic disable: missing-fields
return {
  'mrcjkb/rustaceanvim',
  version = '^8',
  lazy = false,
  init = function()
    local project = require('umtdg.projects').get()
    vim.g.rustaceanvim = vim.tbl_extend('force', vim.g.rustaceanvim or {}, project.rustaceanvim or {})
  end,
}
