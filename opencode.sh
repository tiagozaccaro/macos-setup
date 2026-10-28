#!/usr/bin/env bash
set -eo pipefail
log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
if command -v opencode >/dev/null 2>&1; then
  log "opencode already installed"
else
  log "Installing opencode CLI via npm"
  npm install -g opencode-ai
fi
log "Done"