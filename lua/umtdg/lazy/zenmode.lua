---@type LazyPluginSpec
return {
  'folke/zen-mode.nvim',
  ---@module 'zen-mode'
  ---@type ZenOptions
  opts = {
    plugins = {
      twilight = { enabled = false },
    },
    -- callback where you can add custom code when the Zen window opens
    -- on_open = function(win) end,
    -- callback where you can add custom code when the Zen window closes
    -- on_close = function() end,
  },
  keys = {
    { '<leader>tz', ':ZenMode<CR>', desc = '[T]oggle: [Z]en mode' },
  },
}
