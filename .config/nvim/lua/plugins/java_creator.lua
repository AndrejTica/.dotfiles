vim.pack.add({"https://github.com/alessio-vivaldelli/java-creator-nvim"})


require("java-creator-nvim").setup({
    options = {
      auto_open = true,  -- Open file after creation
      java_version = 17  -- Minimum Java version
    }
})


