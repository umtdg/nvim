---@type LazyPluginSpec
return {
  'akinsho/bufferline.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = { 'BufEnter' },
  ---@module 'bufferline'
  ---@type bufferline.UserConfig
  opts = {
    options = {
      mode = 'buffers',
      style_preset = 2, -- 1: default, 2: minimal, 3: no_bold, 4: no_italic
      themable = true,
      numbers = 'buffer_id',
      indicator = { style = 'underline' },
      diagnostics = 'nvim_lsp',
      color_icons = true,
    },
  },
  keys = {
    {
      '<leader>bp',
      ':BufferLineCyclePrev<CR>',
      desc = '[B]uffers: [P]revious',
    },
    {
      '<leader>bn',
      ':BufferLineCycleNext<CR>',
      desc = '[B]uffers: [N]ext',
    },
    {
      '<leader>bj',
      ':BufferLinePick<CR>',
      desc = '[B]uffers: [J]ump',
    },
    {
      '<leader>bcp',
      ':BufferLinePickClose<CR>',
      desc = '[B]uffers: [C]lose [P]ick',
    },
    {
      '<leader>bch',
      ':BufferLineCloseLeft<CR>',
      desc = '[B]uffers: [C]lose [L]eft',
    },
    {
      '<leader>bcl',
      ':BufferLineCloseRight<CR>',
      desc = '[B]uffers: [C]lose [R]ight',
    },
    {
      '<leader>bco',
      ':BufferLineCloseOthers<CR>',
      desc = '[B]uffers: [C]lose [O]thers',
    },
  },
}
