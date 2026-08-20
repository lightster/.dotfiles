return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- Servers that need a stable Node run against nvim/mise.toml rather than
      -- whatever the open project pins. `mise exec -C` replaces the environment
      -- instead of layering onto it, so nothing from the project reaches them.
      local function editor_env(...)
        local cmd = { 'mise', 'exec', '-C', vim.fn.stdpath('config'), '--' }
        vim.list_extend(cmd, { ... })
        return cmd
      end

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      vim.lsp.config('yamlls', { cmd = editor_env('yaml-language-server', '--stdio') })
      vim.lsp.config('jsonls', { cmd = editor_env('vscode-json-language-server', '--stdio') })
      vim.lsp.config('bashls', { cmd = editor_env('bash-language-server', 'start') })

      vim.lsp.enable({ 'gopls', 'lua_ls', 'yamlls', 'jsonls', 'bashls' })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('dotfiles_lsp_attach', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
          end
        end,
      })
    end,
  },
}
