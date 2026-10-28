#!/usr/bin/env bash
set -eo pipefail
log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
uv python install
uv python update-shell
log "Python installed via uv"