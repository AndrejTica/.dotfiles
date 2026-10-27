vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = require("config.shared").keymap
_G.keymap = keymap

-- Files and splits
keymap("n", "<C-s>", ":w<CR>", "Save file")
keymap("n", "<leader>,", "<c-w>5<", "Resize split left")
keymap("n", "<leader>.", "<c-w>5>", "Resize split right")

-- Indentation
keymap("n", "<Tab>", "==", "Reindent current line")

-- Search
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear highlight")
keymap("n", "n", "nzz", "On each search next item stay centered")
keymap("n", "N", "Nzz", "On each search prev item stay centered")
keymap("n", "*", "*zz", "On jump to next word under cursor stay centered")
keymap("n", "#", "#zz", "On jump to prev word under cursor stay centered")

-- Visual mode
keymap("v", "<", "<gv", "Stay in indent mode")
keymap("v", ">", ">gv", "Stay in indent mode")
keymap("x", "p", [["_dP]], "As we paste over something, keep the thing we yanked before")

-- Registers
keymap("n", "x", '"_x', "x does not override yanked buffer")

-- Navigation and tooling
keymap("n", "<C-j>", ":!tmux neww tmux-sessionizer<CR>", "New tmux session")
keymap("n", "<leader>b", ":Explore<CR>", "Open netrw")
keymap("n", "<leader>z", ":b#<CR>", "Go to prev open buffer")

-- Execution
keymap("n", "<leader>e", ":w | Run<CR>", "Run program")
keymap("x", "<leader>e", ":RunCommand<CR>", "Run the command in buffer")
