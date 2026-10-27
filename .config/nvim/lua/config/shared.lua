local M = {}

M.augroup = vim.api.nvim_create_augroup("UserConfig", {})

function M.keymap(mode, keys, action, description)
    vim.keymap.set(mode, keys, action, { desc = " " .. description })
end

return M
