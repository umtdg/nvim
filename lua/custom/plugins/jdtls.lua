return {
  'mfussenegger/nvim-jdtls',
  dependencies = {
    {
      'nvim-dap',
      keys = {
        {
          '<leader>dt',
          function()
            require('jdtls').test_class()
          end,
          desc = 'Debug: Test current class',
        },
        {
          '<leader>df',
          function()
            require('jdtls').test_nearest_method()
          end,
          desc = 'Debug: Test nearest function',
        },
      },
    },
  },
}
