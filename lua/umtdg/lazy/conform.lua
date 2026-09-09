local project = require('umtdg.projects').get()
local project_conform = project.conform or {}

local defaults = {
  notify_on_error = true,
  formatters_by_ft = {
    lua = { 'stylua' },
    python = function(bufnr)
      -- Use ruff if available, otherwise use isort + black
      local ruff_info = require('conform').get_formatter_info('ruff_format', bufnr)
      if ruff_info.available then
        return { 'ruff_organize_imports', 'ruff_format' }
      end

      return { 'isort', 'black' }
    end,
    c = { 'clang-format' },
    cpp = { 'clang-format' },
    java = { 'jdtls' },
    nix = { 'nixfmt' },
    javascript = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true },
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
}

local opts = vim.tbl_deep_extend('force', defaults, project_conform)

local lsp_format = project_conform.lsp_format or 'fallback'
opts.lsp_format = nil

---@type LazyPluginSpec
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = opts,
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = lsp_format }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
}
