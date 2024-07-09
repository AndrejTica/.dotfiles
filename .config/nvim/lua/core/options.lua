vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

local options = {
  number = true,
  undofile = true,
  relativenumber = true,
  splitbelow = true,
  expandtab = true,
  splitright = true,
  wrap = false,
  tabstop = 4,
  laststatus = 3,
  shiftwidth = 4,
  clipboard = "unnamedplus",
  scrolloff = 999,
  mouse = "a",
  showtabline = 1,
  smartindent = true,
  virtualedit = "block",
  inccommand = "split",
  incsearch = true,
  smartcase = true,
  ignorecase = true,
  termguicolors = true,
  showmode = false,
  updatetime = 150,
  hlsearch = true,
  breakindent = true,
  timeoutlen = 300,
  -- colorcolumn = "90",
}

for option, value in pairs(options) do
  vim.opt[option] = value
end
