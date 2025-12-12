vim.pack.add({ "https://github.com/mfussenegger/nvim-dap" })
vim.pack.add({"https://codeberg.org/mfussenegger/nvim-dap-python"})


local dap = require 'dap'
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


require("dap-python").setup("python3")
-- install debugpy first with: 'python3 -m pip install debugpy'
--
dap.configurations.java = {
        {
            name = "Debug Launch (2GB)";
            type = "java";
            request = "launch";
            vmArgs = "--enable-preview " ..
                "-Xmx2g "
        },
        {
            name = "Debug Attach (8000)";
            type = "java";
            request = "attach";
            hostName = "127.0.0.1";
            port = 8000;
        },
        {
            name = "Debug Attach (8001)";
            type = "java";
            request = "attach";
            hostName = "127.0.0.1";
            port = 8001;
        },
    }

