#!/usr/bin/env bash
set -euo pipefail
log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
install_android_sdk() {
  log "Setting up Android SDK for Flutter"
  mkdir -p "$ANDROID_HOME/cmdline-tools"
  if [ ! -d "$ANDROID_HOME/cmdline-tools/latest" ]; then
    local tmp; tmp="$(mktemp -d)"
    curl -fsSL "https://dl.google.com/android/repository/commandlinetools-mac-11076708_latest.zip" -o "$tmp/cmdline-tools.zip"
    unzip -q "$tmp/cmdline-tools.zip" -d "$tmp"
    mv "$tmp/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest"
    rm -rf "$tmp"
  fi
  export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
  yes | sdkmanager --licenses >/dev/null 2>&1 || true
  sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" "emulator" "system-images;android-34;google_apis;arm64-v8a" || true
  # Persist env vars
  local profile="$HOME/.zshrc"
  grep -q 'ANDROID_HOME' "$profile" 2>/dev/null || {
    printf '\nexport ANDROID_HOME="%s"\nexport PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"\n' "$ANDROID_HOME" >> "$profile"
  }
  log "Android SDK setup complete"
}
install_android_sdk; log "Done"