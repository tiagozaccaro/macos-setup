#!/usr/bin/env bash
set -eo pipefail
log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; elif [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"; fi

log "Configuring Dock icons"
APPS=(
  "/Applications/Google Chrome.app"
  "/Applications/Brave Browser.app"
  "/Applications/Visual Studio Code.app"
)

uv run python - "$@" <<'PY'
import subprocess, os, plistlib, sys
apps = [
  "/Applications/Google Chrome.app",
  "/Applications/Brave Browser.app",
  "/Applications/Visual Studio Code.app",
]
entries = []
for app in apps:
    if not os.path.exists(app):
        continue
    entries.append({
        "tile-data": {
            "file-data": {
                "_CFURLString": app,
                "_CFURLStringType": 0,
            }
        },
        "tile-type": "file-tile",
    })
subprocess.run(["defaults", "write", "com.apple.dock", "persistent-apps", "-array"], check=False)
# write via plist to temp then import
import tempfile
fd, path = tempfile.mkstemp(suffix=".plist")
with os.fdopen(fd, "wb") as f:
    plistlib.dump(entries, f, fmt=plistlib.FMT_XML)
subprocess.run(["defaults", "import", "com.apple.dock", path], check=True)
os.remove(path)
PY

killall Dock >/dev/null 2>&1 || true
log "Done"