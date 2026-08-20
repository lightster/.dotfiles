local map = vim.keymap.set

map('n', '<leader>e', '<c-^>', { desc = 'Switch to alternate buffer' })
map('n', '<leader>o', 'o<esc>', { desc = 'Insert line below' })
map('n', '<leader>O', 'O<esc>', { desc = 'Insert line above' })
map('n', '<leader>=', '=i}', { desc = 'Re-indent surrounding block' })
map('n', '<leader>h', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })
