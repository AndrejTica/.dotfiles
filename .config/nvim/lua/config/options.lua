require("vim._core.ui2").enable({})

local opt = vim.opt

opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Editing
opt.wrap = false
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.mouse = "a"

-- Window splitting
opt.splitright = true
opt.splitbelow = true

-- Files and undo
opt.swapfile = false
opt.backup = false
opt.undofile = true

-- Performance and UI
opt.updatetime = 150
opt.timeoutlen = 300
opt.termguicolors = true
