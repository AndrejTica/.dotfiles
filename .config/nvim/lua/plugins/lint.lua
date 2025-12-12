vim.pack.add({"https://github.com/mfussenegger/nvim-lint"})


require('lint').linters_by_ft = {
  python = {'ruff'},
}


vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  callback = function()

    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()
  end,
})
