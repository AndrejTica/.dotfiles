
# ~/.bashrc — sourced for interactive shells only.

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# ============================================================
# VARIABLES 
# ============================================================
# to build emacs
#export CFLAGS="-O2 -pipe -march=native -mtune=native -fno-omit-frame-pointer -fno-plt -flto=auto"
#export LDFLAGS="-Wl,-O2 -Wl,-z,now -Wl,-z,relro -Wl,--sort-common -Wl,--as-needed -Wl,-z,pack-relative-relocs -flto=auto -O2"

# ============================================================
# HISTORY — the single biggest QOL improvement
# ============================================================
HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL=ignoreboth:erasedups   # ignore dups+space-prefixed; remove old dups
HISTTIMEFORMAT='%F %T '             # timestamp every command
shopt -s histappend                 # append on exit, don't overwrite
shopt -s cmdhist                    # multi-line commands stay one history entry
PROMPT_COMMAND='history -a'         # flush to file after each command

# ============================================================
# SHELL OPTIONS — small wins
# ============================================================
shopt -s checkwinsize               # update LINES/COLUMNS on resize
shopt -s autocd                     # `cd somedir` works as just `somedir`
shopt -s cdspell                    # autocorrect minor typos in cd
shopt -s globstar                   # ** matches files recursively

# ============================================================
# ENVIRONMENT
# ============================================================
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER='nvim +Man!'        # readable man pages in nvim
export PATH="$HOME/.local/bin:$PATH"

# ============================================================
# COLORS & LISTING
# ============================================================
alias ls='ls -lah --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'

# Quick directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git shortcuts (the ones you'll actually use)
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'

# ============================================================
# PROMPT — minimal but informative
# ============================================================
# Shows: user:cwd (branch) $
# Branch is fast because git invocation is suppressed when not in a repo.
parse_git_branch() {
    git branch --show-current 2>/dev/null | sed 's/.*/ (&)/'
}
PS1='\[\e[32m\]\u\[\e[0m\]:\[\e[34m\]\W\[\e[33m\]$(parse_git_branch)\[\e[0m\]\$ '

# ============================================================
# COMPLETION
# ============================================================
# Bash completion is essential; some distros include it, but ensure it's on.
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

[[ -f /usr/share/bash-completion/bash_completion ]] && \
    source /usr/share/bash-completion/bash_completion
