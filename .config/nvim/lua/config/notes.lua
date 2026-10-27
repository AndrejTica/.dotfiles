local utftex = require("config.utftex").ensure_installed()

require("render-markdown").setup({
    latex = {
        enabled = true,
        converter = { utftex, "latex2text" },
        inline = true,
        block = true,
    },
})
