local M = {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
}

M.config = function()
  vim.o.background = "dark" -- or "light" for light mode
  vim.cmd([[colorscheme gruvbox]])
end

return M
