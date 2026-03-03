# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/andrej/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#


export VISUAL=nvim
export EDITOR=nvim
export TERM="tmux-256color"
export BROWSER="firefox"
export JAVA_HOME="$HOME/.jdks/openjdk-25.0.1"
export JDTLS_JAVA_HOME="$HOME/.jdks/openjdk-25.0.1"

path=(
	$PATH
	$HOME/.local/bin
	$HOME/.local/share/JetBrains/Toolbox/scripts
	/bin
	/usr/bin
	/usr/local/bin
	/sbin
	$JAVA_HOME
	$JAVA_HOME/bin/
	$HOME/Downloads/apache-maven-3.9.12/bin/
	$HOME/Downloads/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-linux-gnueabihf/bin
	)

export PATH

set -o vi
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS


PURE_GIT_PULL=0
fpath+=($HOME/.zsh/pure)

autoload -U promptinit; promptinit
prompt pure

alias v=nvim
alias ls='ls --color=auto'
alias yy='yazi'


source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh


# Redefine the `cd` command as a shell function
# This allows us to intercept every `cd` call
cd() {

  # Check how many arguments were passed to `cd`
  # "$#" is the number of arguments
  if [[ "$#" -eq 0 ]]; then

    # If no arguments were given (`cd` alone),
    # go to the home directory ($HOME)
    # `builtin` ensures we call zsh's built-in `pushd`,
    # not a function or alias with the same name
    # `> /dev/null` suppresses pushd's default output
    builtin pushd ~ > /dev/null

  else

    # If arguments were given (`cd dir`, `cd ..`, `cd -`, etc.),
    # forward them exactly as-is to `pushd`
    # "$@" preserves all arguments without modification
    builtin pushd "$@" > /dev/null

  fi
}
# Set up fzf key bindings and fuzzy completion

bindkey -s '^F' 'tmux-sessionizer\n'


# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# source <(fzf --zsh)
