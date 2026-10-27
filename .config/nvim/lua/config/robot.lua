local M = {}

local function notify_error(message)
    vim.notify(message, vim.log.levels.ERROR, { title = "Robot Framework" })
end

function M.run_test_on_current_line()
    local suite_path = vim.api.nvim_buf_get_name(0)
    if suite_path == "" or not suite_path:match("%.robot$") then
        notify_error("The current buffer is not a Robot Framework suite")
        return
    end

    local test_name = vim.trim(vim.api.nvim_get_current_line())
    if test_name == "" then
        notify_error("The current line does not contain a test case name")
        return
    end

    if vim.fn.executable("robot") ~= 1 then
        notify_error("The 'robot' executable was not found in PATH")
        return
    end

    vim.cmd.update()
    vim.cmd("botright vnew")

    local job_id = vim.fn.jobstart({ "robot", "--test", test_name, suite_path }, {
        term = true,
    })
    if job_id <= 0 then
        vim.cmd.close()
        notify_error("Failed to start the Robot Framework test")
        return
    end

    vim.cmd.startinsert()
end

local group = vim.api.nvim_create_augroup("RobotFrameworkRunner", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    desc = "Add Robot Framework suite test mappings",
    group = group,
    pattern = "robot",
    callback = function(event)
        local path = vim.api.nvim_buf_get_name(event.buf)
        if not path:match("%.robot$") then
            return
        end

        vim.keymap.set("n", "<leader>tc", M.run_test_on_current_line, {
            buffer = event.buf,
            desc = "Test: Run Robot test on current line",
        })
    end,
})

return M
