local jdtls = require("jdtls")

local buffer_name = vim.api.nvim_buf_get_name(0)
if buffer_name == "" or buffer_name:match("^%w[%w+.-]*://") then
    return
end

local root_markers = {
    ".git",
    "mvnw",
    "gradlew",
    "pom.xml",
    "settings.gradle",
    "settings.gradle.kts",
    "build.gradle",
    "build.gradle.kts",
}

local root_dir = vim.fs.root(0, root_markers)
    or vim.fs.dirname(buffer_name)

if not root_dir or root_dir == "" then
    return
end

local mason = vim.fn.stdpath("data") .. "/mason"
local jdtls_cmd = mason .. "/bin/jdtls"
if vim.fn.executable(jdtls_cmd) ~= 1 then
    vim.notify(
        "jdtls is not installed yet. Wait for Mason to finish, then reopen the Java file.",
        vim.log.levels.ERROR
    )
    return
end

local lombok_jar = mason .. "/share/jdtls/lombok.jar"
if not vim.uv.fs_stat(lombok_jar) then
    vim.notify(
        "Mason's jdtls installation is missing lombok.jar. Reinstall jdtls with :Mason.",
        vim.log.levels.ERROR
    )
    return
end

local bundles = {}
local debug_bundle = mason
    .. "/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"
if vim.uv.fs_stat(debug_bundle) then
    table.insert(bundles, debug_bundle)
end

local excluded_test_bundles = {
    ["com.microsoft.java.test.runner-jar-with-dependencies.jar"] = true,
    ["jacocoagent.jar"] = true,
}
local seen_test_bundles = {}
for _, bundle in ipairs(vim.fn.glob(mason .. "/share/java-test/*.jar", true, true)) do
    local real_bundle = vim.uv.fs_realpath(bundle) or bundle
    if not excluded_test_bundles[vim.fs.basename(bundle)]
        and not seen_test_bundles[real_bundle]
    then
        seen_test_bundles[real_bundle] = true
        table.insert(bundles, bundle)
    end
end

local workspace_dir = vim.fn.stdpath("state")
    .. "/jdtls/"
    .. vim.fs.basename(root_dir)
    .. "-"
    .. vim.fn.sha256(root_dir):sub(1, 12)
vim.fn.mkdir(workspace_dir, "p")

local function java_map(bufnr, mode, keys, callback, description)
    vim.keymap.set(mode, keys, callback, {
        buffer = bufnr,
        desc = description,
    })
end

local function run_test(method)
    method({ config_overrides = { noDebug = true } })
end

local function debug_current_file()
    vim.cmd.write()

    local source_file = vim.api.nvim_buf_get_name(0)
    local class_name = vim.fs.basename(source_file):gsub("%.java$", "")
    for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
        local package_name = line:match("^%s*package%s+([%w_.]+)%s*;")
        if package_name then
            class_name = package_name .. "." .. class_name
            break
        end
    end

    local output_dir = vim.fn.stdpath("cache")
        .. "/java-single-file/"
        .. vim.fn.sha256(source_file):sub(1, 12)
    vim.fn.mkdir(output_dir, "p")

    vim.system({
        "javac",
        "-g",
        "-d",
        output_dir,
        source_file,
    }, { text = true }, function(result)
        vim.schedule(function()
            if result.code ~= 0 then
                vim.notify(
                    "javac failed:\n" .. (result.stderr or result.stdout or ""),
                    vim.log.levels.ERROR
                )
                return
            end

            require("dap").run({
                type = "java",
                request = "launch",
                name = "Debug current Java file",
                mainClass = class_name,
                cwd = vim.fs.dirname(source_file),
                classPaths = { output_dir },
                modulePaths = {},
                javaExec = vim.fn.exepath("java"),
                console = "integratedTerminal",
            })
        end)
    end)
end

local function on_attach(_, bufnr)
    java_map(bufnr, "n", "<leader>jo", jdtls.organize_imports, "Java: Organize imports")
    java_map(bufnr, "n", "<leader>jv", jdtls.extract_variable, "Java: Extract variable")
    java_map(bufnr, "x", "<leader>jv", function()
        jdtls.extract_variable({ visual = true })
    end, "Java: Extract variable")
    java_map(bufnr, "x", "<leader>jm", function()
        jdtls.extract_method({ visual = true })
    end, "Java: Extract method")

    java_map(bufnr, "n", "<leader>tc", function()
        run_test(jdtls.test_nearest_method)
    end, "Test: Run nearest Java test")
    java_map(bufnr, "n", "<leader>tC", function()
        run_test(jdtls.test_class)
    end, "Test: Run Java test class")
    java_map(bufnr, "n", "<leader>td", jdtls.test_nearest_method, "Test: Debug nearest Java test")
    java_map(bufnr, "n", "<leader>tD", jdtls.test_class, "Test: Debug Java test class")
    java_map(bufnr, "n", "<leader>jd", debug_current_file, "Java: Debug current file")

    if #bundles > 0 then
        jdtls.setup_dap({ hotcodereplace = "auto" })
    end
end

jdtls.start_or_attach({
    cmd = {
        jdtls_cmd,
        "--jvm-arg=-javaagent:" .. lombok_jar,
        "-data",
        workspace_dir,
    },
    root_dir = root_dir,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    on_attach = on_attach,
    settings = {
        java = {
            configuration = {
                updateBuildConfiguration = "interactive",
            },
            eclipse = {
                downloadSources = true,
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            signatureHelp = {
                enabled = true,
            },
            inlayHints = {
                parameterNames = {
                    enabled = "all",
                },
            },
        },
    },
    init_options = {
        bundles = bundles,
    },
})
