---@type LazyPluginSpec
return {
  'rcarriga/nvim-notify',
  config = function()
    local notify = require 'notify'

    notify.setup {
      stages = 'fade',
      position = 'top_right',
      timeout = 2000,
      merge_duplicates = true,
      render = 'compact',
    }

    vim.notify = notify
  end,
}
