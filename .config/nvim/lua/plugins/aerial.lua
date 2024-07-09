local M = {
  'stevearc/aerial.nvim',
  opts = {},
  -- Optional dependencies
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
}

M.config = function()
  require("aerial").setup({
    -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  })
  -- You probably also want to set a keymap to toggle aerial
end

return M
