-- Basic autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", {})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Enable spell checking for text and markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "markdown" },
  callback = function()
    vim.opt_local.spell = true

 	vim.opt_local.textwidth = 80
    -- draw a vertical line at the textwidth column
    vim.opt_local.colorcolumn = tostring(vim.opt_local.textwidth:get())
  end,
})

-- Define a helper function that returns the visually selected text as one string
local function get_visual_selection()
  local s = vim.fn.getpos("'<")[2]           -- get the start line number of the visual selection (mark '<)
  local e = vim.fn.getpos("'>")[2]           -- get the end line number of the visual selection (mark '>)

  local lines = vim.fn.getline(s, e)         -- get all lines between start and end (inclusive)
  return table.concat(lines, "\n")           -- join the lines into a single string separated by newlines
end

vim.api.nvim_create_user_command("RunCommand", function()
  local cmd = get_visual_selection()         

  vim.cmd("vsplit | terminal")               

  local term_buf = vim.api.nvim_get_current_buf()  

  vim.fn.chansend(vim.b.terminal_job_id, cmd .. "\n") -- send the selected text as a command to the terminal (plus Enter)

  vim.api.nvim_buf_set_keymap(              -- define a buffer-local keymap for this terminal buffer
    term_buf,
    "t",
    "q",
    [[<C-\><C-n>:close<CR>]],               -- leave terminal mode, then run :close to close the split
    { noremap = true, silent = true }       -- do not remap "q" further, and do not show command messages
  )
end, {range = true})


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
  	vim.schedule(function()
    local plug = vim.api.nvim_replace_termcodes("<Plug>(DBUI_ExecuteQuery)", true, false, true)
    vim.api.nvim_feedkeys(plug, "n", false)
	end)
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
	"terminal"
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
