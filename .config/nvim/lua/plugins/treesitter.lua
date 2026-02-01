vim.pack.add({
	{src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master"},
})


require("nvim-treesitter.configs").setup({
    ensure_installed = { 'bash',
		'c',
		'python',
		'diff',
		'html',
		'lua',
		'luadoc',
		'markdown',
		'vim',
		'vimdoc',
		'java'
		},
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true}
  })


