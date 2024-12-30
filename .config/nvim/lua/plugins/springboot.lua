local M = {
  "JavaHello/spring-boot.nvim",
  ft = "java",
  dependencies = {
    "mfussenegger/nvim-jdtls", -- or nvim-java, nvim-lspconfig
  },
}


M.config = function()
  require('spring_boot').setup({
    ls_path = "/home/andrej/.vscode-oss/extensions/vmware.vscode-spring-boot-1.59.0-universal", -- ???? ~/.vscode/extensions/vmware.vscode-spring-boot-x.xx.x
    jdtls_name = "jdtls",
    log_file = nil,
    java_cmd = nil,

  })
end


return M
