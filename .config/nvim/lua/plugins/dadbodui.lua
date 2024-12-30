local M = {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod',                     lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_save_location = "~/workspace/sql-scripts/"
    vim.g.db_ui_debug = 1
    vim.g.db_ui_execute_on_save = 0

    vim.api.nvim_create_autocmd("User", {
      pattern = "DBUIOpened",
      callback = function()
        local dotenv = vim.fn.DotenvRead('~/workspace/sql-scripts/.env')
        vim.b.dotenv = dotenv
        vim.cmd("normal R")
      end,
    })
  end,
}


return M
