---@type LazyPluginSpec
return {
  'saghen/blink.cmp',
  event = { 'VimEnter' },
  dependencies = {
    'folke/lazydev.nvim',
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',

      ['<Up>'] = {},
      ['<Down>'] = {},

      ['<Tab>'] = {},
      ['<S-Tab>'] = {},
      ['<C-h>'] = { 'snippet_backward' },
      ['<C-l>'] = { 'snippet_forward' },

      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = {
        auto_show = false,
        auto_show_delay_ms = 500,
      },
    },

    sources = {
      default = { 'lsp', 'lazydev', 'path', 'snippets', 'buffer' },
      providers = {
        lazydev = {
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },

    fuzzy = { implementation = 'lua' },

    signature = { enabled = true },
  },
}
