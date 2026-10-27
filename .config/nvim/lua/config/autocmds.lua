local augroup = require("config.shared").augroup

vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
    desc = "Enable English spell checking only for text and Markdown files",
    group = augroup,
    callback = function()
        local spell_enabled = vim.bo.filetype == "text" or vim.bo.filetype == "markdown"
        vim.opt_local.spell = spell_enabled
        if spell_enabled then
            vim.opt_local.spelllang = "en"
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "yaml", "yml", "xml" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.expandtab = true
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    desc = "Return to last edit/cursor position when reopening a file",
    group = augroup,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = {
        "checkhealth",
        "fugitive*",
        "git",
        "help",
        "lspinfo",
        "netrw",
        "notify",
        "qf",
        "query",
        "oil",
    },
    callback = function()
        vim.keymap.set("n", "q", vim.cmd.close, {
            buffer = true,
            desc = "Close the current buffer",
        })
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    callback = function(event)
        vim.keymap.set("n", "q", vim.cmd.close, {
            buffer = event.buf,
            desc = "Close the terminal split",
        })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.bo.makeprg = "python3 %"
        vim.bo.errorformat = '%C %.%#,%A  File "%f"\\, line %l%.%#,%Z%[%^ ]%\\@=%m'
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "javascriptreact" },
    callback = function()
        vim.bo.makeprg = "node %"
        vim.bo.errorformat = table.concat({
            "%C %.%#",
            "%C",
            "%A%f:%l",
            "%Z%[%^ ]%\\@=%m",
            "%-G%.%#at node:%.%#",
            "%.%#at %.%# (%f:%l:%c)",
            "%.%#at %f:%l:%c",
            "%-G%.%#",
        }, ",")
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescript", "typescriptreact" },
    callback = function()
        vim.bo.makeprg = "npx tsx %"
        vim.bo.errorformat = table.concat({
            "%C %.%#",
            "%C",
            "%A%f:%l",
            "%Z%[%^ ]%\\@=%m",
            "%-G%.%#at node:%.%#",
            "%.%#at %.%# (%f:%l:%c)",
            "%.%#at %f:%l:%c",
            "%-G%.%#",
        }, ",")
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
        vim.bo.makeprg = "java %"
        vim.bo.errorformat = table.concat({
            "%E%f:%l: error: %m",
            "%W%f:%l: warning: %m",
            "%-Z%p^",
            "%-C%.%#",
            "%EException in thread %m",
            "%ECaused by: %m",
            "%.%#at %.%#(%f:%l)%.%#",
            "%-G%.%#",
        }, ",")
    end,
})
