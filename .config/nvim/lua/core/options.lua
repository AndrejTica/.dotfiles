vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.undofile = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"
vim.o.mouse = "a"
vim.o.scrolloff = 999
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.virtualedit = "block"
vim.o.inccommand = "split"
vim.o.incsearch = true
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.termguicolors = true
vim.o.showmode = false
vim.o.hlsearch = true
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"
vim.o.laststatus = 3
vim.opt.diffopt:append("linematch:60")
vim.o.winborder = 'rounded'
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_winsize = 20
vim.g.clipboard = {
  name = 'xclip',
  copy = {
    ['+'] = { 'xclip', '-quiet', '-i', '-selection', 'clipboard' },
    ['*'] = { 'xclip', '-quiet', '-i', '-selection', 'primary' },
  },
  paste = {
    ['+'] = { 'xclip', '-o', '-selection', 'clipboard' },
    ['*'] = { 'xclip', '-o', '-selection', 'primary' },
  },
  cache_enabled = 1, -- cache MUST be enabled, or else it hangs on dd/y/x and all other copy operations
}
 if vim.fn.has("wsl") == 1 then
    vim.g.clipboard = {
      name = "WslClipboard",
      copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
      },
      paste = {
        ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      },
      cache_enabled = 0,
    }
end
