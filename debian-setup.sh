#!/usr/bin/env bash
# debian-setup.sh — install development toolkit on a fresh Debian system
# Idempotent: safe to re-run; skips already-completed steps.
# Usage: chmod +x debian-setup.sh && ./debian-setup.sh

set -euo pipefail

# ============================================================
# COLOR OUTPUT
# ============================================================
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()  { echo -e "${RED}[ERR]${NC}  $*" >&2; }
skip() { echo -e "${BLUE}[SKIP]${NC} $*"; }

# ============================================================
# HELPERS
# ============================================================
have() { command -v "$1" >/dev/null 2>&1; }

apt_installed() {
    dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"
}

# ============================================================
# PRE-FLIGHT
# ============================================================
if [ "$EUID" -eq 0 ]; then
    err "Do not run this script as root. Run as your normal user; it will sudo when needed."
    exit 1
fi

if ! have sudo; then
    err "sudo is not installed. Install it first: su -c 'apt install sudo && usermod -aG sudo \$USER'"
    exit 1
fi

# ============================================================
# UPDATE SYSTEM
# ============================================================
log "Updating package index..."
sudo apt update
sudo apt upgrade -y

# ============================================================
# CORE APT PACKAGES
# ============================================================
log "Installing core packages from apt..."

CORE_PKGS=(
    wget
    curl
    vim-gtk3
    build-essential
    htop
    tmux
    tree
    unzip
    zip
    tar
    ca-certificates
    fzf
    cmake
    make
    pkg-config
    git
    gnupg
    lsb-release
    apt-transport-https
    fontconfig
)

# Filter to only what's not installed yet
TO_INSTALL=()
for pkg in "${CORE_PKGS[@]}"; do
    if apt_installed "$pkg"; then
        skip "$pkg already installed"
    else
        TO_INSTALL+=("$pkg")
    fi
done

