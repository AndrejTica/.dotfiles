local M = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" }
}

M.config = function()
  local harpoon = require("harpoon")

  -- REQUIRED
  harpoon:setup()
  -- REQUIRED

  vim.keymap.set("n", "<leader>ma", function() harpoon:list():add() end)
  vim.keymap.set("n", "<leader>md", function() harpoon:list():clear() end)
  vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

  vim.keymap.set("n", "Z", function() harpoon:list():select(1) end)
  vim.keymap.set("n", "X", function() harpoon:list():select(2) end)
  vim.keymap.set("n", "C", function() harpoon:list():select(3) end)

  -- Toggle previous & next buffers stored within Harpoon list
  vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
  vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
end


return M
