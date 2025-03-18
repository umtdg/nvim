-- https://github.com/kevinhwang91/nvim-ufo

return {
  'kevinhwang91/nvim-ufo',
  version = '*',
  dependencies = { 'kevinhwang91/promise-async' },
  config = function()
    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    local ufo = require 'ufo'
    vim.keymap.set('n', 'zR', ufo.openAllFolds)
    vim.keymap.set('n', 'zM', ufo.closeAllFolds)

    ufo.setup {
      provider_selector = function(_, filetype, _)
        local lsp_with_no_fold = {
          'bashls',
          'dockerls',
        }

        if vim.tbl_contains(lsp_with_no_fold, filetype) then
          return { 'treesitter', 'indent' }
        end

        return { 'lsp', 'indent' }
      end,
    }
  end,
}
