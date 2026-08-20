local function augroup(name)
  return vim.api.nvim_create_augroup('dotfiles_' .. name, { clear = true })
end

vim.filetype.add({
  extension = { phtml = 'html' },
  pattern = {
    ['.*%.zsh%-theme'] = 'zsh',
    ['.*zshrc'] = 'zsh',
  },
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('clipboard'),
  desc = 'Send yanked text to the terminal clipboard via OSC 52',
  callback = function()
    if vim.v.event.operator ~= 'y' then
      return
    end
    require('vim.ui.clipboard.osc52').copy('+')(vim.v.event.regcontents, vim.v.event.regtype)
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup('trim'),
  desc = 'Trim trailing whitespace, leaving the cursor where it was',
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('prose'),
  pattern = 'markdown',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.list = false
    vim.opt_local.textwidth = 0
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('gitcommit'),
  pattern = 'gitcommit',
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 72
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('indent'),
  pattern = { 'php', 'go' },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('html'),
  pattern = 'html',
  callback = function()
    vim.opt_local.smartindent = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('zsh'),
  pattern = 'zsh',
  callback = function()
    vim.opt_local.commentstring = '# %s'
  end,
})
