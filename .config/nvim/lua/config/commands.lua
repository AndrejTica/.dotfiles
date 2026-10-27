vim.api.nvim_create_user_command("SaveQuery", function()
    vim.api.nvim_exec([[execute "normal \<Plug>(DBUI_SaveQuery)"]], false)
end, {})

local run_commands = {
    python = "python3 %",
    java = "java %",
    js = "node %",
    ts = "node %",
    sh = "./%",
    sql = function()
        vim.cmd([[normal! vip]])
        vim.schedule(function()
            local plug = vim.api.nvim_replace_termcodes(
                "<Plug>(DBUI_ExecuteQuery)",
                true,
                false,
                true
            )
            vim.api.nvim_feedkeys(plug, "n", false)
        end)
    end,
}

vim.api.nvim_create_user_command("Run", function()
    for filetype, command in pairs(run_commands) do
        if vim.bo.filetype == filetype then
            if filetype == "sql" or filetype == "plsql" then
                command()
                break
            end

            vim.cmd("vsp | terminal " .. command)
            break
        end
    end
end, {})

vim.cmd([[cabbrev Wa wa]])
vim.cmd([[cabbrev Wq wq]])
vim.cmd([[cabbrev Wqa wqa]])
vim.cmd([[cabbrev Q q]])
vim.cmd([[cabbrev Qa qa]])
