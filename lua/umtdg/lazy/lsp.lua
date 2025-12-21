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

    ---@class LspConfig
    ---@field enabled? boolean
    ---@field use_mason? boolean
    ---@field config? vim.lsp.Config
    ---
    ---@type table<string, LspConfig>
    local servers = {
      lua_ls = {
        use_mason = true,
        config = {
          settings = {
            Lua = { completion = { callSnippet = 'Replace' } },
          },
        },
      },
      clangd = {
        use_mason = false,
        config = {
          cmd = {
            'clangd',
            '--pretty',
            '--background-index',
            '--completion-style=detailed',
            '--compile-commands-dir=build',
          },
        },
      },
      zls = {
        config = {
          settings = {
            zls = {
              enable_snippets = true,
              warn_style = true,
            },
          },
        },
      },
      pyright = {
        use_mason = false,
      },
      rust_analyzer = {
        use_mason = false,
        config = {
          settings = {
            ['rust-analyzer'] = {
              files = {
                exclude = {
                  '~/.rustup',
                  '~/.cargo',
                },
              },
            },
          },
        },
      },
      nil_ls = {
        use_mason = false,
      },
    }

    local project_lsp_file = vim.fn.getcwd(0, 0) .. '/.nvim/lsp.lua'
    if vim.fn.filereadable(project_lsp_file) then
      local ok, servers_override = pcall(dofile, project_lsp_file)
      if ok and type(servers_override) == 'table' then
        servers = vim.tbl_deep_extend('force', servers, servers_override or {})
      end
    end

    --- Used by mason-tool-installer to make sure each of them are installed
    local ensure_installed = { 'stylua', 'markdownlint' }
    --- List of LSPs to exclude from mason-lspconfig
    local mason_lspconfig_exclude = { 'jdtls' }
    for name, config in pairs(servers) do
      local enabled = config.enabled ~= false
      local use_mason = config.use_mason ~= false

      --- If LSP is not enabled, do not even bother doing anything with it
      if not enabled then
        goto continue
      end

      local lspconfig = config.config or {}
      lspconfig.capabilities = vim.tbl_deep_extend('force', {}, capabilities, lspconfig.capabilities or {})

      vim.lsp.config(name, lspconfig)

      --- If we are using mason, make sure we have it installed via ensure_installed.
      ---
      --- Otherwise, manually enable and add to mason_lspconfig_exclude to prevent
      --- mason-lspconfig from enabling it. This will allow us to use system-wide
      --- installation of specific LSPs instead of relying on it to be installed via Mason.
      ---
      --- Without this, for example, if clangd is not installed via Mason, but available in path
      --- it won't be enabled.
      if use_mason then
        table.insert(ensure_installed, name)
      else
        vim.lsp.enable(name, true)
        table.insert(mason_lspconfig_exclude, name)
      end

      ::continue::
    end

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_enable = {
        exclude = mason_lspconfig_exclude,
      },
    }
  end,
}
