return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local bufferline = require 'bufferline'
    bufferline.setup {
      options = {
        mode = 'buffers',
        style_preset = bufferline.style_preset.default,
        themable = true,
        numbers = 'none',
        indicator = {
          icon = '▎',
          style = 'icon',
        },
        diagnostics = 'nvim_lsp',
        color_icons = true,
      },
    }

    vim.keymap.set('n', '<leader>bp', ':BufferLineCyclePrev<CR>', { desc = '[B]uffers [P]revious' })
    vim.keymap.set('n', '<leader>bn', ':BufferLineCycleNext<CR>', { desc = '[B]uffers [N]ext' })
    vim.keymap.set('n', '<leader>bj', ':BufferLinePick<CR>', { desc = '[B]uffers [J]ump' })
    vim.keymap.set('n', '<leader>bc', ':BufferLinePickClose<CR>', { desc = '[B]uffers [C]lose' })
  end,
}
