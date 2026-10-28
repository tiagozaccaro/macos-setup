#!/usr/bin/env bash
set -eo pipefail
log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; elif [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"; fi
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }

SSH_KEY="$HOME/.ssh/id_ed25519"
SSH_PUB="$SSH_KEY.pub"

# Ensure gh is available
if ! command -v gh >/dev/null 2>&1; then
  log "Installing gh via Homebrew"
  brew install gh
fi

# Authenticate with GitHub if needed
if ! gh auth status >/dev/null 2>&1; then
  log "Authenticating with GitHub (interactive)"
  gh auth login --git-protocol ssh
fi

# Generate SSH key if missing
if [ ! -f "$SSH_KEY" ]; then
  log "Generating SSH key at $SSH_KEY"
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  ssh-keygen -t ed25519 -C "${GITHUB_EMAIL:-$(git config --global user.email 2>/dev/null || echo user@localhost)}" -f "$SSH_KEY" -N ""
else
  log "SSH key already exists at $SSH_KEY"
fi

# Start ssh-agent and add key
eval "$(ssh-agent -s)" >/dev/null
ssh-add "$SSH_KEY" 2>/dev/null || true

# Upload public key to GitHub if gh is authenticated
if gh auth status >/dev/null 2>&1; then
  if ! gh ssh-key list 2>/dev/null | grep -q "$(cut -d' ' -f1-2 "$SSH_PUB")"; then
    log "Uploading SSH public key to GitHub"
    gh ssh-key add "$SSH_PUB" --title "$(hostname)-$(date +%Y%m%d)" 2>/dev/null || warn "Could not upload key (maybe already present)"
  else
    log "SSH key already registered on GitHub"
  fi
  gh config set git_protocol ssh 2>/dev/null || true
fi

log "Done"