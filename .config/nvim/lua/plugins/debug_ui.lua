vim.pack.add({ "https://github.com/igorlfs/nvim-dap-view" })


require "dap-view".setup({

	winbar = {
		controls = {
			enabled = true,
		},
	}
})

local dap = require("dap")
local dapui = require("dap-view")
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close
