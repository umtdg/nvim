---@type LazyPluginSpec
return {
  'nvim-treesitter/nvim-treesitter-context',
  keys = {
    { '<leader>tc', ':TSContext toggle<CR>', desc = '[T]oggle: Tree-sitter [C]ontext' },
    {
      '[C',
      function()
        require('treesitter-context').go_to_context(vim.v.count1)
      end,
      desc = 'Jump to [C]ontext upwards',
      silent = true,
    },
  },
}
