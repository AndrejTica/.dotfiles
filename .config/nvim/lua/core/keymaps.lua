local keymap = function(mode, keys, func, desc)
  vim.keymap.set(mode, keys, func, { noremap = true, silent = true, desc = ' ' .. desc })
end

local function general()
  keymap('n', '<leader>l', '<C-w>l', 'Go right right')
  keymap('n', '<leader>h', '<C-w>h', 'Go left split')
  keymap('n', '<leader>j', '<C-w>j', 'Go down split')
  keymap('n', '<leader>k', '<C-w>k', 'Go up split')
  keymap('t', '<esc>', [[<C-\><C-n>]], 'Easier terminal mode exit')
  keymap('n', '<leader>sv', ':vsplit<CR>', 'Split vert')
  keymap('n', '<leader>sh', ':split<CR>', 'Split horiz')
  keymap('n', '<leader>,', '<c-w>5<', 'Resize split left')
  keymap('n', '<leader>.', '<c-w>5>', 'Resize split right')
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear highlight' })
  keymap('n', '<leader>e', ':w | Run<CR>', 'Run program')
  keymap('n', '<C-s>', ':w<CR>', 'Save file')
  keymap('n', '<tab>', ':bnext<cr>', 'Buffer next')
  keymap('n', '<S-tab>', ':bprevious<cr>', 'Buffer prev')
  keymap('v', '<', '<gv', 'Stay in indent mode')
  keymap('v', '>', '>gv', 'Stay in indent mode')
  vim.keymap.set('n', 'n', 'nzz', { desc = 'On each search next item stay centered' })
  vim.keymap.set('n', 'N', 'Nzz', { desc = 'On each search prev item stay centered' })
  vim.keymap.set('n', '*', '*zz', { desc = 'On jump to next word under cursor stay centered' })
  vim.keymap.set('n', '#', '#zz', { desc = 'On jump to prev word under cursor stay centered' })
  vim.keymap.set('x', 'p', [["_dP]], { desc = 'As we paste over something, keep the thing we yanked before' })
  keymap('n', '<C-f>', ':!tmux neww tmux-sessionizer<CR>', 'New tmux session')
  keymap('n', '<C-h>', ':!tmux neww cheat-sheet<CR>', 'Open cht.sh')
  vim.keymap.set('n', 'x', '"_x')
end

local function telescope()
  -- Telescrope
  local builtin = require 'telescope.builtin'
  keymap('n', '<leader>fh', builtin.help_tags, '[S]earch [H]elp')
  keymap('n', '<leader>fm', builtin.keymaps, '[S]earch [K]eymaps')
  keymap('n', '<leader>ff', builtin.find_files, '[S]earch [F]iles')
  keymap('n', '<leader>fs', builtin.builtin, '[S]earch [S]elect Telescope')
  keymap('n', '<leader>fg', builtin.live_grep, '[S]earch by [G]rep')
  keymap('n', '<leader>fd', builtin.diagnostics, '[S]earch [D]iagnostics')
  keymap('n', '<leader>fr', builtin.resume, '[S]earch [R]esume')
  keymap('n', '<leader>fo', builtin.oldfiles, '[S]earch Recent Files ("." for repeat)')
  keymap('n', '<leader><leader>', builtin.buffers, '[ ] Find existing buffers')

  -- Slightly advanced example of overriding default behavior and theme
  keymap('n', '<leader>fc', function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, 'Current buffer fuzzy find')
end

local function lsp()
  -- Jump to the definition of the word under your cursor.
  --  This is where a variable was first declared, or where a function is defined, etc.
  --  To jump back, press <C-t>.
  keymap('n', 'gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

  -- Find references for the word under your cursor.
  keymap('n', 'gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  keymap('n', 'gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  keymap('n', '<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

  -- Fuzzy find all the symbols in your current document.
  --  Symbols are things like variables, functions, types, etc.
  keymap('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

  -- Fuzzy find all the symbols in your current workspace.
  --  Similar to document symbols, except searches over your entire project.
  keymap('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- Rename the variable under your cursor.
  --  Most Language Servers support renaming across files, etc.
  keymap('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  keymap('n', '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  -- Opens a popup that displays documentation about the word under your cursor
  --  See `:help K` for why this keymap.
  keymap('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')

  -- WARN: This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header.
  keymap('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  keymap('n', '<leader>ih', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, 'Toggle inline hints')

  keymap({ 'i', 's' }, '<C-L>', function()
    require('luasnip').jump(1)
  end, 'Jump to next snippet field')
end

local function aerial()
  keymap('n', '<leader>a', '<cmd>AerialToggle!<CR>', 'Toggle Aerial')
end

local function dap()
  local dap = require 'dap'
  local dapui = require 'dapui'
  keymap('n', '<leader>dc', dap.continue, 'Debug: Start/Continue')
  keymap('n', '<F1>', dap.step_into, 'Debug: Step Into')
  keymap('n', '<F2>', dap.step_over, 'Debug: Step Over')
  keymap('n', '<F4>', dap.step_out, 'Debug: Step Out')
  keymap('n', '<leader>dc', dap.continue, 'Debug: Continue')
  vim.keymap.set('n', '<leader>db', function()
    local condition = vim.fn.input 'Optional condition: '
    if condition == nil then
      dap.toggle_breakpoint()
    else
      dap.toggle_breakpoint(condition)
    end
  end, { desc = 'Debug: Toggle breakpoint' })
  keymap('n', '<F7>', dapui.toggle, 'Debug: See last session result.')
end

local function git()
  keymap('n', '<leader>gj', "<cmd>lua require('gitsigns').next_hunk({navigation_message = false})<cr>", 'Next hunk')
  keymap('n', '<leader>gk', "<cmd>lua require('gitsigns').prev_hunk({navigation_message = false})<cr>", 'Prev hunk')
  keymap('n', '<leader>gp', "<cmd>lua require('gitsigns').preview_hunk()<cr>", 'Preview hunk')
  keymap('n', '<leader>gr', "<cmd>lua require('gitsigns').reset_hunk()<cr>", 'Reset hunk')
  keymap('n', '<leader>gR', "<cmd>lua require('gitsigns').reset_buffer()<cr>", 'Reset buffer')
  keymap('n', '<leader>gd', '<cmd>Gitsigns diffthis HEAD<cr>', 'Diff this')
end

local function leap()
  keymap('n', '<leader>b', '<Plug>(leap-forward)', 'Leap forward')
  keymap('n', '<leader>B', '<Plug>(leap-backward)', 'Leap backwards')
end

local function trouble()
  keymap('n', '<leader>t', ':Trouble<CR>', 'Open Trouble')
end

local function java()
  keymap('n', '<leader>tc', function()
    if vim.bo.filetype == 'java' then
      require('jdtls').test_class()
    end
  end, 'Run a whole test class')

  keymap('n', '<leader>tm', function()
    if vim.bo.filetype == 'java' then
      require('jdtls').test_nearest_method()
    end
  end, 'Test nearest method')
end

local function lol()
  keymap('n', '<leader>fml', '<cmd>CellularAutomaton make_it_rain<CR>', 'assert dominance')
end

general()
telescope()
lsp()
aerial()
dap()
git()
leap()
trouble()
lol()
java()
