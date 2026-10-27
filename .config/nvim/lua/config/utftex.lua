local M = {}

local install_dir = vim.fn.stdpath("data") .. "/tools/libtexprintf"
local executable = install_dir .. "/bin/utftex"
local source_dir = vim.fn.stdpath("cache") .. "/libtexprintf-build"
local installing = false

local build_steps = {
    { "./autogen.sh" },
    { "./configure", "--prefix=" .. install_dir },
    { "make", "--quiet", "-j2" },
    { "make", "--quiet", "install" },
}

local function notify(message, level)
    vim.schedule(function()
        vim.notify(message, level, { title = "utftex" })
    end)
end

local function run_build_step(index)
    local command = build_steps[index]
    if not command then
        installing = false
        vim.fs.rm(source_dir, { recursive = true, force = true })
        notify("Installed LaTeX renderer.", vim.log.levels.INFO)
        return
    end

    vim.system(command, { cwd = source_dir, text = true }, function(result)
        if result.code ~= 0 then
            installing = false
            local output = result.stderr and result.stderr ~= ""
                    and result.stderr
                or result.stdout
                or ""
            notify(
                ("Installation failed while running `%s`:\n%s"):format(
                    table.concat(command, " "),
                    vim.trim(output)
                ),
                vim.log.levels.ERROR
            )
            return
        end

        run_build_step(index + 1)
    end)
end

local function bootstrap()
    if installing then
        return
    end

    local required_commands = { "git", "autoreconf", "make", "gcc" }
    for _, command in ipairs(required_commands) do
        if vim.fn.executable(command) ~= 1 then
            notify(
                ("Cannot install utftex: `%s` is not available."):format(command),
                vim.log.levels.ERROR
            )
            return
        end
    end

    installing = true
    vim.fs.rm(source_dir, { recursive = true, force = true })
    vim.fn.mkdir(vim.fs.dirname(source_dir), "p")
    vim.fn.mkdir(install_dir, "p")

    notify("Installing LaTeX renderer in the background...", vim.log.levels.INFO)
    vim.system({
        "git",
        "clone",
        "--quiet",
        "--depth",
        "1",
        "https://github.com/bartp5/libtexprintf.git",
        source_dir,
    }, { text = true }, function(result)
        if result.code ~= 0 then
            installing = false
            notify(
                "Failed to download utftex:\n" .. vim.trim(result.stderr or ""),
                vim.log.levels.ERROR
            )
            return
        end

        run_build_step(1)
    end)
end

function M.ensure_installed()
    local installed = vim.fn.exepath("utftex")
    if installed ~= "" then
        return installed
    end

    if vim.fn.executable(executable) ~= 1 then
        bootstrap()
    end

    return executable
end

return M
