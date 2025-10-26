vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.undofile = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"
vim.o.mouse = "a"
vim.o.scrolloff = 999
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.virtualedit = "block"
vim.o.inccommand = "split"
vim.o.incsearch = true
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.termguicolors = true
vim.o.showmode = false
vim.o.hlsearch = true
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"
vim.o.laststatus = 3
vim.opt.diffopt:append("linematch:60")
vim.o.winborder = 'rounded'
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_winsize = 20
vim.g.clipboard = {
  name = 'xclip',
  copy = {
    ['+'] = { 'xclip', '-quiet', '-i', '-selection', 'clipboard' },
    ['*'] = { 'xclip', '-quiet', '-i', '-selection', 'primary' },
  },
  paste = {
    ['+'] = { 'xclip', '-o', '-selection', 'clipboard' },
    ['*'] = { 'xclip', '-o', '-selection', 'primary' },
  },
  cache_enabled = 1, -- cache MUST be enabled, or else it hangs on dd/y/x and all other copy operations
}


keymap = function(mode, keys, func, desc)
  vim.keymap.set(mode, keys, func, { noremap = true, silent = true, desc = ' ' .. desc })
end


keymap('n', '<C-s>', ':w<CR>', 'Save file')
keymap('n', '<leader>,', '<c-w>5<', 'Resize split left')
keymap('n', '<leader>.', '<c-w>5>', 'Resize split right')
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>', 'Clear highlight')
keymap('n', '<leader>e', ':w | Run<CR>', 'Run program')
keymap('v', '<', '<gv', 'Stay in indent mode')
keymap('v', '>', '>gv', 'Stay in indent mode')
keymap('n', 'n', 'nzz', 'On each search next item stay centered')
keymap('n', 'N', 'Nzz', 'On each search prev item stay centered')
keymap('n', '*', '*zz', 'On jump to next word under cursor stay centered')
keymap('n', '#', '#zz', 'On jump to prev word under cursor stay centered')
keymap('x', 'p', [["_dP]], 'As we paste over something, keep the thing we yanked before')
keymap('n', '<C-f>', ':!tmux neww tmux-sessionizer<CR>', 'New tmux session')
keymap('n', 'x', '"_x', 'x does not override yanked buffer')
keymap('n', '<leader>n', ':Lexplore<CR>', 'Open netrw')
keymap('n', '<leader>z', ':b#<CR>', 'Go to prev open buffer')



vim.pack.add({"https://github.com/nvim-tree/nvim-web-devicons"})
vim.pack.add({"https://github.com/nvim-lua/plenary.nvim"})
require('colorscheme')
require('treesitter')
require('treesitter_text')
require('fzf')
require('lualine')
require('lsp')
require('terminal')
require('mason_config')
require('autopair')
require('blink')
require('conform_config')
require('jdtls_config')


--todo: see why jdtls is attaching

-- Basic autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", {})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})


vim.api.nvim_create_user_command("Openconfig", function()
  local builtin = require 'fzf-lua'
  builtin.files { cwd = vim.fn.stdpath 'config' }
end, {})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_user_command("SaveQuery", function()
  vim.api.nvim_exec([[execute "normal \<Plug>(DBUI_SaveQuery)"]], false)
end, {})


local run_commands = {
  python = "python3 %",
  java = "java %",
  sh = "./%",
  sql = function()
    vim.cmd([[normal! vip]])
    vim.cmd([[execute "normal \<Plug>(DBUI_ExecuteQuery)"]])
  end,
}


vim.api.nvim_create_user_command("Run", function()
  for file, command in pairs(run_commands) do
    if vim.bo.filetype == file then
      if file == "sql" or file =="plsql" then
        command()
        break
      end
      vim.cmd("vsp | terminal " .. command)
      break
    end
  end
end, {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "checkhealth",
    "fugitive*",
    "git",
	"",
    "help",
    "lspinfo",
    "netrw",
    "notify",
    "qf",
    "query",
    "oil",
    --trouble
  },
  callback = function()
    vim.keymap.set("n", "q", vim.cmd.close, { desc = "Close the current buffer", buffer = true })
  end,
})


vim.api.nvim_create_autocmd("FileType", {                     -- Define an autocommand for when a buffer's filetype is set
  pattern = "netrw",                                          -- Only trigger for netrw buffers (the built-in file explorer)
  callback = function(args)                                   -- Function to run when the autocmd fires; `args` contains the buffer id
    local buf = args.buf                                      -- Capture the current buffer id (netrw buffer)

    vim.keymap.set("n", "%", function()                       -- In normal mode, map '%' to our create-file action
      local filename = vim.fn.input("Filename: ")             -- Prompt the user for a file name (no validation)
      local dir = vim.b[buf].netrw_curdir or vim.fn.getcwd()  -- Get netrw's current directory (fallback to current working dir)
      local path = (vim.fs and vim.fs.joinpath(dir, filename)) -- Build the full path using vim.fs if available
        or (dir .. "/" .. filename)                           -- Fallback string concatenation for older Neovim

      vim.fn.writefile({}, path)                              -- Create an empty file at the path (no checks, no open)

      vim.api.nvim_buf_call(buf, function()                   -- Run the next command in the context of the netrw buffer
        vim.cmd("silent !normal R")                          -- Refresh netrw listing ('R' reloads directory)
      end)
    end, { buffer = buf })                                    -- Make the mapping buffer-local to the netrw buffer
  end,                                                        -- End of callback
})                                                            -- End of autocmd definition

vim.cmd([[cabbrev Wa wa]])
vim.cmd([[cabbrev Wq wq]])
vim.cmd([[cabbrev Wqa wqa]])
vim.cmd([[cabbrev Q q]])
vim.cmd([[cabbrev Qa qa]])
