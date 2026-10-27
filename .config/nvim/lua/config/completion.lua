vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }

local augroup = require("config.shared").augroup

local html_void_tags = {
    area = true,
    base = true,
    br = true,
    col = true,
    embed = true,
    hr = true,
    img = true,
    input = true,
    link = true,
    meta = true,
    param = true,
    source = true,
    track = true,
    wbr = true,
}

local function complete_tag(item, client, bufnr)
    local filetype = vim.bo[bufnr].filetype
    if filetype ~= "html" and filetype ~= "xml" then
        return {}
    end

    -- XML servers already supply snippets, including attributes and tab stops.
    local edit = item.textEdit
    if item.insertTextFormat == vim.lsp.protocol.InsertTextFormat.Snippet or not edit then
        return {}
    end

    local tag = edit.newText
    local range = edit.range or edit.insert
    if not tag:match("^[%a_][%w_.:%-]*$") or not range or range.start.line ~= range["end"].line then
        return {}
    end

    local line = vim.api.nvim_buf_get_lines(bufnr, range.start.line, range.start.line + 1, false)[1]
    local start_col = vim.str_byteindex(line, client.offset_encoding, range.start.character)
    local end_col = vim.str_byteindex(line, client.offset_encoding, range["end"].character)
    if line:sub(1, start_col):sub(-1) ~= "<" then
        return {}
    end

    -- Leave existing attributes, closing brackets and self-closing tags alone.
    local suffix = line:sub(end_col + 1)
    if suffix:match("^%s*[^%s<]") then
        return {}
    end

    local closing_tag = "</" .. tag .. ">"
    local has_closing_tag = suffix:match("^%s*(.*)"):sub(1, #closing_tag) == closing_tag
    local snippet = tag .. ">$0"
    if not (filetype == "html" and html_void_tags[tag:lower()]) and not has_closing_tag then
        snippet = snippet .. closing_tag
    end

    -- Keep Neovim's original client metadata and let it expand the snippet on acceptance.
    item.textEdit.newText = snippet
    item.insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet
    return {}
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, event.buf, {
                autotrigger = false,
                convert = function(item)
                    return complete_tag(item, client, event.buf)
                end,
            })
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "sql", "mysql", "plsql" },
    callback = function(event)
        vim.bo[event.buf].omnifunc = "vim_dadbod_completion#omni"
    end,
})
