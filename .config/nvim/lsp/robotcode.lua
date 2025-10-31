return {
  cmd = { 'robotcode', 'language-server' },
  filetypes = { 'robot', 'resource' },
  root_markers = { 'robot.toml', 'pyproject.toml', 'Pipfile', '.git' },
  get_language_id = function(_, _)
    return 'robotframework'
  end,
}
