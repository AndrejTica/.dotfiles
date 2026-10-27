vim.g.no_plugin_maps = 1
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_save_location = "~/workspace/sql-scripts/"
vim.g.db_ui_debug = 1
vim.g.db_ui_execute_on_save = 0
vim.g.tagalong_filetypes = { "html", "xml" }

vim.pack.add({
    { src = "https://github.com/tpope/vim-rsi" },
    { src = "https://github.com/tpope/vim-fugitive" },

    -- dadbod must load before dadbod-ui.
    { src = "https://github.com/tpope/vim-dadbod" },
    { src = "https://github.com/kristijanhusak/vim-dadbod-ui" },

    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/AndrewRadev/tagalong.vim" },

    -- fzf-lua and dadbod-ui probe for devicons while loading.
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/stevearc/aerial.nvim" },
    { src = "https://github.com/SmiteshP/nvim-navic" },
    { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
    { src = "https://github.com/mikavilpas/yazi.nvim" },
    { src = "https://github.com/ellisonleao/gruvbox.nvim" },
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        version = "main",
    },
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
        version = "main",
    },
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    { src = "https://github.com/kristijanhusak/vim-dadbod-completion" },
    { src = "https://github.com/mfussenegger/nvim-dap" },
    { src = "https://github.com/mfussenegger/nvim-dap-python" },
    { src = "https://github.com/igorlfs/nvim-dap-view" },
    { src = "https://github.com/mfussenegger/nvim-jdtls" },
    { src = "https://github.com/alessio-vivaldelli/java-creator-nvim" },
})

require("nvim-web-devicons").setup({})
require("nvim-autopairs").setup({})
require("java-creator-nvim").setup({
    options = {
        auto_open = true,
        java_version = 17,
    },
    keymaps = {
        java_new = "<leader>jn",
        java_class = "<leader>jc",
        java_interface = "<leader>ji",
        java_enum = "<leader>je",
        java_record = "<leader>jr",
        java_abstract_class = "<leader>ja",
    },
})
require("fzf-lua").setup({ "telescope" })
require("gitsigns").setup({})
require("nvim-highlight-colors").setup({
    render = "background",
})
require("mason").setup({})
require("mason-tool-installer").setup({
    ensure_installed = {
        { "angular-language-server", version = "21.2.22" },
        "java-debug-adapter",
        "java-test",
        "debugpy",
        "stylua",
        "ruff",
        "prettierd",
        "google-java-format",
        "clang-format",
        "shfmt",
        "xmlformatter",
    },
    run_on_start = true,
})
