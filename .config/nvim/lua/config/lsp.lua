vim.lsp.config("yamlls", {
    settings = {
        yaml = {
            schemas = {
                ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = {
                    ".gitlab-ci.yml",
                    ".gitlab-ci.yaml",
                    "*.gitlab-ci.yml",
                    "*.gitlab-ci.yaml",
                },
                kubernetes = {
                    "k8s/**/*.yaml",
                    "k8s/**/*.yml",
                    "manifests/**/*.yaml",
                    "*.k8s.yaml",
                },
            },
            kubernetesVersion = "1.30.3",
            validate = true,
            keyOrdering = false,
            schemaStore = { enable = false },
        },
    },
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("lua", true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

vim.lsp.config("angularls", {
    cmd = function(dispatchers, config)
        local root_dir = config.root_dir or vim.fn.getcwd()
        local node_modules = {
            vim.fs.joinpath(root_dir, "node_modules"),
            vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "angular-language-server", "node_modules"),
        }

        node_modules = vim.tbl_filter(function(path)
            return vim.uv.fs_stat(path) ~= nil
        end, node_modules)

        local ng_probe_locations = vim
            .iter(node_modules)
            :map(function(path)
                return vim.fs.joinpath(path, "@angular", "language-server", "node_modules")
            end)
            :totable()

        local angular_core_version = ""
        local package_json = vim.fs.joinpath(root_dir, "package.json")
        if vim.uv.fs_stat(package_json) then
            local ok, package = pcall(vim.json.decode, vim.fn.readblob(package_json))
            if ok then
                local dependencies = vim.tbl_extend("keep", package.dependencies or {}, package.devDependencies or {})
                angular_core_version = (dependencies["@angular/core"] or ""):match("%d+%.%d+%.%d+") or ""
            end
        end

        return vim.lsp.rpc.start({
            "ngserver",
            "--stdio",
            "--tsProbeLocations",
            table.concat(node_modules, ","),
            "--ngProbeLocations",
            table.concat(ng_probe_locations, ","),
            "--angularCoreVersion",
            angular_core_version,
            "--forceStrictTemplates",
        }, dispatchers)
    end,
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "basedpyright",
        "ts_ls",
        "angularls@21.2.22",
        "dockerls",
        "lemminx",
        "yamlls",
        "cssls",
        "html",
        "jsonls",
        "marksman",
        "jdtls",
    },
    automatic_enable = {
        "lua_ls",
        "basedpyright",
        "ts_ls",
        "angularls",
        "dockerls",
        "lemminx",
        "yamlls",
        "cssls",
        "html",
        "jsonls",
        "marksman",
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = require("config.shared").augroup,
    callback = function(event)
        local function map(keys, action, description)
            vim.keymap.set("n", keys, action, {
                buffer = event.buf,
                desc = " " .. description,
            })
        end

        local fzf = require("fzf-lua")

        map("gd", fzf.lsp_definitions, "[G]oto [D]efinition")
        map("gr", fzf.lsp_references, "[G]oto [R]eferences")
        map("gI", fzf.lsp_implementations, "[G]oto [I]mplementation")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("<leader>D", fzf.lsp_typedefs, "Type [D]efinition")
        map("<leader>ds", fzf.lsp_document_symbols, "[D]ocument [S]ymbols")
        map("<leader>ws", fzf.lsp_live_workspace_symbols, "[W]orkspace [S]ymbols")
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("<leader>ci", fzf.lsp_incoming_calls, "[C]alls [I]ncoming")
        map("<leader>co", fzf.lsp_outgoing_calls, "[C]alls [O]utgoing")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("<leader>ih", function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
            vim.lsp.inlay_hint.enable(not enabled)
        end, "Toggle inlay hints")
    end,
})

vim.diagnostic.config({
    virtual_text = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
})

local keymap = require("config.shared").keymap

keymap("n", "<C-k>", vim.diagnostic.open_float, "Open diagnostic popup")
keymap("n", "<leader>fd", function()
    require("fzf-lua").diagnostics_document()
end, "Document diagnostics")
keymap("n", "<leader>fq", vim.diagnostic.setqflist, "Diagnostics to quickfix")
