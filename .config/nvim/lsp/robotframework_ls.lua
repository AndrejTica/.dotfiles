return {
	cmd = { 'robotframework_ls' },
	filetypes = { 'robot' },
	root_markers = { 'robotidy.toml', 'pyproject.toml', 'conda.yaml', 'robot.yaml', '.git' },
	settings = {
		robot = {
			python = {
				executable = vim.fn.getenv("VIRTUAL_ENV") .. "/bin/python3.12"
			}
		}
	}
}
