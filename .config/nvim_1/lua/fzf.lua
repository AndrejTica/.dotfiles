vim.pack.add({"https://github.com/ibhagwan/fzf-lua"})


require 'fzf-lua'.setup {
	actions = {
		 files = {
      		["ctrl-q"]       = FzfLua.actions.file_sel_to_qf,
      		["ctrl-Q"]       = FzfLua.actions.file_sel_to_ll,
			["enter"]       = FzfLua.actions.file_edit_or_qf,
		}
	}
}

keymap('n', '<leader>ff', ':lua require("fzf-lua").files()<CR>', 'Find files in current working directory')
keymap('n', '<leader><leader>', ':lua require("fzf-lua").buffers()<CR>', 'Open current open buffers')
keymap('n', '<leader>fg', ':lua require("fzf-lua").live_grep()<CR>', 'Live grep')
keymap('n', '<leader>fo', ':lua require("fzf-lua").oldfiles()<CR>', 'Search for previously opened files')


