local modules = {
    "config.options",
    "config.keymaps",
    "config.autocmds",
    "config.commands",
    "config.plugins",
    "config.formatting",
    "config.treesitter",
    "config.notes",
    "config.ui",
    "config.completion",
    "config.lsp",
    "config.debugging",
    "config.robot",
}

-- Keep :source $MYVIMRC useful while still organizing the config as modules.
package.loaded["config.shared"] = nil
for _, module in ipairs(modules) do
    package.loaded[module] = nil
    require(module)
end
