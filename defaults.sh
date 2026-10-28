#!/usr/bin/env bash
set -eo pipefail
log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
apply_defaults() {
  log "Applying macOS defaults"

  # Finder: show hidden files
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # Dock
  defaults write com.apple.dock tilesize -int 45
  
  # Keyboard: use F1, F2, etc. as standard function keys
  defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

  # Trackpad: tap to click
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  for app in Dock Finder SystemUIServer; do killall "$app" >/dev/null 2>&1 || true; done
}
apply_defaults; log "Done"