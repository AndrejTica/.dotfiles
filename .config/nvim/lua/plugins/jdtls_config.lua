vim.pack.add({"https://github.com/mfussenegger/nvim-jdtls"})


vim.api.nvim_create_user_command("RunTestMethod", function()
  vim.cmd("lua require'jdtls'.test_nearest_method()")
end, {})

