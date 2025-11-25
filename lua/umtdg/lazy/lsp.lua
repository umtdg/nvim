---@type LazyPluginSpec
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'saghen/blink.cmp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('umtdg-lsp-attach', { clear = true }),
      callback = function(event_attach)
        local function map(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event_attach.buf, desc = 'LSP: ' .. desc })
        end

        ---@param client vim.lsp.Client?
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer
        local function client_supports_method(client, method, bufnr)
          return client and client:supports_method(method, bufnr)
        end

        map('grn', vim.lsp.buf.rename, '[R]e[N]ame')
        map('gqa', vim.lsp.buf.code_action, 'Code [A]ction')
        map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]ecleration')
        map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]type Definition')

        local client = vim.lsp.get_client_by_id(event_attach.data.client_id)
        if client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event_attach.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('umtdg-lsp-highlight', { clear = false })

          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event_attach.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event_attach.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd({ 'LspDetach' }, {
            group = vim.api.nvim_create_augroup('umtdg-lsp-detach', { clear = true }),
            callback = function(event_detach)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'umtdg-lsp-highlight', buffer = event_detach.buf }
            end,
          })
        end

        if client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event_attach.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event_attach.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    vim.diagnostic.config {
      float = {
        style = 'minimal',
        border = 'rounded',
        source = true,
        header = '',
        prefix = '',
      },
    }

    local capabilities = require('blink-cmp').get_lsp_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    ---@type table<string, vim.lsp.Config>
    local servers = {
      lua_ls = {
        settings = {
          Lua = { completion = { callSnippet = 'Replace' } },
        },
      },
      clangd = {
        cmd = {
          'clangd',
          '--pretty',
          '--background-index',
          '--completion-style=detailed',
        },
      },
      zls = {
        settings = {
          zls = {
            enable_snippets = true,
            warn_style = true,
          },
        },
      },
      pyright = {},
      rust_analyzer = {
        check = { command = 'clippy' },
        files = {
          exclude = {
            '~/.rustup',
            '~/.cargo',
          },
        },
      },
    }

    local ensure_installed = { 'stylua', 'black', 'isort', 'clang-format' }
    ensure_installed = vim.tbl_deep_extend('force', ensure_installed, vim.tbl_keys(servers or {}))
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    for name, config in pairs(servers) do
      config = config or {}
      config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})

      vim.lsp.config(name, config)
    end

    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_enable = {
        exclude = { 'jdtls' },
      },
    }
  end,
}
