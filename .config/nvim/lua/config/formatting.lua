local conform = require("conform")

conform.setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        html = { "prettierd" },
        css = { "prettierd" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        java = { "google_java_format" },
        c = { "clang_format" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        xml = { "xmlformatter" },
    },
    default_format_opts = {
        lsp_format = "fallback",
    },
})

require("config.shared").keymap({ "n", "x" }, "<F3>", function()
    conform.format({ async = true })
end, "Format buffer or selection")
