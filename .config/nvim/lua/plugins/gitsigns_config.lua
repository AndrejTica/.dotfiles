vim.pack.add({"https://github.com/lewis6991/gitsigns.nvim"})


keymap('n', '<leader>gj', "<cmd>lua require('gitsigns').next_hunk({navigation_message = false})<cr>", 'Next hunk')
keymap('n', '<leader>gk', "<cmd>lua require('gitsigns').prev_hunk({navigation_message = false})<cr>", 'Prev hunk')
keymap('n', '<leader>gp', "<cmd>lua require('gitsigns').preview_hunk()<cr>", 'Preview hunk')
keymap('n', '<leader>gr', "<cmd>lua require('gitsigns').reset_hunk()<cr>", 'Reset hunk')
keymap('n', '<leader>gR', "<cmd>lua require('gitsigns').reset_buffer()<cr>", 'Reset buffer')
keymap('n', '<leader>gd', '<cmd>Gitsigns diffthis HEAD<cr>', 'Diff this')