if [ ${#TO_INSTALL[@]} -gt 0 ]; then
    log "Installing: ${TO_INSTALL[*]}"
    sudo apt install -y "${TO_INSTALL[@]}"
else
    skip "All core packages already installed"
fi

# ============================================================
# PYTHON
# ============================================================
log "Checking Python + venv + pip..."

PY_PKGS=(python3 python3-venv python3-pip python3-dev)
PY_TO_INSTALL=()
for pkg in "${PY_PKGS[@]}"; do
    if apt_installed "$pkg"; then
        skip "$pkg already installed"
    else
        PY_TO_INSTALL+=("$pkg")
    fi
done

if [ ${#PY_TO_INSTALL[@]} -gt 0 ]; then
    sudo apt install -y "${PY_TO_INSTALL[@]}"
fi

log "Python version: $(python3 --version)"

# ============================================================
# NODE.JS via NVM (latest LTS)
# ============================================================
log "Checking nvm + Node.js LTS..."

NVM_VERSION="v0.40.1"

if [ -d "$HOME/.nvm" ]; then
    skip "nvm already installed at ~/.nvm"
else
    log "Installing nvm $NVM_VERSION..."
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
fi

# Clean up potentially-broken npm config (e.g. from a Windows migration)
if [ -f "$HOME/.npmrc" ] && grep -q "C:\\\\" "$HOME/.npmrc" 2>/dev/null; then
    warn "Found Windows paths in ~/.npmrc — backing up and removing"
    mv "$HOME/.npmrc" "$HOME/.npmrc.bak.$(date +%s)"
fi

# Disable strict unset-variable check around nvm — its internals
# reference variables (PROVIDED_VERSION etc.) that may be unset.
set +u

export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if have node && node --version | grep -q "^v"; then
    skip "Node already installed: $(node --version)"
else
    log "Installing latest Node.js LTS..."
    nvm install --lts
    nvm use --lts
    nvm alias default 'lts/*'
fi

set -u

log "Node version: $(node --version)"
log "npm version: $(npm --version)"

# ============================================================
# DOCKER + COMPOSE PLUGIN (latest from Docker's official repo)
# ============================================================
log "Checking Docker..."

if have docker && apt_installed "docker-ce"; then
    skip "Docker already installed: $(docker --version)"
else
    log "Installing Docker from Docker's official repo..."

    # Remove any old/conflicting packages
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
        if apt_installed "$pkg"; then
            sudo apt-get remove -y "$pkg"
        fi
    done

    # Add Docker's official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    if [ ! -f /etc/apt/keyrings/docker.asc ]; then
        sudo curl -fsSL https://download.docker.com/linux/debian/gpg \
            -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
    fi

    # Add the repository
    if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    fi

    sudo apt update
    sudo apt install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin
fi

# Ensure user is in docker group
if id -nG "$USER" | grep -qw docker; then
    skip "User '$USER' already in docker group"
else
    log "Adding $USER to docker group..."
    sudo usermod -aG docker "$USER"
    warn "You'll need to log out and back in for docker group membership to take effect"
fi

log "Docker version: $(docker --version)"
log "Compose version: $(docker compose version)"

# ============================================================
# JAVA 25 JDK + MAVEN (via Adoptium Temurin)
# ============================================================
log "Checking Java JDK..."

if have java && java -version 2>&1 | grep -qE "(25|21)"; then
    skip "Java already installed: $(java -version 2>&1 | head -1)"
else
    log "Installing Java JDK via Adoptium Temurin..."

    # Add Adoptium GPG key if not present
    if [ ! -f /etc/apt/keyrings/adoptium.gpg ]; then
        sudo install -m 0755 -d /etc/apt/keyrings
        wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | \
            sudo gpg --dearmor -o /etc/apt/keyrings/adoptium.gpg
    fi

    # Add Adoptium repo if not present
    if [ ! -f /etc/apt/sources.list.d/adoptium.list ]; then
        echo "deb [signed-by=/etc/apt/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb $(. /etc/os-release && echo "$VERSION_CODENAME") main" | \
            sudo tee /etc/apt/sources.list.d/adoptium.list > /dev/null
        sudo apt update
    fi

    # Try Java 25 first, fall back to 21 LTS if not available
    if sudo apt install -y temurin-25-jdk 2>/dev/null; then
        log "Installed Temurin Java 25 JDK"
    elif sudo apt install -y temurin-21-jdk; then
        warn "Java 25 not available — installed Java 21 LTS instead"
    else
        err "Failed to install any Temurin JDK"
        exit 1
    fi
fi

log "Java version: $(java -version 2>&1 | head -1)"

# ============================================================
# MAVEN
# ============================================================
if apt_installed maven; then
    skip "Maven already installed: $(mvn --version | head -1)"
else
    log "Installing Maven..."
    sudo apt install -y maven
    log "Maven version: $(mvn --version | head -1)"
fi

# ============================================================
# JETBRAINS MONO NERD FONT
# ============================================================
log "Checking JetBrains Mono Nerd Font..."

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

if fc-list 2>/dev/null | grep -qi "jetbrainsmono nerd"; then
    skip "JetBrains Mono Nerd Font already installed"
else
    log "Installing JetBrains Mono Nerd Font..."

    TMP_DIR=$(mktemp -d)
    pushd "$TMP_DIR" > /dev/null

    log "Downloading latest from GitHub..."
    wget -q --show-progress \
        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

    unzip -q JetBrainsMono.zip -d JetBrainsMono
    cp JetBrainsMono/*.ttf "$FONT_DIR/"

    popd > /dev/null
    rm -rf "$TMP_DIR"

    log "Refreshing font cache..."
    fc-cache -fv >/dev/null

    if fc-list | grep -qi "jetbrainsmono nerd"; then
        log "Font installed successfully"
    else
        warn "Font cache refreshed but JetBrainsMono Nerd Font not detected"
    fi
fi

# ============================================================
# FINAL CLEANUP
# ============================================================
log "Cleaning up apt cache..."
sudo apt autoremove -y
sudo apt clean

# ============================================================
# SUMMARY
# ============================================================
echo
echo "============================================================"
echo "                  INSTALLATION COMPLETE"
echo "============================================================"
echo
echo "Installed versions:"
echo "  Python:    $(python3 --version 2>&1)"
echo "  Node.js:   $(node --version 2>&1) (via nvm)"
echo "  npm:       $(npm --version 2>&1)"
echo "  Docker:    $(docker --version 2>&1)"
echo "  Compose:   $(docker compose version --short 2>&1)"
echo "  Java:      $(java -version 2>&1 | head -1 | sed 's/.*"\(.*\)".*/\1/' || echo 'see java -version')"
echo "  Maven:     $(mvn --version 2>&1 | head -1 | awk '{print $3}')"
echo "  Git:       $(git --version 2>&1 | awk '{print $3}')"
echo "  CMake:     $(cmake --version 2>&1 | head -1 | awk '{print $3}')"
echo
warn "Next steps:"
echo "  1. Log out and back in for docker group membership to take effect"
echo "  2. Open a new shell or 'source ~/.bashrc' to load nvm/Node"
echo "  3. Configure your terminal to use 'JetBrainsMono Nerd Font'"
echo
log "Done!"
