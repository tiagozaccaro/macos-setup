#!/usr/bin/env bash
set -eo pipefail
log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; elif [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"; fi

log "Configuring Dock icons"
uv run python <<'PY'
import os, plistlib
plist_path = os.path.expanduser("~/Library/Preferences/com.apple.dock.plist")
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
try:
    with open(plist_path, "rb") as f:
        data = plistlib.load(f)
except FileNotFoundError:
    data = {}
existing = data.get("persistent-apps", [])
existing_paths = {e.get("tile-data", {}).get("file-data", {}).get("_CFURLString") for e in existing}
for e in entries:
    p = e["tile-data"]["file-data"]["_CFURLString"]
    if p not in existing_paths:
        existing.append(e)
        existing_paths.add(p)
data["persistent-apps"] = existing
with open(plist_path, "wb") as f:
    plistlib.dump(data, f)
PY

killall Dock >/dev/null 2>&1 || true
log "Done"