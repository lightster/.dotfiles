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

      map('n', '<leader>c', function()
        local root = vim.fn.systemlist({ 'git', 'rev-parse', '--show-toplevel' })[1]
        if vim.v.shell_error ~= 0 then
          return vim.notify('Not in a git repo', vim.log.levels.WARN)
        end
        MiniPick.builtin.cli({
          command = { 'git', '-C', root, '-c', 'core.quotepath=false', 'status', '--porcelain', '-uall' },
          postprocess = function(lines)
            local items = {}
            for _, line in ipairs(lines) do
              if line ~= '' then
                -- Renames are reported as "old -> new"; keep the new path
                local path = line:sub(4)
                table.insert(items, path:match('.* %-> (.*)') or path)
              end
            end
            return items
          end,
        }, { source = { name = 'Git changed', cwd = root } })
      end, { desc = 'Changed files (git)' })

      map('n', '<leader>aa', 'gaips=><cr>', { remap = true, desc = 'Align paragraph on =>' })
      map('x', '<leader>aa', 'gas=><cr>', { remap = true, desc = 'Align on =>' })
      map('n', '<leader>a:', 'gaips:<cr>', { remap = true, desc = 'Align paragraph on :' })
      map('x', '<leader>a:', 'gas:<cr>', { remap = true, desc = 'Align on :' })
    end,
  },
}
