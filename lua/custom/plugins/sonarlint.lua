-- https://gitlab.com/schrieveslaach/sonarlint.nvim

return {
  {
    url = 'https://gitlab.com/schrieveslaach/sonarlint.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',

      'llewis6991/gitsigns.nvim',
    },
    config = function()
      require('sonarlint').setup {
        server = {
          cmd = {
            'java',
            '-jar',
            vim.fn.expand '$MASON/packages/sonarlint-language-server/extension/server/sonarlint-ls.jar',
            '-stdio',
            '-analyzers',
            vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarcfamily.jar',
            vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarjava.jar',
            vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarpython.jar',
          },

          settings = {
            sonarlint = {
              connectedMode = {
                connections = {
                  sonarcloud = {
                    {
                      connectionId = 'umtdg',
                      region = 'EU',
                      organizationKey = 'umtdg',
                      disableNotifications = false,
                    },
                  },
                },
              },
            },
          },
        },

        filetypes = {
          'c',
          'cpp',
          'python',
          'java',
        },
      }
    end,
  },
}
