---@type LazyPluginSpec
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    notify_on_error = true,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      java = { 'jdtls' },
      nix = { 'nixfmt' },
      javascript = { 'biome', 'prettierd', 'prettier' },
      typescript = { 'biome', 'prettierd', 'prettier' },
      javascriptreact = { 'biome', 'prettierd', 'prettier' },
      typescriptreact = { 'biome', 'prettierd', 'prettier' },
    },
    formatters = {
      black = {
        prepend_args = {
          '--preview',
          '--enable-unstable-feature',
          'string_processing',
        },
      },
    },
  },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
}
