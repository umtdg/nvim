-- https://github.com/yetone/avante.nvim

return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  version = false,
  opts = {
    provider = 'claude',
    providers = {
      claude = {
        endpoint = 'https://api.anthropic.com',
        model = 'claude-3-5-sonnet-20241022',
        extra_request_body = {
          temperature = 0,
          max_tokens = 4096,
        },
      },
    },
    auto_suggestions_provider = 'claude',
    cursor_applying_provider = nil,
  },
  build = 'make',
  dependencies = {
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
}
