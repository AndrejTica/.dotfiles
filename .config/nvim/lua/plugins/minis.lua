local M = {
  { 'tpope/vim-sleuth' }, -- Detect tabstop and shiftwidth automatically
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true },
  { 'ggandor/leap.nvim' },
  { 'mbbill/undotree' },
  { 'tpope/vim-dotenv' },
  {'eandrju/cellular-automaton.nvim'},
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    config = function()
      local ufo = require 'ufo'
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      --za to toggle folds
      vim.api.nvim_create_user_command('Foldall', ufo.closeAllFolds, {})
      vim.api.nvim_create_user_command('Unfoldall', ufo.openAllFolds, {})
      ufo.setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end,
      }
    end,
  },
  {
    'uga-rosa/ccc.nvim',
    config = function()
      require('ccc').setup {}
    end,
  },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
}

return M
