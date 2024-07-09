local M = {
  'mikavilpas/yazi.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  event = 'VeryLazy',
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      '<leader>n',
      function()
        require('yazi').yazi()
      end,
      desc = 'Open the file manager',
    },
  },
  opts = {
    open_for_directories = false,
  },
}

return M
