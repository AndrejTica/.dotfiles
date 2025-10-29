vim.pack.add({"https://github.com/mikavilpas/yazi.nvim"})

vim.keymap.set("n", "<leader>n", function()
  require("yazi").yazi()
end)
