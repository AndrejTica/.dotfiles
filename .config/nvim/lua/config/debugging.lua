local dap = require("dap")
local dap_view = require("dap-view")

dap_view.setup({
    winbar = {
        controls = { enabled = true },
    },
})

dap.listeners.after.event_initialized.dap_view = function()
    dap_view.open()
end
dap.listeners.before.event_terminated.dap_view = function()
    dap_view.close()
end
dap.listeners.before.event_exited.dap_view = function()
    dap_view.close()
end

local debugpy_python = vim.fn.stdpath("data")
    .. "/mason/packages/debugpy/venv/bin/python"
require("dap-python").setup(debugpy_python)

vim.fn.sign_define("DapBreakpoint", {
    text = "●",
    texthl = "DiagnosticError",
})
vim.fn.sign_define("DapBreakpointCondition", {
    text = "◆",
    texthl = "DiagnosticWarn",
})
vim.fn.sign_define("DapLogPoint", {
    text = "◈",
    texthl = "DiagnosticInfo",
})
vim.fn.sign_define("DapStopped", {
    text = "▶",
    texthl = "DiagnosticOk",
    linehl = "Visual",
    numhl = "DiagnosticOk",
})

local keymap = require("config.shared").keymap

keymap("n", "<leader>dc", dap.continue, "Debug: Start/Continue")
keymap("n", "<F1>", dap.step_into, "Debug: Step Into")
keymap("n", "<F2>", dap.step_over, "Debug: Step Over")
keymap("n", "<F4>", dap.step_out, "Debug: Step Out")
keymap("n", "<leader>db", dap.toggle_breakpoint, "Debug: Toggle breakpoint")
keymap("n", "<leader>dt", dap.terminate, "Debug: Terminate")
keymap("n", "<leader>dr", dap.repl.toggle, "Debug: Toggle REPL")
keymap("n", "<leader>dv", function()
    dap_view.toggle()
end, "Debug: Toggle UI")
keymap("n", "<leader>dw", function()
    dap_view.add_expr()
end, "Debug: Watch expression")

keymap("n", "<leader>dB", function()
    vim.ui.input({ prompt = "Breakpoint condition: " }, function(condition)
        if condition and condition ~= "" then
            dap.set_breakpoint(condition)
        end
    end)
end, "Debug: Conditional breakpoint")
