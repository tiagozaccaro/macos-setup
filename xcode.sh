#!/usr/bin/env bash
set -eo pipefail
log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
install_xcode() {
  if [ ! -d "/Applications/Xcode.app" ]; then
    local installed_mas=0
    if ! command -v mas >/dev/null 2>&1; then
      log "Installing mas temporarily"
      brew install mas
      installed_mas=1
    fi
    log "Installing Xcode via Mac App Store (mas)"
    mas install 497799835 || true
    if [ "$installed_mas" -eq 1 ]; then
      log "Removing temporary mas"
      brew uninstall mas || true
    fi
  fi
  if [ -d "/Applications/Xcode.app" ]; then
    sudo xcodebuild -license accept 2>/dev/null || true
    log "Installing iOS platform/simulator runtime"
    xcodebuild -downloadPlatform iOS 2>/dev/null || true
  else
    log "Xcode not present; installing command line tools only"
    if ! xcode-select -p >/dev/null 2>&1; then xcode-select --install || true; fi
  fi
}
install_xcode; log "Done"