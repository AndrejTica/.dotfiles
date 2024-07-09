-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

local M = {
    -- NOTE: Yes, you can install new plugins here!
    'mfussenegger/nvim-dap',
    -- NOTE: And you can specify dependencies as well
    dependencies = {
        -- Creates a beautiful debugger UI
        'rcarriga/nvim-dap-ui',
        'theHamsta/nvim-dap-virtual-text',

        -- Required dependency for nvim-dap-ui
        'nvim-neotest/nvim-nio',

        -- Installs the debug adapters for you
        'williamboman/mason.nvim',
        'jay-babu/mason-nvim-dap.nvim',
        { "mfussenegger/nvim-dap-python", ft = "python" },
    },
}

M.config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
            -- Update this to ensure that you have the debuggers for the langs you want
            'delve',
        },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
            icons = {
                pause = '',
                play = '▶',
                step_into = '⏎',
                step_over = '',
                step_out = '',
                step_back = '',
                run_last = '▶▶',
                terminate = '󰙧',
                disconnect = '⏏',
            },
        },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

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
            name = "Debug Attach (5005)";
            type = "java";
            request = "attach";
            hostName = "127.0.0.1";
            port = 5005;
        },
    }


    local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
    require("dap-python").setup(path)
    require("nvim-dap-virtual-text").setup()
end

return M
