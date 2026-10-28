#!/usr/bin/env bash
set -eo pipefail
log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; elif [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"; fi

# Ensure gh is available
if ! command -v gh >/dev/null 2>&1; then
  log "Installing gh via Homebrew"
  brew install gh
fi

# Authenticate with GitHub (gh handles SSH key generation)
if ! gh auth status >/dev/null 2>&1; then
  log "Authenticating with GitHub (interactive)"
  gh auth login --git-protocol ssh
fi
gh config set git_protocol ssh 2>/dev/null || true

log "Done"