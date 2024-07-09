local M = {
  "folke/persistence.nvim",
  event = "BufReadPre",       -- this will only start session saving when an actual file was opened
  opts = {
    -- add any custom options here
  },
}

M.config = function()
  require("persistence").setup({
    dir = vim.fn.expand(vim.fn.stdpath "state" .. "/sessions/"),
    options = { "buffers", "curdir", "tabpages", "winsize" }
  })
end

return M
