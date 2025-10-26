vim.pack.add({"https://github.com/stevearc/conform.nvim"})


require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" }
    -- Conform will run multiple formatters sequentially
  },
})

keymap('n', '<F3>', function() require('conform').format { async = true, lsp_fallback = true } end, "Format")
