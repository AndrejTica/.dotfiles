vim.filetype.add({
    extension = {
        robot = "robot",
        resource = "robot",
    },
})

require("nvim-treesitter").install({
    "lua",
    "vim",
    "vimdoc",
    "query",
    "python",
    "java",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "sql",
    "yaml",
    "json",
    "html",
    "xml",
    "markdown",
    "markdown_inline",
    "latex",
    "bash",
    "dockerfile",
    "gitcommit",
    "diff",
    "robot",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "lua",
        "vim",
        "help",
        "query",
        "python",
        "java",
        "javascript",
        "typescript",
        "typescriptreact",
        "c",
        "sql",
        "yaml",
        "json",
        "html",
        "xml",
        "markdown",
        "sh",
        "bash",
        "dockerfile",
        "gitcommit",
        "diff",
    },
    callback = function()
        vim.treesitter.start()
    end,
})

local select_textobject = require("nvim-treesitter-textobjects.select")

local function map_textobject(key, query, group)
    vim.keymap.set({ "x", "o" }, key, function()
        select_textobject.select_textobject(query, group or "textobjects")
    end, { desc = query })
end

map_textobject("af", "@function.outer")
map_textobject("if", "@function.inner")
map_textobject("ac", "@class.outer")
map_textobject("ic", "@class.inner")
map_textobject("ap", "@parameter.outer")
map_textobject("ip", "@parameter.inner")
map_textobject("as", "@scope", "locals")
