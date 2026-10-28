#!/usr/bin/env bash
set -eo pipefail
log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
if command -v code >/dev/null 2>&1; then
  log "Installing OpenCode extension in VS Code"
  code --install-extension sst-dev.opencode --force || true
else
  log "VS Code 'code' CLI not found; skipping extension install"
fi
log "Done"