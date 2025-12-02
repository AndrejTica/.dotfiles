vim.pack.add({"https://github.com/lervag/vimtex"})

-- This is necessary for VimTeX to load properly. "indent" is optional.
-- Note: Most plugin managers will do this automatically!
vim.cmd([[filetype plugin indent on]])

-- Enable Vim/Neovim syntax-related features.
-- Note: Most plugin managers will do this automatically!
vim.cmd([[syntax enable]])

-- Viewer options: built-in viewer method
vim.g.vimtex_view_method = 'zathura'

-- Or generic viewer interface
-- vim.g.vimtex_view_general_viewer = 'okular'
vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'

-- Compiler backend (default is latexmk; here we set it explicitly)
vim.g.vimtex_compiler_method = 'latexrun'

-- Localleader for VimTeX mappings (default is "\")
-- vim.g.maplocalleader = ','
