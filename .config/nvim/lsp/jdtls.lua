
local bundles = {
  vim.fn.glob("/home/andrej/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar")
}

vim.list_extend(bundles,
  vim.split(vim.fn.glob(vim.env.HOME .. "/.local/share/nvim/mason/share/java-test/*.jar", 1), "\n"))

return {

	filetypes = {
		"java",
	},

	cmd = {
		"jdtls",

		-- depends on if `java` is in your $PATH env variable and if it points to the right version.
		"/usr/lib/jvm/java-21-openjdk/bin/java",

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		-- 💀
		"-jar",
		"/home/andrej/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.7.0.v20250519-0528.jar",
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
		-- Must point to the                                                     Change this to
		-- eclipse.jdt.ls installation                                           the actual version

		-- 💀
		"-configuration",
		"/home/andrej/.local/share/nvim/mason/packages/jdtls/config_linux/",
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
		-- Must point to the                      Change to one of `linux`, `win` or `mac`
		-- eclipse.jdt.ls installation            Depending on your system.

		-- 💀
		-- See `data directory configuration` section in the README
		"-data",
		"/home/andrej/workspace/jdtls_data/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
	},

	root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw" }),

	settings = {
		java = {
			-- Custom eclipse.jdt.ls options go here
		},
	},

	-- 		-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	init_options = {
		bundles = bundles
	},
	on_attach =  function(client, bufnr)
    require('jdtls').setup_dap({ hotcodereplace = 'auto' })
    require('jdtls.dap').setup_dap_main_class_configs()
end

}

-- This starts a new client & server, or attaches to an existing client & server based on the `root_dir`.
