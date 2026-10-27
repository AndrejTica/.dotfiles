require("gruvbox").setup({
    contrast = "hard",
    transparent_mode = false,
    italic = {
        strings = false,
        comments = true,
    },
})
vim.cmd.colorscheme("gruvbox")

require("aerial").setup({})

require("nvim-navic").setup({
    lsp = {
        auto_attach = true,
    },
})

require("lualine").setup({
    options = {
        theme = "gruvbox",
        disabled_filetypes = {
            winbar = { "dap-view", "dap-view-term", "dap-repl" },
        },
    },
    sections = {
        lualine_x = {
            "lsp_status",
            "encoding",
            "fileformat",
            "filetype",
        },
    },
    winbar = {
        lualine_c = {
            { "filename", path = 1 },
            { "navic" },
        },
    },
})

local keymap = require("config.shared").keymap

keymap("n", "<leader>a", "<cmd>AerialToggle!<CR>", "Toggle symbol outline")

keymap("n", "<leader>ff", ':lua require("fzf-lua").files()<CR>', "Find files in current working directory")
keymap("n", "<leader><leader>", ':lua require("fzf-lua").buffers()<CR>', "Open current open buffers")
keymap("n", "<leader>fg", ':lua require("fzf-lua").live_grep()<CR>', "Live grep")
keymap("n", "<leader>fo", ':lua require("fzf-lua").oldfiles()<CR>', "Search for previously opened files")

vim.keymap.set("n", "<leader>n", function()
    require("yazi").yazi()
end, { desc = "Open yazi" })

keymap("n", "<leader>gj", "<cmd>lua require('gitsigns').next_hunk({navigation_message = false})<cr>", "Next hunk")
keymap("n", "<leader>gk", "<cmd>lua require('gitsigns').prev_hunk({navigation_message = false})<cr>", "Prev hunk")
keymap("n", "<leader>gp", "<cmd>lua require('gitsigns').preview_hunk()<cr>", "Preview hunk")
keymap("n", "<leader>gr", "<cmd>lua require('gitsigns').reset_hunk()<cr>", "Reset hunk")
keymap("n", "<leader>gR", "<cmd>lua require('gitsigns').reset_buffer()<cr>", "Reset buffer")
keymap("n", "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", "Diff this")
