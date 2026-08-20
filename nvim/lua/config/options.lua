local opt = vim.opt

opt.scrolloff = 6

opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

opt.list = true
opt.listchars = { tab = '→ ', trail = '•', extends = '⟩', precedes = '⟨' }

opt.number = true
opt.relativenumber = true
opt.numberwidth = 6

opt.colorcolumn = '+1,+2,+3,+4,+5'

opt.ignorecase = true
opt.smartcase = true

opt.undofile = true

if vim.fn.executable('rg') == 1 then
  opt.grepprg = 'rg --vimgrep --smart-case'
  opt.grepformat = '%f:%l:%c:%m'
end

-- Left unset on purpose. Routing the unnamed register through the system
-- clipboard would make `d`, `c`, and `x` overwrite it too; yanks are pushed to
-- the terminal's clipboard by the TextYankPost autocommand instead.
opt.clipboard = ''
