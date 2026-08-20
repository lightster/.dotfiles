return {
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require('mini.pairs').setup()
      require('mini.surround').setup()
      require('mini.align').setup()
      require('mini.statusline').setup()
      require('mini.diff').setup()
      require('mini.extra').setup()
      require('mini.pick').setup()

      local map = vim.keymap.set

      map('n', '<c-p>', '<cmd>Pick files<cr>', { desc = 'Find files' })
      map('n', '<leader>p', '<cmd>Pick oldfiles<cr>', { desc = 'Recent files' })
      map('n', '\\', '<cmd>Pick grep_live<cr>', { desc = 'Search in project' })
      map('n', '<leader>b', '<cmd>Pick buffers<cr>', { desc = 'Buffers' })
      map('n', '<leader>.', '<cmd>Pick lsp scope="workspace_symbol"<cr>', { desc = 'Workspace symbols' })

      map('n', '<leader>aa', 'gaips=><cr>', { remap = true, desc = 'Align paragraph on =>' })
      map('x', '<leader>aa', 'gas=><cr>', { remap = true, desc = 'Align on =>' })
      map('n', '<leader>a:', 'gaips:<cr>', { remap = true, desc = 'Align paragraph on :' })
      map('x', '<leader>a:', 'gas:<cr>', { remap = true, desc = 'Align on :' })
    end,
  },
}
