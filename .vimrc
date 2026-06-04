" ~/.vimrc — Pareto-optimal Vim configuration

" ============================================================
" SANITY — undo Vim's worst defaults
" ============================================================
set nocompatible              " behave like Vim, not vi
filetype plugin indent on     " load filetype-specific plugins & indent rules
syntax on                     " syntax highlighting
set encoding=utf-8

" ============================================================
" CORE EDITING
" ============================================================
set number                    " line numbers
set relativenumber            " relative line numbers (5j visible)
set cursorline                " highlight current line
set scrolloff=8               " keep 8 lines of context above/below cursor
set sidescrolloff=8           " same horizontally
set wrap                      " wrap long lines visually
set linebreak                 " wrap at word boundaries, not mid-word
set showmatch                 " briefly jump to matching bracket
set matchtime=2               " ...for 0.2s

" ============================================================
" INDENTATION (sane defaults)
" ============================================================
set expandtab                 " tabs become spaces
set tabstop=4                 " a tab is 4 columns wide
set shiftwidth=4              " >> shifts by 4
set softtabstop=4             " backspace deletes 4 spaces at once
set autoindent                " keep indent of previous line
set smartindent               " add indent after { etc.

" ============================================================
" SEARCH
" ============================================================
set ignorecase                " case-insensitive by default
set smartcase                 " ...unless query has uppercase
set incsearch                 " jump to match as you type
set hlsearch                  " highlight all matches
" <Esc> clears search highlight
nnoremap <silent> <Esc> :nohlsearch<CR>

" ============================================================
" QUALITY OF LIFE
" ============================================================
set hidden                    " allow switching buffers without saving
set autoread                  " reload files changed outside Vim
set mouse=a                   " enable mouse (selecting, scrolling)
set clipboard=unnamedplus     " use system clipboard for y/p
set splitright                " :vsplit opens to the right
set splitbelow                " :split opens below
set wildmenu                  " tab completion in command mode
set wildmode=longest:full,full
set noerrorbells              " no beeps
set novisualbell              " no flashes
set ttyfast                   " smoother redraw
set lazyredraw                " don't redraw during macros
set updatetime=300            " faster swap write / CursorHold
set timeoutlen=500            " mapping wait time (default 1000ms is sluggish)
set backspace=indent,eol,start " sane backspace behavior

" ============================================================
" FILE SAFETY — move sidecar files out of project directories
" ============================================================
set undofile                  " persistent undo across sessions
set undodir=~/.vim/undo//
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//   " swap files
" Create the dirs if missing (silently)
silent !mkdir -p ~/.vim/{undo,backup,swap} > /dev/null 2>&1

" ============================================================
" UI
" ============================================================
set laststatus=2              " always show status line
set showcmd                   " show partial commands in status line
set ruler                     " show cursor position
set signcolumn=yes            " always show sign column (no jumpy gutter)
set termguicolors             " 24-bit color if terminal supports it
set background=dark
colorscheme habamax           " ships with Vim 9, looks decent in dark

" ============================================================
" LEADER KEY & QUICK BINDINGS
" ============================================================
let mapleader = " "           " space as leader

" Keep cursor centered when jumping by half-pages
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Center next/prev search match
nnoremap n nzz
nnoremap N Nzz

" Center on * and # word jumps
nnoremap * *zz
nnoremap # #zz

" x does not overwrite the yank buffer
nnoremap x "_x

" Paste over selection without losing yanked text
xnoremap p "_dP

" Stay in visual mode after indent
vnoremap < <gv
vnoremap > >gv

" Open netrw file explorer
nnoremap <leader>n :Lexplore<CR>

" Switch to previous buffer
nnoremap <leader>z :b#<CR>

" ============================================================
" COMMAND ABBREVIATIONS — typo-proof common commands
" ============================================================
cabbrev Wa wa
cabbrev Wq wq
cabbrev Wqa wqa
cabbrev Q q
cabbrev Qa qa

" ============================================================
" AUTOCMDS
" ============================================================
" Briefly highlight yanked text
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=150})
augroup END

" ============================================================
" CURSOR SHAPE — thin in insert mode, block in normal mode
" ============================================================
let &t_SI = "\e[6 q"          " thin bar on insert
let &t_EI = "\e[2 q"          " block on normal
let &t_SR = "\e[4 q"          " underline on replace

" ============================================================
" COMMENTING — gc to toggle comments (like vim-commentary)
" ============================================================
packadd! comment                " built-in since Vim 9.1.0787
