vim.pack.add({"https://github.com/kristijanhusak/vim-dadbod-completion"})

vim.pack.add({"https://github.com/tpope/vim-dadbod"})

vim.pack.add({"https://github.com/kristijanhusak/vim-dadbod-ui"})


vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_save_location = "~/workspace/sql-scripts/"
vim.g.db_ui_debug = 1
vim.g.db_ui_execute_on_save = 0


vim.api.nvim_create_user_command("SaveQuery", function()
  vim.api.nvim_exec([[execute "normal \<Plug>(DBUI_SaveQuery)"]], false)
end, {})


