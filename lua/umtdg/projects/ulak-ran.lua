---@type ProjectConfig
return {
  conform = {
    formatters = {
      black = {
        prepend_args = {
          '--line-length',
          '100',
        },
      },
    },
    lsp_format = 'never',
  },
  lint = {
    linters_by_ft = {
      python = { 'flake8' },
    },
    linters = {
      flake8 = function()
        local config = vim.deepcopy(require 'lint.linters.flake8')
        table.insert(config, '--max-line-length=100')
        return config
      end,
    },
  },
}
