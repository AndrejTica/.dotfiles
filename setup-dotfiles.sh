#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/AndrejTica/.dotfiles.git"
WORKSPACE_DIR="$HOME/Workspaces"
DOTFILES_DIR="$WORKSPACE_DIR/.dotfiles"

mkdir -p "$WORKSPACE_DIR"

if [ ! -d "$DOTFILES_DIR/.git" ]; then
    echo "Cloning dotfiles..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    echo "Dotfiles already present."
fi

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local"

link() {
    local source="$1"
    local target="$2"

    rm -rf "$target"
    ln -s "$source" "$target"

    echo "Linked $target"
}

# Home directory files
link "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
link "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
link "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
link "$DOTFILES_DIR/.ideavimrc" "$HOME/.ideavimrc"

# .config
#link "$DOTFILES_DIR/.config/emacs" "$HOME/.config/emacs"
#link "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
#link "$DOTFILES_DIR/.config/yazi" "$HOME/.config/yazi"
#link "$DOTFILES_DIR/.config/mimeapps.list" "$HOME/.config/mimeapps.list"

# Zed
link "$DOTFILES_DIR/zed" "$HOME/.config/zed"

# Local bin
link "$DOTFILES_DIR/.local/bin" "$HOME/.local/bin"

echo "Done."
