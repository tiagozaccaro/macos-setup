#!/usr/bin/env bash
set -eo pipefail
log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
if command -v opencode >/dev/null 2>&1; then
  log "opencode already installed"
else
  log "Installing opencode CLI via npm"
  npm install -g opencode-ai
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/opencode"
CONFIG_FILE="$CONFIG_DIR/opencode.jsonc"
SOURCE_CONFIG="$SCRIPT_DIR/.opencode/opencode.jsonc"
ENV_FILE="$HOME/.opencode.env"
mkdir -p "$CONFIG_DIR"

# Prompt for Zen API key and save to env file
if [ -z "${ZEN_API_KEY}" ]; then
  if [ -f "$ENV_FILE" ] && grep -q '^export ZEN_API_KEY=' "$ENV_FILE"; then
    # shellcheck disable=SC1090
    . "$ENV_FILE"
  fi
  if [ -z "${ZEN_API_KEY}" ]; then
    read -r -p "Enter your Zen API key: " ZEN_API_KEY
    {
      echo "# Zen API key for opencode"
      echo "export ZEN_API_KEY=\"${ZEN_API_KEY}\""
    } >> "$ENV_FILE"
    log "Saved Zen API key to $ENV_FILE"
  fi
fi

# Prompt for Kilo API key and save to env file
if [ -z "${KILO_API_KEY}" ]; then
  if [ -f "$ENV_FILE" ] && grep -q '^export KILO_API_KEY=' "$ENV_FILE"; then
    # shellcheck disable=SC1090
    . "$ENV_FILE"
  fi
  if [ -z "${KILO_API_KEY}" ]; then
    read -r -p "Enter your Kilo API key: " KILO_API_KEY
    {
      echo "# Kilo API key for opencode"
      echo "export KILO_API_KEY=\"${KILO_API_KEY}\""
    } >> "$ENV_FILE"
    log "Saved Kilo API key to $ENV_FILE"
  fi
fi

# Prompt for OpenRouter API key and save to env file
if [ -z "${OPENROUTER_API_KEY}" ]; then
  if [ -f "$ENV_FILE" ] && grep -q '^export OPENROUTER_API_KEY=' "$ENV_FILE"; then
    # shellcheck disable=SC1090
    . "$ENV_FILE"
  fi
  if [ -z "${OPENROUTER_API_KEY}" ]; then
    read -r -p "Enter your OpenRouter API key: " OPENROUTER_API_KEY
    {
      echo "# OpenRouter API key for opencode"
      echo "export OPENROUTER_API_KEY=\"${OPENROUTER_API_KEY}\""
    } >> "$ENV_FILE"
    log "Saved OpenRouter API key to $ENV_FILE"
  fi
fi

# Prompt for Context7 API key and save to env file
if [ -z "${CONTEXT7_API_KEY}" ]; then
  if [ -f "$ENV_FILE" ] && grep -q '^export CONTEXT7_API_KEY=' "$ENV_FILE"; then
    # shellcheck disable=SC1090
    . "$ENV_FILE"
  fi
  if [ -z "${CONTEXT7_API_KEY}" ]; then
    read -r -p "Enter your Context7 API key: " CONTEXT7_API_KEY
    {
      echo "# Context7 API key for opencode MCP"
      echo "export CONTEXT7_API_KEY=\"${CONTEXT7_API_KEY}\""
    } >> "$ENV_FILE"
    log "Saved Context7 API key to $ENV_FILE"
  fi
fi

log "Done"
