return {
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    opts = {
      formatters_by_ft = {
        bash = { 'shfmt' },
        css = { 'prettier' },
        go = { 'goimports', 'gofmt' },
        html = { 'prettier' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        lua = { 'stylua' },
        markdown = { 'prettier' },
        sh = { 'shfmt' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        yaml = { 'prettier' },
      },
      format_on_save = {
        timeout_ms = 2000,
        -- do not format in projects where tools are not explicitly installed
        lsp_format = 'never',
      },
    },
  },
}
