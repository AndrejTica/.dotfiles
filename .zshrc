HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
zstyle :compinstall filename '/home/andrej/.zshrc'

autoload -Uz compinit
compinit
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:$HOME/scripts/dmenu_scripts:$HOME/scripts/:/usr/local/bin:$PATH
#export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git vi-mode zsh-autosuggestions zsh-syntax-highlighting)

VI_MODE_SET_CURSOR=true
VI_MODE_CURSOR_NORMAL=2
VI_MODE_CURSOR_INSERT=6


# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

bindkey -s ^f "tmux-sessionizer\n"
bindkey -s ^h "cheat-sheet\n"

alias v='nvim'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
bindkey -s ^n "yy\n"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Function to select and execute a command from the shell history
function his() {
  # Use history command to list commands, pipe it to fzf for interactive selection
  # Use awk to remove the history number and extract the command
  local cmd="$(history | fzf | awk '{
    # Set the first field (history number) to an empty string
    $1 = ""

    # Print the entire line starting from the second character
    # This effectively removes the leading space after setting $1 to an empty string
    print substr($0, 2)
  }')"
  
  eval "$cmd"
}

function copyimg() {
    copyq write image/png - < "$@" && copyq select 0 
}

function yy() {
    # Create a temporary file with a unique name for storing the cwd
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    
    # Execute yazi with provided arguments and store cwd in the temporary file
    yazi "$@" --cwd-file="$tmp"
    
    # Read cwd from the temporary file
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        # Change directory if cwd is valid and different from current directory
        cd -- "$cwd"
    fi
    
    # Remove the temporary file
    rm -f -- "$tmp"
}

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi


if [ -n "$PS1" ] && [ -z "$TMUX" ]; then
  # Create session 'main' or attach to 'main' if already exists.
  tmux new-session -A -s main
fi

source $ZSH/oh-my-zsh.sh
