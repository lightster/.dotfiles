return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install({
        'bash',
        'go',
        'gomod',
        'gosum',
        'html',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'php',
        'query',
        'vim',
        'vimdoc',
        'yaml',
      })

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('dotfiles_treesitter', { clear = true }),
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}
