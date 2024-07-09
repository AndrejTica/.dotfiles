local M = { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 1500
  end,
}

M.config = function()
  require('which-key').setup()
end

return M
