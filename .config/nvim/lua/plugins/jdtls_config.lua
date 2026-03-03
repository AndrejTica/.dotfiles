vim.pack.add({"https://github.com/mfussenegger/nvim-jdtls"})


vim.api.nvim_create_user_command("RunTestMethod", function()
  vim.cmd("lua require'jdtls'.test_nearest_method()")
end, {})


vim.api.nvim_create_user_command("RunTestMethod", function()
  vim.cmd("lua require'jdtls'.test_nearest_method()")
end, {})

vim.api.nvim_create_user_command("RunTestClass", function()
  vim.cmd("lua require'jdtls'.test_class()")
end, {})

vim.api.nvim_create_user_command("GoToSubject", function()
  vim.cmd("lua require'jdtls.tests'.goto_subjects()")
end, {})




