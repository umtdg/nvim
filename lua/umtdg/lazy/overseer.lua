---@type LazyPluginSpec
return {
  'stevearc/overseer.nvim',

  ---@module 'overseer'
  ---@type overseer.SetupOpts
  opts = {
    task_list = {
      direction = 'bottom',
      keymaps = {
        ['r'] = { 'keymap.run_action', opts = { action = 'restart' }, desc = 'Restart task' },
      },
      render = function(task)
        return require('overseer.render').format_compact(task)
      end,
    },
  },
  config = function(_, opts)
    local overseer = require 'overseer'
    overseer.setup(opts)

    vim.keymap.set('n', '<leader>ot', overseer.toggle, { desc = '[O]verseer [T]oggle' })
    vim.keymap.set('n', '<leader>or', ':OverseerRun<CR>', { desc = '[O]verseer [R]un' })
    vim.keymap.set('n', '<leader>os', ':OverseerShell<CR>', { desc = '[O]verseer [S]hell' })
  end,
}
