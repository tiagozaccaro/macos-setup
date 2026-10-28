#!/usr/bin/env bash
#
# macOS setup script
# Installs Homebrew, packages, casks, applies macOS defaults, and symlinks dotfiles.
#
# Usage:
#   ./setup.sh            # run everything
#   ./setup.sh --brew     # only Homebrew + packages
#   ./setup.sh --defaults # only macOS defaults
#   ./setup.sh --dotfiles # only dotfiles
#
set -eo pipefail

# ---------- helpers ----------
log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
err()  { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd 2>/dev/null || echo "")"
# When run via `curl ... | bash`, BASH_SOURCE points at stdin; treat as remote run.
if [ -z "$SCRIPT_DIR" ] || [ ! -d "$SCRIPT_DIR" ] || [ "$SCRIPT_DIR" = "/" ]; then
  SCRIPT_DIR=""
  REMOTE=1
else
  REMOTE=0
fi

# Raw base URL for fetching companion files when run remotely (curl | bash).
# Override with: RAW_URL=... ./setup.sh  or  curl ... | RAW_URL=... bash
RAW_URL="${RAW_URL:-https://raw.githubusercontent.com/tiagozaccaro/macos-setup/main}"

fetch_file() {
  # fetch_file <relative-path> <dest>
  local rel="$1" dest="$2"
  if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/$rel" ]; then
    cp "$SCRIPT_DIR/$rel" "$dest"
  else
    curl -fsSL "$RAW_URL/$rel" -o "$dest"
  fi
}

# ---------- macOS version guard ----------
MIN_MACOS_MAJOR=27
macos_major() {
  sw_vers -productVersion 2>/dev/null | cut -d. -f1
}
if [ "$(uname -s)" = "Darwin" ]; then
  cur="$(macos_major)"
  if [ -n "$cur" ] && [ "$cur" -lt "$MIN_MACOS_MAJOR" ]; then
    if [ "${FORCE:-0}" = "1" ]; then
      warn "macOS $cur < $MIN_MACOS_MAJOR, continuing due to FORCE=1"
    else
      err "This script requires macOS $MIN_MACOS_MAJOR or newer (detected $cur). Set FORCE=1 to override."
      exit 1
    fi
  fi
fi
RUN_BREW=1
RUN_DEFAULTS=1
for arg in "$@"; do
  case "$arg" in
    --brew)     RUN_DEFAULTS=0 ;;
    --defaults) RUN_BREW=0 ;;
    --help|-h)  sed -n '1,20p' "$0"; exit 0 ;;
    *) err "Unknown argument: $arg"; exit 1 ;;
  esac
done

# (logic now lives in brew.sh, defaults.sh, dotfiles.sh)

# ---------- main ----------
run_script() {
  local name="$1"
  log "Running $name"
  if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/$name" ]; then
    bash "$SCRIPT_DIR/$name"
  else
    local tmp; tmp="$(mktemp)"; fetch_file "$name" "$tmp"; bash "$tmp"
  fi
}
main() {
  if [ "$RUN_BREW" -eq 1 ]; then
    run_script "brew.sh" || warn "brew.sh failed"
    run_script "python.sh" || warn "python.sh failed"
    run_script "opencode.sh" || warn "opencode.sh failed"
    run_script "github.sh" || warn "github.sh failed"
    run_script "vscode-extensions.sh" || warn "vscode-extensions.sh failed"
    run_script "xcode.sh" || warn "xcode.sh failed"
    run_script "dock.sh" || warn "dock.sh failed"
    run_script "android.sh" || warn "android.sh failed"
  fi
  if [ "$RUN_DEFAULTS" -eq 1 ]; then run_script "defaults.sh"; fi
  log "Done"
}

main "$@"
