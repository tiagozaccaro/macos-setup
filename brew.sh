#!/usr/bin/env bash
set -euo pipefail
log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RAW_URL="${RAW_URL:-https://raw.githubusercontent.com/tiagozaccaro/macos-setup/main}"
fetch_file() { local rel="$1" dest="$2"; if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/$rel" ]; then cp "$SCRIPT_DIR/$rel" "$dest"; else curl -fsSL "$RAW_URL/$rel" -o "$dest"; fi; }
install_homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    log "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; elif [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"; fi
  # Persist brew to user PATH
  local profile="$HOME/.zprofile"
  if [ -x /opt/homebrew/bin/brew ]; then
    grep -q 'brew shellenv' "$profile" 2>/dev/null || echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> "$profile"
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
  elif [ -x /usr/local/bin/brew ]; then
    grep -q 'brew shellenv' "$profile" 2>/dev/null || echo 'eval "$(/usr/local/bin/brew shellenv zsh)"' >> "$profile"
    eval "$(/usr/local/bin/brew shellenv zsh)"
  fi
  log "Updating Homebrew"; brew update
}
install_from_brewfile() {
  local brewfile
  if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/Brewfile" ]; then brewfile="$SCRIPT_DIR/Brewfile"; else brewfile="$(mktemp)"; log "Fetching Brewfile"; fetch_file "Brewfile" "$brewfile"; fi
  log "Installing from Brewfile"; brew bundle --file="$brewfile"
}
main() { install_homebrew; install_from_brewfile; log "Done"; }
main "$@"